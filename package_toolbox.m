% Create a MATLAB Toolbox package from the Hybrid Equations Toolbox source code.
% Before running this script, the following steps should be performed:
%
% 1. Within the <toolbox root>/doc/src directory, run "source ./build_html.sh"
% 2. Open doc/GettingStarted.mlx. Run once to generate plots, then clear the output
%    of "configure_toolbox" in the first cell.
% 3. Update the build number in HybridEquationsToolbox.prj.
%
% By Paul Wintz.

close all

configure_development_path

do_publish = true;
do_tests = true;
do_package = true;

projectFile = 'HybridEquationsToolbox.prj';
toolbox_dirs = {'matlab', ...
                'matlab/legacyPlottingFunctions', ...
                'simulink/Library2014b', ...
                'doc'};

% Check that the working dirctory is the root of the HyEQ toolbox by checking
% that it contains the project file "HybridEquationsToolbox.prj".
proj_root = pwd();
assert(isfile(fullfile(proj_root, projectFile)), ...
        'The working directory is not the root of the HyEQ toolbox.')

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

    % Export GettingStarted.mlx. We can't use 'publish' on GettingStarted
    % because it is a live script.
    mlxloc = fullfile(pwd(),'doc','GettingStarted.mlx');
    fileout = fullfile(pwd(),'doc','html','GettingStarted.html');
    matlab.internal.liveeditor.openAndConvert(mlxloc,fileout)
    fprintf(['Published %s\n' ...
             '       to %s\n'], mlxloc, fileout)

    % Publish help files via 'publish' command.
    directory = 'doc';
    addpath(directory)
    m_file_path = dir(fullfile(directory,'*.m'));
    for i = 1:numel(m_file_path)
        file = fullfile(m_file_path(i).folder, m_file_path(i).name);
        outdir = fullfile(m_file_path(i).folder, 'html');
        assert(isfile(file));
        html_file = publish(file);
        fprintf(['Published %s \n' ...
                 '       to %s.\n'], file, html_file)
    end

    % Close all the figures that were opened.
    close all
end

% Move the function signatures file so that it is unused in the packaged version
% until 'configure_toolbox' is run after installation on an appropriate version
% of MATLAB.
copyfile(functionSignituresAutocompleteInfoPath_dev, functionSignituresAutocompleteInfoPath_package)

% Create the .mltbx file.
if do_package
    matlab.addons.toolbox.packageToolbox(projectFile)
end

% Move the function signatures file back so that it is enabled during
% development.
delete(functionSignituresAutocompleteInfoPath_package)

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