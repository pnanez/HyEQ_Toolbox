classdef LinearTimeInvariantSystem < ControlledHybridSystem
    
    properties(SetAccess = immutable)
        state_dimension
        input_dimension
        output_dimension
        A
        B
        C
        D
    end
    
    %%%%%% System Data %%%%%% 
    methods
        function obj = LinearTimeInvariantSystem(A, B, C, D)
            assert(size(A, 1) == size(B, 1), "The heights of A and B must match!")
            assert(size(A, 1) == size(A, 2), "Matrix A must be square!")
            
            if ~exist("C", "var")
                assert(~exist("D", "var"))
                C = eye(size(A));
            end
            if ~exist("D", "var")
                D = zeros(size(C, 1), size(B, 2));
            end     
            obj.state_dimension = size(A, 1);
            obj.input_dimension = size(B, 2);
            obj.output_dimension = size(C, 1); 
            obj.A = A;
            obj.B = B;
            obj.C = C;
            obj.D = D;
            obj.output = @(x) C * x; %  + D * u; 
        end
            
        % The jump_map function must be implemented with the following 
        % signature (t and j cannot be ommited)
        function xdot = flow_map(this, x, u, t, j) %#ok<INUSD>
            xdot = this.A * x + this.B * u;
        end

        function xplus = jump_map(this, x, u, t, j)  %#ok<INUSD,INUSL>
            xplus = x; % This will never be used.
        end 

        function C = flow_set_indicator(this, x, u, t, j)  %#ok<INUSD>
            C = 1;
        end

        function D = jump_set_indicator(this, x, u, t, j) %#ok<INUSD>
            D = 0;
        end
    end
    
end