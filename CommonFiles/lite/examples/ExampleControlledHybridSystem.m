classdef ExampleControlledHybridSystem < ControlledHybridSystem
    
    properties(SetAccess = immutable)
        % Define the abstract properties from ControlledHybridSystem.
        state_dimension = 2
        control_dimension = 1
    end
    
    properties
        bounce_coef = 0.9; 
    end
    
    methods
        function xdot = flow_map(~, x, u, ~, ~)  
            xdot = [x(2); u];
        end

        function xplus = jump_map(this, x, u, t, j) 
            xplus = [x(1); -this.bounce_coef*x(2)];
        end 

        function C = flow_set_indicator(this, x, u, t, j)
            C = 1;
        end 

        function D = jump_set_indicator(this, x, u, t, j)
            D = x(1) <= 0 && x(2) <= 0;
        end
    end
end