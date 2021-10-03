function [us, ys] = evaluateInOrder(order, inputs, outputs, xs, t, js)
% EVALUATEINORDER Evaluates given input and output functions in a specified order.
%
% Arguments:
% order (char array): Contains a row for each entry in 'inputs' and each entry in
% * 'outputs'. A row that starts with 'u' indicates an input function and row that starts
% * with 'y' indicates an output function. The second chararacter is an positive
% * integer that indicates the index of the corresponding function. Every input
% * and output function corresponds to a unique row in 'order'. The order
% * they appear is the order they are evaluated. 
% * See hybrid.internal.sortInputAndOutputFunctionNames() for how to generate this array.
% inputs (cell array of function handles): Contains function handles for each
% * input function. Each function must have the signature required by
% * CompositeHybridSystem.
% outputs (cell array of function handles): Contains function handles for each
% * output function. Each function must have the signature required by
% * CompositeHybridSystem.
% xs (cell array of double vectors): Contains the state vectors of each subsystem.
% t (double): Continuous time of composite system.
% js (double array): Discrete time of each subsystem.

n = length(inputs);
assert(n == length(outputs))
assert(2*n == length(order), '2n = %d, length(order) = %d', 2*n, length(order))
assert(iscell(xs), 'xs is not a cell array')
assert(isscalar(t), 't is not a scalar')
assert(isvector(js), 'js is not a vector')
assert_all_unique(order)

us = cell(1,n);
ys = cell(1,n);

CHAR_ZERO_VALUE = 48; % The integer value of char '0' is 48. 
for row = 1:size(order, 1)
    i_ss = order(row, 2) - CHAR_ZERO_VALUE;
    switch order(row, 1)
        case 'y'
            h = outputs{i_ss};
            ys{i_ss} = eval_output(h, xs{i_ss}, us{i_ss}, t, js(i_ss));
        case 'u'
            kappa = inputs{i_ss};
            us{i_ss} = eval_input(kappa, ys, t, js(i_ss));
        otherwise
            error('Hybrid:InvalidFunctionName','Invalid function name: %s', order(row, :));
    end
end
end

function u = eval_input(kappa, ys, t, j)
assert(isscalar(t), 't is not a scalar')
assert(isscalar(j), 'j is not a scalar')
narg = nargin(kappa);
switch narg
    case length(ys)
        u = kappa(ys{:});
    case length(ys) + 1
        u = kappa(ys{:}, t);
    case length(ys) + 2
        u = kappa(ys{:}, t, j);
    otherwise 
        if narg < length(ys)
            u = kappa(ys{1:narg});
        else
            error('Hybrid:InvalidArguments',...
                'Unexpected number of input arguments for function %s: %d', ...
                narg, func2str(kappa));
        end
end
end

function u = eval_output(h, x, u, t, j)
assert(isscalar(t), 't is not a scalar')
assert(isscalar(j), 'j is not a scalar')
switch nargin(h)
    case 1
        u = h(x);
    case 2
        u = h(x, u);
    case 3
        u = h(x, u, t);
    case 4
        u = h(x, u, t, j);
    otherwise
        error('Hybrid:InvalidArguments''Unexpected number of arguments for function ''%s''. ' + ... 
            'Must be 1, 2, 3, or 4. Instead was %d.',...
            func2str(h), nargin(h));
end
end

function assert_all_unique(char_array)
assert(ischar(char_array), 'expected char array, instead was %s', class(char_array));
assert(size(char_array, 2) == 2, 'expected 2 columns')
unique_rows = unique(char_array,'rows');
assert(length(char_array) == length(unique_rows), 'Hybrid:NonuniqueRows', 'Rows are not all unique');
end