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

do_publish_docs = false;
do_tests = false;
do_package = true;
do_cleanup_path = do_package && true;

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

functionSignituresAutocompleteInfoPath_dev = fullfile('matlab', 'functionSignatures.json');
functionSignituresAutocompleteInfoPath_package = fullfile('matlab', 'functionSignatures_disabled.json');

if do_tests
    nTestsFailed = hybrid.tests.run();
    validateFunctionSignaturesJSON(functionSignituresAutocompleteInfoPath_dev)
else
    nTestsFailed = -1;
end

if do_publish_docs
    % Publish help files

    cd('doc/src')
    ExtractSimulinkFunctionBlocks;
    cd(proj_root)

    % Publish help files via 'publish' command.
    cd('doc');
    m_demo_paths = dir(fullfile('*.m'));
    for i = 1:numel(m_demo_paths)
        mfile_path = fullfile(m_demo_paths(i).folder, m_demo_paths(i).name);
        publish_to_html(mfile_path)
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
    
    if endsWith(mfile_path, 'demo.m')
        html_file = publish(mfile_path, 'showCode', true);
    else
        html_file = publish(mfile_path, 'showCode', false);
    end
    fprintf(['Published %s \n' ...
        '       to %s.\n'], mfile_path, html_file)
end