classdef BouncingBall < HybridSystem
% A bouncing ball modeled as a HybridSystem subclass.
% 
% Added in HyEQ Toolbox version 3.0 

% Written by Paul K. Wintz, Hybrid Systems Laboratory, UC Santa Cruz (©2022). 
    properties
        gravity = 9.8;
        bounce_coeff = 0.9;
    end

    methods 
        % To define the data of the system, we implement 
        % the abstract functions from HybridSystem.m

        function this = BouncingBall()
            this = this@HybridSystem(2);
        end

        function xdot = flowMap(this, x, t, j)
            xdot = [x(2); -this.gravity];
        end

        function xplus = jumpMap(this, x)
            xplus = [x(1); -this.bounce_coeff*x(2)];
        end
        
        function C = flowSetIndicator(this, x)
            C = x(1) >= 0 || x(2) >= 0;
        end

        function D = jumpSetIndicator(this, x)
            D = x(1) <= 0 && x(2) <= 0;
        end
    end

end