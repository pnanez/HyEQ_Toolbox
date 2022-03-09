function package_toolbox()
% Create a MATLAB Toolbox package from the Hybrid Equations Toolbox source code.
% 
% Before running this script to generate a released toolbox package, perform the
% following steps: 
% 1. Open doc/GettingStarted.mlx. Run once to generate plots, then clear the output
%    of "configure_toolbox" in the first cell.
% 2. Update the build number in HybridEquationsToolbox.prj.
%
% By Paul Wintz, 2021-2022.

% 'package_toolbox' is a function instead of script because functions don't
% use the base workspace, they have their own workspace. This ensures that when
% package_toolbox() is called, nothing will be messed up by existing variables
% in the workspace (e.g., a variable named 'plot' that hides the built-in 'plot'
% function).

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

wd_before_package_toolbox = pwd();
proj_root = hybrid.getFolderLocation('');
cd(proj_root)

% Setup path.
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

    cd('doc/src')
    RebuildTexFiles;
    cd(proj_root)

    % Export GettingStarted.mlx. We can't use 'publish' on GettingStarted
    % because it is a live script.
    mlxloc = fullfile(pwd(),'doc','GettingStarted.mlx');
    fileout = fullfile(pwd(),'doc','html','GettingStarted.html');
    matlab.internal.liveeditor.openAndConvert(mlxloc,fileout) % This is 'fragile' and might break on future versions of MATLAB.
    fprintf(['Published %s\n' ...
             '       to %s\n'], mlxloc, fileout)

    % Publish help files via 'publish' command.
    directory = 'doc';
    cd(directory);
    m_demo_paths = dir(fullfile('*.m'));
    for i = 1:numel(m_demo_paths)
        file = fullfile(m_demo_paths(i).folder, m_demo_paths(i).name);
        assert(isfile(file));
        
        % Close any simulink systems that happen to have the same name as the
        % example.
        DISABLE_WARNING = 0;
        close_system(m_demo_paths(i).name(1:end-2), DISABLE_WARNING)

        if endsWith(m_demo_paths(i).name, 'demo.m')
            html_file = publish(file, 'showCode', true);
        else
            html_file = publish(file, 'showCode', false);
        end
        fprintf(['Published %s \n' ...
            '       to %s.\n'], file, html_file)
    end
    cd(hybrid.getFolderLocation('root'));

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

cd(wd_before_package_toolbox)

end