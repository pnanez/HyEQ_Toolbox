hyeqsolver_path = which('HyEQsolver', '-all');
if length(hyeqsolver_path) > 1
    error('Multiple versions of HyEQsolver() are on the MATLAB path. Have you uninstalled the previous version of the HybridEquationSolver?')
elseif isempty(hyeqsolver_path)
    error('Hybrid Equations Toolbox is not installed.')
end

if verLessThan('matlab','9.10')
    disable_enhanced_autocomplete(hyeqsolver_path)
end

disp('Hybrid Equations Toolbox is ready to use.')

function disable_enhanced_autocomplete(hyeqsolver_path)
assert(contains(hyeqsolver_path, 'Hybrid Equations Toolbox'))

hyeqsolver_path = hyeqsolver_path{1}; % De-cell
src_path = replace(replace(hyeqsolver_path,'/HyEQsolver.m',''),'\HyEQsolver.m','');
p_before = fullfile(src_path, 'functionSignatures.json');
p_after = fullfile(src_path, 'functionSignatures_unused.json');
if exist(p_before, 'file') == 2
    movefile(p_before, p_after);
end
end
