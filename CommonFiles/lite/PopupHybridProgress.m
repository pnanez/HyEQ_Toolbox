classdef PopupHybridProgress < HybridProgress
    
    properties
        progressbar; 
    end
    
    methods 

        function init(this, tspan, jspan)
            this.progressbar = waitbar(0.0, "");
            init@HybridProgress(this, tspan, jspan);
        end

        function update(this)   
            assert(~isempty(this.progressbar), "Progress has not been initialized. Call init() before update()")
            pct = max(this.t_percent, this.j_percent);
            msg = sprintf("Solving Hybrid Sysytem. t=%.3f, j=%d", this.t, this.j);
            if isvalid(this.progressbar) && this.progressbar.Visible
                waitbar(pct, this.progressbar, msg)
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