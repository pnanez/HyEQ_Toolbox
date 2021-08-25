classdef HybridPlotBuilder < handle

    properties(Constant)
        INTERPRETERS = ["none", "tex", "latex"];
    end

    properties(SetAccess = private)
        % Text
        component_titles;
        component_labels; 
        text_interpreter = "latex";

        % Plots
        flow_color = "b";
        flow_line_style string = "-";
        flow_line_width double = 0.5;
        jump_color = "r";
        jump_line_style string = "--";
        jump_line_width double = 0.5;
        jump_start_marker string = ".";
        jump_start_marker_size double = 6;
        jump_end_marker string = "*";
        jump_end_marker_size double = 6;
        
        % Subplots
        auto_subplots logical = true;
        subplots_callback function_handle = @(component) disp('');
    end
    properties(Access = private)
        plots_for_legend = [];
        axes_for_legend = [];
        component_indices uint32 = [];
        timestepsFilter = [];
        max_subplots = 4;
    end
    properties(Dependent)
        % Labels that correctly adjust to different text interpreters.
        t_label
        j_label
    end
    methods
        function value = get.t_label(this)
            if strcmp(this.text_interpreter, "none")
                value = "t"; % No formatting
            elseif strcmp(this.text_interpreter, "tex")
                value = "t";
            elseif strcmp(this.text_interpreter, "latex")
                value = "$t$";
            else
                error("text interpreter '%s' unrecognized",... 
                            this.text_interpreter);
            end
        end

        function value = get.j_label(this)
            if strcmp(this.text_interpreter, "none")
                value = "j"; % No formatting
            elseif strcmp(this.text_interpreter, "tex")
                value = "j";
            elseif strcmp(this.text_interpreter, "latex")
                value = "$j$";
            else
                error("text interpreter '%s' unrecognized",... 
                            this.text_interpreter);
            end
        end
    end

    methods

        function this = title(this, title)
            assert(length(title) == 1, "For setting multiple titles, use titles()")
            this.component_titles = title;
        end
        
        function this = titles(this, varargin)
            this.component_titles = varargin;
        end

        function this = labels(this, varargin)
            this.component_labels = varargin;
        end

        function this = flowColor(this, color)
            % FLOWCOLOR Set the color of flow lines.
            this.flow_color = color;
        end

        function this = flowLineStyle(this, style)
            % FLOWLINESTYLE Set the style of flow lines.  If 'style'
            % is an empty string or empty array, then flow lines are hidden. 
            if style == "" || isempty(style)
                this.flow_line_style = "none";
            else
                this.flow_line_style = style;
            end
        end

        function this = flowLineWidth(this, width)
            % FLOWLINEWIDTH Set the width of flow lines.
            assert(width > 0, "Line width must be positive")
            this.flow_line_width = width;
        end

        function this = jumpColor(this, color)
            % JUMPCOLOR Set the color of jump lines and jump markers.
            % at each end.
            this.jump_color = color;
        end

        function this = jumpLineStyle(this, style)
            % JUMPLINESTYLE Set the style of lines along jumps. If 'style'
            % is an empty string or empty array, then jump lines are hidden. 
            if style == "" || isempty(style)
                this.jump_line_style = "none";
            else
                this.jump_line_style = style;
            end
        end

        function this = jumpLineWidth(this, width)
            % JUMPLINEWIDTH Set the width of jump lines.
            assert(width > 0, "Line width must be positive")
            this.jump_line_width = width;
        end

        function this = jumpMarker(this, marker)
            % JUMPMARKER Set the marker for both sides of jumps.
            this.jumpStartMarker(marker);
            this.jumpEndMarker(marker);
        end

        function this = jumpMarkerSize(this, size)
            % JUMPMARKERSIZE Set the marker size for both sides of jumps.
            this.jumpStartMarkerSize(size);
            this.jumpEndMarkerSize(size);
        end

        function this = jumpStartMarker(this, marker)
            % JUMPSTARTMARKER Set the marker for the starting point of each
            % jump.
            if marker == "" || isempty(marker)
                this.jump_start_marker = "none";
            else
                this.jump_start_marker = marker;
            end
        end

        function this = jumpStartMarkerSize(this, size)
            % JUMPSTARTMARKERSIZE Set the marker size for the starting 
            % point of each jump.
            assert(size > 0, "Size must be positive")
            this.jump_start_marker_size = size;
        end

        function this = jumpEndMarker(this, marker)
            % JUMPENDMARKER Set the marker for the end point of each
            % jump.
            if marker == "" || isempty(marker)
                this.jump_end_marker = "none";
            else
                this.jump_end_marker  = marker;
            end
        end

        function this = jumpEndMarkerSize(this, size)
            % JUMPENDMARKERSIZE Set the marker size for the end 
            % point of each jump.
            assert(size > 0, "Size must be positive")
            this.jump_end_marker_size = size;
        end

        function this = slice(this, component_indices)
            % SLICE Pick the state components to plot by providing the
            % corresponding indices. 
            
            if size(component_indices, 1) > 1
                % We need component_indices to be a row vector so that when
                % we use it to create a for-loop (i.e., "for
                % i=component_indices"), every entry is used for 
                % one iteration each. If component_indices is a column
                % vector, instead, then the entire column is used as the
                % value of 'i' for only a single iteration.
                assert(size(component_indices, 2) == 1)
                component_indices = component_indices';
            end
            
            this.component_indices = component_indices;
        end

        function this = filter(this, timesteps_filter)
            % FILTER Pick the timesteps to display. All others are hidden
            % from plots. 
            this.timestepsFilter = timesteps_filter;
        end
        
        function this = autoSubplots(this, auto_subplots)
            % AUTOSUBPLOTS Configure whether to automatically create subplots for each component.
            if strcmp("on", auto_subplots)
                auto_subplots = true;
            elseif strcmp("off", auto_subplots)
                auto_subplots = false;
            end
            assert(isscalar(auto_subplots), "Argument 'auto_subplots' was an array")
            this.auto_subplots = logical(auto_subplots);
        end
        
        function this = configureSubplots(this, callback)
           this.subplots_callback = callback;
        end
        
        function this = textInterpreter(this, interpreter)
            is_valid = ismember(interpreter,HybridPlotBuilder.INTERPRETERS);
            assert(is_valid, "'%s' is not a valid value. Use one of these values: 'none' | 'tex' | 'latex'.", interpreter)
            this.text_interpreter = interpreter;
        end

        function plotflows(this, hybrid_sol)
            indices_to_plot = indicesToPlot(this, hybrid_sol);
            
            was_hold_on = ishold();
            if ~was_hold_on
                % Clear the plot
                plot(nan, nan);
            end
            
            subplot_ndx = 1;
            for i=indices_to_plot
                if this.auto_subplots
                    subplots(subplot_ndx) = open_subplot(length(indices_to_plot), subplot_ndx); %#ok<AGROW>
%                     if ~was_hold_on
%                         % Clear the plot
%                         plot(nan, nan);
%                     end
                else
                    hold on
                end
                
                to_plot = [hybrid_sol.t, hybrid_sol.x(:, i)];
                this.plot_sliced(hybrid_sol, to_plot)

                if this.auto_subplots 
                    % Should these settings be conditional?
                    xlim("tight")
                    ylim('padded') 
                end
                
                xlabel(this.t_label, "interpreter", this.text_interpreter)
                if this.auto_subplots
                    this.subplots_callback(i);
                    this.ylabel(i)
                    this.applyTitle(i)
                    subplot_ndx = subplot_ndx + 1;
                else
                    this.ylabel(1)
                    this.applyTitle(1)
                    if ~was_hold_on
                        hold off
                    end
                end
            end 
            
            if this.auto_subplots
                % Link the x-axes of the subplots so zooming and panning
                % one subplot effects the others.
                linkaxes(subplots,'x')
            end
        end

        function plotjumps(this, hybrid_sol)
            indices_to_plot = indicesToPlot(this, hybrid_sol);

            subplot_ndx = 1;
            for i=indices_to_plot
                if this.auto_subplots
                    subplots(subplot_ndx) = open_subplot(length(indices_to_plot), subplot_ndx); %#ok<AGROW>
                else
                    hold on
                end
                sliced_x = [hybrid_sol.j, hybrid_sol.x(:, i)];
                this.plot_sliced(hybrid_sol, sliced_x)

                if this.auto_subplots
                    xlim("tight")
                    ylim('padded') 
                end
                
                xlabel(this.j_label, "interpreter", this.text_interpreter)
                this.ylabel(i)
                this.applyTitle(i)
                if this.auto_subplots
                   this.subplots_callback(i); 
                end
                subplot_ndx = subplot_ndx + 1;
            end 
            
            if this.auto_subplots
                % Link the x-axes of the subplots so zooming and panning
                % one subplot effects the others.
                linkaxes(subplots,'x')
            end
        end

        function plotHybridArc(this, hybrid_sol)
            indices_to_plot = indicesToPlot(this, hybrid_sol);

            subplot_ndx = 1;
            for i=indices_to_plot
                if this.auto_subplots
                    subplots(subplot_ndx) = open_subplot(length(indices_to_plot), subplot_ndx); %#ok<AGROW>
                end           	

                % Prepend t and j, then plot.
                sliced_x = [hybrid_sol.t, hybrid_sol.j, hybrid_sol.x(:, i)];
                this.plot_sliced(hybrid_sol, sliced_x)

                if this.auto_subplots
                    xlim("tight")
                    ylim('tight') 
                    % zlim('padded') % Does this make better plots?
                end
                
                xlabel(this.t_label, "interpreter", this.text_interpreter)
                ylabel(this.j_label, "interpreter", this.text_interpreter)
                this.zlabel(i)
                this.applyTitle(i)
                if this.auto_subplots
                   this.subplots_callback(); 
                end
                subplot_ndx = subplot_ndx + 1;
            end
            
            if this.auto_subplots
                % Link the subplot axes so that the views are sync'ed.
                link = linkprop(subplots, {'View', 'XLim', 'YLim'});
                setappdata(gcf, 'StoreTheLink', link);
            end
        end

        function plot(this, hybrid_sol)
            % PLOT Plot the hybrid solution in an intelligent way.
            % The output of depends on the dimension of the system 
            % (or the number of components selected with 'slice()'). 
            % The output is as follows: 
            % - 1D: a 1D plot generated using plotflows
            % - 2D: a 2D phase plot
            % - 3D: a 3D phase plot
            % - 4D+: a set of 1D subplots generated using plotflows.
            sliced_indices = indicesToPlot(this, hybrid_sol);
            dimensions = length(sliced_indices);
            
            if dimensions ~= 2 && dimensions ~= 3
                this.plotflows(hybrid_sol)
                return
            end
            if this.auto_subplots
                subplot(1, 1, 1) % Reset to only one subplot
            end
            sliced_x = hybrid_sol.x(:, sliced_indices);
            this.plot_sliced(hybrid_sol, sliced_x)

            this.xlabel(sliced_indices(1))
            this.ylabel(sliced_indices(2))
            if dimensions == 3
                this.zlabel(sliced_indices(3))
            end
            this.applyTitle(1) % Use first title entry                  
        end

        function lgd = legend(this, varargin)
            % LEGEND Add a legend for each call to builder.plots() while 
            % in the current figure. (Plots in other figures will be
            % skipped).
            lgd_labels = varargin;
            
            % For the current figure, get all the line plots. 
            plots_in_figure = findall(gcf,'Type','Line');
            
            % For each plot saved in this.plots_for_legend, check whether
            % it is a plot in the current figure.
            plots_for_legend_indices ...
                = ismember(this.plots_for_legend,  plots_in_figure);
            plots_for_this_legend ...
                = this.plots_for_legend(plots_for_legend_indices);
            axes_for_this_legend = this.axes_for_legend(plots_for_legend_indices);
            for ax = unique(this.axes_for_legend)
                % Add the legend entries for each plot. We truncate the lengths
                % of the arrays to match so that Matlab does not print a
                % (rather unhelpful) warning.
                plots_in_axes = plots_for_this_legend(axes_for_this_legend == ax);
                m = min(length(plots_in_axes), length(lgd_labels));
                
                check_legend_count(plots_in_axes, lgd_labels);
                
                if isvalid(ax)
                    lgd_res = legend(ax, plots_in_axes(1:m), lgd_labels(1:m), ...
                        "interpreter", this.text_interpreter, ...
                        'AutoUpdate','off');
                end
                if nargout ~= 0
                    % We only set the output argument if the output of the
                    % function is used. This prevents the value of lgd_res
                    % from being printed out if the function call was not
                    % terminated with a semi-colon.
                    lgd = lgd_res;
                end
            end
        end
    end

    methods(Access = private)

        function plot_sliced(this, hybrid_sol, sliced_x)

            if ~isempty(this.timestepsFilter)
                assert(length(this.timestepsFilter) == size(sliced_x, 1), ...
                    "The length(filter)=%d does not match the timesteps=%d in the HybridSolution.", ...
                    length(this.timestepsFilter), size(sliced_x, 1))
                % Set entries that don't match the filter to NaN so they are not plotted.
                sliced_x(~this.timestepsFilter) = NaN;
            end
            
            flows_x = HybridPlotBuilder.separateFlows(...
                                    hybrid_sol.t, hybrid_sol.j, sliced_x);
            [jumps_x, jumps_befores, jumps_afters] ...
                = HybridPlotBuilder.separateJumps(hybrid_sol.t, hybrid_sol.j, sliced_x);

            % Add an invisible plot that will show up in the legend.
            % Drawing this point will also clear the plot if 'hold' is off.
            this.addLegendEntry()
            
            % We have to turn on hold while plotting the hybrid arc, so 
            % we save the current hold state and restore it at the end.
            was_hold_on = ishold();
            hold on

            switch size(sliced_x, 2)
                case 2
                    this.plotFlow2D(flows_x)
                    this.plotJump2D(jumps_x, jumps_befores, jumps_afters)
                case 3
                    this.plotFlow3D(flows_x)
                    this.plotJump3D(jumps_x, jumps_befores, jumps_afters)
                    view(34.8,16.8)
                otherwise
                    error("HybridPlotBuilder:WrongNumberOfComponents", ...
                        "The plot_sliced method can only plot in 2D and 3D.")
            end
            
            % Turn off 'hold' if it was off at the beginning of this
            % function.
            if ~was_hold_on
                hold off
            end
        end
        
        function indices_to_plot = indicesToPlot(this, hybrid_sol)
            n = size(hybrid_sol.x, 2);
            if isempty(this.component_indices)
                if this.auto_subplots
                    last_index = min(n, this.max_subplots);
                else
                    last_index = n;
                end
                indices_to_plot = 1:last_index;
            else
                indices_to_plot = this.component_indices;
            end
            assert(min(indices_to_plot) >= 1)
            assert(max(indices_to_plot) <= n, ...
                "max(indices_to_plot)=%d is greater than n=%d", ...
                max(indices_to_plot), n)
        end

        function plotFlow2D(this, x)
            if isempty(x)
               return 
            end
            plot(x(:,1), x(:,2), 'Color', this.flow_color, ...
                            'LineStyle', this.flow_line_style, ...
                            'LineWidth', this.flow_line_width)
        end

        function plotFlow3D(this, x)
            if isempty(x)
               return 
            end
            plot3(x(:,1), x(:,2), x(:,3), ...
                            'Color', this.flow_color, ...
                            'LineStyle', this.flow_line_style, ...
                            'LineWidth', this.flow_line_width)
        end

        function plotJump2D(this, x_jump, x_start, x_end)
            % Plot the line from start to end.
            plot(x_jump(:,1), x_jump(:,2), ...
                'Color', this.jump_color, ...
                'LineStyle', this.jump_line_style, ...
                'LineWidth', this.jump_line_width)
            % Plot the start of the jump
            plot(x_start(:,1), x_start(:,2), ...
                'Color', this.jump_color, ...
                'Marker', this.jump_start_marker, ...
                'MarkerSize', this.jump_start_marker_size)
            % Plot the end of the jump
            plot(x_end(:,1), x_end(:,2), ...
                'Color', this.jump_color, ...
                'Marker', this.jump_end_marker, ...
                'MarkerSize', this.jump_end_marker_size)
        end

        function plotJump3D(this, x_jump, x_before, x_after)
            if isempty(x_before)
                return % Not a jump
            end
            % Plot jump line
            plot3(x_jump(:,1), x_jump(:, 2), x_jump(:, 3), ...
                'Color', this.jump_color, ...
                'LineStyle', this.jump_line_style, ...
                'LineWidth', this.jump_line_width)
            % Plot the start of the jump
            plot3(x_before(:,1), x_before(:,2), x_before(:,3), ...
                'Color', this.jump_color, ...
                'Marker', this.jump_start_marker, ...
                'MarkerSize', this.jump_start_marker_size)
            % Plot the end of the jump
            plot3(x_after(:,1), x_after(:,2), x_after(:,3), ...
                'Color', this.jump_color, ...
                'Marker', this.jump_end_marker, ...
                'MarkerSize', this.jump_end_marker_size)
        end
        
        function label = createLabel(this, index)
            if index <= length(this.component_labels)
                label = this.component_labels(index);  
            else
                if strcmp(this.text_interpreter, "none")
                    fmt = "x_%d"; % No formatting
                elseif strcmp(this.text_interpreter, "tex")
                    fmt = "x_{%d}";
                elseif strcmp(this.text_interpreter, "latex")
                    fmt = "$x_{%d}$";
                else
                    error("text interpreter '%s' unrecognized",... 
                                this.text_interpreter);
                end
                label = sprintf(fmt, index);
            end
        end
        
        function xlabel(this, index)
            % xlabel Add a label to the x-axis for the component at 'index'.
            label = this.createLabel(index);
            xlabel(label, "interpreter", this.text_interpreter)
        end

        function ylabel(this, index)
            % ylabel Add a label to the y-axis for the component at 'index'.
            label = this.createLabel(index);
            ylabel(label, "interpreter", this.text_interpreter)
        end

        function zlabel(this, index)
            % zlabel Add a label to the z-axis for the component at 'index'.
            label = this.createLabel(index);
            zlabel(label, "interpreter", this.text_interpreter)
        end

        function applyTitle(this, index)
            if index <= length(this.component_titles)
                title(this.component_titles(index), "interpreter", this.text_interpreter)
            end
        end

        function addLegendEntry(this)
            % We 'plot' a invisible dummy point (NaN values are not visible in plots), 
            % which provides the line and marker appearance for the corresponding legend entry.
            p = plot(nan, nan, "Color", this.flow_color, ...
                                "LineStyle", this.flow_line_style, ...
                                "LineWidth", this.flow_line_width, ...
                                "Marker", this.jump_start_marker, ...
                                "MarkerSize", this.jump_start_marker_size, ...
                                "MarkerEdgeColor", this.jump_color);
            this.plots_for_legend = [this.plots_for_legend, p];
            this.axes_for_legend = [this.axes_for_legend, gca];
        end
                
    end
    
    methods(Static, Hidden)
       
        function flows_x = separateFlows(t, j, x)
            [~, ~, ~, is_jump] = HybridUtils.jumpTimes(t, j);
            
            if length(t) <= 1
                flows_x = [];
                return
            end

            % Modify is_jump by prepending a 1 and setting the last entry
            % to 1. These changes emulate 'virtual' jumps immediately prior
            % to and after the given hybrid time domain.
            is_jump = [1; is_jump(1:(end-1)); 1];
            
            % Everywhere in the domain where the previous entry was a jump
            % and the next entry is not is the start of an interval of
            % flow.
            is_start_of_flow = diff(is_jump) == -1;
            
            % Similarly, everywhere in the domain where the previous entry
            % was not a jump and the next entry is a jump, is the end of
            % an interval of flow.
            is_end_of_flow = diff(is_jump) == 1;
            
            start_of_flow_ndxs = find(is_start_of_flow);
            end_of_flow_ndxs = find(is_end_of_flow);
            
            n_flows = sum(is_start_of_flow);
            n_interior_flow_boundaries = n_flows - 1;
            n_flow_entries = sum(end_of_flow_ndxs - start_of_flow_ndxs + 1);
            
            % Create an array to hold the values with NaN padding between
            % flows.
            flows_x = NaN(n_flow_entries+n_interior_flow_boundaries, size(x, 2));
            
            % out_start_ndx tracks the starting index for the output array.
            out_start_ndx = 1;
            for i = 1:n_flows
                start_ndx = start_of_flow_ndxs(i);
                end_ndx = end_of_flow_ndxs(i);
                ndx_count = end_ndx - start_ndx + 1;
                
                in_ndxs = start_ndx:end_ndx;
                out_ndxs = out_start_ndx:(out_start_ndx + ndx_count - 1);
                flows_x(out_ndxs, :) = x(in_ndxs, :);
                
                out_start_ndx = out_start_ndx + ndx_count + 1;
            end
        end
        
        function [jumps_x, jumps_befores, jumps_afters] = separateJumps(t, j, x)
            [~, ~, jump_indices] = HybridUtils.jumpTimes(t, j);

            jump_count = length(jump_indices);
            
            % Create an array to hold the values with NaN padding between
            % flows.
            n = size(x, 2);
            jumps_befores = NaN(3*jump_count, n);
            jumps_afters = NaN(3*jump_count, n);
            jumps_x = NaN(3*jump_count, n);

            for i=1:jump_count
                jump_ndx = jump_indices(i);
                offset = 3*(i-1);
                jumps_befores(1 + offset, :) = x(jump_ndx, :);
                if jump_ndx < size(x, 1)
                    jumps_afters(1 + offset, :) = x(jump_ndx+1, :);
                end 
            end
            jumps_x(1:3:end, :) = jumps_befores(1:3:end, :);
            jumps_x(2:3:end, :) = jumps_afters(1:3:end, :);
        end 
    end
end
        
%%% Local functions %%%

function sp = open_subplot(subplots_count, index)
    is_hold_on = ishold(); % Save the hold status to apply in subplots.
    sp = subplot(subplots_count, 1, index);
    if is_hold_on
        % Subplots default to hold off, so we modify the hold
        % status to match what was met before 
        hold on
    end
end

function checkColorArg(color_arg)
    if ~verLessThan('matlab', '9.9')
        % The validatecolor function was added in R2020b (v9.9), so we
        % first check the version to make sure we can call it.
        if ~validatecolor(color_arg)
            error("HybridPlotBuilder:InvalidColor", ...
                "The argument is not recognized as a color.")
        end
    end
    
end
       
function check_legend_count(plots_in_axes, lgd_labels)
% Print a warning if the number of plots and labels do not
% match.
warning_msg = "The number of plots (%d) added to the current axes" + ...
    " by this HybridPlotBuilder is %s than the number of legend labels provided (%d).";
if length(plots_in_axes) < length(lgd_labels)
    warning(warning_msg, length(plots_in_axes), "less", length(lgd_labels))
elseif length(plots_in_axes) > length(lgd_labels)
    warning(warning_msg, length(plots_in_axes), "more", length(lgd_labels))
end
end
