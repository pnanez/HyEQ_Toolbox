classdef DummyHybridSubsystem < HybridSubsystem
%%% The HybridSubsystem class allows for the construction of a
%%% hybrid system that depends on an input, u. 
    properties (SetAccess = immutable) 
        state_dimension = 1;
        input_dimension = 1;
        output_dimension = 1;
    end
    
    %%%%%% System Data %%%%%% 
    methods 
        
        function xdot = flowMap(this, x, u, t, j) 
            xdot = 0*x;
        end

        function xplus = jumpMap(this, x, u, t, j) 
            xplus = x;
        end 

        function C = flowSetIndicator(this, x, u, t, j) 
            C = 1;
        end

        function D = jumpSetIndicator(this, x, u, t, j)
            D = 0;
        end
    end

end