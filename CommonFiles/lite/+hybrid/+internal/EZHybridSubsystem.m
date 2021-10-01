classdef EZHybridSubsystem < HybridSubsystem
    
    properties(SetAccess = immutable)
        f
        g
        C_indicator
        D_indicator
    end
    
    methods
        function obj = EZHybridSubsystem(f, g, C_indicator, D_indicator,...
                state_dim, input_dim, output_dim, output)
            obj = obj@HybridSubsystem(state_dim, input_dim, output_dim, output);
            obj.f = f;
            obj.g = g;
            obj.C_indicator = C_indicator;
            obj.D_indicator = D_indicator;
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