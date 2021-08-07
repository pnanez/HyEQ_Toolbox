classdef CompoundHybridSolution < HybridSolution

    properties(SetAccess = immutable)
        subsystem1_sol
        subsystem2_sol
    end
    
    methods
        function this = CompoundHybridSolution(compound_solution, subsystem1_sol, subsystem2_sol, tspan, jspan)
            cs = compound_solution;
            this = this@HybridSolution(cs.t, cs.j, cs.x, cs.f_vals, cs.g_vals, cs.C_vals, cs.D_vals, tspan, jspan);
            this.subsystem1_sol = subsystem1_sol;
            this.subsystem2_sol = subsystem2_sol;
        end
    end
end

