function is_used = getUsedArguments(fh)
% GETUSEDARGUMENTS Get a logical vector that indicates which input arguments of
% the given function handle are used (indicated by a '1') and which are ignored
% (indicated by a '0'). The functon must be an anonymous function. That is, 
% it must be defined using the syntax 
%   fh = @(x1, x2, ..., xn) <some expression of x1, x2, ..., xn>.
% rather than being defined as a local function, in a function file, or as a
% class method.
% Ignored arguments are indicated by replacing the argument name with a tiled "~".

% Get the arguments of the given function as a string, with the arguments
% separated by commas.
if ~isa(fh, 'function_handle')
    error('Argument was not a function handle, it was a %s', ...
        class(fh));
end

tokens = regexp(func2str(fh), '@\((?<args>.*?)\)','names');
if nargin(fh) ~= 0 && isempty(tokens)
    error('Function arguments for ''%s'' cannot be read. Use an anonymous function (such as @(x, t, j) x).', func2str(fh))
end
comma_separated_args = tokens.args;
if isempty(comma_separated_args)
    is_used = [];
    return;
end
args = regexp(comma_separated_args, ',', 'split');
is_used = ~strcmp('~', args);
end