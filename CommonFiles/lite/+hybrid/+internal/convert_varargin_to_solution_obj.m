function hybrid_sol = convert_varargin_to_solution_obj(varargin_cell)
switch length(varargin_cell)
    case 1
        hybrid_sol = varargin_cell{1};
        assert(isa(hybrid_sol, "HybridSolution"), ...
            "When passing one argument, it must be a HybridSolution")
        return
    case 2
        base_sol = varargin_cell{1};
        assert(isa(base_sol, "HybridSolution"), ...
            "When passing two arguments, first argument must be a HybridSolution")
        values = varargin_cell{2};
        t = base_sol.t;
        j = base_sol.j;
        if isa(values, "function_handle")
            values = base_sol.evaluateFunction(values);
        end
    case 3
        t = varargin_cell{1};
        j = varargin_cell{2};
        values = varargin_cell{3};
    otherwise
        error("Expected 1, 2, or 3 arguments.")
end
assert(length(t) == length(j));
assert(length(t) == size(values, 1));
hybrid_sol = HybridSolution(t, j, values);

end