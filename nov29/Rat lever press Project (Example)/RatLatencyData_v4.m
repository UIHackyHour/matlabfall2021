%% RatLeverPressData_v3
% Purpose: import rat lever press data and sort. Export to excel. 
% Authors: V. Muller Ewald

% Versiion history:
% 11.8.21 - V Muller Ewald - Created script
% 11.9.21 - V. Muller Ewald - Re-wrote script in front of MatLab boot camp meeting
% 11.14.21 - V. Muller Ewald - Added for loop to run through subjects. Added plottign for multiple subjects
% 11.28.21 - V. Muller Ewald - Added stats (t test and ANOVA)

% Comments:


%% Set paths
clear; clc; close all

dataLocation = 'P:\Victoria\1. Parker Lab\Teaching\2021 - UIowa - Fall MatLab boot camp\Meeting 3\Rat Project(Example)\Data\';
saveLocation = 'P:\Victoria\1. Parker Lab\Teaching\2021 - UIowa - Fall MatLab boot camp\Meeting 3\Rat Project(Example)\Results\RatLeverPressData_v3\';
if ~exist(saveLocation); mkdir(saveLocation); end  
excelName = 'Lever press Data v3';

[~, ~, subjInfo] = xlsread('P:\Victoria\1. Parker Lab\Teaching\2021 - UIowa - Fall MatLab boot camp\Meeting 3\Rat Project(Example)\RatProject_SubjectIDs.xlsx','Sheet1');   % Excel sheet with subjects Info

%% Initialize
cutOff = 20; % this is the cutoff for quick vs slow
lpQuick = []; lpSlow = [];
lpLatencyTab = []; % this is where the results save
nSubjects = size(subjInfo,1);

%% Analyze
for subjectLoop = 1:nSubjects
    subjIDStr = subjInfo{subjectLoop, 1}; % subject ID as a string
    subjIDNum = str2num(extractAfter(subjIDStr,"Rat")); % subject ID as a number
    
    % Import
    load([dataLocation, subjIDStr, '_data.mat']); % Loads the data
    thisData = latencyData; % these are the data. The unit is seconds. 
    nTrials = size(thisData,1); 

    % Calculate metrics for data
    lp_mean = nanmean(thisData,1); 
    lp_trialN = size(thisData,1); 

    % Sort the trials into quick and slow
    for trialSortLoop = 1:nTrials
        thisTrial = thisData(trialSortLoop,1);

        if thisTrial > cutOff
            lpSlow = vertcat(lpSlow, thisTrial);
        elseif thisTrial < cutOff
            lpQuick = vertcat(lpQuick, thisTrial);
        end % thisTrial > cutOff
    end % trialSortLoop

    % Calculate metrics of quick or slow trials
    lpQuick_mean = nanmean(lpQuick,1);
    lpQuick_nTrials = size(lpQuick,1);
    lpSlow_mean = nanmean(lpSlow,1);
    lpSlow_nTrials = size(lpSlow,1);

    % Save to output matrix
    lpLatencyTab(subjectLoop,1) = subjIDNum;
    lpLatencyTab(subjectLoop,2) = lp_mean;
    lpLatencyTab(subjectLoop,3) = lp_trialN;
    lpLatencyTab(subjectLoop,4) = lpQuick_mean;
    lpLatencyTab(subjectLoop,5) = lpQuick_nTrials;
    lpLatencyTab(subjectLoop,6) = lpSlow_mean;
    lpLatencyTab(subjectLoop,7) = lpSlow_nTrials;
end %subjectLoop

%% Stats
% T-test
% Grab the data
lpLatencyTab_SlowLatency = lpLatencyTab(:,4);
lpLatencyTab_QuickLatency = lpLatencyTab(:,6);

% Run the t test
[h,p,ci,stats] = ttest(lpLatencyTab_SlowLatency,lpLatencyTab_QuickLatency); % sig?, p value, confidence interval, test stat
[h,p, ~, stats] = ttest(lpLatencyTab_SlowLatency,lpLatencyTab_QuickLatency); % you can suppress an output by using ~

% Select appropriate string to print on graph because you fancy 
if h == 1 % if p value is significant
    sigStr = ('Significant difference');
else % if p value is not significant
    sigStr = ('Not significantly different');
end %if h == 0

% Plot
% Plot a bar graph with mean and SEM error bars
% Get mean
lpSlow_grandMean = nanmean(lpLatencyTab(:,4));
lpQuick_grandMean = nanmean(lpLatencyTab(:,6));
matrixMean = [lpSlow_grandMean lpQuick_grandMean]; % matrix that contains means
% Get SEM
lpSlow_SEM = std(lpLatencyTab(:,4))./sqrt(size(lpLatencyTab(:,4),1)); % SEM SD/sample size
lpQuick_SEM = std(lpLatencyTab(:,6))./sqrt(size(lpLatencyTab(:,6),1)); 
matrixSEM = [lpSlow_SEM, lpQuick_SEM];
%Plot
bar([lpSlow_grandMean,lpQuick_grandMean],'FaceColor', [0.9290 0.6940 0.1250], 'BarWidth', 0.6);
title('Quick and slow trials - average latencies');
box off;
xticklabels({'Quick trials', 'Slow trials'});
ylabel('time(ms)');
hold on
er = errorbar(1:2, matrixMean, matrixSEM);
er.Color = [0 0 0];                            
er.LineStyle = 'none';  
er.LineWidth = 2;
er.CapSize = 25;
% Add info about stats
text(0.3,27,sigStr) % x location, y location, string
hold off
saveas(gcf,[saveLocation,'Average ITT Latencies - 2 groups.png']); %Save figure % OR EMF so you can import to illustrator

%% ANOVA
% Grab the data
lpLatencyTab_SlowLatency = lpLatencyTab(:,4);
lpLatencyTab_QuickLatency = lpLatencyTab(:,6);
lpLatencyTab_AllLatency = lpLatencyTab(:,2);

p = anova1([lpLatencyTab_AllLatency, lpLatencyTab_SlowLatency, lpLatencyTab_QuickLatency]);
close all;

% Select appropriate string to print on graph because you fancy 
if p < 0.05 % if p value is significant
    sigStr = ('Significant difference');
else % if p value is not significant
    sigStr = ('Not significantly different');
end %if h == 0

% Plot
% Plot a bar graph with mean and SEM error bars
% Get mean
lpSlow_grandMean = nanmean(lpLatencyTab(:,4));
lpQuick_grandMean = nanmean(lpLatencyTab(:,6));
lpAll_grandMean = nanmean(lpLatencyTab(:,2));
matrixMean = [lpAll_grandMean, lpSlow_grandMean, lpQuick_grandMean]; % matrix that contains means
% Get SEM
lpSlow_SEM = std(lpLatencyTab(:,4))./sqrt(size(lpLatencyTab(:,4),1)); % SEM SD/sample size
lpQuick_SEM = std(lpLatencyTab(:,6))./sqrt(size(lpLatencyTab(:,6),1)); 
lpAll_SEM = std(lpLatencyTab(:,2))./sqrt(size(lpLatencyTab(:,2),1)); 
matrixSEM = [lpAll_SEM, lpSlow_SEM, lpQuick_SEM];
%Plot
bar([lpAll_grandMean, lpSlow_grandMean,lpQuick_grandMean],'FaceColor', [0.10 0.70 0.32], 'BarWidth', 0.6);
title('Average latency of different trial types');
box off;
xticklabels({'All trials', 'Quick trials', 'Slow trials'});
ylabel('time(ms)');
hold on
er = errorbar(1:3, matrixMean, matrixSEM);
er.Color = [0 0 0];                            
er.LineStyle = 'none';  
er.LineWidth = 2;
er.CapSize = 25;
% Add info about stats
text(0.3,27,sigStr) % x location, y location, string
hold off
saveas(gcf,[saveLocation,'Average ITT Latencies - 3 groups.png']); % Save


%% Save/export
header = {'Subj', 'latency all', 'total trials', 'latency quick', 'total quick', 'latency slow', 'total slow'}; 
xlswrite([saveLocation, excelName], header, 'lpLatencyTab');
xlswrite([saveLocation, excelName], lpLatencyTab, 'lpLatencyTab', 'A2');

%% The End
fprintf('Wohoooo the script ran!');








