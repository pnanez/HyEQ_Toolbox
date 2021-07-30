classdef DummyControlledHybridSystem < ControlledHybridSystem
%%% The ControlledHybridSystem class allows for the construction of a
%%% hybrid system that depends on an input, u. 
    properties (SetAccess = immutable) 
        state_dimension = 1;
        control_dimension = 1;
    end
    
    %%%%%% System Data %%%%%% 
    methods 
        
        function xdot = flow_map(this, x, u, t, j) 
            xdot = 0*x;
        end

        function xplus = jump_map(this, x, u, t, j) 
            xplus = x;
        end 

        function C = flow_set_indicator(this, x, u, t, j) 
            C = 1;
        end

        function D = jump_set_indicator(this, x, u, t, j)
            D = 0;
        end
    end

end