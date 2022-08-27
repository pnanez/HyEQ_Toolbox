function configureToolbox()
% Script for finishing the installation of the Hybrid Equations Toolbox.
% In particular, this script:
% 1. Checks that only one version of the toolbox is installed.
% 2. Prompts the user to run automated tests.
% 3. Enables autocomplete data for the MATLAB editor in supported versions of
%    MATLAB. 
% 4. Saves the Simulink Library file with the current MATLAB version.
% 
% Added in HyEQ Toolbox version 3.0 

% Written by Paul K. Wintz, Hybrid Systems Laboratory, UC Santa Cruz (©2022). 

hyeqsolver_paths = which('HyEQsolver', '-all');
if length(hyeqsolver_paths) > 1

    try
        for i = 1:length(hyeqsolver_paths)
            path_to_solver = fileparts(hyeqsolver_paths{i});

            toolbox_root_path_candidate = what(fullfile(path_to_solver, '..', '..')).path;
            uninstall_script_candidate_path = fullfile(toolbox_root_path_candidate, 'tbclean.m');

            if exist(uninstall_script_candidate_path, 'file') == 2
                uninstall_script_path = uninstall_script_candidate_path;
                disp(['A previous version of the Hybrid Equations Toolbox was found at "', toolbox_root_path_candidate, '".'])
                disp(['Click <a href="matlab:run(''', uninstall_script_path,''')">here</a> to start the unstallation. ', ...
                    'Afterwards, please run <a href="matlab:run(''hybrid.configureToolbox'')">hybrid.configureToolbox</a> again.'])
                return
            end
        end
        error('An uninstall script could not be found for any of the installed versions of the HyEQ Toolbox.')
    catch e
        warning('Hybrid:FailedAutomaticUninstall', ...
            ['The following error occured when trying to remove the ' ...
            'old toolbox versions: %s. Please uninstall old versions manually.'], e.message)
        disp('Multiple versions of the HyEQsolver function were found on the MATLAB path at the following locations:')
        hyeqsolver_paths  %#ok<NOPRT> 

        error(['Previously installed versions of the Hybrid Equations Toolbox ' ...
            'must be removed before the newest version can be used.'])
    end
elseif isempty(hyeqsolver_paths)
    error('The Hybrid Equations Toolbox is not installed.')
end

% Enable Autocomplete information (if supported)
if ~verLessThan('matlab','9.10')
    enable_enhanced_autocomplete(hyeqsolver_paths)
end

% Open and save the Simulink Library
close_system('HyEQ_Library', 0) % Ensure there is not an old version of the library open.
% Open, save, and close the new version.
file_path = fullfile(hybrid.getFolderLocation('Simulink'), 'HyEQ_Library.slx');
open_system(file_path)
save_system(file_path)
close_system(file_path)

% Prompt to run automated tests.
promptMessage = sprintf(['Do you want to run automated tests?\n' ...
                    'The tests will take less than a minute.']);
button = questdlg(promptMessage, 'Run Tests', 'Run Tests', 'Skip Tests', 'Run Tests');
if strcmpi(button, 'Run Tests')
  nFailed = hybrid.tests.run('essential');
  if nFailed > 0
    fprintf(['\nThe Hybrid Equations Toolbox is installed but %d tests failed. ' ...
            'Some features will not work as expected.\n'], nFailed);
    return
  else 
    disp('All tests passed.');
  end
else 
    disp('Tests skipped.')
end

fprintf('\nThe Hybrid Equations Toolbox is ready to use.\n')
end

% ========= Local Functions ========= %

function enable_enhanced_autocomplete(hyeqsolver_path)
% assert(contains(hyeqsolver_path, 'Hybrid Equations Toolbox'))

hyeqsolver_path = hyeqsolver_path{1}; % De-cell
src_path = replace(hyeqsolver_path,'HyEQsolver.m','');
p_before = fullfile(src_path, 'functionSignatures_disabled.json');
p_after = fullfile(src_path, 'functionSignatures.json');
if exist(p_before, 'file') == 2
    movefile(p_before, p_after);
elseif ~exist(p_after, 'file')
    warning(['Could not find autocomplete information source file \n\t''%s'' \n' ...
        'nor destination file \n\t''%s''.'], ...
        p_before, p_after)
end
if exist(p_after, 'file')
    disp('Autocomplete information is enabled for the Hybrid Equations Toolbox.')
end
end
