function sorted_names = sortInputAndOutputFunctionNames(inputs, outputs)
% SORTINPUTANDOUTPUTFUNCTIONNAMES
% Create a char array that indicates an order that the given input and output
% functions can be evaluated. For a system that is a composition of N
% subsystems, the input function of the ith system must have one of the
% following signatures: @(x1, x2, ..., xN), @(x1, x2, ..., xN, t), or 
% @(x1, x2, ..., xN, t, j), and the output function of the ith system must
% match one of the following signatures @(x), @(x, u), @(x, u, t), or 
% @(x, u, t, j).

n_ss = length(inputs); % number of subsystems

if n_ss > 9
    warning('CompositeHybridSystem is not expected to work with more than 9 subsystems.')
end

in_dependence_on_out = NaN(n_ss);
out_dependence_on_in = NaN(n_ss);
for i_ss = 1:n_ss
in_dependence_on_out(i_ss, :) = getInputDependenciesMatrix(inputs{i_ss}, n_ss);
out_dependence_on_in(i_ss, :) = getOutputDependenciesMatrix(...
                                                    outputs{i_ss}, n_ss, i_ss);
end
dependencies = [         zeros(n_ss), in_dependence_on_out; 
                out_dependence_on_in,          zeros(n_ss)];
fnc_names_unsorted = createUnsortedFunctionNamesArray(n_ss);

sorted_names = char(zeros(n_ss, 2));
for i=1:(2*n_ss)
   next = find(~(dependencies*ones(2*n_ss, 1)), 1);
   if isempty(next)
      e = MException('sortInputAndOutputFunctionNames:DependencyLoop', 's%', ...
          'The given input and output functions have a dependency loop. ', ...
          'If there are unused input arguments for the input and output functions, ', ... 
          'replace those arguments with ''~''. ', ...
          '(For example, use ''@(x, ~, t, j)'' instead of ''@(x, u, t, j)'' if ''u'' is unused). ', ... 
          'Otherwise, redesign the connections between systems to remove the dependency loop.');
      throwAsCaller(e)
   end
   sorted_names(i, :) = fnc_names_unsorted(next, :);
   dependencies(:, next) = 0;
   dependencies(next, :) = inf;
end
end

function unsorted_names = createUnsortedFunctionNamesArray(n_ss)
unsorted_names = char(zeros(n_ss, 2));
unsorted_names(1:n_ss, 1) = 'u';
unsorted_names(n_ss+(1:n_ss), 1) = 'y';
unsorted_names(1:n_ss, 2) = (1:n_ss)' + 48;
unsorted_names(n_ss+(1:n_ss), 2) = (1:n_ss)' + 48;
end

function is_dependent = getInputDependenciesMatrix(kappa, n_subsystems)
is_dependent = zeros(1, n_subsystems);
is_used = hybrid.internal.getUsedArguments(kappa);
n = min(length(is_used), n_subsystems);
is_dependent(1:n) = double(is_used(1:n));
end

function is_dependent = getOutputDependenciesMatrix(h, n_subsystems, i_subsystem)
is_dependent = zeros(1, n_subsystems);
is_used = hybrid.internal.getUsedArguments(h);
if length(is_used) >= 2
    is_dependent(i_subsystem) = is_used(2);
end
end