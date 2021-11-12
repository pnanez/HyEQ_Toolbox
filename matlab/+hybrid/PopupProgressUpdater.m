classdef PopupProgressUpdater < hybrid.ProgressUpdater
% Defines a mechanism that displays progress updates while solving hybrid systems in a popup box with a progress bar.
%
% See also: HybridSolverConfig, hybrid.ProgressUpdater, Silenthybrid.ProgressUpdater.
%
% Written by Paul K. Wintz, Hybrid Systems Laboratory, UC Santa Cruz. 
% © 2021. 
    
    properties
        % The t_decimal_places property deterimines the number of decimal points to
        % display for t in the progress bar. The progress bar updates when
        % the value of t up to the precision determined by this value
        % changes (so long as min_delay has passed).
        t_decimal_places = 2; 
        
        % The property min_delay sets the minimum number of seconds between 
        % updates to the progress bar. Smaller values can significantly
        % slow down the solver.
        min_delay = 0.25; 
    end
    
    properties(Access = private)
        progressbar; 
        last_update_tic;
        last_update_t;
        last_update_j;
    end
    properties(Hidden)
        update_count = 0;
    end
    
    methods 
        function obj = PopupProgressUpdater(t_decimal_places)
            if exist('t_decimal_places', 'var')
                obj.t_decimal_places = t_decimal_places;
            end
        end

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
            this.update_count = 0;
            init@hybrid.ProgressUpdater(this, tspan, jspan);
        end

        function update(this)
            pct = max(this.t_percent, this.j_percent);
            round_t = floor(10^this.t_decimal_places * this.t) / 10^this.t_decimal_places;
            
            % Updating the progress bar is slow, so we wait until
            % 'min_delay' seconds have passed and either the value of j or 
            % the displayed (rounded) value of 't' has changed. 
            % The speedup from this optimization depends on the
            % system being solved and the choices of min_delay and
            % t_decimal places, but we've seen improvements of ~5x.  
            is_past_min_delay = toc(this.last_update_tic) > this.min_delay;
            is_value_changed = round_t > this.last_update_t || this.j > this.last_update_j;
            show_update = is_past_min_delay && is_value_changed;
            
            if show_update
                this.openWaitbar()
                msg_fmt = strcat('Solving Hybrid Sysytem. t=%.', num2str(this.t_decimal_places), 'f, j=%d');
                msg = sprintf(msg_fmt, this.t, this.j);
                waitbar(pct, this.progressbar, msg)
                this.last_update_t = round_t;
                this.last_update_j = this.j;
                this.last_update_tic = tic();
                this.update_count = this.update_count+1;
            end
        end

        function done(this)    
            if isempty(this.progressbar)
                % The progress bar was never opened, 
                % so we don't need to close it.
               return 
            end
            if isvalid(this.progressbar)
                close(this.progressbar)
            end
            delete(this.progressbar)
            this.progressbar = [];
        end
        
        function delete(this)
            this.done();
        end
    end
    
    methods(Access = private)
        function openWaitbar(this)
            if isempty(this.progressbar)
                % If this.progressbar is empty, then it has not been created
                % after this hybrid.PopupProgressUpdater was initialized, so we do that
                % now.
                cancel_callback = @(src, event) this.cancelSolver();
                this.progressbar = waitbar(0.0, '', ...
                    'Name', 'Hybrid Solver Progress', ...
                    'CreateCancelBtn', cancel_callback);
            end
        end
    end
    
    methods(Static)
        function forceCloseAll()
            % Sometimes MATLAB's waitbars get stuck and cannot be closed
            % via the normal methods, so calling this method will force
            % them all to close.
            F = findall(0,'type','figure','tag','TMWWaitbar');
            delete(F);
        end
    end
end