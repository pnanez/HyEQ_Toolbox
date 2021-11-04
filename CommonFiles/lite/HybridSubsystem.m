classdef (Abstract) HybridSubsystem < handle
% Class of hybrid subsystems with inputs and outputs, used in the construction of composite hybrid systems.
%
% See also: CompositeHybridSystem, HybridSystem, HybridSubsystemBuilder, hybrid.subsystems.
%
% Written by Paul K. Wintz, Hybrid Systems Laboratory, UC Santa Cruz. 
% © 2021. 

    properties(SetAccess = immutable)
        % Dimension of the state vector 'x'
        state_dimension
        % Dimension of the input 'u'
        input_dimension
        % Dimension of the output 'y'
        output_dimension
        % Function that generates 'y' from 'x', and (optionally) 'u', 't', and 'j'.
        output_fnc
    end
    
    methods
        function this = HybridSubsystem(state_dim, input_dim, ...
                output_dim, output_fnc)
            % Constructor
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
            this.output_fnc = output_fnc;
        end
    end
    
    %%%%%% System Data %%%%%% 
    methods(Abstract) 

        % The flow map 'f' used to compute the evolution of the subsystem during intervals of flow.
        %
        % The flowMap function must be implemented in subclasses with the following 
        % signature (t and j cannot be ommited). 
        xdot = flowMap(this, x, u, t, j)  

        % The jump map 'g' used to compute the evolution of the subsystem at jumps.
        %
        % The jumpMap function must be implemented in subclasses with the following 
        % signature (t and j cannot be ommited)
        xplus = jumpMap(this, x, u, t, j)  

        % Indicator function for flow set 'C'. Returns 1 inside 'C' and 0 outside.
        % 
        % The flowSetIndicator function must be implemented in subclasses with the following 
        % signature (t and j cannot be ommited)
        C = flowSetIndicator(this, x, u, t, j) 

        % Indicator function for jump set 'D'. Returns 1 inside 'D' and 0 outside.
        % 
        % The jumpSetIndicator function must be implemented in subclasses with the following 
        % signature (t and j cannot be ommited)
        D = jumpSetIndicator(this, x, u, t, j)
    end
    
    methods(Hidden)
        function sol = wrap_solution(this, t, j, x, u, y, tspan, jspan)
            % Override this method in subclasses to use other classes than
            % HybridSubsystemSolution.
            x_end = x(end, :)';
            u_end = u(end, :)';
            C_end = this.flowSetIndicator(x_end, u_end, t(end), j(end));
            D_end = this.jumpSetIndicator(x_end, u_end, t(end), j(end));
            
            sol = HybridSubsystemSolution(t, j, x, u, y, C_end, D_end, tspan, jspan);
        end
        
    end

    methods
        
        function [f_vals, g_vals, C_vals, D_vals] = generateFGCD(this, sol)
            % Compute the values of the data (f, g, C, D) at each point along a given hybrid solution.
            % 
            % The flow map 'f' and jump map 'g' are evaluated at each point, including
            % points not in the flow set or jump set, respectively. 
            % If the flow map 'f' (jump map 'g') throws an error and the
            % solution is not in the flow set (jump set), then the values are set to
            % NaN, but if the solution is in the flow set (jump set), then the
            % error is rethrown. 
            %
            % See also: HybridSubsystem.flowMap, HybridSubsystem.jumpMap,
            % HybridSubsystem.flowSetIndicator,
            % HybridSubsystem.jumpSetIndicator.
            assert(isa(sol, 'HybridSubsystemSolution'))
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

                try
                    f_vals(i, :) = this.flowMap(x_i, u_i, t(i), j(i))';
                catch e
                    if C_vals(i) % Only evaluate flow map in the flow set.
                        rethrow(e);
                    end
                end
                try
                    g_vals(i, :) = this.jumpMap(x_i, u_i, t(i), j(i))';
                catch e
                    if D_vals(i) % Only evaluate jump map in the jump set.
                        rethrow(e)
                    end
                end
            end
        end
    end

    methods(Hidden) % Hide methods from 'handle' superclass from documentation.
        function addlistener(varargin)
             addlistener@HybridSubsystem(varargin{:});
        end
        function delete(varargin)
             delete@HybridSubsystem(varargin{:});
        end
%         function eq(varargin)
%             builtin('eq', varargin{:});
%         end
        function findobj(varargin)
             findobj@HybridSubsystem(varargin{:});
        end
        function findprop(varargin)
             findprop@HybridSubsystem(varargin{:});
        end
        % function isvalid(varargin)  Method is sealed.
        %      isvalid@HybridSubsystem(varargin);
        % end
        function ge(varargin)
        end
        function gt(varargin)
        end
        function le(varargin)
            error('Not supported')
        end
        function lt(varargin)
            error('Not supported')
        end
        function ne(varargin)
            error('Not supported')
        end
        function notify(varargin)
            notify@HybridSubsystem(varargin{:});
        end
        function listener(varargin)
            listener@HybridSubsystem(varargin{:});
        end
    end
end