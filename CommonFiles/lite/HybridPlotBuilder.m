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

        function this = tickLabelSize(this, size)
            % Set the font size of tick mark labels.
            this.settings.tick_label_size = size;
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

        function this = legend(this, varargin)
            % Set the legend entry label(s) for the next plot. Optional name-value options for the built-in MATLAB 'legend' function can be included.
            [labels, options] = hybrid.internal.parseStringVararginWithOptionalOptions(varargin{:});
            this.settings.component_legend_labels = labels;
            this.settings.legend_options = options;
        end
                
        function this = flowColor(this, color)
            % Set the color of flow lines.
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
            % Set the color of jump lines and jump markers.
            % at each end.
            this.settings.jump_color = color;
        end

        function this = color(this, color)
            this.settings.jump_color = color;
            this.settings.flow_color = color;
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
            % The choices are 'none', 'tex', and 'latex' (default).
            this.settings.title_interpreter = interpreter;
        end
        
        function this = labelInterpreter(this, interpreter)
            % Set the text interpreter used in time, component, and legend entry labels. 
            % The choices are 'none', 'tex', and 'latex' (default).
            this.settings.label_interpreter = interpreter;
        end
        
        function this = tickLabelInterpreter(this, interpreter)
            % Set the text interpreter used in time, component, and legend entry labels. 
            this.settings.tick_label_interpreter = interpreter;
        end

        function this = textInterpreter(this, interpreter)
            % Set both the title and legend entry labels.
            % The choices are 'none', 'tex', and 'latex' (default).
            this.titleInterpreter(interpreter);
            this.labelInterpreter(interpreter);
            this.tickLabelInterpreter(interpreter);
        end

    end
    
    methods % Plotting functions
        function this = plotFlows(this, varargin)
            % Plot values vs. continuous time 't'.
            hybrid_sol = hybrid.internal.convert_varargin_to_solution_obj(varargin);
            x_ndxs = this.settings.indicesToPlot(hybrid_sol);
            plot_struct = this.makePlotDataArray(hybrid_sol, x_ndxs, {'t', 'x'});
            this.plot_from_plot_data_array(plot_struct);
            
            if nargout == 0
                % Prevent output if function is not terminated with a
                % semicolon.
                clearvars this
            end
        end

        function this = plotJumps(this, varargin)
            % Plot values vs. discrete time 'j'.
            hybrid_sol = hybrid.internal.convert_varargin_to_solution_obj(varargin);
            x_ndxs = this.settings.indicesToPlot(hybrid_sol);
            plot_struct = this.makePlotDataArray(hybrid_sol, x_ndxs, {'j', 'x'});
            this.plot_from_plot_data_array(plot_struct);
            
            if nargout == 0
                % Prevent output if function is not terminated with a
                % semicolon.
                clear this
            end
        end

        function this = plotHybrid(this, varargin)
            % Plot values vs. continuous and discrete time (t, j).
            hybrid_sol = hybrid.internal.convert_varargin_to_solution_obj(varargin);

            x_ndxs = this.settings.indicesToPlot(hybrid_sol);
            plot_struct = this.makePlotDataArray(hybrid_sol, x_ndxs, {'t', 'j', 'x'});
            this.plot_from_plot_data_array(plot_struct)

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
            
            x_ndxs = this.settings.indicesToPlot(hybrid_sol)';
            switch size(x_ndxs, 2)
                case 2
                    plot_struct = this.makePlotDataArray(hybrid_sol, x_ndxs, {'x', 'x'});
                case 3
                    plot_struct = this.makePlotDataArray(hybrid_sol, x_ndxs, {'x', 'x', 'x'});
                otherwise
                    error('Expected 2 or 3 dimensions.');
            end
            this.plot_from_plot_data_array(plot_struct)
            
            if nargout == 0
                % Prevent output if function is not terminated with a
                % semicolon.
                clear this
            end          
        end

        function this = plot(this, varargin)
            % Plot the hybrid solution in an intelligent way.
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
                this.plotFlows(varargin{:});
            else
                this.plotPhase(varargin{:});
            end
            
            if nargout == 0
                % Prevent output if function is not terminated with a
                % semicolon.
                clear this
            end          
        end

        function this = addLegendEntry(this, graphic_obj, label)
            % Add an object to include in the legend. 
            % This function MUST be called while the axes where the object
            % was plotted is still active.
            if isempty(label) || strcmp('', label)
                return
            end
            graphic_obj.DisplayName = char(label);
            this.plots_for_legend = [this.plots_for_legend, graphic_obj];
            this.axes_for_legend = [this.axes_for_legend, graphic_obj.Parent];
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
        function plot_data_array = makePlotDataArray(this, hybrid_sol, x_ndxs, axis_symbols)
            plot_data_array = hybrid.internal.buildPlotDataArray(axis_symbols, x_ndxs, hybrid_sol, this.settings);
        end

        function plot_from_plot_data_array(this, plot_data_array)
            % axis_ids is a nx1 cell array. The kth entry contains a value that
            % identifies what to plot in the kth dimension. Each entry can
            % contain a scalar or a vector (each entry must have the same length). 
            % The length of each entry is the number of plots to draw. If
            % automatic subplots is on, then each plot is automatically placed
            % into a new subplot.
            n_plots = size(plot_data_array, 1);
             
            % Save the 'hold' status.
            is_hold_on_before = ishold();
            hold_status_before = logical2on_off(is_hold_on_before);
            
            n_subplots = max([plot_data_array.subplot_ndx]);
            
            for i_sp = 1:n_subplots
                if this.settings.auto_subplots
                    axes_array(i_sp) = subplot(n_subplots, 1, i_sp); %#ok<AGROW>
                else
                    axes_array = gca();
                    assert(n_subplots == 1)
                    assert(i_sp == 1)
                end
                
                if i_sp == 1 || this.settings.auto_subplots 
                    if ~is_hold_on_before
                        % Clear the plot to emulate 'hold off' behavior.
                        plot(nan, nan);
                    end
                    hold on
                    fh = @() hold(axes_array(i_sp), hold_status_before);
                    restore_hold_on_cleanup(i_sp) = onCleanup(fh); %#ok<AGROW>
                end
            end

            for plt_data = plot_data_array
                axes = axes_array(plt_data.subplot_ndx);
                assert(ishold(axes), '''hold on'' should have been automatically activated, but it was not.')

                t = plt_data.t;
                j = plt_data.j;
                flows_x = hybrid.internal.separateFlowsWithNaN(t, j, plt_data.plot_values);
                [jumps_x, jumps_befores, jumps_afters] ...
                    = hybrid.internal.separateJumpsWithNaN(t, j, plt_data.plot_values);

                % We 'plot' an invisible dummy point (NaN values are not
                % visible in plots), which provides the line and marker
                % appearance for the corresponding legend entry.
                dummy_plt = plot(axes, nan, nan, ...
                    plt_data.flow_args{:}, ...
                    plt_data.jump_args.start{:});
                this.addLegendEntry(dummy_plt, plt_data.legend_label);

                switch size(plt_data.plot_values, 2)
                    case 2
                        this.plotFlow2D(axes, flows_x, plt_data.flow_args)
                        this.plotJump2D(axes, jumps_x, jumps_befores, jumps_afters, plt_data.jump_args)
                    case 3
                        this.plotFlow3D(axes, flows_x, plt_data.flow_args)
                        this.plotJump3D(axes, jumps_x, jumps_befores, jumps_afters, plt_data.jump_args)
                        view(axes, 34.8,16.8)
                    otherwise
                        error('plot_values must have 2 or 3 components.')
                end

                % Apply adjustments to tick labels
                % This section MUST come before we set the label sizes, otherwise
                % the label sizes will be overwritten when we call
                %   "ax.XAxis.FontSize = ..."
                for axis_name = {'XAxis', 'YAxis', 'ZAxis'}
                    axes.(axis_name{1}).FontSize = this.settings.tick_label_size;
                    axes.(axis_name{1}).TickLabelInterpreter = this.settings.tick_label_interpreter;
                end

                % Apply labels
                this.xlabel(axes, plt_data.xlabel)
                this.ylabel(axes, plt_data.ylabel)
                this.zlabel(axes, plt_data.zlabel)
                this.applyTitle(axes, plt_data.title)

                % Adjust padding.
                xlim(axes, plt_data.xlim)
                ylim(axes, plt_data.ylim)

                this.settings.plots_callback(axes, plt_data.state_ndx);
            end

            if this.settings.auto_subplots
                % Link the subplot axes.
                is2D = size(plot_data_array(1).plot_values, 2) == 2;
                if is2D && n_plots > 1
                    % Link the x-axes of the subplots so zooming and panning
                    % one subplot effects the others.
                    linkaxes(axes_array,'x')
                elseif n_plots > 1
                    % Link the subplot axes so that the views are sync'ed.
                    link = linkprop(axes_array, {'View', 'XLim', 'YLim'});
                    setappdata(gcf, 'StoreTheLink', link);
                end
            end
        end
       
        function plotFlow2D(this, ax, x, flow_args)
            if isempty(x)
               return 
            end
            plot(ax, x(:,1), x(:,2), flow_args{:})
        end

        function plotFlow3D(this, ax, x, flow_args)
            if isempty(x)
               return 
            end
            plot3(ax, x(:,1), x(:,2), x(:,3), flow_args{:});
        end

        function plotJump2D(this, ax, x_jump, x_start, x_end, jump_args)
            % Plot the line from start to end.
            plot(ax, x_jump(:,1), x_jump(:,2), jump_args.line{:});
            % Plot the start of the jump
            plot(ax, x_start(:,1), x_start(:,2), jump_args.start{:});
            % Plot the end of the jump
            plot(ax, x_end(:,1), x_end(:,2), jump_args.end{:});
        end

        function plotJump3D(this, ax, x_jump, x_before, x_after, jump_args)
            if isempty(x_before)
                return % Not a jump
            end 
            % Plot jump line
            plot3(ax, x_jump(:,1), x_jump(:, 2), x_jump(:, 3), jump_args.line{:});
            % Plot the start of the jump
            plot3(ax, x_before(:,1), x_before(:,2), x_before(:,3), jump_args.start{:});
            % Plot the end of the jump
            plot3(ax, x_after(:,1), x_after(:,2), x_after(:,3), jump_args.end{:});   
        end
        
        function display_legend(this)
            % Add a legend for each call to builder.plots() while 
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
                
        function xlabel(this, axes, label)
            % xlabel Add a label to the x-axis for thecreateLegendLabel component at 'index'.
            xlabel(axes, label, this.settings.labelArguments{:})
            set(axes, 'LabelFontSizeMultiplier', 1.0);
        end

        function ylabel(this, axes, label)
            % ylabel Add a label to the y-axis for the component at 'index'.
            ylabel(axes, label, this.settings.labelArguments{:})
            set(axes, 'LabelFontSizeMultiplier', 1.0);
        end

        function zlabel(this, axes, label)
            % zlabel Add a label to the z-axis for the component at 'index'.
            zlabel(axes, label, this.settings.labelArguments{:})
            set(axes, 'LabelFontSizeMultiplier', 1.0);
        end

        function applyTitle(this, axes, title_str)
            title(axes, title_str, this.settings.titleArguments{:});
            set(axes, 'TitleFontSizeMultiplier', 1.0);
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

function axis_ids = generateAxisIds(axis1_id, axis2_id, axis3_id)
is3D = exist('axis3_id', 'var');

plot_dim = 2 + is3D;
if is3D
    plot_count = max([length(axis1_id), length(axis2_id), length(axis3_id)]);
else
    plot_count = max([length(axis1_id), length(axis2_id)]);
end
    function ids_cell = toCell(ids)
        if isnumeric(ids)
            ids_cell = num2cell(ids);
        else
            ids_cell = cellstr(repmat(ids, plot_count, 1));
        end
    end
axis_ids = cell(plot_count, plot_dim);
axis_ids(:, 1) = toCell(axis1_id);
axis_ids(:, 2) = toCell(axis2_id);
if is3D
    axis_ids(:, 3) = toCell(axis3_id);
end
end

function on_off = logical2on_off(b)
    % Convert a logical value to 'on' or 'off'
    if b 
        on_off = 'on';
    else
        on_off = 'off';
    end
end