classdef ExampleLinearTimeInvariantPlant < ControlledHybridSystem

    properties 
        state_dimension
        control_dimension
        A
        B
    end
    
    %%%%%% System Data %%%%%% 
    methods

        function this = LinearTimeInvariantPlant(A, B, C, D)
            assert(size(A, 1) == size(B, 1), "The heights of A and B must match!")
            assert(size(A, 1) == size(A, 2), "Matrix A must be square!")
            this.state_dimension = size(A, 1);
            this.control_dimension = size(B, 2);
            
            if ~exist("C", "var")
                assert(~exist("D", "var"))
                C = eye(size(A));
            end
            if ~exist("D", "var")
                D = zeros(size(C, 1), size(B, 2));
            end
            
            this.A = A;
            this.B = B;
        end
        
        function xdot = flow_map(this, x, u, ~, ~)  
            xdot = this.A * x + this.B * u;
        end
        
        function xplus = jump_map(~, x, ~, ~, ~)  
            xplus = x;
        end


        function C = flow_set_indicator(this, x, u, t, j)  %#ok<INUSD>
            C = 1;
        end

        function D = jump_set_indicator(this, x, u, t, j) %#ok<INUSD>
            D = 0;
        end
    end
    
    
    
end