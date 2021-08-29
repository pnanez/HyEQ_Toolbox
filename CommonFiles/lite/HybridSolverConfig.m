classdef HybridSolverConfig < handle

    properties
        ode_solver string = "ode45";
        hybrid_priority = HybridPriority.JUMP;
        mass_matrix = [];
    end
    
    properties(SetAccess = private)
        ode_options;
    
        progressListener HybridProgress = PopupHybridProgress();
    end

    methods
        function this = HybridSolverConfig(varargin)
            this.ode_options = odeset();
            
            % Check if the first argument is "silent". If it is, set the
            % progress listener and remove the first argument from
            % varargin.
            if ~isempty(varargin) && strcmp(varargin{1}, "silent")
                this.progressListener = SilentHybridProgress();

                % Delete first entry
                varargin(1) = [];
            end

            % Parse Name/Value pairs from arguments.
            parser = inputParser();
            nonnegative_validator = @(n)validateattributes(n,{'numeric'},{'nonnegative'});
            addParameter(parser,'RelTol',NaN,nonnegative_validator);
            addParameter(parser,'AbsTol',NaN,nonnegative_validator);
            addParameter(parser,'MaxStep',NaN,nonnegative_validator);
            addParameter(parser,'Refine',NaN,nonnegative_validator);
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
        end
            
        function set.ode_solver(this, ode_solver)
            if ode_solver == "ode15i"
                error("The 'ode15i' solver is not supported");
            end
            this.ode_solver = ode_solver;
        end

        function this = jumpPriority(this)
            this.hybrid_priority = HybridPriority.JUMP;
        end

        function this = flowPriority(this)
            this.hybrid_priority = HybridPriority.FLOW;
        end

        function this = RelTol(this, relTol)
            % RelTol  Set the relative tolerance for the ODE solver.
            this.ode_options = odeset(this.ode_options, "RelTol", relTol);
        end

        function this = AbsTol(this, absTol)
            % AbsTol  Set the absolute tolerance for the ODE solver.
            this.ode_options = odeset(this.ode_options, "AbsTol", absTol);
        end

        function this = MaxStep(this, maxStep)
            % MaxStep  Set the maximum step size for the ODE solver.
            this.ode_options = odeset(this.ode_options, "MaxStep", maxStep);
        end

        function this = Refine(this, refine)
            % Refine Solution refinement factor. See documentation for
            % odeset.
            this.ode_options = odeset(this.ode_options, "Refine", refine);
        end
        
        function this = odeOption(this, name, value)
            % ODEOPTION  Set an arbitrary ODE option via name-value pair.
            this.ode_options.(name) = value;
        end
        
        function this = progress(this, progressListener)
            % PROGRESS Set the progress listener for displaying the portion
            % completed while running the hybrid solver. The argument
            % 'progressListener' must be either an instance of
            % HybridProgress or a string equal to 'popup'(default) or
            % 'silent'. When 'popup' is selected, a graphic progress bar is
            % displayed. When 'silent' is selected, no progress updates are
            % shown. This is slightly faster than the popup progress bar
            % and is useful when solving many hybrid systems.
            
            if ischar(progressListener)
                % Convert progressListener to a string if it is a char
                % array (i.e., if single quotes 'silent' was used instead
                % of double quotes "silent")
                progressListener = string(progressListener);
            end
            
            if ~isstring(progressListener)
                if isa(progressListener, 'HybridProgress')
                    this.progressListener = progressListener;
                else
                    error("HybridSolverConfig:InvalidProgress", ...
                        "The progress listener must be a subclass of HybridProgress, but instead was '%s'.",...
                        class(progressListener));
                end
                return;
            end
            switch progressListener
                case "popup"
                    this.progressListener = PopupHybridProgress();
                case "silent"
                    this.progressListener = SilentHybridProgress();
                otherwise
                    error("HybridSolverConfig:InvalidProgress", ...
                        "The progress type '%s' was unrecognized. Should be 'popup' or 'string'.",...
                        progressListener);
            end
        end
    end
    
end