classdef HybridSolverConfig < handle

    properties
        ode_solver = "ode45";
    end
    
    properties(SetAccess = private)
        ode_options;
    
        progressListener HybridProgress = PopupHybridProgress();
    end

    methods
        function this = HybridSolverConfig()
            this.ode_options = odeset();
        end
            
        function set.ode_solver(this, ode_solver)
            if ode_solver == "ode15i"
                error("The 'ode15i' solver is not supported");
            end
            this.ode_solver = ode_solver;
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