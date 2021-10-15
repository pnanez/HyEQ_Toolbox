classdef HybridPlotBuilder < handle
% Class for creating plots of hybrid solutions
%
% Written by Paul K. Wintz, Hybrid Systems Laboratory, UC Santa Cruz. 
% © 2021. 

    properties(Constant)
        defaults = hybrid.internal.PlotSettings() % default plot settings
    end
    
    properties(SetAccess = immutable)
        settings % plot settings
    end
    
    properties(Access = private)
        % Legend options
        plots_for_legend = [];
        axes_for_legend = [];
    end

    methods
        function obj = HybridPlotBuilder()
            % HybridPlotBuilder constructor.
           obj.settings = HybridPlotBuilder.defaults.copy();
        end
    end
    
    methods % Setting property setters
        function this = title(this, title)
            % Set a title for the plot.
            if iscell(title)
                e = MException('HybridPlotBuilder:InvalidArgument', ...
                    'For setting multiple titles, use titles()');
                throwAsCaller(e);
            end
            this.titles(title);
        end
        
        function this = titles(this, varargin)
            % Set the titles for each subplot.
            titles = hybrid.internal.parseStringVararginWithOptionalOptions(varargin{:});
            this.settings.component_titles = titles;
        end

        function this = label(this, label)
            % Set a single component label. 
            if iscell(label)
                e = MException('HybridPlotBuilder:InvalidArgument', ...
                    'For setting multiple labels, use labels()');
                throwAsCaller(e);
            end
            this.labels(label);
        end

        function this = labels(this, varargin)
            % Set component labels.
            labels = hybrid.internal.parseStringVararginWithOptionalOptions(varargin{:});
            this.settings.component_labels = labels;
        end

        function this = labelSize(this, size)
            % Set the font size of component labels.
            this.settings.label_size = size;
        end

        function this = titleSize(this, size)
            % Set the font size of titles.
            this.settings.title_size = size;
        end

        function this = tLabel(this, t_label)
            % Set the label for the continuous time axis.
            %
            % The default value depends on the label interpreter:
            %  'none': 't'
            %   'tex': 't'
            % 'latex': '$t$'
            this.settings.t_label = t_label;
        end

        function this = jLabel(this, j_label)
            % Set the label for the discrete time axis 
            % The default value depends on the label interpreter:
            %  'none': 'j'
            %   'tex': 'j'
            % 'latex': '$j$'
            this.settings.j_label = j_label;
        end

        function this = xLabelFormat(this, label_format)
            % Set the string format used for missing component labels in automatic subplots (used only if explicit labels are not specified) .
            %
            % The string 'label_format' must be a valid format for
            %         sprint(label_format, i)
            % where 'i' is an integer that equals the index number of the
            % component for the subplot where the label is placed. That is,
            % label_format is a string that contains a single occurance of '%d',
            % which is replaced in each label by the corresponding component
            % index.
            % 
            % The default value depends on the label interpreter:
            %  'none': 'x(%d)'
            %   'tex': 'x_{%d}'
            % 'latex': '$x_{%d}$'
            this.settings.x_label_format = label_format;
        end

        function this = plot2Function(this, plot_function_2D)
            % Set the plot function used for drawing 2D graphs. 
            this.settings.plot_function_2D = str2func(plot_function_2D);
        end

        function this = plot3Function(this, plot_function_3D)
            % Set the plot function used for drawing 3D graphs. 
            this.settings.plot_function_3D = str2func(plot_function_3D);
        end

        function this = legend(this, varargin)
            % Set the legend entry label(s) for the next plot. Optional name-value options for the built-in MATLAB 'legend' function can be included.
            [labels, options] = hybrid.internal.parseStringVararginWithOptionalOptions(varargin{:});
            this.settings.component_legend_labels = labels;
            this.settings.legend_options = options;
        end
                
        function this = flowColor(this, color)
            % FLOWCOLOR Set the color of flow lines.
            this.settings.flow_color = color;
        end

        function this = flowLineStyle(this, style)
            % FLOWLINESTYLE Set the style of flow lines.  If 'style'
            % is an empty string or empty array, then flow lines are hidden. 
            this.settings.flow_line_style = style;
        end

        function this = flowLineWidth(this, width)
            % FLOWLINEWIDTH Set the width of flow lines.
            this.settings.flow_line_width = width;
        end

        function this = jumpColor(this, color)
            % JUMPCOLOR Set the color of jump lines and jump markers.
            % at each end.
            this.settings.jump_color = color;
        end

        function this = jumpLineStyle(this, style)
            % JUMPLINESTYLE Set the style of lines along jumps. If 'style'
            % is an empty string or empty array, then jump lines are hidden. 
            this.settings.jump_line_style = style;
        end

        function this = jumpLineWidth(this, width)
            % JUMPLINEWIDTH Set the width of jump lines.
            this.settings.jump_line_width = width;
        end

        function this = jumpMarker(this, marker)
            % Set the marker for both sides of jumps.
            this.jumpStartMarker(marker);
            this.jumpEndMarker(marker);
        end

        function this = jumpMarkerSize(this, size)
            % Set the marker size for both sides of jumps.
            this.jumpStartMarkerSize(size);
            this.jumpEndMarkerSize(size);
        end

        function this = jumpStartMarker(this, marker)
            % Set the marker for the starting point of each jump.
            this.settings.jump_start_marker = marker;
        end

        function this = jumpStartMarkerSize(this, size)
            % Set the marker size for the starting point of each jump.
            this.settings.jump_start_marker_size = size;
        end

        function this = jumpEndMarker(this, marker)
            % Set the marker for the end point of each jump.
            this.settings.jump_end_marker = marker;
        end

        function this = jumpEndMarkerSize(this, size)
            % Set the marker size for the end  point of each jump.
            this.settings.jump_end_marker_size = size;
        end

        function this = slice(this, component_indices)
            % Pick the state components to plot by providing the corresponding indices. 
            this.settings.component_indices = component_indices;
        end

        function this = filter(this, timesteps_filter)
            % Pick the timesteps to display. All others are hidden from plots. 
            this.settings.timesteps_filter = timesteps_filter;
        end
        
        function this = autoSubplots(this, auto_subplots)
            % Configure whether to automatically create subplots for each component.
            this.settings.auto_subplots = auto_subplots;
        end
        
        function this = configurePlots(this, plots_callback)
            % Provide a function that is called within each subplot to facilitate additional configuration.
           this.settings.plots_callback = plots_callback;
        end
        
        function this = titleInterpreter(this, interpreter)
            % Set the text interpreter used in titles. 
            this.settings.title_interpreter = interpreter;
        end
        
        function this = labelInterpreter(this, interpreter)
            % Set the text interpreter used in time, component, and legend entry labels. 
            this.settings.label_interpreter = interpreter;
        end
        
        function this = textInterpreter(this, interpreter)
            % Set both the title and legend entry labels.
            this.titleInterpreter(interpreter);
            this.labelInterpreter(interpreter);
        end

    end
    
    methods 
        function this = plotFlows(this, varargin)
            % Plot values vs. continuous time 't'.
            hybrid_sol = hybrid.internal.convert_varargin_to_solution_obj(varargin);
            
            indices_to_plot = this.settings.indicesToPlot(hybrid_sol);
                        
            nplot = length(indices_to_plot);
            axis1_ids = repmat('t', nplot, 1);
            axis2_ids = indices_to_plot;
             
            axis_ids = {axis1_ids, axis2_ids};
            primary_ndxs = axis2_ids;
            this.plot_from_ids(hybrid_sol, axis_ids, primary_ndxs);
            
            if nargout == 0
                % Prevent output if function is not terminated with a
                % semicolon.
                clearvars this
            end
        end

        function this = plotJumps(this, varargin)
            % Plot values vs. discrete time 'j'.
            hybrid_sol = hybrid.internal.convert_varargin_to_solution_obj(varargin);
            indices_to_plot = this.settings.indicesToPlot(hybrid_sol);
                        
            nplot = length(indices_to_plot);
            axis1_ids = repmat('j', nplot, 1);
            axis2_ids = indices_to_plot;
             
            axis_ids = {axis1_ids, axis2_ids};
            primary_ndxs = axis2_ids;
            this.plot_from_ids(hybrid_sol, axis_ids, primary_ndxs);
            
            if nargout == 0
                % Prevent output if function is not terminated with a
                % semicolon.
                clear this
            end
        end

        function this = plotHybrid(this, varargin)
            % Plot values vs. continuous and discrete time (t, j).
            hybrid_sol = hybrid.internal.convert_varargin_to_solution_obj(varargin);
            indices_to_plot = this.settings.indicesToPlot(hybrid_sol);

            nplot = length(indices_to_plot);
            axis1_ids = repmat('t', nplot, 1);
            axis2_ids = repmat('j', nplot, 1);
            axis3_ids = indices_to_plot;
             
            axis_ids = {axis1_ids, axis2_ids, axis3_ids};
            primary_ndxs = axis3_ids;
            this.plot_from_ids(hybrid_sol, axis_ids, primary_ndxs)
            
            if nargout == 0
                % Prevent output if function is not terminated with a
                % semicolon.
                clear this
            end
        end

        function this = plotPhase(this, varargin)
            % Plot a phase plot of the hybrid solution.
            % The output of depends on the dimension of the system 
            % or the number of components selected with 'slice()'. 
            % The output is as follows: 
            % - 2D: a 2D phase plot
            % - 3D: a 3D phase plot
            % - otherwise, an error is thrown
            hybrid_sol = hybrid.internal.convert_varargin_to_solution_obj(varargin);
            sliced_indices = this.settings.indicesToPlot(hybrid_sol);
            dimensions = length(sliced_indices);
            
            if dimensions ~= 2 && dimensions ~= 3
                error('Expected 2 or 3 dimensions.');
            else
                sliced_indices_cell = num2cell(sliced_indices');
                primary_ndxs = -ones(size(sliced_indices_cell));
                this.plot_from_ids(hybrid_sol, sliced_indices_cell, primary_ndxs);
            end
            
            if nargout == 0
                % Prevent output if function is not terminated with a
                % semicolon.
                clear this
            end          
        end

        function this = plot(this, varargin)
            % PLOT Plot the hybrid solution in an intelligent way.
            % The output of depends on the dimension of the system 
            % (or the number of components selected with 'slice()'). 
            % The output is as follows: 
            % - 1D: a 1D plot generated using plotFlows
            % - 2D: a 2D phase plot
            % - 3D: a 3D phase plot
            % - 4D+: a set of 1D subplots generated using plotFlows.
            hybrid_sol = hybrid.internal.convert_varargin_to_solution_obj(varargin);
            sliced_indices = this.settings.indicesToPlot(hybrid_sol);
            dimensions = length(sliced_indices);
            
            if dimensions ~= 2 && dimensions ~= 3
                this.plotFlows(hybrid_sol);
            else
                this.plotPhase(hybrid_sol);
            end
            
            if nargout == 0
                % Prevent output if function is not terminated with a
                % semicolon.
                clear this
            end          
        end

        function this = addLegendEntry(this, plt, name)
            % Add an object to include in the legend. 
            % This function MUST be called while the axes where the object
            % was plotted is still active.
            if isempty(name) || strcmp('', name)
                return
            end
            plt.DisplayName = char(name);
            this.plots_for_legend = [this.plots_for_legend, plt];
            this.axes_for_legend = [this.axes_for_legend, gca()];
            this.display_legend();
            if nargout == 0
                clear this
            end
        end
    end

    methods(Hidden) % Legacy-named plot functions
        % The following functions are provided to help users transition
        % from v2.04 to v3.0.
        
        function plotflows(this, varargin)   
            warning('Please use the plotFlows function instead of plotflows.')
            this.plotFlows(varargin{:});
        end

        function plotjumps(this, varargin)
            warning('Please use the plotJumps function instead of plotjumps.')
            this.plotJumps(varargin{:});
        end

        function plotHybridArc(this, varargin)
            warning('Please use the plotHybrid function instead of plotHybridArc.')
            this.plotHybrid(varargin{:});
        end 
    end
    
    methods(Access = private)

        function configureAxes(this, xaxis_id, yaxis_id, zaxis_id)
            narginchk(3, 4)
            %is2D = nargin == 4;
            is3D = nargin == 4;
            is_x_a_time_axis = any(strcmp(xaxis_id, {'t', 'j'}));
            is_y_a_time_axis = strcmp(yaxis_id, 'j');            
            first_nontime_axis = 1 + is_x_a_time_axis + is_y_a_time_axis;
            
            % Apply labels
            this.xlabel(xaxis_id)
            this.ylabel(yaxis_id)
            if is3D
                this.zlabel(zaxis_id)
            end
            if ~this.settings.auto_subplots
                switch first_nontime_axis
                    case 1
                        % If the first nontime axis is 1, then the plot is a 2D
                        % or 3D phase plot, so the component labels should be
                        % used.
                    case 2
                        this.ylabel('single')
                    case 3
                        this.zlabel('single')
                end 
            end
            
            if this.settings.auto_subplots
                switch first_nontime_axis
                    case 1
                        this.applyTitle(xaxis_id)
                    case 2
                        this.applyTitle(yaxis_id)
                    case 3
                        this.applyTitle(zaxis_id)
                end
            else
                this.applyTitle('single')
            end
            
            % Adjust padding.
            if is_x_a_time_axis
                % Make the plot limits 'tight'
                xlim([-inf, inf])
            end
            
            if is_y_a_time_axis
                % Make the plot limits 'tight'
                ylim([-inf, inf])
            end
            
            this.display_legend();
        end
        
        function plot_from_ids(this, hybrid_sol, axis_ids, primary_ndxs)
            % axis_ids is a nx1 cell array. The kth entry contains a value that
            % identifies what to plot in the kth dimension. Each entry can
            % contain a scalar or a vector (each entry must have the same length). 
            % The length of each entry is the number of plots to draw. If
            % automatic subplots is on, then each plot is automatically placed
            % into a new subplot.
            narginchk(3, 4)
            nplot = size(axis_ids{1}, 1);
            plt_dimension = length(axis_ids);
            is2D = plt_dimension == 2;
            
            axis1_ids = axis_ids{:, 1};
            axis2_ids = axis_ids{:, 2};
            if is2D
                axis3_ids = [];
            else
                axis3_ids = axis_ids{:, 3};
            end
            check_legend_count(primary_ndxs, this.settings.component_legend_labels);
            
            if ~this.settings.auto_subplots
                was_hold_on_no_auto_subplots = ishold();
                % Clear the plot if 'hold off'. Otherwise, this has no effect.
                plot(nan, nan);
                % Turn on hold until the end of plot_from_ids
                hold on
            end
            
            for iplot = 1:nplot
                if this.settings.auto_subplots
                    % Save the hold status to apply in subplots.
                    was_hold_on_outside_subplot = ishold(); 
                    subplots(iplot) = subplot(nplot, 1, iplot); %#ok<AGROW>
                    if ~was_hold_on_outside_subplot
                        % Clear the plot to emulate 'hold off' behavior.
                        plot(nan, nan);
                    end
                    hold on
                end
                
                axis1_id = axis1_ids(iplot);
                axis2_id = axis2_ids(iplot);
                if is2D
                    axis3_id = [];
                else
                    axis3_id = axis3_ids(iplot);
                end
                primary_ndx = primary_ndxs(iplot);
                plot_values = create_plot_values(hybrid_sol, axis1_id, axis2_id, axis3_id);
                
                if ~isempty(this.settings.timesteps_filter)
                    assert(length(this.settings.timesteps_filter) == size(plot_values, 1), ...
                        'The length(filter)=%d does not match the timesteps=%d in the HybridSolution.', ...
                        length(this.settings.timesteps_filter), size(plot_values, 1))
                    % Set entries that don't match the filter to NaN so they are not plotted.
                    plot_values(~this.settings.timesteps_filter) = NaN;
                end
                
                t = hybrid_sol.t;
                j = hybrid_sol.j;
                flows_x = hybrid.internal.separateFlowsWithNaN(t, j, plot_values);
                [jumps_x, jumps_befores, jumps_afters] ...
                    = hybrid.internal.separateJumpsWithNaN(t, j, plot_values);
                
                % We 'plot' an invisible dummy point (NaN values are not
                % visible in plots), which provides the line and marker
                % appearance for the corresponding legend entry.
                plt = plot(nan, nan, ...
                    this.settings.flowArguments{:}, ...
                    this.settings.jumpStartArguments{:});
                legend_label = this.settings.createLegendLabel(primary_ndx);
                this.addLegendEntry(plt, legend_label);
                
                switch size(plot_values, 2)
                    case 2
                        this.plotFlow2D(flows_x)
                        this.plotJump2D(jumps_x, jumps_befores, jumps_afters)
                    case 3
                        this.plotFlow3D(flows_x)
                        this.plotJump3D(jumps_x, jumps_befores, jumps_afters)
                        view(34.8,16.8)
                    otherwise
                        error('plot_values must have 2 or 3 components.')
                end
                   
                this.configureAxes(axis1_id, axis2_id, axis3_id);
                if this.settings.auto_subplots
                    if ~was_hold_on_outside_subplot
                        hold off
                    end
                end
                this.settings.plots_callback(primary_ndx);
            end
            
            if this.settings.auto_subplots
                % Link the subplot axes.
                if is2D && nplot > 1
                    % Link the x-axes of the subplots so zooming and panning
                    % one subplot effects the others.
                    linkaxes(subplots,'x')
                elseif nplot > 1
                    % Link the subplot axes so that the views are sync'ed.
                    link = linkprop(subplots, {'View', 'XLim', 'YLim'});
                    setappdata(gcf, 'StoreTheLink', link);
                end
            else
                if ~was_hold_on_no_auto_subplots
                    hold off
                end
            end
        end
       
        function plotFlow2D(this, x)
            if isempty(x)
               return 
            end
            plot(x(:,1), x(:,2), this.settings.flowArguments{:})
        end

        function plotFlow3D(this, x)
            if isempty(x)
               return 
            end
            plot3(x(:,1), x(:,2), x(:,3), this.settings.flowArguments{:});
        end

        function plotJump2D(this, x_jump, x_start, x_end)
            % Plot the line from start to end.
            plot(x_jump(:,1), x_jump(:,2), this.settings.jumpLineArguments{:});
            % Plot the start of the jump
            plot(x_start(:,1), x_start(:,2), this.settings.jumpStartArguments{:});
            % Plot the end of the jump
            plot(x_end(:,1), x_end(:,2), this.settings.jumpEndArguments{:});
        end

        function plotJump3D(this, x_jump, x_before, x_after)
            if isempty(x_before)
                return % Not a jump
            end
            % Plot jump line
            plot3(x_jump(:,1), x_jump(:, 2), x_jump(:, 3), ...
                this.settings.jumpLineArguments{:});
            % Plot the start of the jump
            plot3(x_before(:,1), x_before(:,2), x_before(:,3), ...
                this.settings.jumpStartArguments{:});
            % Plot the end of the jump
            plot3(x_after(:,1), x_after(:,2), x_after(:,3), ...
                this.settings.jumpEndArguments{:});   
        end
        
        function display_legend(this)
            % LEGEND Add a legend for each call to builder.plots() while 
            % in the current figure. (Plots in other figures will be
            % skipped).
            
            % For the current figure, get all the graphics objects. 
            plots_in_figure = findall(gcf, '-not', 'DisplayName', []);

            % For each plot saved in this.plots_for_legend, check whether
            % it is a plot in the current figure.
            plots_for_legend_indices = ismember(this.plots_for_legend,  plots_in_figure);
            plots_for_this_legend = this.plots_for_legend(plots_for_legend_indices);
            axes_for_this_legend = this.axes_for_legend(plots_for_legend_indices);
            
            if isempty(axes_for_this_legend) 
                % Calling unique on an empty array creates a 0x1 array,
                % which causes the for-loop below to execute once with
                % ax=[]. This return statement prevents that.
                return 
            end
            for ax = unique(axes_for_this_legend)
                % Add the legend entries for each plot. We truncate the lengths
                % of the arrays to match so that Matlab does not print a
                % (rather unhelpful) warning.
                plots_in_axes = plots_for_this_legend(axes_for_this_legend == ax);
                
                if isvalid(ax) % Check that figure hasn't been closed.
                    lgd = legend(ax, plots_in_axes);
                    try
                        set(lgd, 'AutoUpdate','off');
                    catch
                        % Older versions of MATLAB don't automatically update
                        % legends and thus don't have an 'AutoUpdate' option.
                    end
                    set(lgd, this.settings.legendArguments{:})
                end
            end
        end
                
        function xlabel(this, index)
            % xlabel Add a label to the x-axis for thecreateLegendLabel component at 'index'.
            label = this.settings.labelFromId(index);
            xlabel(label, this.settings.labelArguments{:})
            set(gca, 'LabelFontSizeMultiplier', 1.0);
        end

        function ylabel(this, index)
            % ylabel Add a label to the y-axis for the component at 'index'.
            label = this.settings.labelFromId(index);
            ylabel(label, this.settings.labelArguments{:})
            set(gca, 'LabelFontSizeMultiplier', 1.0);
        end

        function zlabel(this, index)
            % zlabel Add a label to the z-axis for the component at 'index'.
            label = this.settings.labelFromId(index);
            zlabel(label, this.settings.labelArguments{:})
            set(gca, 'LabelFontSizeMultiplier', 1.0);
        end

        function applyTitle(this, title_id)
            title_str = this.settings.getTitle(title_id);
            title(title_str, this.settings.titleArguments{:});
            set(gca, 'TitleFontSizeMultiplier', 1.0);
        end         
    end

    methods(Hidden) % Hide methods from 'handle' superclass from documentation.
        function addlistener(varargin)
             addlistener@HybridPlotBuilder(varargin{:});
        end
        function delete(varargin)
             delete@HybridPlotBuilder(varargin{:});
        end
        function eq(varargin)
            error('Not supported')
        end
        function findobj(varargin)
             findobj@HybridPlotBuilder(varargin{:});
        end
        function findprop(varargin)
             findprop@HybridPlotBuilder(varargin{:});
        end
        % function isvalid(varargin)  Method is sealed.
        %      isvalid@HybridPlotBuilder(varargin);
        % end
        function ge(varargin)
        end
        function gt(varargin)
        end
        function le(varargin)
            error('Not supported')
        end
        function lt(varargin)
            error('Not supported')
        end
        function ne(varargin)
            error('Not supported')
        end
        function notify(varargin)
            notify@HybridPlotBuilder(varargin{:});
        end
        function listener(varargin)
            listener@HybridPlotBuilder(varargin{:});
        end
    end
end
        
%%% Local functions %%%

function plot_values = create_plot_values(sol, xaxis_id, yaxis_id, zaxis_id)
% CREATE_PLOT_VALUES Create an array containing the values from the corresponding id in each column.
% xaxis_id can take values 't', 'j' or an integer.
% yaxis_id can take values 'j' or an integer.
% zaxis_id can take value of an integer or an empty set.
narginchk(4, 4)

    function values = values_from_id(id)
        if strcmp(id, 't')
            values = sol.t;
        elseif strcmp(id, 'j')
            values = sol.j;
        else
            values = sol.x(:, id);
        end
    end

    xvalues = values_from_id(xaxis_id);
    yvalues = values_from_id(yaxis_id);
    % If zaxis_id is empty, then zvalues will be as well, which means the
    % the plot will be only 2D.
    zvalues = values_from_id(zaxis_id);
    plot_values = [xvalues, yvalues, zvalues];

end
       
function check_legend_count(primary_axes, lgd_labels)
% Print a warning if the number of plots and labels do not match.

if isempty(lgd_labels)
    return 
end
if all(primary_axes == -1)
    expected_count = 1;
else
    expected_count = max(primary_axes);
end

lgd_count = length(lgd_labels);
warning_msg = 'Expected %d legend labels but only %d of were provided.';
if expected_count < lgd_count
    id = 'HybridPlotBuilder:TooManyLegends';
    warning(id, warning_msg, expected_count, lgd_count)
elseif expected_count > lgd_count
    id = 'HybridPlotBuilder:TooFewLegends';
    warning(id, warning_msg, expected_count, lgd_count)
end
end