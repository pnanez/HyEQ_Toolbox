close all

configure_development_path

do_publish = false;
do_tests = false;
do_package = true;

if ~endsWith(pwd(), 'hybrid-toolbox')
   error('Working directory is not ''hybrid-toolbox''.') 
end

projectFile = 'HybridEquationsToolbox.prj';
toolbox_dirs = {'matlab', ...
    'matlab/legacyPlottingFunctions', ...
    'simulink/Library2014b', ...
    'doc'};
publish_dirs = {'doc'};
% Setup path
for directory = toolbox_dirs
    addpath(directory{1})
end

functionSignituresAutocompleteInfoPath_dev = 'matlab/functionSignatures.json';
functionSignituresAutocompleteInfoPath_package = 'matlab/functionSignatures_disabled.json';

if do_tests
    nTestsFailed = hybrid.tests.run();
    validateFunctionSignaturesJSON(functionSignituresAutocompleteInfoPath_dev)
else
    nTestsFailed = -1;
end

if do_publish
    % Publish help files
    for directory_cell = publish_dirs
        directory = directory_cell{1};
        addpath(directory)
        root_path = dir(fullfile(directory,'*.m'));
        
        for i = 1:numel(root_path)
            file = fullfile(root_path(i).folder, root_path(i).name);
            outdir = fullfile(root_path(i).folder, 'html');
            assert(isfile(file));
            publish(file);
            fprintf('Published %s to HTML.\n', file)
        end
    end
    close all
end

% Move the function signatures file so that it is unused in the packaged version
% until 'configure_toolbox' is run after installation on an appropriate version
% of MATLAB.
copyfile(functionSignituresAutocompleteInfoPath_dev, functionSignituresAutocompleteInfoPath_package)

% Create the .mltbx file.
matlab.addons.toolbox.packageToolbox(projectFile)

% Move the function signitures file back so that it is enabled during
% development.
delete(functionSignituresAutocompleteInfoPath_dev)

% Cleanup publish directories. We do this after packaging the toolbox because
% some of the demos need to be on the MATLAB path.
if do_publish    
    for directory_cell = publish_dirs
        rmpath(directory)
    end
end

% Cleanup path
for directory = toolbox_dirs
    rmpath(directory{1})
end

close all
fprintf('Packaging complete. ')
if nTestsFailed >= 0
    fprintf('%d tests failed.\n', nTestsFailed)
else
    fprintf('Tests were skipped.\n')
end