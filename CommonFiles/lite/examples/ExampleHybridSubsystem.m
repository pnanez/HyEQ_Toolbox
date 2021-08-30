classdef ExampleHybridSubsystem < HybridSubsystem
    
    properties(SetAccess = immutable)
        % Define the abstract properties from HybridSubsystem.
        state_dimension = 2
        input_dimension = 1
        output_dimension = 2;
    end
    
    properties
        bounce_coef = 0.9; 
    end
    
    methods
        function xdot = flowMap(~, x, u, ~, ~)  
            xdot = [x(2); u];
        end

        function xplus = jumpMap(this, x, u, t, j) 
            xplus = [x(1); -this.bounce_coef*x(2) + u];
        end 

        function C = flowSetIndicator(this, x, u, t, j)
            C = 1;
        end 

        function D = jumpSetIndicator(this, x, u, t, j)
            D = x(1) <= 0 && x(2) <= 0;
        end
    end
end