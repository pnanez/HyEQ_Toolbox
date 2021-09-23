classdef LinearContinuousSubsystem < HybridSubsystem
    
    properties(SetAccess = immutable)
        A
        B
        C
        D
    end
    
    %%%%%% System Data %%%%%% 
    methods
        function obj = LinearContinuousSubsystem(A, B, C, D)
            % LinearContinuousSubsystem Create a continuous linear time invariant subsystem with data (A, B, C, D).
            % The state equation is given 
            %   \dot x = Ax + Bu
            % The output function is 
            %   y = Cx + Du
            % The arguments C and D are optional. If omitted, C is set to the
            % identity matrix of appropriate size and D is set to zero.
            assert(size(A, 1) == size(B, 1), 'The heights of A and B must match!')
            assert(size(A, 1) == size(A, 2), 'Matrix A must be square!')
            
            if ~exist('C', 'var')
                C = eye(size(A));
            end
            if ~exist('D', 'var') || isempty(D) || all(D == 0)
                D = zeros(size(C, 1), size(B, 2));
                output = @(x) C * x;
            else
                output = @(x, u) C * x + D * u; 
            end     
            state_dimension = size(A, 1);
            input_dimension = size(B, 2);
            output_dimension = size(C, 1); 
            obj = obj@HybridSubsystem(state_dimension, input_dimension, ...
                                        output_dimension, output);
            obj.A = A;
            obj.B = B;
            obj.C = C;
            obj.D = D;
        end
            
        % The jumpMap function must be implemented with the following 
        % signature (t and j cannot be ommited)
        function xdot = flowMap(this, x, u, t, j) %#ok<INUSD>
            xdot = this.A * x + this.B * u;
        end

        function xplus = jumpMap(this, x, u, t, j)  %#ok<INUSD,INUSL>
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