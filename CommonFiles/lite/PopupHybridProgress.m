classdef PopupHybridProgress < HybridProgress
    
    properties
        progressbar; 
        update_tic;
    end
    
    methods 

        function init(this, tspan, jspan)
            this.progressbar = waitbar(0.0, "");
            this.update_tic = tic();
            init@HybridProgress(this, tspan, jspan);
        end

        function update(this)   
            assert(~isempty(this.progressbar), "Progress has not been initialized. Call init() before update()")
            pct = max(this.t_percent, this.j_percent);
            show_update = toc(this.update_tic) > 0.25;
            if isvalid(this.progressbar) && this.progressbar.Visible && show_update
                msg = sprintf("Solving Hybrid Sysytem. t=%.3f, j=%d", this.t, this.j);
                waitbar(pct, this.progressbar, msg)
                this.update_tic = tic();
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