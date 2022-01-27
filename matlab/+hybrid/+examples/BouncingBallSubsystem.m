classdef BouncingBallSubsystem < HybridSubsystem
        
    properties
        bounce_coef = 0.9; 
        gravity = -9.8;
    end
    
    methods
        function obj = BouncingBallSubsystem() % Constructor.
            state_dim = 2;
            input_dim = 1;
            output_dim = 2; % Matches state_dim (default).
            output_fnc = @(x) x; % Full-state output (default).
            obj = obj@HybridSubsystem(state_dim, input_dim, output_dim, output_fnc);
        end
        
        function xdot = flowMap(this, x, u, t, j)  
            xdot = [x(2); this.gravity];
        end

        function xplus = jumpMap(this, x, u, t, j) 
            xplus = [x(1); -this.bounce_coef*x(2) + u];
        end 

        function C = flowSetIndicator(this, x, u, t, j)
            C = x(1) >= 0 || x(2) >= 0;
        end 

        function D = jumpSetIndicator(this, x, u, t, j)
            D = x(1) <= 0 && x(2) <= 0;
        end
    end
end