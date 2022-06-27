classdef BouncingBallSubsystem < HybridSubsystem
% 
% Added in HyEQ Toolbox version 3.0.

% Written by Paul K. Wintz, Hybrid Systems Laboratory, UC Santa Cruz (©2022).   
    properties
        bounce_coef = 0.9; 
        gravity = -9.8;
    end

    properties(SetAccess = immutable)
        % Define properties for referencing the state components
        height_index = 1;
        velocity_index = 2;
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
            v = x(this.velocity_index);
            xdot = [v; this.gravity];
        end

        function xplus = jumpMap(this, x, u, t, j) 
            h = x(this.height_index);
            v = x(this.velocity_index);
            xplus = [h; -this.bounce_coef*v + u];
        end 

        function C = flowSetIndicator(this, x, u, t, j)
            h = x(this.height_index);
            v = x(this.velocity_index);
            C = h >= 0 || v >= 0;
        end 

        function D = jumpSetIndicator(this, x, u, t, j)
            h = x(this.height_index);
            v = x(this.velocity_index);
            D = h <= 0 && v <= 0;
        end
    end
end