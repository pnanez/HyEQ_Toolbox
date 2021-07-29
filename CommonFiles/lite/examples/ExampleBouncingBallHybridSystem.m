classdef ExampleBouncingBallHybridSystem < HybridSystem

    properties 
        gravity = 9.8;
        bounce_coeff = 0.9;
    end

    methods 
        % To define the data of the system, we implement 
        % the abstract functions from HybridSystem.m

        function xdot = flow_map(this, x)
            xdot = [x(2); -this.gravity];
        end

        function xplus = jump_map(this, x)
            xplus = [0; -this.bounce_coeff*x(2)];
        end
        
        function C = flow_set_indicator(this, x) %#ok<INUSD>
            C = 1;
        end

        function D = jump_set_indicator(this, x) %#ok<INUSL>
            D = x(1) <= 0 && x(2) <= 0;
        end
    end

end