classdef EZHybridSubsystem < HybridSubsystem
    
    properties(SetAccess = immutable)
        state_dimension
        input_dimension
        output_dimension
        f
        g
        C_indicator
        D_indicator
    end
    
    methods
        function obj = EZHybridSubsystem(f, g, C_indicator, D_indicator, output,...
                input_dim, state_dim, output_dim)
            obj.f = f;
            obj.g = g;
            obj.C_indicator = C_indicator;
            obj.D_indicator = D_indicator;
            obj.output = output;
            obj.state_dimension = state_dim;
            obj.input_dimension = input_dim;
            obj.output_dimension = output_dim;
        end
            
        function xdot = flowMap(this, x, u, t, j)
            xdot = this.f(x, u, t, j);
        end

        function xplus = jumpMap(this, x, u, t, j) 
            xplus = this.g(x, u, t, j);
        end 

        function C = flowSetIndicator(this, x, u, t, j) 
            C = this.C_indicator(x, u, t, j);
        end

        function D = jumpSetIndicator(this, x, u, t, j)
            D = this.D_indicator(x, u, t, j);
        end
    end
    
end