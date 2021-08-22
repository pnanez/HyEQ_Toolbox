close all

projectFile = 'HybridEquationsToolbox.prj';
toolbox_dirs = {'CommonFiles/lite', ...
    'CommonFiles/lite/examples', ...
    'CommonFiles/plottingFunctions', ...
    'CommonFiles/simulinkBased/Library2014b'};
publish_dirs = {'helpFiles/Matlab_publish'};
test_dir = "CommonFiles/lite/tests";

% Setup path
for d = toolbox_dirs
    addpath(d{1})
end

% Run Tests
addpath(test_dir)
nTestsFailed = runTests();
rmpath(test_dir)

% Make sure we can run the GettingStarted live script.
run doc/GettingStarted

% TODO: Add publishing of help documents and figures.

matlab.addons.toolbox.packageToolbox(projectFile)

% Cleanup path
for d = toolbox_dirs
    rmpath(d{1})
end

close all
fprintf("Packaging complete. %d tests failed.\n", nTestsFailed)