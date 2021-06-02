classdef ODESolverConfig < handle

    properties(SetAccess = private)
        ode_options;
    
        progressListener = PopupHybridProgress();
    end

    properties
        solver = "ode45";
    end

    methods
        function this = ODESolverConfig()
            this.ode_options = odeset();
        end
            
        function this = set.solver(this, solver)
            if solver == "ode15i"
                error("The 'ode15i' solver is not supported");
            end
            this.solver = solver;
        end

        function this = relativeTolerance(this, relTol)
            this.ode_options = odeset(this.ode_options, "RelTol", relTol);
        end

        function this = absoluteTolerance(this, absTol)
            this.ode_options = odeset(this.ode_options, "AbsTol", absTol);
        end

        function this = maxStep(this, maxStep)
            this.ode_options = odeset(this.ode_options, "MaxStep", maxStep);
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

            if ~isstring(progressListener)  
                assert(isa(progressListener, 'HybridProgress'), ...
                        "progressListener is not an instance of HybridProgress")
                this.progressListener = progressListener;
                return;
            end
            switch progressListener
                case "popup"
                    this.progressListener = PopupHybridProgress();
                case "silent"
                    this.progressListener = SilentHybridProgress();
                otherwise 
                    warning("progress type '%s' not recognized", progressListener);
            end
        end
    end

end