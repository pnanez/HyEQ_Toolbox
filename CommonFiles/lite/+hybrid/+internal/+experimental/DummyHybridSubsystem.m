classdef DummyHybridSubsystem < HybridSubsystem
%%% The HybridSubsystem class allows for the construction of a
%%% hybrid system that depends on an input, u. 
    
    %%%%%% System Data %%%%%% 
    methods 
        
        function obj = DummyHybridSubsystem()
            state_dim = 2;
            input_dim = 1;
            output_dim = 2;  % optional (default: state_dimension)
            output = @(x) x; % optional (default: @(x) x)
            obj = obj@HybridSubsystem(input_dim, state_dim, output_dim, output);
        end
        
        function xdot = flowMap(this, x, u_C, t, j) 
            xdot = zeros(size(x));
        end

        function xplus = jumpMap(this, x, u_D, t, j) 
            xplus = x;
        end 

        function C = flowSetIndicator(this, x, u_C, t, j) 
            C = 1;
        end

        function D = jumpSetIndicator(this, x, u_D, t, j)
            D = 0;
        end
    end

end