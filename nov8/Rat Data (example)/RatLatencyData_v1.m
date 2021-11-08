%% RatLeverPressDaya_v1
% This script was written by V. Muller Ewald, Parker lab, Fall 2021
% Purpose: To import rat lever press data, sort into different trial types
% and save info

% Version history
% 11.7.21. - V. Muller Ewald - Created script

% Comments:

%% Set Paths
clear; clc; close all;

dataLocation = 'P:\Victoria\1. Parker Lab\Teaching\2021 - UIowa - Fall MatLab boot camp\Meeting 2\Rat Project\Data\';
saveLocation = 'P:\Victoria\1. Parker Lab\Teaching\2021 - UIowa - Fall MatLab boot camp\Meeting 2\Rat Project\Results\RatLeverPressData_v1';

excelName = 'Lever Press Data v1';

%% Initialize 
cutOff = 20; % cutoff between slow and quick trials
lpQuick = []; lpSlow = []; % where trial latencies will go
lpLatencyTab = []; % results matrix 

%% Analyze
% Import
load([dataLocation, 'Rat1_data.mat']);
thisData = Rat1_data;

% Calculate metrics of all trials together
lp_mean = nanmean(thisData,1);
lp_nTrials = size(thisData,1);

% Sort into quick and slow trials
for trialSortLoop = 1:size(thisData,1)
    thisTrial = thisData(trialSortLoop,1);
    
    if thisTrial > cutOff 
        lpSlow = vertcat(lpSlow, thisTrial);
    else
        lpQuick = vertcat(lpQuick, thisTrial);
    end % thisTrial > cutoff  
    clear thisTrial
end % trialSortLoop

% Calculate metrics of quick or slow trials
lpQuick_mean = nanmean(lpQuick,1);
lpQuick_nTrials = size(lpQuick,1);
lpSlow_mean = nanmean(lpSlow,1);
lpSlow_nTrials = size(lpSlow,1);

% Save to output matrix
lpLatencyTab(1,1) = 1;
lpLatencyTab(1,2) = lp_mean;
lpLatencyTab(1,3) = lp_nTrials;
lpLatencyTab(1,4) = lpQuick_mean;
lpLatencyTab(1,5) = lpQuick_nTrials;
lpLatencyTab(1,6) = lpSlow_mean;
lpLatencyTab(1,7) = lpSlow_nTrials;

%% Plot
bar([lp_mean lpQuick_mean lpSlow_mean]);
title('Subject 1 performance');
xticklabels({'Grand mean', 'Quick mean', 'Slow mean'});
ylabel('Time (s)');
box off;
saveas(gcf,[saveLocation,'Rat1_performance.png']);

%% Save/export
header = {'Subj', 'latency all', 'total trials', 'latency quick', 'total quick', 'latency slow', 'total slow'}; 
xlswrite([saveLocation, excelName], header, 'lpLatencyTab');
xlswrite([saveLocation, excelName], lpLatencyTab, 'lpLatencyTab', 'A2');

%% The End
fprintf('Wohoo all done!');





















