classdef SublevelSetsHybridSystem < HybridSystem

    properties
        gravity = 9.8;
        bounce_coeff = 0.9;
    end

    methods 
        
        function xdot = flow_map(this, x, t, j)  %#ok<*INUSD> (Surpress warnings in this file)
            xdot = [x(2); -this.gravity];
        end

        function xplus = jump_map(this, x, t, j)  
            xplus = [0; -this.bounce_coeff*x(2)];
        end

        function C = flow_set_indicator(this, x, t, j) 
            C = -x(1);
        end
        
        function D = jump_set_indicator(this, x, t, j)
            D = x(1);
        end
        
        function sol = solve(this, x0, tspan, jspan, config)
            if ~exist("config", "var")
                config = HybridSolverConfig();
            end
            config.hybridLogic = SublevelSetsHybridEventLogic(HybridPriority.FLOW);
            sol = this.solve@HybridSystem(x0, tspan, jspan, config);
        end
    end
    
end