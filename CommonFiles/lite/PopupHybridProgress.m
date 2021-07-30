classdef PopupHybridProgress < HybridProgress
    
    properties
        t_decimal_places = 2; % Number of decimal points to display for continuous time
        min_delay = 0.25; % Minimum number of seconds between updates to the waitbar.
    end
    
    properties(Access = private)
        progressbar; 
        last_update_tic;
        last_update_t;
        last_update_j;
    end
    
    methods 

        function init(this, tspan, jspan)
            % Creating the waitbar is slow, so we wait to initialize it 
            % until a time of at least min_delay seconds has passed. This
            % reduces the overhead for computing short simulations that
            % complete withing min_delay seconds because the waitbar will
            % then never open. This improves the startup time by a factor
            % of ~5x. 
            this.progressbar = []; % Must be explicitly set to empty so we know to create the waitbar.
            this.last_update_tic = tic();
            this.last_update_t = -Inf;
            this.last_update_j = -Inf;
            init@HybridProgress(this, tspan, jspan);
        end

        function update(this)   
            pct = max(this.t_percent, this.j_percent);
            round_t = floor(10^this.t_decimal_places * this.t) / 10^this.t_decimal_places;
            
            % Updating the progress bar is slow, so we wait until
            % 'min_delay' seconds have passed and either the value of j or 
            % the displayed (rounded) value of 't' has changed. 
            % The speedup from this optimization depends on the
            % system being solved and the choices of min_delay and
            % t_decimal places, but we've seen improvements on the order of 5x. 
            show_update = toc(this.last_update_tic) > this.min_delay ...
                            && (round_t > this.last_update_t || this.j > this.last_update_j);
            
            if show_update
                this.openWaitbar()
                msg = sprintf("Solving Hybrid Sysytem. t=%." + this.t_decimal_places + "f, j=%d", this.t, this.j);
                waitbar(pct, this.progressbar, msg)
                this.last_update_t = round_t;
                this.last_update_j = this.j;
                this.last_update_tic = tic();
            end
        end

        function done(this)    
            if ~isempty(this.progressbar) && isvalid(this.progressbar) && this.progressbar.Visible
                close(this.progressbar)
                delete(this.progressbar)
            end
        end
       
        function openWaitbar(this)
            if isempty(this.progressbar)
                % If this.progressbar is empty, then it has not been created
                % after this PopupHybridProgress was initialized, so we do that
                % now.
                cancel_callback = @(src, event) this.cancelSolver();
                this.progressbar = waitbar(0.0, "", ...
                    "Name", "Hybrid Solver Progress", ...
                    "CreateCancelBtn", cancel_callback);
            end
        end
        
        function cancelSolver(this)
            this.cancel = true;
        end
    end
    
    methods(Static)
        function closeAllWaitbars()
            % Sometimes MATLAB's waitbars get stuck and cannot be closed
            % via the normal methods, so calling this method will force
            % them all to close.
            F = findall(0,'type','figure','tag','TMWWaitbar');
            delete(F);
        end
    end
end