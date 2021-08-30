classdef ExampleLinearTimeInvariantPlant < HybridSubsystem

    properties 
        state_dimension
        input_dimension
        A
        B
    end
    
    %%%%%% System Data %%%%%% 
    methods

        function this = LinearTimeInvariantPlant(A, B, C, D)
            assert(size(A, 1) == size(B, 1), "The heights of A and B must match!")
            assert(size(A, 1) == size(A, 2), "Matrix A must be square!")
            this.state_dimension = size(A, 1);
            this.input_dimension = size(B, 2);
            
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
        
        function xdot = flowMap(this, x, u, ~, ~)  
            xdot = this.A * x + this.B * u;
        end
        
        function xplus = jumpMap(~, x, ~, ~, ~)  
            xplus = x;
        end
        
        function C = flowSetIndicator(this, x, u, t, j)  %#ok<INUSD>
            C = 1;
        end

        function D = jumpSetIndicator(this, x, u, t, j) %#ok<INUSD>
            D = 0;
        end
    end
    
    
    
end