classdef (Abstract) HybridSubsystem < handle
%%% The HybridSubsystem class allows for the construction of a
%%% hybrid system that depends on an input. 
    properties(SetAccess = immutable)
        state_dimension
        input_dimension
        output_dimension
        output
    end
    
    methods
        function this = HybridSubsystem(state_dim, input_dim, ...
                output_dim, output_fnc)
            this.state_dimension = state_dim;
            if ~exist('input_dim', 'var')
                input_dim = 0;
            end
            if ~exist('output_dim', 'var')
                 output_dim = state_dim;
            end  
            if ~exist('output_fnc', 'var')
                assert(output_dim <= state_dim);
                if output_dim < state_dim
                    output_fnc = @(x) x(1:output_dim);
                else 
                    output_fnc = @(x) x;
                end
                
            end
            this.input_dimension = input_dim;
            this.output_dimension = output_dim;
            this.output = output_fnc;
        end
    end
    
    %%%%%% System Data %%%%%% 
    methods(Abstract) 

        % The jumpMap function must be implemented with the following 
        % signature (t and j cannot be ommited)
        xdot = flowMap(this, x, u, t, j)  

        % The jumpMap function must be implemented with the following 
        % signature (t and j cannot be ommited)
        xplus = jumpMap(this, x, u, t, j)  

        % The jumpMap function must be implemented with the following 
        % signature (t and j cannot be ommited)
        C = flowSetIndicator(this, x, u, t, j) 

        % The jumpMap function must be implemented with the following 
        % signature (t and j cannot be ommited)
        D = jumpSetIndicator(this, x, u, t, j)
    end
    
    methods(Hidden)
        function sol = wrap_solution(this, t, j, x, u, tspan, jspan)
            % Override this method in subclasses to use other classes than
            % HybridSolutionWithInput.
            x_end = x(end, :)';
            u_end = u(end, :)';
            C_end = this.flowSetIndicator(x_end, u_end, t(end), j(end));
            D_end = this.jumpSetIndicator(x_end, u_end, t(end), j(end));
            
            sol = HybridSolutionWithInput(t, j, x, u, C_end, D_end, tspan, jspan);
        end
        
    end

    methods
        
        function [f_vals, g_vals, C_vals, D_vals] = generateFGCD(this, sol)
            % Compute the values of the flow and jump maps and sets at each
            % point in the solution trajectory.
            assert(isa(sol, 'HybridSolutionWithInput'))
            t = sol.t;
            j = sol.j;
            x = sol.x;
            u = sol.u;
            f_vals = NaN(size(x));
            g_vals = NaN(size(x));
            C_vals = NaN(size(t));
            D_vals = NaN(size(t));
            for i=1:length(t)
                x_i = x(i, :)';
                u_i = u(i, :)';
                C_vals(i) = this.flowSetIndicator(x_i, u_i, t(i), j(i));
                D_vals(i) = this.jumpSetIndicator(x_i, u_i, t(i), j(i));
                if C_vals(i) % Only evaluate flow map in the flow set.
                    f_vals(i, :) = this.flowMap(x_i, u_i, t(i), j(i))';
                end
                if D_vals(i) % Only evaluate jump map in the jump set.
                    g_vals(i, :) = this.jumpMap(x_i, u_i, t(i), j(i))';
                end
            end
        end
    end

end