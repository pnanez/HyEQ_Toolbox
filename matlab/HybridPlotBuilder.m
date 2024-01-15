classdef HybridPlotBuilder < handle
% Class for plotting hybrid arcs with many configuration options.
%
% See also: <a href="matlab: hybrid.internal.openHelp('HybridPlotBuilder_demo')">Demo: Creating plots with HybridPlotBuilder</a>, and HybridArc/plotFlows, HybridArc/plotJumps, etc.
% 
% Added in HyEQ Toolbox version 3.0.

% Written by Paul K. Wintz, Hybrid Systems Laboratory, UC Santa Cruz (©2022).
% 
% Tests for this class can be opened with the command 
%   open('hybrid.tests.slow_essential.HybridPlotBuilderTest')
% and run with the command 
%   runtests('hybrid.tests.slow_essential.HybridPlotBuilderTest')

    properties(Constant)
        defaults = hybrid.PlotSettings() % default plot settings
    end
    
    properties(SetAccess = immutable)
        settings % plot settings
    end
    
    properties(Access = {?hybrid.tests.slow_essential.HybridPlotBuilderTest})
        % Legend options
        plots_for_legend = [];
        axes_for_legend = [];

        % last_function_call records the last function called so that we can
        % warn a user if a plotting function was not called last.
        last_function_call;
    end

    methods
        function obj = HybridPlotBuilder()
            % HybridPlotBuilder constructor.
           obj.settings = HybridPlotBuilder.defaults.copy();
        end
    end
    
    methods % Property setters for plot settings.
        function this = title(this, title)
            % Set a title for the plot.
            % 
            % See also: titles, titleInterpreter, titleSize.
            if iscell(title)
                e = MException('HybridPlotBuilder:InvalidArgument', ...
                    'For setting multiple titles, use titles()');
                throwAsCaller(e);
            end
            this.titles(title);
            this.last_function_call = 'title';

            if nargout == 0
                % Prevent output if function is not terminated with a semicolon.
                clearvars this
            end
        end
        
        function this = titles(this, varargin)
            % Set the plot titles.
            % 
            % See also: title, titleInterpreter, titleSize.
            titles = hybrid.internal.parseStringVararginWithOptionalOptions(varargin{:});
            this.settings.component_titles = titles;
            this.last_function_call = 'titles';

            if nargout == 0
                % Prevent output if function is not terminated with a semicolon.
                clearvars this
            end
        end

        function this = label(this, label)
            % Set an axis label for a single state component.
            % 
            % See also: labels, tLabel, jLabel, labelInterpreter, labelSize.
            if iscell(label)
                e = MException('HybridPlotBuilder:InvalidArgument', ...
                    'For setting multiple labels, use labels()');
                throwAsCaller(e);
            end
            this.labels(label);
            this.last_function_call = 'label';

            if nargout == 0
                % Prevent output if function is not terminated with a semicolon.
                clearvars this
            end
        end

        function this = labels(this, varargin)
            % Set axis labels for state components.
            % 
            % See also: label, tLabel, jLabel, labelInterpreter, labelSize.
            labels = hybrid.internal.parseStringVararginWithOptionalOptions(varargin{:});
            this.settings.component_labels = labels;
            this.last_function_call = 'labels';

            if nargout == 0
                % Prevent output if function is not terminated with a semicolon.
                clearvars this
            end
        end

        function this = labelSize(this, size)
            % Set the font size of component labels.
            % 
            % See also: label, labels, tLabel, jLabel, labelInterpreter,
            % titleSize, tickLabelSize.
            this.settings.label_size = size;
            this.last_function_call = 'labelSize';

            if nargout == 0
                % Prevent output if function is not terminated with a semicolon.
                clearvars this
            end
        end

        function this = titleSize(this, size)
            % Set the font size of titles.
            %
            % See also: title, titles, titleInterpreter, labelSize, tickLabelSize.
            this.settings.title_size = size;
            this.last_function_call = 'titleSize';

            if nargout == 0
                % Prevent output if function is not terminated with a semicolon.
                clearvars this
            end
        end

        function this = tickLabelSize(this, size)
            % Set the font size of tick mark labels.
            % This function is not supported in R2014b. 
            %
            % See also: labelInterpreter, labelSize, titleSize.
            if verLessThan('matlab', '8.5')
                warning('Setting the ''tickLabelSize'' with this function is not supported on R2014b.')
            end

            this.settings.tick_label_size = size;
            this.last_function_call = 'tickLabelSize';

            if nargout == 0
                % Prevent output if function is not terminated with a semicolon.
                clearvars this
            end
        end

        function this = tLabel(this, t_label)
            % Set the label for the continuous time axis.
            %
            % The default value depends on the label interpreter:
            %  'none': 't'
            %   'tex': 't'
            % 'latex': '$t$'
            % 
            % To remove the label, use an empty string.
            %
            % See also: jLabel, label, labels, labelInterpreter.
            this.settings.t_label = t_label;
            this.last_function_call = 'tLabel';

            if nargout == 0
                % Prevent output if function is not terminated with a semicolon.
                clearvars this
            end
        end

        function this = jLabel(this, j_label)
            % Set the label for the discrete time axis 'j'.
            %
            % The default value depends on the label interpreter:
            %  'none': 'j'
            %   'tex': 'j'
            % 'latex': '$j$'
            % 
            % To remove the label, use an empty string.
            %
            % See also: tLabel, label, labels, labelInterpreter.
            this.settings.j_label = j_label;
            this.last_function_call = 'jLabel';

            if nargout == 0
                % Prevent output if function is not terminated with a semicolon.
                clearvars this
            end
        end

        function this = xLabelFormat(this, label_format)
            % Set the string format used for missing component labels when using automatic subplots.
            % The label format is used only if explicit labels are not given.
            %
            % The string 'label_format' must be a valid format for
            %         sprint(label_format, i)
            % where 'i' is an integer that equals the index number of the
            % component for the subplot where the label is placed. That is,
            % label_format is a string that contains a single occurance of '%d',
            % which is replaced in each label by the corresponding component
            % index. Backslashes must be escaped, so '\alpha' should be written
            % '\\alpha'.
            % 
            % The default value depends on the label interpreter:
            %  'none': 'x(%d)'
            %   'tex': 'x_{%d}'
            % 'latex': '$x_{%d}$'
            %
            % See also: subplots, label, labels, labelInterpreter.
            this.settings.x_label_format = label_format;
            this.last_function_call = 'xLabelFormat';

            if nargout == 0
                % Prevent output if function is not terminated with a semicolon.
                clearvars this
            end
        end
        
        function this = labelInterpreter(this, interpreter)
            % Set the text interpreter used in time, component, and legend entry labels. 
            % The choices are 'none', 'tex', and 'latex' (default).
            % 
            % See also: label, labels, legend, labelSize, textInterpreter.
            this.settings.label_interpreter = interpreter;
            this.last_function_call = 'labelInterpreter';

            if nargout == 0
                % Prevent output if function is not terminated with a semicolon.
                clearvars this
            end
        end
        
        function this = tickLabelInterpreter(this, interpreter)
            % Set the text interpreter used in time, component, and legend entry labels.
            % This function is not supported in R2014b.
            %  
            % See also: textInterpreter.
            if verLessThan('matlab', '8.5')
                warning('Setting the ''tickLabelInterpreter'' with this function is not supported on R2014b.')
            end
            this.settings.tick_label_interpreter = interpreter;
            this.last_function_call = 'tickLabelInterpreter';

            if nargout == 0
                % Prevent output if function is not terminated with a semicolon.
                clearvars this
            end
        end
        
        function this = titleInterpreter(this, interpreter)
            % Set the text interpreter used in titles. 
            % The choices are 'none', 'tex', and 'latex' (default).
            % 
            % See also: title, titles, titleSize, textInterpreter.
            this.settings.title_interpreter = interpreter;
            this.last_function_call = 'titleInterpreter';

            if nargout == 0
                % Prevent output if function is not terminated with a semicolon.
                clearvars this
            end
        end

        function this = textInterpreter(this, interpreter)
            % Set both the title and legend entry labels.
            % The choices are 'none', 'tex', and 'latex' (default).
            % 
            % See also: titleInterpreter, labelInterpreter,
            % tickLabelInterpreter.
            this.titleInterpreter(interpreter);
            this.labelInterpreter(interpreter);
            this.tickLabelInterpreter(interpreter);
            this.last_function_call = 'textInterpreter';

            if nargout == 0
                % Prevent output if function is not terminated with a semicolon.
                clearvars this
            end
        end

        function this = legend(this, varargin)
            % Set the legend entry label(s) for each state component. 
            % If the legend labels are given in a cell array as the first
            % argument, than name-value options for the built-in MATLAB
            % 'legend' function can be included in subsequent arguments.
            %
            % See also: legend addLegendEntry reorderLegendEntries
            % circshiftLegendEntries  labelInterpreter
            [labels, options] = hybrid.internal.parseStringVararginWithOptionalOptions(varargin{:});
            this.settings.component_legend_labels = labels;
            this.settings.legend_options = options;
            this.last_function_call = 'legend';

            if nargout == 0
                % Prevent output if function is not terminated with a semicolon.
                clearvars this
            end
        end

        function this = legendOptions(this, varargin)
            % Set name-value options for the built-in MATLAB 'legend' function 
            % that are applied when the building the legend. This function may
            % be called before or after HybridPlotBuilder.legend and
            % HybridPlotBuilder.addLegendEntry. 
            % 
            % Example: 
            %
            %     HybridPlotBuilder()...
            %         .legend('System state')...
            %         .legendOptions('Location', 'Best', ...
            %                        'NumColumns', 2)...
            %         .plotPhase(sol.select(1:2))
            %
            % Added in HyEQ Toolbox version 3.1.
            %
            % See also: legend addLegendEntry reorderLegendEntries
            % circshiftLegendEntries  labelInterpreter
            [~, options] = hybrid.internal.parseStringVararginWithOptionalOptions({}, varargin{:});
            this.settings.legend_options = options;
            this.display_legend();

            if nargout == 0
                % Prevent output if function is not terminated with a semicolon.
                clearvars this
            end
        end

        function this = addLegendEntry(this, graphic_obj_handle, label)
            % Add a graphic object to the legend. 
            % 
            % This function is used to add an object to the legend generated by
            % HybridPlotBuilder. 'graphic_obj_handle' can be the output of a builtin
            % MATLAB plotting function, such as 'plot' or 'contour' (note that
            % for 'contour', the _second_ output is the handle).
            %
            % Example: 
            %
            %     plt_handle = plot(0, 0, '*');
            %     pb.addLegendEntry(plt_handle, 'Origin');
            %
            % See also: legend reorderLegendEntries circshiftLegendEntries
            if isempty(label) || strcmp('', label)
                return
            end
            graphic_obj_handle.DisplayName = char(label);
            this.plots_for_legend = [this.plots_for_legend, graphic_obj_handle];
            this.axes_for_legend = [this.axes_for_legend, graphic_obj_handle.Parent];
            this.display_legend();
            if nargout == 0
                % Prevent output if function is not terminated with a semicolon.
                clearvars this
            end
        end

        function this = reorderLegendEntries(this, permutation_indices)
            % Reorder the legend entries.
            % This function should be called after all of the plotting functions
            % are called.
            % The 'permutation_indices' contains a list of positive integers that define
            % how to reorder that the legend entries. It may omit entries or
            % contain duplicates. 
            %
            % Example: To swap the order of two legend entries, call reorderLegendEntries([2 1]).
            % Example: To swap the first and fourth legend entry, call reorderLegendEntries([4 2 3 1]).
            % Example: To remove the first of four entries, call reorderLegendEntries(2:4).
            %
            % If this HybridPlotBuilder has been used to add plots to multiple
            % axes, then the legends in each axes is reordered.
            % The maximum value in 'permutation_indices' must not be greater
            % than the least number of legend entries among all the affected
            % axes.
            % If a legend label was given as an empty string '' in |legend| or
            % |addLegendEntry|, then there is not a corresponding
            % legend entry so the number of legend entries is one less than it
            % would be otherwise.
            %
            % Added in HyEQ Toolbox version 3.1.
            %
            % See also: circshiftLegendEntries legend addLegendEntry

            % Create empty cell arrays that we will populate with the permuted
            % values.
            new_axes_for_legend_cell = {};
            new_plots_for_legend_cell = {};

            if ~isnumeric(permutation_indices) || any(round(permutation_indices) ~= permutation_indices)
                error('The input argument "permutation_indices" must contain only (positive) integers.')
            end

            if ~isvector(permutation_indices)
                error('The input argument "permutation_indices" must be a vector (or scalar).')
            end

            if min(permutation_indices) < 1
                error('The minimum permuation index was %d but must not be less than 1.', ...
                    min(permutation_indices))
            end

            % For each axes that has a legend...
            for ax = unique(this.axes_for_legend)
                % Get the indices that are in this axes.
                indices_in_ax = find(this.axes_for_legend == ax);

                if max(permutation_indices) > numel(indices_in_ax)
                    error('The maximum permuation index was %d,  but axes only has %d legend entries.', ...
                        max(permutation_indices), numel(indices_in_ax))
                end

                % Permute them according to the indices in the input argument. 
                permuted_indices = indices_in_ax(permutation_indices);

                % Save the permuted entries as the next entry in the cell
                % arrays.
                new_plots_for_legend_cell{end+1} = this.plots_for_legend(permuted_indices); %#ok<AGROW> 
                new_axes_for_legend_cell{end+1} = this.axes_for_legend(permuted_indices); %#ok<AGROW> 
            end

            % Convert back from a cell arrays of arrays to just arrays.
            this.plots_for_legend = [new_plots_for_legend_cell{:}];
            this.axes_for_legend = [new_axes_for_legend_cell{:}];

            % Apply changes.
            this.display_legend();
        
            if nargout == 0
                % Prevent output if function is not terminated with a semicolon.
                clearvars this
            end
        end

        function this = circshiftLegendEntries(this, offset)
            % Shift the legend entries circularly by the given amount.
            % This function should be called after all of the plotting functions
            % are called.
            %
            % If this hybrid plot builder has been used to add plots to multiple
            % axes, then the legends in each axes is reordered.
            %
            % Example: To move the last entry to the beginning, use 
            %   circshiftLegendEntries(1);
            % Example: To move the first entry to the end, use 
            %   circshiftLegendEntries(-1);
            %
            % Added in HyEQ Toolbox version 3.1.
            %
            % See also: circshift reorderLegendEntries legend addLegendEntry
        
            % Create empty cell arrays that we will populate with the shifted values.
            new_axes_for_legend_cell = {};
            new_plots_for_legend_cell = {};

            if ~isscalar(offset)
                error('The input argument "offset" must be a scalar.')
            end

            if ~isnumeric(offset) || round(offset) ~= offset
                error('The input argument "offset" must be an integer.')
            end

            % For each axes that has a legend...
            for ax = unique(this.axes_for_legend)
                % Get the indices that are in this axes.
                indices_in_ax = find(this.axes_for_legend == ax);

                % Circshift the indices by the given offset. 
                shifted_indices = circshift(indices_in_ax, offset);

                % Save the shifted entries as the next entry in the cell arrays.
                new_plots_for_legend_cell{end+1} = this.plots_for_legend(shifted_indices); %#ok<AGROW> 
                new_axes_for_legend_cell{end+1} = this.axes_for_legend(shifted_indices); %#ok<AGROW> 
            end

            % Convert back from a cell arrays of arrays to just arrays.
            this.plots_for_legend = [new_plots_for_legend_cell{:}];
            this.axes_for_legend = [new_axes_for_legend_cell{:}];

            % Apply changes.
            this.display_legend();

            if nargout == 0
                % Prevent output if function is not terminated with a semicolon.
                clearvars this
            end
        end
                
        function this = flowColor(this, color)
            % Set the color of flow lines.
            % 
            % The 'color' argument can be any valid MATLAB color specification: 
            %    name (e.g., 'red', 'blue'),
            %    short name (e.g., 'r', 'b'), 
            %    RGB Triplet (e.g., [1, 0, 0], [0, 0, 1]), or
            %    hexadecimal color code (e.g., '#FF0000', '#0000FF').
            % Multiple colors can be set by passing an cell array of color
            % specifications, such as {'red', 'black', [0.3, 0.1, 0.9]}. If
            % auto-subplots is 'off', then each state component is plotted in
            % the next color in the array, looping back to the first when the
            % end is reached. If auto-subplots is 'on', then all components are
            % plotted in their respective subplot with each call to a 
            % plotting function using the next color.
            %
            % To use the default MATLAB plot colors, use flowColor('matlab'). 
            % 
            % To hide flows, use 'none' or an empty array []. 
            %
            % See also: plot, jumpColor, color.
            this.settings.flow_color = color;
            this.last_function_call = 'flowColor';

            if nargout == 0
                % Prevent output if function is not terminated with a semicolon.
                clearvars this
            end
        end

        function this = flowLineStyle(this, style)
            % Set the style of flow lines. 
            % 
            % Options are '-' (default), '--'. ':', '-.', or 'none'.
            %
            % See also: flowColor, flowLineWidth.
            this.settings.flow_line_style = style;
            this.last_function_call = 'flowLineStyle';

            if nargout == 0
                % Prevent output if function is not terminated with a semicolon.
                clearvars this
            end
        end

        function this = flowLineWidth(this, width)
            % Set the width of flow lines.
            % See also: flowColor, flowLineStyle.
            this.settings.flow_line_width = width;
            this.last_function_call = 'flowLineWidth';

            if nargout == 0
                % Prevent output if function is not terminated with a semicolon.
                clearvars this
            end
        end

        function this = flowMarker(this, marker)
            % Set markers for each sample point during flows.
            %
            % Options are 
            % 'none' - Default
            % 'o' (circle) 
            % '+' (plus sign) 
            % '*' (asterisk) 
            % '.' (point)
            % 'x' (cross) 
            % '_' (horizontal line) 
            % '|' (vertical line) 
            % 's' (square) 
            % 'd' (diamond) 
            % '^' (upward-pointing triangle) 
            % 'v' (downward-pointing triangle) 
            % '>' (right-pointing triangle)
            % '<' (left-pointing triangle) 
            % 'p' (pentagram) or 
            % 'h' (hexagram).
            %
            % Added in HyEQ Toolbox version 3.1.
            %
            % See also: flowMarkerSize
            this.settings.flow_marker = marker;
            this.last_function_call = 'flowMarker';

            if nargout == 0
                % Prevent output if function is not terminated with a semicolon.
                clearvars this
            end
        end

        function this = flowMarkerSize(this, size)
            % Set the marker size for flows.
            %
            % Default: 6. 
            %
            % Added in HyEQ Toolbox version 3.1.
            %
            % See also: flowMarker.

            this.settings.flow_marker_size = size;
            this.last_function_call = 'flowMarkerSize';

            if nargout == 0
                % Prevent output if function is not terminated with a semicolon.
                clearvars this
            end
        end

        function this = jumpColor(this, color)
            % Set the color of jump lines and markers.
            % 
            % The 'color' argument can be any valid MATLAB color specification: 
            %    name (e.g., 'red', 'blue'),
            %    short name (e.g., 'r', 'b'), 
            %    RGB Triplet (e.g., [1, 0, 0], [0, 0, 1]), or
            %    hexadecimal color code (e.g., '#FF0000', '#0000FF').
            % Multiple colors can be set by passing an cell array of color
            % specifications, such as {'red', 'black', [0.3, 0.1, 0.9]}. If
            % auto-subplots is 'off', then each state component is plotted in
            % the next color in the array, looping back to the first when the
            % end is reached. If auto-subplots is 'on', then all components are
            % plotted in their respective subplot with each call to a 
            % plotting function using the next color.
            %
            % To use the default MATLAB plot colors, use jumpColor('matlab'). 
            % 
            % To hide jumps, use 'none' or
            % an empty array []. To hide only jump lines, instead use
            % jumpLineStyle('none') and to hide only jump markers, use
            % jumpStartMarker('none'), jumpEndMarker('none'), or jumpMarker('none').  
            %
            % See also: jumpLineStyle, jumpStartMarker, jumpEndMarker,
            % jumpMarker, flowColor, color. 
            this.settings.jump_color = color;
            this.last_function_call = 'jumpColor';

            if nargout == 0
                % Prevent output if function is not terminated with a semicolon.
                clearvars this
            end
        end

        function this = color(this, color)
            % Set both the flow and jump colors.
            %
            % See also: flowColor, jumpColor.
            this.settings.jump_color = color;
            this.settings.flow_color = color;
            this.last_function_call = 'color';

            if nargout == 0
                % Prevent output if function is not terminated with a semicolon.
                clearvars this
            end
        end

        function this = jumpLineStyle(this, style)
            % Set the line style for lines between the start and end of jumps. 
            % 
            % Options are '-', '--' (default), ':', '-.', or 'none'.
            %
            % See also: jumpColor, jumpLineWidth.
            this.settings.jump_line_style = style;
            this.last_function_call = 'jumpLineStyle';

            if nargout == 0
                % Prevent output if function is not terminated with a semicolon.
                clearvars this
            end
        end

        function this = jumpLineWidth(this, width)
            % Set the with of lines between the start and end of jumps
            %
            % See also: jumpColor, jumpLineStyle.
            this.settings.jump_line_width = width;
            this.last_function_call = 'jumpLineWidth';

            if nargout == 0
                % Prevent output if function is not terminated with a semicolon.
                clearvars this
            end
        end

        function this = jumpMarker(this, marker)
            % Set the marker for both the start and end of jumps.
            %
            % Options are 
            % 'none', 
            % 'o' (circle), 
            % '+' (plus sign), 
            % '*' (asterisk), 
            % '.' (point)
            % 'x' (cross), 
            % '_' (horizontal line), 
            % '|' (vertical line), 
            % 's' (square), 
            % 'd' (diamond), 
            % '^' (upward-pointing triangle), 
            % 'v' (downward-pointing triangle), 
            % '>' (right-pointing triangle),
            % '<' (left-pointing triangle), 
            % 'p' (pentagram), or 
            % 'h' (hexagram).
            %
            % See also: jumpMarkerSize, jumpStartMarker, jumpEndMarker
            this.jumpStartMarker(marker);
            this.jumpEndMarker(marker);
            this.last_function_call = 'jumpMarker';

            if nargout == 0
                % Prevent output if function is not terminated with a semicolon.
                clearvars this
            end
        end

        function this = jumpMarkerSize(this, size)
            % Set the marker size for both the start and end of jumps.
            %
            % Default: 6. 
            %
            % See also: jumpMarker, jumpStartMarkerSize, jumpEndMarkerSize.
            this.jumpStartMarkerSize(size);
            this.jumpEndMarkerSize(size);
            this.last_function_call = 'jumpMarkerSize';

            if nargout == 0
                % Prevent output if function is not terminated with a semicolon.
                clearvars this
            end
        end

        function this = jumpStartMarker(this, marker)
            % Set the marker for the starting point of each jump.
            %
            % Options are 
            % 'none' 
            % 'o' (circle) 
            % '+' (plus sign) 
            % '*' (asterisk) 
            % '.' (point) - Default
            % 'x' (cross) 
            % '_' (horizontal line) 
            % '|' (vertical line) 
            % 's' (square) 
            % 'd' (diamond) 
            % '^' (upward-pointing triangle) 
            % 'v' (downward-pointing triangle) 
            % '>' (right-pointing triangle)
            % '<' (left-pointing triangle) 
            % 'p' (pentagram) or 
            % 'h' (hexagram).
            %
            % See also: jumpStartMarkerSize, jumpEndMarker, jumpMarker
            this.settings.jump_start_marker = marker;
            this.last_function_call = 'jumpStartMarker';

            if nargout == 0
                % Prevent output if function is not terminated with a semicolon.
                clearvars this
            end
        end

        function this = jumpStartMarkerSize(this, size)
            % Set the marker size for the starting point of each jump.
            %
            % Default: 6. 
            %
            % See also: jumpMarkerSize, jumpEndMarkerSize, jumpStartMarker.
            this.settings.jump_start_marker_size = size;
            this.last_function_call = 'jumpStartMarkerSize';

            if nargout == 0
                % Prevent output if function is not terminated with a semicolon.
                clearvars this
            end
        end

        function this = jumpEndMarker(this, marker)
            % Set the marker for the end point of each jump.
            %
            % Options are 
            % 'none'
            % 'o' (circle)
            % '+' (plus sign) 
            % '*' (asterisk) - Default
            % '.' (point)
            % 'x' (cross) 
            % '_' (horizontal line) 
            % '|' (vertical line) 
            % 's' (square) 
            % 'd' (diamond) 
            % '^' (upward-pointing triangle) 
            % 'v' (downward-pointing triangle) 
            % '>' (right-pointing triangle)
            % '<' (left-pointing triangle) 
            % 'p' (pentagram) or 
            % 'h' (hexagram).
            %
            % See also: jumpEndMarkerSize, jumpStartMarker, jumpMarker
            this.settings.jump_end_marker = marker;
            this.last_function_call = 'jumpEndMarker';

            if nargout == 0
                % Prevent output if function is not terminated with a semicolon.
                clearvars this
            end
        end

        function this = jumpEndMarkerSize(this, size)
            % Set the marker size for the end point of each jump.
            %
            % Default: 6. 
            %
            % See also: jumpMarkerSize, jumpStartMarkerSize, jumpEndMarker.
            this.settings.jump_end_marker_size = size;
            this.last_function_call = 'jumpEndMarkerSize';

            if nargout == 0
                % Prevent output if function is not terminated with a semicolon.
                clearvars this
            end
        end
        
        function this = subplots(this, auto_subplots)
            % Configure whether to automatically create subplots for each component.
            % 
            % Input value can be 'on','off', true, or false. The default value
            % is 'off'.
            %
            % When 'off', all plots are placed in the current axes. The first
            % 'title' value is used, if provided. For 'plotFlows', 'plotJumps',
            % and 'plotHybrid', the first 'label' value, if provided, is used to
            % label the vertical axis. For 'plotPhase', then the 'label' values
            % corresponding to the plotted component indices are added to each axis, if
            % provided (otherwise default values are used).
            %
            % When 'subplots' is 'on' and 'plotFlows', 'plotJumps',
            % or 'plotHybrid' is called, then a subplot is created for each
            % plotted state component. If 'plotPhase' is called, then a single subplot
            % is create. If the current figure did not, previously, have the
            % correct number of subplots, then the figure is cleared before plotting. 
            % For 'plotFlows', 'plotJumps', and 'plotHybrid', the 'title' and
            % 'label' values corresponding to the component index is applied to
            % each subplot. For 'plotPhase', the first 'title' value is applied
            % and the 'label' values corresponding to the plotted components are
            % added to each axis, if provided (otherwise default values are used).
            %
            % See also: configurePlots, titles, labels.
            this.settings.auto_subplots = auto_subplots;
            this.last_function_call = 'subplots';

            if nargout == 0
                % Prevent output if function is not terminated with a semicolon.
                clearvars this
            end
        end

        function this = filter(this, timesteps_filter)
            % Pick the timesteps to display. All others are hidden from plots. 
            % 
            % The 'timesteps_filter' argument must must be a column vector with
            % the same entries as the number of 
            % time steps in the solution being plotted.
            %
            % To reset to the default value, call filter([]).
            %
            % See also: select.
            this.settings.timesteps_filter = timesteps_filter;
            this.last_function_call = 'filter';

            if nargout == 0
                % Prevent output if function is not terminated with a
                % semicolon.
                clearvars this
            end
        end

        function this = setAxesArgs(this, varargin)
            % Provide additional arguments that are passed to the axes function in each plot (or subplot). 
            %
            % Define axes arguments using name-value pairs. Multiple arguments
            % can be set in a single call to setAxesArgs. Calling setAxesArgs a
            % second time replaces the previously defined arguments.
            % The arguments given here override any other settings defined by
            % HybridPlotBuilder. To reset to the default value, call setAxesArgs([]).
            % 
            % The given arguments are applied to each axes in the plot after all
            % other plotting is finished but before the callbacks passed in
            % HybridPlotBuilder.configurePlots() are called.
            % 
            % Example: 
            % 
            %   HybridPlotBuilder().setAxesArgs('XGrid', 'on')
            %
            % See also: axes, setPlotArgs, setPlotFlowArgs,
            % setPlotJumpArgs, setPlotJumpStartArgs, setPlotJumpLineArgs, setPlotJumpEndArgs
            this.settings.user_axes_args = varargin;
            this.last_function_call = 'setAxesArgs';

            if nargout == 0
                % Prevent output if function is not terminated with a
                % semicolon.
                clearvars this
            end
        end

        % function this = addAxesArgs(this, varargin)
        %     % TODO
        %     %
        %     % To reset to the default value, call axesArgs([]).
        %     %
        %     % See also: 
        %     this.settings.axes_builtin_fnc_args = [this.settings.axes_builtin_fnc_args, varargin];
        %     this.last_function_call = 'addAxesArgs';
        % 
        %     if nargout == 0
        %         % Prevent output if function is not terminated with a
        %         % semicolon.
        %         clearvars this
        %     end
        % end

        function this = setPlotArgs(this, varargin)
            % Provide additional arguments that are passed to the plotting function. 
            %
            % Define plot arguments using name-value pairs. Multiple arguments
            % can be set in a single call to setPlotArgs. Calling setPlotArgs a
            % second time replaces the previously defined arguments.
            % The arguments given here override any other settings defined
            % defined using other |HybridPlotBuilder| functions, such as
            % |flowColor| or |jumpMarker|.
            % To reset to the default value, call setPlotArgs([]).  
            %
            % The priority of these commands
            % is as follows, with the lowest priority on the left:
            % 
            %   default < other functions < setPlotArgs < setPlotFlowArgs
            %                                           < setPlotJumpArgs < setPlotJumpStartArgs 
            %                                                             < setPlotJumpEndArgs    
            % 
            % You can see a list of available name-value pairs in the Matlab documentation
            % for plot.
            %
            % See also: plot, setAxesArgs, setPlotFlowArgs,
            % setPlotJumpArgs, setPlotJumpStartArgs, setPlotJumpLineArgs, setPlotJumpEndArgs
            this.settings.user_plot_args = varargin;
            this.last_function_call = 'setPlotArgs';

            if nargout == 0
                % Prevent output if function is not terminated with a
                % semicolon.
                clearvars this
            end
        end

        function this = setPlotFlowArgs(this, varargin)
            % Provide additional arguments that are passed to the plotting function when plotting flows. 
            %
            % Define plot arguments using name-value pairs. Multiple arguments
            % can be set in a single call to setPlotFlowArgs. Calling setPlotFlowArgs a
            % second time replaces the previously defined arguments.
            % The arguments given here override any other settings defined
            % defined using other |HybridPlotBuilder| functions, such as
            % |flowColor|.
            % To reset to the default value, call setPlotFlowArgs([]).  
            %
            % The priority of these commands
            % is as follows, with the lowest priority on the left:
            % 
            %   default < other functions < setPlotArgs < setPlotFlowArgs
            %                                           < setPlotJumpArgs < setPlotJumpStartArgs 
            %                                                             < setPlotJumpEndArgs    
            % 
            % You can see a list of available name-value pairs in the Matlab documentation
            % for plot.
            %
            % See also: plot, setAxesArgs, setPlotArgs,
            % setPlotJumpArgs, setPlotJumpStartArgs, setPlotJumpLineArgs, setPlotJumpEndArgs
            this.settings.user_plot_flow_args = varargin;
            this.last_function_call = 'setPlotFlowArgs';

            if nargout == 0
                % Prevent output if function is not terminated with a
                % semicolon.
                clearvars this
            end
        end

        function this = setPlotJumpArgs(this, varargin)
            % Provide additional arguments that are passed to the plotting function when plotting jumps (including the start and end markers and the line between). 
            %
            % Define plot arguments using name-value pairs. Multiple arguments
            % can be set in a single call to setPlotArgs. Calling setPlotJumpArgs a
            % second time replaces the previously defined arguments.
            % The arguments given here override any other settings defined
            % defined using other |HybridPlotBuilder| functions, such as |jumpMarker|.
            % To reset to the default value, call setPlotJumpArgs([]).  
            %
            % The priority of these commands
            % is as follows, with the lowest priority on the left:
            % 
            %   default < other functions < setPlotArgs < setPlotFlowArgs
            %                                           < setPlotJumpArgs < setPlotJumpStartArgs 
            %                                                             < setPlotJumpEndArgs    
            % 
            % You can see a list of available name-value pairs in the Matlab documentation
            % for plot.
            %
            % See also: plot, setAxesArgs, setPlotArgs, setPlotFlowArgs,
            % setPlotJumpStartArgs, setPlotJumpLineArgs, setPlotJumpEndArgs
            this.settings.user_plot_jump_args = varargin;
            this.last_function_call = 'setPlotJumpArgs';

            if nargout == 0
                % Prevent output if function is not terminated with a
                % semicolon.
                clearvars this
            end
        end

        function this = setPlotJumpStartArgs(this, varargin)
            % Provide additional arguments that are passed to the plotting function when plotting the start of jumps.
            %
            % Define plot arguments using name-value pairs. Multiple arguments
            % can be set in a single call to setPlotJumpStartArgs. Calling setPlotJumpStartArgs a
            % second time replaces the previously defined arguments.
            % The arguments given here override any other settings defined
            % defined using other |HybridPlotBuilder| functions, such as
            % |flowColor| or |jumpMarker|.
            % To reset to the default value, call setPlotJumpStartArgs([]).  
            %
            % The priority of these commands
            % is as follows, with the lowest priority on the left:
            % 
            %   default < other functions < setPlotArgs < setPlotFlowArgs
            %                                           < setPlotJumpArgs < setPlotJumpStartArgs 
            %                                                             < setPlotJumpEndArgs    
            % 
            % You can see a list of available name-value pairs in the Matlab documentation
            % for plot.
            %
            % See also: plot, setAxesArgs, setPlotArgs, setPlotFlowArgs,
            % setPlotJumpArgs, setPlotJumpLineArgs, setPlotJumpEndArgs
            this.settings.user_plot_jump_start_args = varargin;
            this.last_function_call = 'setPlotStartArgs';

            if nargout == 0
                % Prevent output if function is not terminated with a
                % semicolon.
                clearvars this
            end
        end

        function this = setPlotJumpLineArgs(this, varargin)
            % Provide additional arguments that are passed to the plotting function when plotting the jump line.
            %
            % Define plot arguments using name-value pairs. Multiple arguments
            % can be set in a single call to setPlotJumpLineArgs. Calling setPlotJumpLineArgs a
            % second time replaces the previously defined arguments.
            % The arguments given here override any other settings defined
            % defined using other |HybridPlotBuilder| functions, such as
            % |flowColor| or |jumpMarker|.
            % To reset to the default value, call setPlotJumpLineArgs([]).  
            %
            % The priority of these commands
            % is as follows, with the lowest priority on the left:
            % 
            %   default < other functions < setPlotArgs < setPlotFlowArgs
            %                                           < setPlotJumpArgs < setPlotJumpStartArgs 
            %                                                             < setPlotJumpEndArgs    
            % 
            % You can see a list of available name-value pairs in the Matlab documentation
            % for plot.
            %
            % See also: plot, setAxesArgs, setPlotArgs, setPlotFlowArgs,
            % setPlotJumpArgs, setPlotJumpStartArgs, setPlotJumpEndArgs
            this.settings.user_plot_jump_line_args = varargin;
            this.last_function_call = 'setPlotJumpLineArgs';

            if nargout == 0
                % Prevent output if function is not terminated with a
                % semicolon.
                clearvars this
            end
        end

        function this = setPlotJumpEndArgs(this, varargin)
            % Provide additional arguments that are passed to the plotting function when plotting the end of jumps.
            %
            % Define plot arguments using name-value pairs. Multiple arguments
            % can be set in a single call to setPlotJumpEndArgs. Calling setPlotJumpEndArgs a
            % second time replaces the previously defined arguments.
            % The arguments given here override any other settings defined
            % defined using other |HybridPlotBuilder| functions, such as
            % |flowColor| or |jumpMarker|.
            % To reset to the default value, call setPlotJumpEndArgs([]).  
            %
            % The priority of these commands
            % is as follows, with the lowest priority on the left:
            % 
            %   default < other functions < setPlotArgs < setPlotFlowArgs
            %                                           < setPlotJumpArgs < setPlotJumpStartArgs 
            %                                                             < setPlotJumpEndArgs    
            % 
            % You can see a list of available name-value pairs in the Matlab documentation
            % for plot.
            %
            % See also: plot, setAxesArgs, setPlotArgs, setPlotFlowArgs,
            % setPlotJumpArgs, setPlotJumpStartArgs, setPlotJumpLineArgs
            this.settings.user_plot_jump_end_args = varargin;
            this.last_function_call = 'setPlotJumpEndArgs';

            if nargout == 0
                % Prevent output if function is not terminated with a
                % semicolon.
                clearvars this
            end
        end
        
        function this = configurePlots(this, plots_callback)
            % Provide a function handle that is called within each plot (or subplot).
            % This can be used to perform additional configuration. The function
            % handle must take two arguments. The first argument 'ax' is the axes of
            % the plot being configured and the second is the compoenent index or
            % component indices of state that were plotted in the 'ax'.
            %
            % See also: subplots.
            this.settings.plots_callback = plots_callback;
            this.last_function_call = 'configurePlots';

            if nargout == 0
                % Prevent output if function is not terminated with a
                % semicolon.
                clearvars this
            end
        end

        function this = plot2Function(this, plot_function_2D)
            % (EXPERIMENTAL) Set the plotting function for 2D plots.
            % The function can be specified using its name as a string, or by
            % its function handle.
            % Supported functions include 'plot' (default), 'semilogy',
            % 'semilogx', and 'loglog'. User-defined functions can also be used,
            % but must have input and output arguments matching the following
            % example:
            %
            %     function plt = myPolarPlot(axes, data1, data2, varargin)
            %         x_values = data2.*cos(data1);
            %         y_values = data2.*sin(data1);
            %         plt = plot(axes, x_values, y_values, varargin{:});
            %     end
            %
            % See also: plot3Function.
            this.settings.plot_function_2D = plot_function_2D;
            this.last_function_call = 'plot2Function';

            if nargout == 0
                % Prevent output if function is not terminated with a
                % semicolon.
                clearvars this
            end
        end

        function this = plot3Function(this, plot_function_3D)
            % (EXPERIMENTAL) Set the plotting function for 3D plots.
            % The function can be specified using its name as a string, or by
            % its function handle.
            % Supported functions include 'plot3' (default). User-defined
            % functions can also be used, 
            % but must have input and output arguments matching the following
            % example:
            %
            %     function plt = myCylindricalPlot(axes, data1, data2, data3, varargin)
            %         x_values = data2.*cos(data1);
            %         y_values = data2.*sin(data1);
            %         z_values = data3;
            %         plt = plot3(axes, x_values, y_values, z_values, varargin{:});
            %     end
            %
            % See also: plot2Function.
            this.settings.plot_function_3D = plot_function_3D;
            this.last_function_call = 'plot3Function';

            if nargout == 0
                % Prevent output if function is not terminated with a
                % semicolon.
                clearvars this
            end
        end
    end
    
    methods % Plotting functions
        function this = plotFlows(this, varargin)
            % Plot values vs. continuous time 't'.
            % Let 'sol' be a HybridSolution object with N time steps (that is,
            % N = length(sol.t)). Then, the input arguments for plotFlows must
            % take one of the following forms: 
            % 'plotFlows(sol)', 
            % 'plotFlows(sol, x)', 
            % 'plotFlows(sol, fh)', or
            % 'plotFlows(t, j, x)', 
            % where
            % 'x' is an array with N rows,
            % 'fh' is a function handle with the inputs |@(x)|, |@(x, t)| or
            %   |@(x, t, j)| and output that is an array with N rows. The
            %   evaluation of 'fh' is done via the function
            %   'HybridSolution.evaluateFunction'.
            % 't' and 'j' are Nx1 column vectors and 'x' is an array with N
            % rows.
            % 
            % See also: plotJumps, plotHybrid, plotPhase,
            % HybridSolution.evaluateFunction.
            [hybrid_sol, x_label_ndxs] ...
                = hybrid.internal.convert_varargin_to_solution_obj(varargin, this.settings.component_indices);
            plot_data = this.createPlotDataArray(hybrid_sol, x_label_ndxs, {'t', 'x'});
            this.plot_from_plot_data_array(plot_data);
            this.last_function_call = [];
            
            if nargout == 0
                % Prevent output if function is not terminated with a
                % semicolon.
                clearvars this
            end
        end

        function this = plotJumps(this, varargin)
            % Plot values vs. discrete time 'j'.
            %
            % Let 'sol' be a HybridSolution object with N time steps (that is,
            % N = length(sol.t)). Then, the input arguments for plotJumps must
            % take one of the following forms: 
            % 'plotJumps(sol)', 
            % 'plotJumps(sol, x)', 
            % 'plotJumps(sol, fh)', or
            % 'plotJumps(t, j, x)', 
            % where
            % 'x' is an array with N rows,
            % 'fh' is a function handle with the inputs |@(x)|, |@(x, t)| or
            %   |@(x, t, j)| and output that is an array with N rows. The
            %   evaluation of 'fh' is done via the function
            %   'HybridSolution.evaluateFunction'.
            % 't' and 'j' are Nx1 column vectors and 'x' is an array with N
            % rows.
            % 
            % See also: plotFlows, plotHybrid, plotPhase,
            % HybridSolution.evaluateFunction.
            [hybrid_sol, x_label_ndxs] = hybrid.internal.convert_varargin_to_solution_obj(varargin, this.settings.component_indices);
            plot_struct = this.createPlotDataArray(hybrid_sol, x_label_ndxs, {'j', 'x'});
            this.plot_from_plot_data_array(plot_struct);
            this.last_function_call = [];
            
            if nargout == 0
                % Prevent output if function is not terminated with a
                % semicolon.
                clear this
            end
        end

        function this = plotHybrid(this, varargin)
            % Plot values vs. continuous and discrete time (t, j).
            %
            % Let 'sol' be a HybridSolution object with N time steps (that is,
            % N = length(sol.t)). Then, the input arguments for plotHybrid must
            % take one of the following forms: 
            % 'plotHybrid(sol)', 
            % 'plotHybrid(sol, x)', 
            % 'plotHybrid(sol, fh)', or
            % 'plotHybrid(t, j, x)', 
            % where
            % 'x' is an array with N rows,
            % 'fh' is a function handle with the inputs |@(x)|, |@(x, t)| or
            %   |@(x, t, j)| and output that is an array with N rows. The
            %   evaluation of 'fh' is done via the function
            %   'HybridSolution.evaluateFunction'.
            % 't' and 'j' are Nx1 column vectors and 'x' is an array with N
            % rows.
            % 
            % See also: plotFlows, plotJumps, plotPhase,
            % HybridSolution.evaluateFunction.
            [hybrid_sol, x_label_ndxs] = hybrid.internal.convert_varargin_to_solution_obj(varargin, this.settings.component_indices);
            
            plot_struct = this.createPlotDataArray(hybrid_sol, x_label_ndxs, {'t', 'j', 'x'});
            this.plot_from_plot_data_array(plot_struct)
            this.last_function_call = [];

            if nargout == 0
                % Prevent output if function is not terminated with a
                % semicolon.
                clear this
            end
        end

        function this = plotPhase(this, varargin)
            % Plot a phase plot of the hybrid solution.
            %
            % The output of depends on the dimension of the system 
            % or the number of components selected with 'select()'. 
            % The if there are two components, then the plot is a a 2D phase
            % plot and if there are three components, then it is a 3D phase
            % plot. Otherwise, an error is thrown.
            %
            % Let 'sol' be a HybridSolution object with N time steps (that is,
            % N = length(sol.t)). Then, the input arguments for plotPhase must
            % take one of the following forms: 
            % 'plotPhase(sol)', 
            % 'plotPhase(sol, x)', 
            % 'plotPhase(sol, fh)', or
            % 'plotPhase(t, j, x)', 
            % where
            % 'x' is a Nx2 or Nx3 array,
            % 'fh' is a function handle with the inputs |@(x)|, |@(x, t)| or
            %   |@(x, t, j)| and output that is a Nx2 or Nx3 array. The
            %   evaluation of 'fh' is done via the function
            %   'HybridSolution.evaluateFunction'.
            % 't' and 'j' are Nx1 column vectors and 'x' is a Nx2 or Nx3 array.
            % 
            % See also: plotFlows, plotJumps, plotHybrid,
            % HybridSolution.evaluateFunction.
            [hybrid_sol, x_label_ndxs] = hybrid.internal.convert_varargin_to_solution_obj(varargin, this.settings.component_indices);
            switch size(x_label_ndxs, 2)
                case 2
                    plot_struct = this.createPlotDataArray(hybrid_sol, x_label_ndxs, {'x', 'x'});
                case 3
                    plot_struct = this.createPlotDataArray(hybrid_sol, x_label_ndxs, {'x', 'x', 'x'});
                otherwise
                    error('Expected ''x'' to be 2 or 3 dimensions, instead was %d.', size(x_label_ndxs, 2));
            end
            this.plot_from_plot_data_array(plot_struct)
            this.last_function_call = [];
            
            if nargout == 0
                % Prevent output if function is not terminated with a
                % semicolon.
                clear this
            end          
        end

        function this = plotTimeDomain(this, varargin)
            % Plot continuous-time t vs and discrete-time j.
            %
            % Let 'sol' be a HybridSolution object with N time steps (that is,
            % N = length(sol.t)). Then, the input arguments for plotHybrid must
            % take one of the following forms: 
            % 'plotTimeDomain(sol)', 
            % 'plotTimeDomain(t, j)', 
            % where
            % 't' and 'j' are Nx1 column vectors.
            % 
            % See also: plotFlows, plotJumps, plotPhase, plotHybrid.
            [hybrid_sol, ~] = hybrid.internal.convert_varargin_to_solution_obj(varargin, this.settings.component_indices);
            
            plot_struct = this.createPlotDataArray(hybrid_sol, [], {'t', 'j'});
            this.plot_from_plot_data_array(plot_struct)
            this.last_function_call = [];

            if nargout == 0
                % Prevent output if function is not terminated with a
                % semicolon.
                clear this
            end
        end
    end

    methods(Hidden)

        function plot(~, varargin)
            % This function has been removed. Please use plotFlows or plotPhase
            % explicitly.
            error(['This function has been removed. Please use ' ...
                'plotFlows or plotPhase explicitly.'])                     
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

    methods(Hidden) % More deprecated functions.
        function this = autoSubplots(this, auto_subplots)
            % Deprecated: use 'subplots()' instead.
            warning('Use HybridPlotBuilder.subplots() instead of autoSubplots()')
            this.subplots(auto_subplots);
            this.last_function_call = 'autoSubplots';
        end

        function this = slice(this, varargin)
            % Select the components of x to plot (DEPRECATED). 
            hybrid.internal.deprecationWarning('HybridPlotBuilder.slice', 'HybridArc.select')
            this.select(varargin{:});
            this.last_function_call = 'slice';
            
            if nargout == 0
                % Prevent output if function is not terminated with a semicolon.
                clearvars this
            end
        end

        function this = select(this, component_indices)
            % Select the components of x to plot (DEPRECATED). 
            % 
            % If plotting a function of the state, such as 
            %   HybridPlotBuilder().select(3).plotFlows(sol, @(x3) cos(x3));
            % then x is selected before it is passed to the given function, so
            % the result would be a plot of cosine of the third component of x.
            % 
            % To reset to the default value, call select([]).
            %
            % See also: filter.
            
            % We don't plot a deprecation warning, here, because this function was
            % never publicly released---we keep it here so we can run the suite
            % of tests written for HybridPlotBuilder.slice without failing tests
            % due to unwanted warnings.

            this.settings.component_indices = component_indices;
            this.last_function_call = 'select';

            if nargout == 0
                % Prevent output if function is not terminated with a semicolon.
                clearvars this
            end
        end
    end
    
    methods(Access = private)
        function plot_data_array = createPlotDataArray(this, hybrid_sol, x_labels_ndxs, axis_symbols)
            % axis_symbols: a cell array containing 2 or 3 cells that contain
            % a combination of 't', 'j' and 'x'.
            plot_data_array = hybrid.internal.buildPlotDataArray(...
                                axis_symbols, x_labels_ndxs, hybrid_sol, this.settings);
        end

        function plot_from_plot_data_array(this, plot_data_array)
            % Given the data in plot_data_array, generate a plot or series of
            % subplots.
             
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
                        % Clear the axes, thereby emulating the typical 'hold off' behavior. 
                        % Including the 'reset' argument for cla() is important
                        % because it causes all of the axes properties to be
                        % deleted, giving us a clean slate.
                        cla('reset');
                    end
                    hold on

                    % Reset the 'hold' status from before the start of this function.
                    % It's possible that the axes were closed already, so we use
                    % safeCallback to ensure that this doesn't cause any errors.
                    reset_hold_fh = @() hold(axes_array(i_sp), hold_status_before);
                    safe_reset_hold_fh = @() safeCallback(axes_array(i_sp), reset_hold_fh);                                                           
                    restore_hold_on_cleanup(i_sp) = onCleanup(safe_reset_hold_fh); %#ok<AGROW>
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
                dummy_plt = this.settings.plot_function_2D(axes, nan, nan, ...
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
                % Our method for adjusting tick labels does not work on older
                % versions of MATLAB.
                if ~verLessThan('matlab', '9.0') % Only supported on R2016a and later.
                    try
                        for axis_name = {'XAxis', 'YAxis', 'ZAxis'}
                            axes.(axis_name{1}).FontSize = this.settings.tick_label_size;
                            axes.(axis_name{1}).TickLabelInterpreter = this.settings.tick_label_interpreter;
                        end
                    catch
                        warning('HybridPlotBuilder:UnsupportedOperation:TickSettings', ...
                            ['Setting the font size and interpreter for ticks is not supported ' ...
                            'on this version of MATLAB. ' ...
                            'If you see this warning, please ' ...
                            '<a href="https://github.com/pnanez/HyEQ_Toolbox/issues/new">' ... 
                            'submit an issue</a> on our GitHub repository and include your MATLAB version number. ' ...
                            'To disable this warning, click <a href="matlab:warning(''off'', ''HybridPlotBuilder:UnsupportedOperation:TickSettings'')">here</a>.'])
                    end
                end

                % Apply labels
                this.xlabel(axes, plt_data.xlabel)
                this.ylabel(axes, plt_data.ylabel)
                this.zlabel(axes, plt_data.zlabel)
                this.applyTitle(axes, plt_data.title)

                % For 'j' axes, the ticks should only be integers, so 
                % we delete all non-integer ticks.
                if plt_data.is_axis1_discrete
                    enableRemoveNonIntegerTicksCallback(axes, 'XAxis')
                end
                if plt_data.is_axis2_discrete
                    enableRemoveNonIntegerTicksCallback(axes, 'YAxis')
                end
                if plt_data.is_axis3_discrete
                    enableRemoveNonIntegerTicksCallback(axes, 'ZAxis')
                end

                % Adjust padding.
                xlim(axes, plt_data.xlim)
                ylim(axes, plt_data.ylim)

                % Pass user-defined arguments to "axes". 
                if ~isempty(this.settings.user_axes_args)
                    set(axes, this.settings.user_axes_args{:});
                end

                this.settings.plots_callback(axes, plt_data.state_ndx);
            end

            if this.settings.auto_subplots
                % Link the subplot axes.
                if isempty(plot_data_array)
                    error('No data to plot. This might be caused because the hybrid arc has dimension zero.')
                end

                safeCallback(axes_array, @() linkTimeAxes(plot_data_array, axes_array))
            end
        end
       
        function plotFlow2D(this, ax, x, flow_args)
            if isempty(x)
               return 
            end
            this.settings.plot_function_2D(ax, ...
                x(:,1), x(:,2), ...
                flow_args{:})
        end

        function plotFlow3D(this, ax, x, flow_args)
            if isempty(x)
               return 
            end
            this.settings.plot_function_3D(ax, x(:,1), x(:,2), x(:,3), flow_args{:});
        end

        function plotJump2D(this, ax, x_jump, x_start, x_end, jump_args)
            % (DO NOT REORDER JUMP COMPONENTS -- effects displayed layer order)
            % Plot the line from start to end. 
            this.settings.plot_function_2D(ax, ...
                x_jump(:,1), x_jump(:,2), ...
                jump_args.line{:});
            % Plot the start of the jump
            this.settings.plot_function_2D(ax, ...
                x_start(:,1), x_start(:,2), ...
                jump_args.start{:});
            % Plot the end of the jump
            this.settings.plot_function_2D(ax, ...
                x_end(:,1), x_end(:,2), ...
                jump_args.end{:});
        end

        function plotJump3D(this, ax, x_jump, x_before, x_after, jump_args)
            if isempty(x_before)
                return % Not a jump
            end 
            % Plot jump line
            this.settings.plot_function_3D(ax, x_jump(:,1), x_jump(:, 2), x_jump(:, 3), jump_args.line{:});
            % Plot the start of the jump
            this.settings.plot_function_3D(ax, x_before(:,1), x_before(:,2), x_before(:,3), jump_args.start{:});
            % Plot the end of the jump
            this.settings.plot_function_3D(ax, x_after(:,1), x_after(:,2), x_after(:,3), jump_args.end{:});   
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
                % Remove any existing legend. This ensures that the default
                % options (rather than preciously set options) are used unless
                % otherwise set with HybridPlotBuilder/legend or
                % HybridPlotBuilder/legendOptions. The actual entries of the
                % legend would be overwritten anyways.
                legend(ax, 'off');

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
            % xlabel Add a label to the x-axis for the component at 'index'.
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

    methods(Hidden)
        function delete(this)
            % Warn users if they changed plot settings without subsequently
            % calling a plot function.
            if ~isempty(this.last_function_call)
                warning(['The function ''%s'' was called on a HybridPlotBuilder ' ...
                    'object without a subsequent call to a plotting function.\nIn ' ...
                    'order for ''%s'' to have an effect, it must be called prior to plotting.'], ...
                    this.last_function_call, this.last_function_call)
            end
            delete@HybridPlotBuilder(this);
        end
    end

    methods(Hidden) % Hide methods from 'handle' superclass from documentation.
        function addlistener(varargin)
             addlistener@HybridPlotBuilder(varargin{:});
        end
%         function delete(varargin)
%              delete@HybridPlotBuilder(varargin{:});
%         end
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

function on_off = logical2on_off(b)
    % Convert a logical value to 'on' or 'off'
    if b 
        on_off = 'on';
    else
        on_off = 'off';
    end
end

function safeCallback(required_axes_handles, callback)
% Check that 'required_handles' all still exist. If they do, 
% run the callback. Otherwise, print an warning.
    try
        if all(isvalid(required_axes_handles))
            callback();
        end
    catch e
        id = e.identifier;
        if strcmp(id,'MATLAB:class:InvalidHandle') ...
            || strcmp(id, 'MATLAB:graphics:proplink')
            % Don't bother warning. The figure was (probably) closed by the user.
        else
            rethrow(e)
        end
    end
end

function linkTimeAxes(plot_data_array, axes_array) 
% Link the x- and possibly y-axes of each subplot together so that all of the
% subplots move when any one of them pans or zooms.
    is2D = size(plot_data_array(1).plot_values, 2) == 2;
    if is2D
        % Link the x-axes of the subplots so zooming and panning
        % one subplot effects the others.
        @() linkaxes(axes_array,'x');
    else
        % Link the subplot axes so that the views are sync'ed.
        link = linkprop(axes_array, {'View', 'XLim', 'YLim'});
        setappdata(gcf, 'StoreTheLink', link);
    end
end

function enableRemoveNonIntegerTicksCallback(ax, axis_name)
    ruler = get(ax, axis_name);
    if ischar(ruler) || ~isprop(ruler, 'LimitsChangedFcn') || ~isprop(ruler, 'TickValues')
        % On old versions (e.g. R2014b), NumericalRulers do not have the
        % fields 'TickValues' or 'LimitsChangedFcn', so our approach for
        % removing noninteger tick marks does not work.
        return
    end
    removeNonintegerTicks(ruler)
    ruler.LimitsChangedFcn = @removeNonintegerTicks;
end

function removeNonintegerTicks(ruler,~)
% For the given ruler, delete all ticks that are at noninteger values.
% This function is used as a callback for when the ruler limits change.

    % Make ruler value mode 'auto', momentarily, (if it isn't already) 
    % so that the location of the tick marks are recomputed.
    ruler.TickValuesMode = 'auto';
    
    % Now, hide any tick marks that are not integers.
    tick_values = ruler.TickValues;

    % Sometimes the '0' tick mark is off by ~1e-17, so we use a small range of
    % values.
    integer_indices = abs(fix(tick_values) - tick_values) < 1e-12;

    % Keep only the (approximately) integer values.
    ruler.TickValues = tick_values(integer_indices);
end