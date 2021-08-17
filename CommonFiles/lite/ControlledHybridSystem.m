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
    
    methods
        function sol = wrap_solution(this, t, j, x, u, tspan, jspan)
            % Override this method in subclasses to use other classes than
            % ControlledHybridSolution.
            sol = ControlledHybridSolution(this, t, j, x, u, tspan, jspan);
        end
        
        function [f_vals, g_vals, C_vals, D_vals] = generateFGCD(this, t, j, x, u)
            % Compute the values of the flow and jump maps and sets at each
            % point in the solution trajectory.
            f_vals = NaN(size(x));
            g_vals = NaN(size(x));
            C_vals = NaN(size(t));
            D_vals = NaN(size(t));
            for i=1:length(t)
                x_i = x(i, :)';
                u_i = u(i, :)';
                C_vals(i) = this.flow_set_indicator(x_i, u_i, t(i), j(i));
                D_vals(i) = this.jump_set_indicator(x_i, u_i, t(i), j(i));
                if C_vals(i) % Only evaluate flow map in the flow set.
                    f_vals(i, :) = this.flow_map(x_i, u_i, t(i), j(i))';
                end
                if D_vals(i) % Only evaluate jump map in the jump set.
                    g_vals(i, :) = this.jump_map(x_i, u_i, t(i), j(i))';
                end
            end
        end
    end

end