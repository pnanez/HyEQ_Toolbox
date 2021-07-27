classdef HybridSolution

    properties(SetAccess = immutable)
        t (:, 1) double;
        j (:, 1) double;
        x (:, :) double;

        f_vals (:, :) double;
        g_vals (:, :) double;
        C_vals (:, 1) uint8;
        D_vals (:, 1) uint8;

        x0 % (1, :) double;

        jump_times (:,1) double; 
        dwell_times (:,1) double;
        flow_duration double;
        min_dwell_time double;
        jump_count uint32;

        termination_cause TerminationCause; 
    end

    properties(GetAccess = private, SetAccess = immutable)
        hybrid_system;
    end

    methods
        function this = HybridSolution(hybrid_system, t, j, x, tspan, jspan)
            checkVectorSizes(t, j, x);
            this.t = t;
            this.j = j;
            this.x = x;
            this.x0 = x(1,:);
            this.jump_times = HybridUtils.jumpTimes(t, j);
            this.flow_duration = t(end) - t(1);
            this.jump_count = length(this.jump_times);
            this.dwell_times = HybridUtils.dwellTimes(t, j);
            this.min_dwell_time = min(this.dwell_times);

            this.hybrid_system = hybrid_system;

            this.f_vals = NaN * x;
            this.g_vals = NaN * x;
            this.C_vals = NaN * t;
            this.D_vals = NaN * t;

            for i=1:length(t)
                x_curr = x(i, :)';
                this.C_vals(i) = hybrid_system.flow_set_indicator_3args(x_curr, t(i), j(i));
                this.D_vals(i) = hybrid_system.jump_set_indicator_3args(x_curr, t(i), j(i));
                if this.C_vals(i) % Only evaluate flow map in the flow set.
                    this.f_vals(i, :) = hybrid_system.flow_map_3args(x_curr, t(i), j(i))';
                end
                if this.D_vals(i) % Only evaluate jump map in the jump set.
                    this.g_vals(i, :) = hybrid_system.jump_map_3args(x_curr, t(i), j(i))';
                end
            end

            this.termination_cause = TerminationCause.getCause(hybrid_system, ...
                                                            t, j, x, tspan, jspan);        
        end

%         function value = get.f_vals(this)
%             if isempty(this.f_vals)
%                 value = NaN * this.x;
%                 for i=1:length(this.t)
%                     x_ = this.x(i, :)';
%                     t_ = this.t(i);
%                     j_ = this.j(i);
%                     value = this.hybrid_system.flow_map_3args(x_, t_, j_)';
%                 end
%             else
%                 value = this.f_vals;
%             end
%         end
% 
%         function value = get.g_vals(this)
%             if isempty(this.f_vals)
%                 value = NaN * this.x;
%                 for i=1:length(this.t)
%                     x_ = this.x(i, :)';
%                     t_ = this.t(i);
%                     j_ = this.j(i);
%                     value = this.hybrid_system.jump_map_3args(x_, t_, j_)';
%                 end
%             else
%                 value = this.g_vals;
%             end
%         end
% 
%         function value = get.C_vals(this)
%             if isempty(this.C_vals)
%                 value = NaN * this.x;
%                 for i=1:length(this.t)
%                     x_ = this.x(i, :)';
%                     t_ = this.t(i);
%                     j_ = this.j(i);
%                     value = this.hybrid_system.flow_set_indicator_3args(x_, t_, j_)';
%                 end
%             else
%                 value = this.C_vals;
%             end
%         end
% 
%         function value = get.D_vals(this)
%             if isempty(this.D_vals)
%                 value = NaN * this.x;
%                 for i=1:length(this.t)
%                     x_ = this.x(i, :)';
%                     t_ = this.t(i);
%                     j_ = this.j(i);
%                     value = this.hybrid_system.jump_set_indicator_3args(x_, t_, j_)';
%                 end
%             else
%                 value = this.D_vals;
%             end
%         end

        function plot(this)
            HybridPlotBuilder().plot(this);
        end

        function plotflows(this, indices)

            n = size(this.x, 2);
            if ~exist("indices", "var")
                last_index = min(n, 4);
                indices = 1:last_index;
            end
            assert(all(indices >= 1))
            assert(all(indices <= n))
            if length(indices) > 5
                warning("Plotting more than five components makes the subplots hard to read")
            end

            subplot_ndx = 1;
            for i=indices
            	subplot(length(indices), 1, subplot_ndx)
                plotflows(this.t, this.j, this.x(:, i));
                subplot_ndx = subplot_ndx + 1;
            end 
        end

        function plotjumps(this, indices)
            n = size(this.x, 2);
            if ~exist("indices", "var")
                last_index = min(n, 4);
                indices = 1:last_index;
            end

            % Check values
            assert(all(indices >= 1))
            assert(all(indices <= n))
            if length(indices) > 5
                warning("Plotting more than five components makes the subplots hard to read")
            end
            
            % Do plotting
            subplot_ndx = 1;
            for i=indices
            	subplot(length(indices), 1, subplot_ndx)
                plotjumps(this.t, this.j, this.x(:, i));
                subplot_ndx = subplot_ndx + 1;
            end 
        end
    end

end

% Local functions %

function checkVectorSizes(t, j, x)
            if size(t, 2) ~= 1
                error('HybridSolution:WrongShape', ...
                    "The vector t must be a column vector");
            end
            if size(j, 2) ~= 1
                error('HybridSolution:WrongShape', ...
                    "The vector j must be a column vector");
            end
            if size(t, 1) ~= size(j, 1)
                error('HybridSolution:WrongShape', ...
                    "The length(t)=%d and length(j)=%d must match.", ...
                    size(t, 1), size(j, 1));
            end
            if size(t, 1) ~= size(x, 1)
                error('HybridSolution:WrongShape', ...
                    "The length(t)=%d and length(x)=%d must match.", ...
                    size(t, 1), size(x, 1));
            end
        end
