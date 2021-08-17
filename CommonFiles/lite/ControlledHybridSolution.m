classdef ControlledHybridSolution < HybridSolution

    properties(SetAccess = immutable)
        u (:, :) double;
    end
    
    methods
        function this = ControlledHybridSolution(system, t, j, x, u, tspan, jspan)
            this = this@HybridSolution(system, t, j, x, tspan, jspan);
            assert(size(u, 1) == length(t), "length of u doesn't match t")
            this.u = u;
        end
    end
    
    methods(Access = protected)
       function generateDependentData(this) % Override the superclass method.
           [this.f_vals, this.g_vals, this.C_vals, this.D_vals] ...
                    = this.system.generateFGCD(this.t, this.j, this.x, this.u); 
        end 
    end

end