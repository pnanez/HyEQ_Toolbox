classdef MockHybridSubsystem < HybridSubsystem

    properties
        f = [];
        g = [];
        C_indicator = @(x, u, t, j) 1;
        D_indicator = @(x, u, t, j) 1; 
    end
    
    %%%%%% System Data %%%%%% 
    methods
            
        function obj = MockHybridSubsystem(varargin)
            obj = obj@HybridSubsystem(varargin{:});
        end
        
        % The jumpMap function must be implemented with the following 
        % signature (t and j cannot be ommited)
        function xdot = flowMap(this, x, u, t, j)
            this.checkXU(x, u)
            if isempty(this.f)
                xdot = zeros(this.state_dimension, 1);
            else
                xdot = this.f(x, u, t, j);
            end
        end

        function xplus = jumpMap(this, x, u, t, j)
            this.checkXU(x, u)
            if isempty(this.g)
                xplus = x;
            else
                xplus = this.g(x, u, t, j);
            end
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
            if length(x) ~= this.state_dimension
               e = MException('Hybrid:MismatchedVectorSizes', ...
                   'length(x)=%d does not match state_dimension=%d', ...
                   length(x), this.state_dimension);
               throwAsCaller(e);
            end
            assert(length(u) == this.input_dimension)
        end
    end
    
end