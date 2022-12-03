function package_toolbox()
% Create a MATLAB Toolbox package from the Hybrid Equations Toolbox source code.
% 
% Before running this script to generate a released toolbox package,
% update the build number in HybridEquationsToolbox.prj.
%
% By Paul Wintz, 2021-2022.

% 'package_toolbox' is a function instead of script so that it has its own
% variable workspace (functions don't use the base workspace, they have their
% own workspace). This ensures that when 
% package_toolbox() is called, nothing will be messed up by existing variables
% in the workspace (e.g., a variable named 'plot' that hides the built-in 'plot'
% function).

close all

configure_development_path

do_publish_docs = true;
do_tests = true;
do_package = true;
do_cleanup_path = do_package && true;

% Make sure we are creating package using the latest version of MATLAB (update
% the version string as new versions are released).
assert(strcmp(version('-release'), '2022b'))

projectFile = 'HybridEquationsToolbox.prj';
toolbox_dirs = {'Examples', ...
                'matlab', ...
                fullfile('matlab', 'legacyPlottingFunctions'), ...
                'simulink'};

wd_before_package_toolbox = pwd();
proj_root = hybrid.getFolderLocation('');
cd(proj_root)

% Setup path.
for directory = toolbox_dirs
    addpath(directory{1})
end

functionSignituresAutocompleteInfoPath_dev = hybrid.getFolderLocation('matlab', 'functionSignatures.json');
functionSignituresAutocompleteInfoPath_package = hybrid.getFolderLocation('matlab', 'functionSignatures_disabled.json');

if do_tests
    nTestsFailed = hybrid.tests.run();
    validateFunctionSignaturesJSON(functionSignituresAutocompleteInfoPath_dev)
else
    nTestsFailed = -1;
end

% Close all Simulink systems.
while ~isempty(gcs())
    close_system(gcs())
end

if do_publish_docs
    % Publish help files

    % Extract MATLAB code from Simulink blocks to include in the documentation.
    cd(hybrid.getFolderLocation('doc', 'src'));
    ExtractSimulinkFunctionBlocks;

    % Publish help files via 'publish' command.
    cd(hybrid.getFolderLocation('doc'));
    m_demo_paths = dir(fullfile('*.m'));
    for i = 1:numel(m_demo_paths)
        mfile_path = fullfile(m_demo_paths(i).folder, m_demo_paths(i).name);
        publish_to_html(mfile_path)
    end
    cd(proj_root);

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
if do_cleanup_path
    for directory = toolbox_dirs
        rmpath(directory{1})
    end
    rmpath(proj_root)
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

function publish_to_html(mfile_path)
    assert(isfile(mfile_path));
    
    html_file = publish(mfile_path, ...
        'catchError', false, ... % Terminate if there is an error.
        'showCode', endsWith(mfile_path, 'demo.m')); % Display code in HTML for files with names that end with "demo.m".

    fprintf(['Published %s \n' ...
        '       to %s.\n'], mfile_path, html_file)
end