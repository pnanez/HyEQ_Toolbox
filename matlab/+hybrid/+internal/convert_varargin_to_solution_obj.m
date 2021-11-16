function [hybrid_arc, label_ids, value_ids] = convert_varargin_to_solution_obj(varargin_cell, slice_ndxs)
% Given varargin to a HybridArc object according to the following pattern:
%     (sol) -> HybridArc(sol.t, sol.j, sol.x(:, slice_ndxs))
%  (sol, x) -> HybridArc(sol.t, sol.j,x(:, slice_ndxs))
% (sol, fh) -> HybridArc(sol.t, sol.j, fh(sol.x(:, slice_ndxs)), or
% (t, j, x) -> HybridArc(t, j, x(:, slice_ndxs)),
% 
% If 'slice_ndxs' is not provided, then the entire x array is used.
% % 
% The value of 'label_ids' is set to 'slice_ndxs', unless 'slice_ndxs' is not
% provided or 'fh' is used, in which case 'label_ids' is set to 1:length(x).
% % 
% The value of 'value_ids' is set to 1:length(x).

% Parse the base values of t, j, x.
if isa(varargin_cell{1}, 'HybridArc')
    assert(length(varargin_cell) <= 2)
    hybrid_sol_in = varargin_cell{1};
    t = hybrid_sol_in.t;
    j = hybrid_sol_in.j;
    x = hybrid_sol_in.x;
else 
    if length(varargin_cell) ~= 3
        throw(MException('Hybrid:InvalidArgument', ...
            ['If the first argument is not a HybridArc, then there must be ' ...
            'three input arguments. Instead there were %d.'], length(varargin_cell)))
    end
    t = varargin_cell{1};
    j = varargin_cell{2};
    x = varargin_cell{3};
    if ~isnumeric(t)
        e = MException('Hybrid:InvalidArgument', ...
            'When passing three arguments, the first argument must be numeric');
        throwAsCaller(e);
    end
    if ~isnumeric(j)
        e = MException('Hybrid:InvalidArgument', ...
            'When passing three arguments, the second argument must be numeric');
        throwAsCaller(e);
    end
    if ~isnumeric(x)
        e = MException('Hybrid:InvalidArgument', ...
            'When passing three arguments, the third argument must be numeric');
        throwAsCaller(e);
    end
end
if ~exist('slice_ndxs', 'var') || isempty(slice_ndxs)
    label_ids = (1:size(x, 2))';
    value_ids = (1:size(x, 2))';
else
    x = x(:, slice_ndxs);
    label_ids = slice_ndxs';
    value_ids = (1:size(x, 2))';
end
hybrid_arc = HybridArc(t, j, x);

assert(length(label_ids) == size(hybrid_arc.x, 2))
switch length(varargin_cell)
    case 1
        if ~isa(varargin_cell{1}, 'HybridArc')
            e = MException('Hybrid:InvalidArgument', ...
            'When passing one argument, it must be a HybridArc. Instead it was a %s.', ...
            class(hybrid_sol_in));
            throwAsCaller(e);
        end
        return
    case 2
        if ~isa(varargin_cell{1}, 'HybridArc')
            e = MException('Hybrid:InvalidArgument', ...
            ['When passing two arguments, the first argument must be a ' ...
            'HybridArc. Instead it was a %s.'], ...
            class(varargin_cell{1}));
            throwAsCaller(e);
        end
        if isa(varargin_cell{2}, 'function_handle')
            fh = varargin_cell{2};
            x = hybrid_arc.evaluateFunction(fh);
        elseif isnumeric(varargin_cell{2})
            x = varargin_cell{2}; % Replace x with second argument

            if exist('slice_ndxs', 'var')  && ~isempty(slice_ndxs)
                x = x(:, slice_ndxs);
            end
        else
            error('Incorrect')
        end
        label_ids = (1:size(x, 2))';
        value_ids = (1:size(x, 2))';
        hybrid_arc = HybridArc(t, j, x);
    case 3
        hybrid_arc = HybridArc(t, j, x);
    otherwise
        error('Hybrid:InvalidArgument', 'Expected 1, 2, or 3 arguments.')
end
if length(t) ~= length(j)
    e = MException('HybridToolbox:MismatchedSizes', 'length(t)=%d ~= length(j)=%d', length(t), length(j));
    throwAsCaller(e)
end
if length(t) ~= size(x, 1)
    e = MException('HybridToolbox:MismatchedSizes', 'length(t)=%d ~= size(values, 1)=%d', length(t), size(x, 1));
    throwAsCaller(e)
end

assert(size(hybrid_arc.x, 2) == numel(label_ids))

end