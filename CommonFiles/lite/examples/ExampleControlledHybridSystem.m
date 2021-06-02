classdef ExampleControlledHybridSystem < HybridSystem

    properties 
        A = [0, 1; 0, 0];
        B = [0; 1];
        K = [-1, -2];
        bounce_coeff = 0.9;
    end

    methods
        function xdot = flow_map(this, x)
            u = this.feedback(x);
            xdot = this.A * x + this.B * u;
        end

        function xplus = jump_map(this, x)
            xplus = [x(1); -this.bounce_coeff*x(2)];
        end
        
        function C = flow_set_indicator(this, x) %#ok<INUSD>
            C = 1;
        end

        function D = jump_set_indicator(this, x) %#ok<INUSL>
            D = x(1) <= 0;
        end

        function u = feedback(this, x)
            u = this.K * x;
        end
    end

end