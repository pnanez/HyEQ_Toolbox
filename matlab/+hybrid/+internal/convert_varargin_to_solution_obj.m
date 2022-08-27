function [hybrid_arc, original_ndxs] = convert_varargin_to_solution_obj(varargin_cell, select_ndxs)
% Given varargin to a HybridArc object according to the following pattern:
%     (sol) -> HybridArc(sol.t, sol.j, sol.x(:, select_ndxs))
%  (sol, x) -> HybridArc(sol.t, sol.j,x(:, select_ndxs))
% (sol, fh) -> HybridArc(sol.t, sol.j, fh(sol.x(:, select_ndxs)), or
% (t, j, x) -> HybridArc(t, j, x(:, select_ndxs)),
% 
% If 'select_ndxs' is not provided, then the entire x array is used.
% 
% The value of 'original_ndxs' is set to 'select_ndxs', unless 'select_ndxs' is not
% provided or 'fh' is used, in which case 'original_ndxs' is set to 1:length(x).

if ~exist('select_ndxs', 'var')
    select_ndxs = [];
end
do_select = ~isempty(select_ndxs);

if isnumeric(varargin_cell{1})
% If the first index is numeric, then varargin_cell must be in the form (t, j, x).
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
    hybrid_arc = HybridArc(t, j, x);

    if do_select
        hybrid_arc = hybrid_arc.select(select_ndxs);
        original_ndxs = select_ndxs;
    else
        original_ndxs = 1:size(x, 2);
    end
    return
end

% From this point on, the first argument must be a HybridArc. 
hybrid_arc = varargin_cell{1};
if ~isa(hybrid_arc, 'HybridArc')
    e = MException('Hybrid:InvalidArgument', ...
    'When passing one argument, it must be a HybridArc. Instead it was a %s.', ...
    class(hybrid_arc));
    throwAsCaller(e);
end

% The optional second argument can be 'fh' or 'x'.
assert(length(varargin_cell) <= 2, 'Hybrid:InvalidArgument', 'Expected 1, 2 arguments.')

do_transform = false;
if length(varargin_cell) == 2 
    second_arg_is_x = isnumeric(varargin_cell{2});
    second_arg_is_fh = isa(varargin_cell{2}, 'function_handle');
    assert(second_arg_is_x || second_arg_is_fh, 'Hybrid:InvalidArgument')
    if second_arg_is_x
        t = hybrid_arc.t;
        j = hybrid_arc.j;
        x = varargin_cell{2};
        hybrid_arc = HybridArc(t, j, x);
    end
    if second_arg_is_fh
        do_transform = true;
        fh = varargin_cell{2};
    end
end

if do_select
    hybrid_arc = hybrid_arc.select(select_ndxs);
    original_ndxs = select_ndxs;
else
    original_ndxs = 1:size(hybrid_arc.x, 2);
end

if do_transform
    hybrid_arc = hybrid_arc.transform(fh);
    original_ndxs = 1:size(hybrid_arc.x, 2);
end

assert(size(hybrid_arc.x, 2) == numel(original_ndxs))
assert(isrow(original_ndxs))

end