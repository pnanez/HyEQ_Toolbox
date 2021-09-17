classdef MockHybridSubsystem < HybridSubsystem

    properties
        C_indicator = @(x, u, t, j) 1;
        D_indicator = @(x, u, t, j) 1; 
    end
    
    %%%%%% System Data %%%%%% 
    methods
            
        % The jumpMap function must be implemented with the following 
        % signature (t and j cannot be ommited)
        function xdot = flowMap(this, x, u, t, j)
            xdot = zeros(this.state_dimension, 1);
        end

        function xplus = jumpMap(this, x, u, t, j) 
            this.checkXU(x, u)
            xplus = x;
        end 

        function C = flowSetIndicator(this, x, u, t, j)
            this.checkXU(x, u)
            C = this.C_indicator(x, u, t, j);
        end

        function D = jumpSetIndicator(this, x, u, t, j)
            this.checkXU(x, u)
            D = this.D_indicator(x, u, t, j);
        end
    end
    
    methods(Access = private)
        function checkXU(this, x, u)
            assert(length(x) == this.state_dimension)
            assert(length(u) == this.input_dimension)
        end
    end
    
end