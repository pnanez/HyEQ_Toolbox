classdef BouncingBall < HybridSystem
    % A bouncing ball modeled as a HybridSystem subclass.

    properties % Define properties that can be modified.
        gravity = 9.8;
        bounce_coeff = 0.9;
    end

    properties(SetAccess = immutable) % Define properties that cannot be modified.
        height_index = 1;
        velocity_index = 2;
    end

    methods 
        % To define the data of the system, we implement 
        % the abstract functions from HybridSystem.m

        function this = BouncingBall()
            state_dim = 2;
            this = this@HybridSystem(state_dim);
        end

        function xdot = flowMap(this, x, t, j)
            v = x(this.velocity_index);
            xdot = [v; -this.gravity];
        end

        function xplus = jumpMap(this, x)
            h = x(this.height_index);
            v = x(this.velocity_index);
            xplus = [h; -this.bounce_coeff*v];
        end
        
        function C = flowSetIndicator(this, x)
            h = x(this.height_index);
            v = x(this.velocity_index);
            C = h >= 0 || v >= 0;
        end

        function D = jumpSetIndicator(this, x)
            h = x(this.height_index);
            v = x(this.velocity_index);
            D = h <= 0 && v <= 0;
        end
    end

end