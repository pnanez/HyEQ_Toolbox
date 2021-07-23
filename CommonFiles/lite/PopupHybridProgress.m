classdef PopupHybridProgress < HybridProgress
    
    properties
        t_decimal_places = 2; % number of decimal points to display for continuous time
        min_delay = 0.2; % Min number of seconds between updates to display.
    end
    
    properties(Access = private)
        progressbar; 
        last_update_tic;
        last_update_t;
    end
    
    methods 

        function init(this, tspan, jspan)
            this.progressbar = waitbar(0.0, "");
            this.last_update_tic = tic();
            this.last_update_t = -Inf;
            init@HybridProgress(this, tspan, jspan);
        end

        function update(this)   
            assert(~isempty(this.progressbar), "Progress has not been initialized. Call init() before update()")
            pct = max(this.t_percent, this.j_percent);
            round_t = floor(10^this.t_decimal_places * this.t) / 10^this.t_decimal_places;
            % Updating the progress bar is slow, so we wait until
            % 'min_delay' seconds have passed and the displayed (rounded)
            % value of 't' has changed. 
            show_update = toc(this.last_update_tic) > this.min_delay ...
                            && round_t > this.last_update_t;
            if isvalid(this.progressbar) && this.progressbar.Visible && show_update
                msg = sprintf("Solving Hybrid Sysytem. t=%." + this.t_decimal_places + "f, j=%d", this.t, this.j);
                waitbar(pct, this.progressbar, msg)
                this.last_update_t = round_t;
                this.last_update_tic = tic();
            end
        end

        function done(this)    
            if isvalid(this.progressbar) && this.progressbar.Visible
                close(this.progressbar)
            end
        end

        function s = j_progress_str(this)
            s = sprintf("j complete: %d in %s", this.j, mat2str(this.jspan));
        end

    end
    
end