classdef HybridProgress < handle
    properties
        tspan (1, 2) double
        jspan (1, 2)
        t (1,1) double
        j (1,1)
    end

    properties(Dependent)
        t_percent
        j_percent
    end
    
    methods 

        function init(this, tspan, jspan)
            this.tspan = tspan;
            this.jspan = jspan;
            this.setBoth(tspan(1), jspan(1));
        end

    end 

    methods(Abstract)
        update(this) 
        done(this)    
    end 

    methods
        function setT(this, t)
            assert(~isempty(t), "t was empty.")
            % Sometimes ode solvers return several time steps at a time,
            % so we only set t to the last one.
            this.t = t(end); 
            this.update();
        end

        function setJ(this, j)
            this.j = j;
            this.update();
        end

        function setBoth(this, t, j)
            this.t = t;
            this.j = j;
            this.update();
        end
        
        function val = get.t_percent(this)
            val = (this.t - this.tspan(1)) / ...
                      (this.tspan(2) - this.tspan(1));
        end

        function val = get.j_percent(this)
            val = (this.j - this.jspan(1)) / ...
                      (this.jspan(2) - this.jspan(1));
        end

        function s = j_progress_str(this)
            s = sprintf("j complete: %d in %s", this.j, mat2str(this.jspan));
        end

    end
    
end