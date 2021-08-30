classdef ExampleBouncingBallHybridSystem < HybridSystem

    properties 
        gravity = 9.8;
        bounce_coeff = 0.9;
    end

    methods 
        % To define the data of the system, we implement 
        % the abstract functions from HybridSystem.m

        function xdot = flowMap(this, x, t, j)
            xdot = [x(2); -this.gravity];
        end

        function xplus = jumpMap(this, x, t, j)
            xplus = [0; -this.bounce_coeff*x(2)];
        end
        
        function C = flowSetIndicator(this, x, t, j) %#ok<INUSD>
            C = 1;
        end

        function D = jumpSetIndicator(this, x, t, j) %#ok<INUSL>
            D = x(1) <= 0 && x(2) <= 0;
        end
    end

end