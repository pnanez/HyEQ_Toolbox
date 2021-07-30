classdef (Abstract) ControlledHybridSystem < handle
%%% The ControlledHybridSystem class allows for the construction of a
%%% hybrid system that depends on an input, u. 
    properties (Abstract, SetAccess = immutable)
        state_dimension
        control_dimension
    end
    
    %%%%%% System Data %%%%%% 
    methods(Abstract) 

        % The jump_map function must be implemented with the following 
        % signature (t and j cannot be ommited)
        xdot = flow_map(this, x, u, t, j)  

        % The jump_map function must be implemented with the following 
        % signature (t and j cannot be ommited)
        xplus = jump_map(this, x, u, t, j)  

        % The jump_map function must be implemented with the following 
        % signature (t and j cannot be ommited)
        C = flow_set_indicator(this, x, u, t, j) 

        % The jump_map function must be implemented with the following 
        % signature (t and j cannot be ommited)
        D = jump_set_indicator(this, x, u, t, j)
    end

end