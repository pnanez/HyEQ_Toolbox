close all

do_publish = true;
do_tests = true;
do_package = true;

projectFile = 'HybridEquationsToolbox.prj';
toolbox_dirs = {'CommonFiles/lite', ...
    'CommonFiles/lite/examples', ...
    'CommonFiles/plottingFunctions', ...
    'CommonFiles/simulinkBased/Library2014b'};
publish_dirs = ["doc", "helpFiles/Matlab_publish", "helpFiles/Matlab_Publish/MatlabScripts/v3.0"];
test_dir = "CommonFiles/lite/tests";
% Setup path
for d = toolbox_dirs
    addpath(d{1})
end

if do_tests
    % Run Tests
    addpath(test_dir)
    nTestsFailed = runTests();
    rmpath(test_dir)
else
    nTestsFailed = -1;
end

if do_publish
    % Publish help files
    for d = publish_dirs
        
        addpath(d)
        root_path = dir(fullfile(d,'*.m'));
        
        for i = 1:numel(root_path)
            f = fullfile(root_path(i).folder, root_path(i).name);
            outdir = fullfile(root_path(i).folder, "html");
            assert(isfile(f));
            publish(f);
        end
        
        rmpath(d)
    end
end
matlab.addons.toolbox.packageToolbox(projectFile)

% Cleanup path
for d = toolbox_dirs
    rmpath(d{1})
end

close all
fprintf("Packaging complete. %d tests failed.\n", nTestsFailed)