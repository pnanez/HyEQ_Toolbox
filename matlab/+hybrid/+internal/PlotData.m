classdef PlotData < handle

    properties 
        t 
        j 
        flow_args
        jump_args
        xlabel
        ylabel
        zlabel
        xlim
        ylim
        plot_values
        state_ndx
        legend_label
        title
        subplot_ndx
        is_axis1_discrete
        is_axis2_discrete
        is_axis3_discrete

        % Cell array containing 2 or 3 entries that are some combination 't',
        % 'j', and 'x'. 
        axis_ids 
    end

    methods
        function this = PlotData(hybrid_sol)
            this.t = hybrid_sol.t;
            this.j = hybrid_sol.j;
        end

        function addPlotArguments(this, plot_settings)
            n_plots = length(this);
            if plot_settings.auto_subplots
                % If using auto-subplots, then we use the same arguments for
                % every plot.
                f_args = plot_settings.flowArguments();
                g_args = plot_settings.jumpArguments();
                for i = 1:n_plots
                    this(i).flow_args = f_args;
                    this(i).jump_args = g_args;
                end
            else
                for i = 1:n_plots
                    f_args = plot_settings.flowArguments();
                    g_args = plot_settings.jumpArguments();
                    this(i).flow_args = f_args; %#ok<*AGROW>
                    this(i).jump_args = g_args;
                end
            end
        end

        function addLabels(this, plot_settings, axis_ids)
            [this.xlabel, this.ylabel, this.zlabel] = plot_settings.generateLabels(axis_ids);
        end

        function addAxisLimits(this, axis_ids)
            is_x_a_time_axis = any(strcmp(axis_ids(1), {'t', 'j'}));
            is_y_a_time_axis = strcmp(axis_ids(2), 'j');

            if is_x_a_time_axis
                this.xlim = [-inf, inf]; % Make the plot limits 'tight'
            else
                this.xlim = 'auto';
            end

            if is_y_a_time_axis
                this.ylim = [-inf, inf]; % Make the plot limits 'tight'
            else
                this.ylim = 'auto';
            end
        end

        function addPlotValues(this, hybrid_sol, axis_ids, timesteps_filter)

            axis1_id = axis_ids{1};
            axis2_id = axis_ids{2};
            if numel(axis_ids) == 3
                axis3_id = axis_ids{3};
            else
                axis3_id = [];
            end   
            this.axis_ids = {axis1_id, axis2_id, axis3_id};
            this.is_axis1_discrete = strcmp(axis1_id, 'j');
            this.is_axis2_discrete = strcmp(axis2_id, 'j');
            this.is_axis3_discrete = strcmp(axis3_id, 'j');
            plot_vals = hybrid.internal.createPlotValuesFromIds(hybrid_sol, axis1_id, axis2_id, axis3_id);

            if ~isempty(timesteps_filter)
                if length(timesteps_filter) ~= size(plot_vals, 1)
                    error('The length(filter)=%d does not match the timesteps=%d in the HybridSolution.', ...
                        length(timesteps_filter), size(plot_vals, 1))
                end
                % Set entries that don't match the filter to NaN so they are not plotted.
                plot_vals(~timesteps_filter) = NaN;
            end
            this.plot_values = plot_vals;
        end
    end

end