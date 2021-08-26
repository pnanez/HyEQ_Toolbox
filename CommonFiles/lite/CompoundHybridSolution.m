classdef CompoundHybridSolution < HybridSolution

    properties(SetAccess = immutable)
        subsys_sols
    end
    
    methods
        function this = CompoundHybridSolution(compound_solution, subsys_sols, tspan, jspan)
            cs = compound_solution;
            this = this@HybridSolution(cs.t, cs.j, cs.x, cs.C_end, cs.D_end, tspan, jspan);
            this.subsys_sols = subsys_sols;
        end
    end
end

