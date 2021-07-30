close all

% Set up the path
addpath('CommonFiles/lite', ...
    'CommonFiles/lite/examples', ...
    'CommonFiles/plottingFunctions', ...
    'CommonFiles/simulinkBased/Library2014b')

% Make sure we can run getting started.
run doc/GettingStarted

projectFile = 'HybridEquationsToolbox.prj';
matlab.addons.toolbox.packageToolbox(projectFile)