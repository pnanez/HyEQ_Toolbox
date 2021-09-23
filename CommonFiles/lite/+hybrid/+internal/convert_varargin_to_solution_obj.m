function hybrid_sol = convert_varargin_to_solution_obj(varargin_cell)
switch length(varargin_cell)
    case 1
        hybrid_sol = varargin_cell{1};
        assert(isa(hybrid_sol, 'HybridSolution'), ...
            'When passing one argument, it must be a HybridSolution')
        return
    case 2
        base_sol = varargin_cell{1};
        assert(isa(base_sol, 'HybridSolution'), ...
            'When passing two arguments, the first argument must be a HybridSolution')
        values = varargin_cell{2};
        t = base_sol.t;
        j = base_sol.j;
        if isa(values, 'function_handle')
            values = base_sol.evaluateFunction(values);
        end
    case 3
        t = varargin_cell{1};
        j = varargin_cell{2};
        assert(isnumeric(t), 'When passing three arguments, the first argument must be numeric')
        assert(isnumeric(j), 'When passing three arguments, the second argument must be numeric')
        values = varargin_cell{3};
    otherwise
        error('Expected 1, 2, or 3 arguments.')
end
if length(t) ~= length(j)
    e = MException('HybridToolbox:MismatchedSizes', 'length(t)=%d ~= length(j)=%d', length(t), length(j));
    throwAsCaller(e)
end
if length(t) ~= size(values, 1)
    e = MException('HybridToolbox:MismatchedSizes', 'length(t)=%d ~= size(values, 1)=%d', length(t), size(values, 1));
    throwAsCaller(e)
end
hybrid_sol = HybridSolution(t, j, values);

end