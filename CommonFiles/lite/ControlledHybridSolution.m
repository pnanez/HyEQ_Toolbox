classdef ControlledHybridSolution < HybridSolution

    properties(SetAccess = immutable)
        u (:, :) double;
    end
    
    methods
        function this = ControlledHybridSolution(t, j, x, u, f_vals, g_vals, C_vals, D_vals, tspan, jspan)
            this = this@HybridSolution(t, j, x, f_vals, g_vals, C_vals, D_vals, tspan, jspan);
            assert(size(u, 1) == length(t), "length of u doesn't match t")
            this.u = u;
        end
    end

end