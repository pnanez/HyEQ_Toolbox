classdef HybridSolutionWithInput < HybridSolution

    properties(SetAccess = immutable)
        u (:, :) double;
    end
    
    methods
        function this = HybridSolutionWithInput(t, j, x, u, C_end, D_end, tspan, jspan)
            this = this@HybridSolution(t, j, x, C_end, D_end, tspan, jspan);
            assert(size(u, 1) == length(t), ...
                "length(u)=%d doesn't match length(t)", ...
                size(u, 1), length(t))
            this.u = u;
        end
    end

end