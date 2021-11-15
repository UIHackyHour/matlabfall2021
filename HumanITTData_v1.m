%% HumanITTData_v1
% Purpose: import human interval timing data (latency in seconds) and sort. Export to excel.
% Authors: V. Muller Ewald
 
% Versiion history:
% 11.14.21 - V Muller Ewald - Created script
 
 
% Comments:
 
 
%% Set paths
clear; clc; close all
 
dataLocation = 'P:\Victoria\1. Parker Lab\Teaching\2021 - UIowa - Fall MatLab boot camp\Meeting 3\HumanProject\Data\';
saveLocation = 'P:\Victoria\1. Parker Lab\Teaching\2021 - UIowa - Fall MatLab boot camp\Meeting 3\HumanProject\Results\HumanITTData_v1\';
if ~exist(saveLocation); mkdir(saveLocation); end  
excelName = 'Human ITT Data v1';
 
% INSERT LINE THAT ESTABLISHES A SUBJECT DIRECTORY HERE
 
 
%% Initialize
cutOff = 7; % this is the cutoff for short vs short
ITTShort = []; ITTLong = []; % these are the matrices that the different trial types will be sorted into
ITTPerformanceTab = []; % this is where the results save, we then export this to excel
 
 
%% Analyze
% Import
load([dataLocation, 'Subject1_data.mat']); % CHANGE LOADING SYNTAX SO THAT EACH SUBJECT CAN BE LOADED
nTrials = size(ITTData,1); % find number of trials
 
% Sort the trials into short and long interval types
for trialSortLoop = 1:nTrials
    thisTrial = ITTData(trialSortLoop,1);
 
    if thisTrial > cutOff
        ITTLong = vertcat(ITTLong, thisTrial);
    elseif thisTrial < cutOff
        ITTShort = vertcat(ITTShort, thisTrial);
    end % thisTrial > cutOff
end % trialSortLoop
 
% Calculate metrics for short or long trials
lpShort_mean = nanmean(ITTShort,1);
lpShort_nTrials = size(ITTShort,1);
lpLong_mean = nanmean(ITTLong,1);
lpLong_nTrials = size(ITTLong,1);
 
% Save to output matrix % CHANGE THIS SO EVERY ROW CONTAINS INFO FROM A SINGLE SUBJECT
ITTPerformanceTab(1,1) = 1; % CHANGE THIS TO REFLECT SUBJECT NUMBER
ITTPerformanceTab(1,2) = lpShort_mean;
ITTPerformanceTab(1,3) = lpShort_nTrials;
ITTPerformanceTab(1,4) = lpLong_mean;
ITTPerformanceTab(1,5) = lpLong_nTrials;
 
 
%% Plot
% Plot a bar graph with mean and SEM error bars
% Bar 1 = mean and SEM of short interval trials, bar 2 = mean and SEM of long interval trials
 
 
%% Save/export
header = {'Subj', 'latency short', 'total short', 'latency long', 'total long'}; 
xlswrite([saveLocation, excelName], header, 'ITTTab');
xlswrite([saveLocation, excelName], ITTPerformanceTab, 'ITTTab', 'A2');
 
%% The End
fprintf('Wohoooo the script ran!');
 
 
 


