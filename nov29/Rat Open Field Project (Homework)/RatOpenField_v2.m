%% RatOpenField_v2
% Purpose: imports open field data (in seconds) from 3 groups of rats. Runs stats (t-tests and ANOVAs) beteen groups of interest. Plots results.
% Authors: V. Muller Ewald, Fall 2021

% Versiion history:
% 11.17.21 - V Muller Ewald - Created script
% 11.28.21 - V. Muller Ewald - Errors for debugging practice added

% Comments:


%% Set paths
clear; clc; close all

dataLocation = 'P:\Victoria\1. Parker Lab\Teaching\2021 - UIowa - Fall MatLab boot camp\Meeting 4 & 5\Rat Project 2 (Homework)\Data\';
saveLocation = 'P:\Victoria\1. Parker Lab\Teaching\2021 - UIowa - Fall MatLab boot camp\Meeting 4 & 5\Rat Project 2 (Homework)\Results\RatOpenField_v1\';
if ~exist(saveLocation); mkdir(saveLocation); end  
excelName = 'Open field Data v1';

[~, ~, subjInfo] = xlsread('P:\Victoria\1. Parker Lab\Teaching\2021 - UIowa - Fall MatLab boot camp\Meeting 4 & 5\Rat Project 2 (Homework)\Rat open field project IDs.xlsx','Sheet1');   % Excel sheet with info about data to be loaded

%% Initialize
conditionInfoTab = []; % matrix that will hold information of interest for our conditions 
conditionDataTab = nan(10,3); % matrix that will hold data organized in a way where we can do stats. Pad with nans to account for differences in variable sizes
nConditions = size(subjInfo,1);

%% Analyze
for conditionLoop = 1:nConditions
    conditionID_num = subjInfo{conditionLoop, 2}; % gives you the condition ID as a number
    conditionID_str = num2str(conditionID_num); % gives you the condition ID as a string
   
    % Import
    load([dataLocation, 'Condition', conditionID_num]);
    thisData = timeOpenField; % these are the data. The unit is seconds. 
    nSubj = size(thisData,1);

    % Calculate metrics for data
    this_mean = nanmean(thisData,1); % mean
    this_sem = std(thisdata)./sqrt(size(thisdata,1)); % standard error of the mean = SD/sample size
    this_n = size(thisData,1); % number of subjects
    
    % Save to output matrix
    conditionInfoTab(conditionLoop,1) = conditionID_num;
    conditionInfoTab(conditionLoop,2) = this_mean;
    conditionInfoTab(conditionLoop,3) = this_sem;
    conditionInfoTab(conditionLoop,4) = this_n;
    
    % Save to other output matrix
    conditionDataTab(1:size(thisData,1),conditionLoop) = thisData; % save "thisData" to the column of "conditionDataTab" that equals conditionLoop 

end %subjectLoop

%% Stats
% ANOVA
% ADD LINES TO ORGANIZE DATA FOR ANOVA AND RUN ANOVA HERE 
% (HINT: THE MATRIX conditionDataTab CONTAINS THE INFO YOU NEED)


% Select appropriate string to print on graph because you fancy 
if p < 0.05 % if p value is significant
    sigStr = ('');
else % if p value is not significant
    sigStr = ('');
end %if h == 0


% Plot 
% Plot a bar graph with mean and SEM error bars
% INSERT YOUR PLOTTING CODE HERE

% Add info about stats to plot
text(0.3,27,sigStr) % x location, y location, string
hold off
saveas(gcf,[saveLocation,'Average ITT Latencies - 3 groups.png']); % Save

%% The End
fprintf('Wohoooo the script ran!');








