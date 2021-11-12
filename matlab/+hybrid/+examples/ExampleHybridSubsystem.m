classdef ExampleHybridSubsystem < HybridSubsystem
        
    properties
        bounce_coef = 0.9; 
    end
    
    methods
        function obj = ExampleHybridSubsystem()
            state_dim = 2;
            input_dim = 1;
            obj = obj@HybridSubsystem(state_dim, input_dim);
        end
        
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