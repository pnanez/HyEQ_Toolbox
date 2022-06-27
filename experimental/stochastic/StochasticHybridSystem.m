classdef StochasticHybridSystem < handle

    properties(SetAccess = immutable)
        base_system
        flowNoise 
        jumpNoise
    end

    methods
        function obj = StochasticHybridSystem(base_system, flowNoise, jumpNoise)
            obj.base_system = base_system;
            obj.flowNoise = flowNoise;
            obj.jumpNoise = jumpNoise;
        end

        function sol = solve(this, x0, tspan, jspan, varargin)

            % Check arguments
            if ~exist('tspan', 'var')
               tspan = [0, 10]; 
            end
            if ~exist('jspan', 'var')
               jspan = [0, 10]; 
            end
            if length(tspan) ~= 2
                e = MException('HybridSystem:InvalidArgs', ...
                    'tspan must be an array of two values in the form [tstart, tend]');
                throwAsCaller(e);
            end
            if length(jspan) ~= 2
                e = MException('HybridSystem:InvalidArgs', ...
                    'jspan must be an array of two values in the form [jstart, jend]');
                throwAsCaller(e);
            end
            if tspan(1) > tspan(2)
                warning('HybridSystem:BackwardTSPAN', ...
                    'The second entry of tspan was smaller than the first.');
            end
            if jspan(1) > jspan(2)
                warning('HybridSystem:BackwardTSPAN', ...
                    'The second entry of jspan was smaller than the first.');
            end
            if ~isempty(varargin) && isa(varargin{1}, 'HybridSolverConfig')
                assert(numel(varargin) == 1, ...
                    ['If a HybridSolverConfig is provided in the 4th argument, ' ...
                    'then there cannot be any more arguments.'])
                config = varargin{1};
            else
                config = HybridSolverConfig(varargin{:});
            end

%             if ~isempty(this.state_dimension)
%                 assert(length(x0) == this.state_dimension, ...
%                     'size(x0)=%d does not match the dimension of the system=%d',...
%                     length(x0), this.state_dimension)
%             end
%             this.assert_functions_can_be_evaluated_at_point(x0, tspan(1), jspan(1));           

            config.odeOption('sigma', @(t, x) this.flowNoise(x,t));
            if strcmp(config.ode_solver, 'ode45')
                config.odeSolver('sde45');
            end

            function noise = jumpNoise(x, t, j)
                std_dev = this.jumpNoise(x, t, j);
                if isscalar(std_dev)
                    std_dev = std_dev * eye(size(x, 1));
                elseif isvector(std_dev)
                    std_dev = diag(std_dev);
                end
                noise = mvnrnd(zeros(size(x)), std_dev, 1)';
            end
            jumpMap = @(x, t, j) this.base_system.jumpMap_3args(x, t, j) ...
                            + jumpNoise(x, t, j);
            % Compute solution
            [t, j, x] = HyEQsolver(this.base_system.flowMap_3args, ...
                                   jumpMap, ...
                                   this.base_system.flowSetIndicator_3args, ...
                                   this.base_system.jumpSetIndicator_3args, ...
                                   x0, tspan, jspan, ...
                                   config.hybrid_priority, config.ode_options, ...
                                   config.ode_solver, config.mass_matrix, ...
                                   config.progressListener);
                        
            % Wrap solution in HybridSolution class (or another class if
            % the function wrap_solution is overriden).
            sol = HybridArc(t, j, x);
%             sol = this.base_system.wrap_solution(t, j, x, tspan, jspan, config);
        end
    end

end