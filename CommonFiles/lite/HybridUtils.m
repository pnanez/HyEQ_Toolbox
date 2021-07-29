classdef HybridUtils
    %HYBRIDUTILS A collection of functions that are useful for working with
    %hybrid system.

    methods(Static)

        function [jump_t, jump_j, jump_indices] = jumpTimes(t, j)
            % Takes the t and j vectors output by HyEQsolver to find the time
            % values where jump events occur. Also returns the corresponding values
            % of j and the indices of the events. 
            assert(length(t) == length(j), "Length(t)=%d ~= length(j)=%d", length(t), length(j))
            assert(~isempty(t), "t and j are empty")

            if length(t) == 1 % Handle the case of a trivial solution.
                jump_t = []; 
                jump_j = [];
                jump_indices = [];
                return;
            end

            differences = HybridUtils.prepend_entry_to_vector(diff(j) > 0, 0);
            jump_indices = find(differences);
            jump_t = t(jump_indices);
            jump_j = j(jump_indices);
        end

        function dwell_times = dwellTimes(t, j)
            % Compute the dwell times (duration between each jump).
            % If the solution ends with an interval of flow, rather
            % than a jump, then we append the length of that last
            % interval of flow to the dwell times. We calculate the minimum
            % dwell time before appending the last interval of flow in case
            % that last interval happens to be shorter than the minimum. 

            jump_times = HybridUtils.jumpTimes(t, j);
            dwell_times = diff([0; jump_times]);

            % Unless there was a jump at the final time, we append the
            % length of the final interval of flow to the dwell times. If
            % there weren't any jumps, then this interval is the entire
            % length of t(end) - t(1), otherwise it is 
            % t(end) - jump_times(end).
            if isempty(jump_times)
                dwell_times(end+1) = t(end) - t(1);
            elseif(jump_times(end) ~= t(end))
                dwell_times(end+1) = t(end) - jump_times(end);
            end
        end

        function t_end = timeOfNonconvergence(sol, dist_function, tol)
            % Truncate the solution to the time where the solution has not
            % yet converged.
            if ~exist("tol", "var")
                tol = 1e-2;
            end
            cnvg_t = HybridUtils.convergenceData(sol, dist_function, tol);
            t_end = cnvg_t;
            if isempty(t_end)
                % If trajectories don't converge to the origin, then show the whole time span.    
                t_end = sol.t(end);
                fprintf("Jump count: %d,\tfinal distance: %1.2f (no convergence), termination cause: %s\n", ...
                            sol.jump_count, dist_function(sol.x(end, :)), sol.termination_cause)
            end
        end

        function [cnvg_t, cnvg_j, cnvg_index] = convergenceData(sol, dist_function, tol)
            if ~exist("tol", "var")
                tol = 1e-4;
            end
            
            cnvg_index = find(dist_function(sol.x) < tol, 1);
            if isempty(cnvg_index)
                % Trajectories don't converge to the origin
                cnvg_t = [];
                cnvg_j = [];
            else 
                % Trajectories do converge
                cnvg_t = sol.t(cnvg_index);
                cnvg_j = sol.j(cnvg_index);
            end
        end

        function plotflows(t, j, x)    
            n = size(x, 2);
            for i=1:min(n, 4)
            	subplot(n, 1, i)
                plotflows(t, j, x(:, i));
            end           
        end

        function plotjumps(t, j, x)
            n = size(x, 2);
            for i=1:min(n, 4)
            	subplot(n, 1, i)
                plotjumps(t, j, x(:, i));
            end      
        end

        function plotFlowLengths(sol)
            values = sol.flow_lengths;
            indices = 1:length(values);
            semilogy(indices, values, "b*");
            % xlim([0, indices(end) + 2])
            hold on
            title("Lengths of Intervals of Flow")
            xlabel("$j$", "interpreter", "latex")
            ylabel("$\Delta t$", "interpreter", "latex")
            
            % Only draw ticks at (at most) 12 of the indices.
            xtickindices = floor(indices(1):length(indices)/12:indices(end));
            xtickindices = unique([xtickindices, indices(end)]); % Add tick at last index.
            if length(xtickindices) == 1
                xtickindices = [xtickindices-1, xtickindices];
            end
            xticks(xtickindices)

            % Set the x-axis limits
            indices_span = indices(end) - indices(1);
            x_padding = 0.03 * (indices_span + 1); % 3-percent on each side.
            xlim([indices(1) - x_padding, indices(end) + x_padding])
                        
            % Zero values are not displayed in semilog plots, but flows
            % of length zero correspond to instaneous jumping, which is 
            % important information to display, so we mark zero values in 
            % a different color at the bottom of the plot.
            zero_indices = values == 0;
            if all(~zero_indices)
                % No nonzero values to display.
                padding_multiple = 1.1;
                ylim([min(values)/padding_multiple, padding_multiple*max(values)]);
                return
            end

            if any(~zero_indices)
                % If any of the values are nonzero, we want to preserve the
                % scaling of the plot (more or less), so we place markers
                % for zeros at half the minimum value.
                smallest_nonzero = min(values(~zero_indices));
                zero_display_value = smallest_nonzero / 2;
            else
                zero_display_value = eps;
            end
            semilogy(indices(zero_indices), zero_display_value, "r*");
            
            ylim([zero_display_value, 1.5*max(values)]);
            
            legend("Nonzero values", "Zero values")
        end

        function [t_interp, j_interp, x_interp] = interpolateHybridArc(t, j, x, steps_per_interval)
            [t, j, x] = HybridUtils.remove_duplicate_hyprid_times(t, j, x);

            intervals = length(unique(j));
            jspan =  [j(1), j(end)];
            t_interp = zeros(1, intervals*steps_per_interval);
            j_interp = zeros(1, intervals*steps_per_interval);
            x_interp = zeros(intervals*steps_per_interval, length(x(1, :)));
            for i = 0:intervals - 1
                % interval_j is the value of j in this interval of flow.
                interval_j = jspan(1) + i; 

                % interp_indices are the indices in t_interp, j_interp, x_interp 
                % that we will fill with interpolated values from this interval of flow. 
                interp_indices = (i*steps_per_interval)+1:(i+1)*steps_per_interval; 

                % interval_t and interval_x are the original values from this
                % interval of flow.
                interval_t = t(j == interval_j);
                interval_x = x(j == interval_j, :);

                % do interpolation
                t_interp(interp_indices) = linspace(interval_t(1), interval_t(end), steps_per_interval);
                j_interp(interp_indices) = interval_j;
                x_interp(interp_indices, :) = interp1(interval_t, interval_x, t_interp(interp_indices));
            end
        end
    end

    % We define here methods that are used above but shouldn't be called
    % externally.
    methods(Access = private, Static)
        function x = prepend_entry_to_vector(x, value)
            first_nonsingleton_dim = find(size(x) > 1);
            if isempty(first_nonsingleton_dim)
                first_nonsingleton_dim = 1;
            end
            x = cat(first_nonsingleton_dim, value, x);
        end

        function [t, j, x] = remove_duplicate_hyprid_times(t, j, x)

            is_distinct = [1; diff(t) | diff(j)];
            is_distinct_ndx = find(is_distinct);
            t = t(is_distinct_ndx);
            j = j(is_distinct_ndx);
            x = x(is_distinct_ndx, :);

        end
    end
end

