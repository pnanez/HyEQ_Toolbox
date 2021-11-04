classdef HybridSolverConfig < handle
% Class containing settings for the HybridSystem.solve() function. 
%
% See also: HybridSystem.solve, CompositeHybridSystem.solve.
%
% Written by Paul K. Wintz, Hybrid Systems Laboratory, UC Santa Cruz. 
% © 2021. 

    properties(SetAccess = private)
        % The ODE solver used to compute trajectories during flows.
        % See also: HybridSolverConfig.odeSolver, ode45 (default).
        ode_solver = 'ode45';
        
        % Options for the ODE solver.
        % See also: RelTol, AbsTol, MaxStep, Refine, odeOption, odeSolver.
        ode_options;

        % Determines the behavior of solutions in the intersection of the flow and jump sets.
        % See also: HybridSolverConfig.priority, HybridPriority.
        hybrid_priority = HybridPriority.JUMP;

        % The mass matrix ODE solver to compute trajectories during flows.
        % See also: HybridSolverConfig.massMatrix, odeset.
        mass_matrix = [];

        % Configures if and how progress updates are displayed.
        % See also: HybridSolverConfig.progress.
        progressListener = PopupHybridProgress(); % Is a HybridProgress
    end

    methods
        function this = HybridSolverConfig(varargin)
            % HybridSolverConfig constructor.
            this.ode_options = odeset();
            
            % Check if the first argument is "silent". If it is, set the
            % progress listener and remove the first argument from
            % varargin.
            if ~isempty(varargin) && strcmp(varargin{1}, 'silent')
                this.progressListener = SilentHybridProgress();

                % Delete first entry
                varargin(1) = [];
            end

            % Parse Name/Value pairs from arguments.
            parser = inputParser(); % Replace this with a for-loop that loops through the varargin.
            addParameter(parser,'RelTol',NaN);
            addParameter(parser,'AbsTol',NaN);
            addParameter(parser,'MaxStep',NaN);
            addParameter(parser,'Refine',NaN);
            addParameter(parser,'Jacobian', NaN)
            addParameter(parser,'odeSolver', NaN);
            parse(parser, varargin{:})
            
            % Apply non-NaN values.
            if ~isnan(parser.Results.RelTol)
                this.RelTol(parser.Results.RelTol);
            end
            if ~isnan(parser.Results.AbsTol)
                this.AbsTol(parser.Results.AbsTol);
            end
            if ~isnan(parser.Results.MaxStep)
                this.MaxStep(parser.Results.MaxStep);
            end
            if ~isnan(parser.Results.Refine)
                this.Refine(parser.Results.Refine);
            end
            if ~isnan(parser.Results.Jacobian)
                this.Jacobian(parser.Results.Jacobian);
            end
            if ~isnan(parser.Results.odeSolver)
                this.odeSolver(parser.Results.odeSolver);
            end
        end
        
        function this = odeSolver(this, solver)
            % Set the ODE solver used to compute trajectories during flows.
            %
            % The solver 'ode15i' is not supported.
            %
            % See also ode45, ode23, ode23s (stiff equations), ode15s (stiff
            % equations, DAE's), ode23t (stiff equations, DAE's).
            
            % Error checking is performed in the setter. 
            this.ode_solver = solver;
            
            if nargout == 0
               clear this 
            end
        end
            
        function set.ode_solver(this, ode_solver)
            if strcmp(ode_solver, 'ode15i')
                error('Hybrid:InvalidOdeSolver','The ''ode15i'' solver is not supported');
            end
            this.ode_solver = ode_solver;
        end

        function this = priority(this, priority)
            % Set the hybrid priority that determines the behavior of solutions in the intersection of the flow set and the jump set.
            %
            % Value must be ''jump'', ''flow'' (case insensitive),
            % HybridPriority.JUMP, or HybridPriority.FLOW.
            % 
            % See also: HybridPriority, HybridSystem.solve, HyEQsolver.
            if strcmpi(priority, 'jump') % Case insenstive
                priority = HybridPriority.JUMP;
            elseif strcmpi(priority, 'flow') % Case insenstive
                priority = HybridPriority.FLOW;
            end
            this.hybrid_priority = HybridPriority(priority);
            if nargout == 0
               clear this 
            end
        end

        function this = RelTol(this, relTol)
            % Set the relative tolerance for the ODE solver.
            % See documentation for odeset.
            %
            % See also: odeset, ode45.
            assert(relTol > 0, 'Hybrid:expectedNonnegative', ...
                'Relative tolerance must be positive.')
            this.ode_options = odeset(this.ode_options, 'RelTol', relTol);
            if nargout == 0
               clear this 
            end
        end

        function this = AbsTol(this, absTol)
            % Set the absolute tolerance for the ODE solver.
            % See documentation for odeset.
            %
            % See also: odeset, ode45.
            assert(absTol > 0, 'Hybrid:expectedNonnegative', ...
                'Absolute tolerance must be positive.')
            this.ode_options = odeset(this.ode_options, 'AbsTol', absTol);
            if nargout == 0
               clear this 
            end
        end

        function this = MaxStep(this, maxStep)
            % Set the maximum step size for the ODE solver.
            % See documentation for odeset.
            %
            % See also: odeset, ode45.
            assert(maxStep > 0, 'Hybrid:expectedNonnegative', ...
                'Max step must be positive.')
            this.ode_options = odeset(this.ode_options, 'MaxStep', maxStep);
            if nargout == 0
               clear this 
            end
        end

        function this = Refine(this, refine)
            % Set solution refinement factor. 
            % See documentation for odeset.
            %
            % See also: odeset, ode45.
            assert(refine > 0, 'Hybrid:expectedPositive', ...
                'Refine must be positive.')
            assert(mod(refine, 1) == 0, 'Hybrid:expectedInteger', ...
                'Refine must an integer.')
            this.ode_options = odeset(this.ode_options, 'Refine', refine);
            if nargout == 0
               clear this 
            end
        end
        
        function this = Jacobian(this, jacobian) % Add autocomplete
            % Set the Jacobian for the ODE solver. 
            % See documentation for odeset.
            %
            % See also: odeset, ode45.
            this.ode_options = odeset(this.ode_options, 'Jacobian', jacobian);
            if nargout == 0
               clear this 
            end
        end

        function this = odeOption(this, name, value)
            % Set an arbitrary ODE option via name-value pair.
            % See documentation for odeset.
            % 
            % The 'Events' function is not supported because we use the
            % eventing system to detect jumps within the hybrid solver.
            %
            % See also: odeset, ode45.
            if strcmp(name, 'Events')
                % The 'Events' function is not supported because we use the
                % eventing system to detect jump events.
                error('Setting ''Events'' is not supported.')
            end

            this.ode_options.(name) = value;
            if nargout == 0
               clear this 
            end
        end

        function this = massMatrix(this, mass_matrix)
            % Set the mass matrix.
            % See documentation for odeset.
            % 
            % See also: odeset.
            this.mass_matrix = mass_matrix;
            if nargout == 0
               clear this 
            end
        end
        
        function this = progress(this, progress, varargin)
            % Set the mechanism for progress updates displayed while running the hybrid solver. 
            %
            % The argument 'progress' must be one of the following:
            %   an instance of HybridProgress (including subclasses, 
            %   the string 'popup'(default),
            %   or the string 'silent'.
            % When 'popup' is selected, a graphic
            % progress bar is displayed and when 'silent' is selected, no progress
            % updates are shown. Using 'silent' is faster than opening a popup
            % progress bar and is suggested when iterating through many hybrid solutions.
            % 
            % See also: HybridProgress, PopupHybridProgress,
            % SilentHybridProgress.
            
            if isa(progress, 'string')
                % Convert progressListener to a string if it is a char
                % array (i.e., if single quotes 'silent' was used instead
                % of double quotes "silent")
                progress = char(progress);
            end
            
            if ~ischar(progress)
                if isa(progress, 'HybridProgress')
                    this.progressListener = progress;
                else
                    error('HybridSolverConfig:InvalidProgress', ...
                        'The progress listener must be a subclass of HybridProgress, but instead was ''%s''.',...
                        class(progress));
                end
                if nargout == 0
                   clear this 
                end
                return;
            end
            switch progress
                case 'popup'
                    this.progressListener = PopupHybridProgress(varargin{:});
                case 'silent'
                    this.progressListener = SilentHybridProgress();
                otherwise
                    error('HybridSolverConfig:InvalidProgress', ...
                        'The progress type ''%s'' was unrecognized. Should be ''popup'' or ''string''.',...
                        progress);
            end
            if nargout == 0
               clear this 
            end
        end
    end
    
    methods(Hidden)
        function copy_of_this = copy(this)
            copy_of_this = HybridSolverConfig();
            copy_of_this.ode_solver = this.ode_solver;
            copy_of_this.ode_options = odeset(this.ode_options);
            copy_of_this.hybrid_priority = this.hybrid_priority;
            copy_of_this.mass_matrix = this.mass_matrix;
            copy_of_this.progressListener = this.progressListener;
            
        end
    end

    methods(Hidden) % Hide methods in 'handle' superclass from documentation.
        function addlistener(varargin)
             addlistener@HybridSolverConfig(varargin{:});
        end
        function delete(varargin)
             delete@HybridSolverConfig(varargin{:});
        end
        function eq(varargin)
            error('Not supported')
        end
        function findobj(varargin)
             findobj@HybridSolverConfig(varargin{:});
        end
        function findprop(varargin)
             findprop@HybridSolverConfig(varargin{:});
        end
        % function isvalid(varargin)  Method is sealed.
        %      isvalid@HybridSolverConfig(varargin);
        % end
        function ge(varargin)
            error('Not supported')
        end
        function gt(varargin)
            error('Not supported')
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
            notify@HybridSolverConfig(varargin{:});
        end
        function listener(varargin)
            listener@HybridSolverConfig(varargin{:});
        end
    end    
end