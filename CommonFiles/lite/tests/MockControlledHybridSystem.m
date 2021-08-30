classdef MockControlledHybridSystem < ControlledHybridSystem
    
    properties(SetAccess = immutable)
        state_dimension
        input_dimension
        output_dimension
    end
    
    properties
        C_indicator = @(x, u, t, j) 1;
        D_indicator = @(x, u, t, j) 1; 
    end
    
    %%%%%% System Data %%%%%% 
    methods
        function obj = MockControlledHybridSystem(input_dimension, state_dimension, output_dimension)
            obj.input_dimension = input_dimension;
            obj.state_dimension = state_dimension;
            obj.output_dimension = output_dimension;
        end
            
        % The jump_map function must be implemented with the following 
        % signature (t and j cannot be ommited)
        function xdot = flow_map(this, x, u, t, j)
            xdot = zeros(this.state_dimension, 1);
        end

        function xplus = jump_map(this, x, u, t, j) 
            this.checkXU(x, u)
            xplus = x;
        end 

        function C = flow_set_indicator(this, x, u, t, j)
            this.checkXU(x, u)
            C = this.C_indicator(x, u, t, j);
        end

        function D = jump_set_indicator(this, x, u, t, j)
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