hyeqsolver_path = which('HyEQsolver', '-all');
if length(hyeqsolver_path) > 1
    error('Multiple versions of HyEQsolver() are on the MATLAB path. Have you uninstalled the previous version of the HybridEquationSolver?')
elseif isempty(hyeqsolver_path)
    error('Hybrid Equations Toolbox is not installed.')
end

if ~verLessThan('matlab','9.10')
    enable_enhanced_autocomplete(hyeqsolver_path)
end

disp('Hybrid Equations Toolbox is ready to use.')

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
