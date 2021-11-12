classdef HybridUtils
% HYBRIDUTILS A collection of functions useful for working with hybrid systems.

    methods(Static)

        function t_end = timeOfNonconvergence(sol, dist_function, tol)
            % Truncate the solution to the time where the solution has not
            % yet converged.
            if ~exist('tol', 'var')
                tol = 1e-2;
            end
            cnvg_t = HybridUtils.convergenceData(sol, dist_function, tol);
            t_end = cnvg_t;
            if isempty(t_end)
                % If trajectories don't converge to the origin, then show the whole time span.    
                t_end = sol.t(end);
                fprintf('Jump count: %d,\tfinal distance: %1.2f (no convergence), termination cause: %s\n', ...
                            sol.jump_count, dist_function(sol.x(end, :)), sol.termination_cause)
            end
        end

        function [cnvg_t, cnvg_j, cnvg_index] = convergenceData(sol, dist_function, tol)
            if ~exist('tol', 'var')
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

        function [t_interp, j_interp, x_interp] = interpolateHybridArc(t, j, x, steps_per_interval)
            [t, j, x] = remove_duplicate_hybrid_times(t, j, x);

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
end

function [t, j, x] = remove_duplicate_hybrid_times(t, j, x)

    is_distinct = [1; diff(t) | diff(j)];
    is_distinct_ndx = find(is_distinct);
    t = t(is_distinct_ndx);
    j = j(is_distinct_ndx);
    x = x(is_distinct_ndx, :);
end

