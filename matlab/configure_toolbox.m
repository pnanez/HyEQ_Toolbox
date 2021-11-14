% Script for finishing the installation of the Hybrid Equations Toolbox.

hyeqsolver_path = which('HyEQsolver', '-all');
if length(hyeqsolver_path) > 1
    error('Multiple versions of HyEQsolver() are on the MATLAB path. Have you uninstalled the previous version of the HybridEquationSolver?')
elseif isempty(hyeqsolver_path)
    error('Hybrid Equations Toolbox is not installed.')
end

if ~verLessThan('matlab','9.10')
    enable_enhanced_autocomplete(hyeqsolver_path)
end

promptMessage = sprintf(['Do you want to run automated tests?\n' ...
                    'The tests will take less than a minute.']);
button = questdlg(promptMessage, 'Run Tests', 'Run Tests', 'Skip Tests', 'Run Tests');
if strcmpi(button, 'Run Tests')
  nFailed = hybrid.tests.run;
  if nFailed > 0
    fprintf(['\nThe Hybrid Equations Toolbox is installed but %d tests failed. ' ...
            'Some features will not work as expected.\n'], nFailed);
    return
  else 
    disp('All tests passed.');
  end
end

fprintf('\nThe Hybrid Equations Toolbox is ready to use.\n')

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
    disp('Autocomplete information enabled for Hybrid Equations Toolbox.')
end
end
