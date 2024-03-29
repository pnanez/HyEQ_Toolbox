classdef ProgressUpdater < handle
% Abstract class for displaying updates while solving a hybrid system.
%
% Added in HyEQ Toolbox version 3.0 (©2022).

% Written by Paul K. Wintz, Hybrid Systems Laboratory, UC Santa Cruz. 
    properties
        tspan % double (1, 2) 
        jspan % integer (1, 2)
        t % double (1,1) 
        j % integer (1,1)
        is_cancel_solver; % When true, HyEQSolver aborts.
    end

    methods(Abstract)
        update(this)     
    end 
    
    methods
        function done(this)  %#ok<MANU>
            % Override this method to cleanup progress display.
        end
    end

    properties(Dependent, Access = protected)
        t_percent
        j_percent
    end
    
    methods(Hidden)
        function init(this, tspan, jspan)
            this.tspan = tspan;
            this.jspan = jspan;
            this.is_cancel_solver = false;
            this.setBoth(tspan(1), jspan(1));
        end

        function setT(this, t)
            assert(~isempty(t), 't was empty.')
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
    end
    
    methods
        function val = get.t_percent(this)
            val = (this.t - this.tspan(1)) / ...
                      (this.tspan(2) - this.tspan(1));
        end

        function val = get.j_percent(this)
            val = (this.j - this.jspan(1)) / ...
                      (this.jspan(2) - this.jspan(1));
        end

    end

    methods(Access = protected)
        function cancelSolver(this)
            this.is_cancel_solver = true;
        end
    end
    
end