classdef CompoundHybridSolution < HybridSolution

    properties(SetAccess = immutable)
        subsys_sols
    end
    
    methods
        function this = CompoundHybridSolution(compound_solution, subsys_sols, tspan, jspan)
            cs = compound_solution;
            this = this@HybridSolution(cs.system, cs.t, cs.j, cs.x, tspan, jspan);
            this.subsys_sols = subsys_sols;
        end
    end
end

