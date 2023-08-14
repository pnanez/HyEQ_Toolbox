classdef PlotSettings < matlab.mixin.Copyable
% Data object class containing settings used by HybridPlotBuilder.
% 
% Added in HyEQ Toolbox version 3.0.

% Written by Paul K. Wintz, Hybrid Systems Laboratory, UC Santa Cruz (©2022). 
    properties
        % Text
        label_size
        title_size
        tick_label_size
        label_interpreter
        title_interpreter
        tick_label_interpreter
        
        % Text data
        component_titles
        component_labels
        component_legend_labels
        
        % Name-value pair options.
        legend_options
        user_axes_args
        user_plot_args % All plots
        user_plot_flow_args % Flow plots
        user_plot_jump_args % All jump plots
        user_plot_jump_start_args % Jump start plots
        user_plot_jump_line_args % Jump line plots
        user_plot_jump_end_args % Jump end plots

        % Flows
        flow_color
        flow_line_width
        flow_line_style
        flow_marker
        flow_marker_size
        
        % Jumps
        jump_color
        jump_line_style
        jump_line_width
        jump_start_marker
        jump_start_marker_size
        jump_end_marker
        jump_end_marker_size
        
        % Explicit Axis Labels
        x_label_format % For state components, not (necessarily) the horizontal axis.
        t_label
        j_label
        
        % Plotting function
        plot_function_2D
        plot_function_3D

        % Subplot Settings
        auto_subplots
        plots_callback
        max_subplots
        
        % Slice and Filter
        timesteps_filter
        component_indices
        
        % Scaling of text, lines widths, and marker sizes.
        text_scale
        line_scale
        marker_scale
    end
    
    properties(Constant, Hidden)
        % Text
        DEFAULT_LABEL_SIZE = 10;
        DEFAULT_TITLE_SIZE = 11;
        DEFAULT_TICK_LABEL_SIZE = 10;
        DEFAULT_LABEL_INTERPRETER = 'latex';
        DEFAULT_TITLE_INTERPRETER = 'latex';
        DEFAULT_TICK_LABEL_INTERPRETER = 'latex';
        
        % Text data
        DEFAULT_COMPONENT_TITLES = {};
        DEFAULT_COMPONENT_LABELS = {};   
        DEFAULT_COMPONENT_LEGEND_LABELS = {}; 
        
        DEFAULT_LEGEND_OPTIONS = {};
        DEFAULT_USER_AXES_ARGS = {};
        DEFAULT_USER_PLOT_ARGS = {};
        DEFAULT_USER_PLOT_FLOW_ARGS = {};
        DEFAULT_USER_PLOT_JUMP_ARGS = {};
        DEFAULT_USER_PLOT_JUMP_START_ARGS = {};
        DEFAULT_USER_PLOT_JUMP_LINE_ARGS = {};
        DEFAULT_USER_PLOT_JUMP_END_ARGS = {};
        
        % Flows
        DEFAULT_FLOW_COLOR = 'blue';
        DEFAULT_FLOW_LINE_WIDTH = 0.5;
        DEFAULT_FLOW_LINE_STYLE = '-'
        DEFAULT_FLOW_MARKER = 'none'
        DEFAULT_FLOW_MARKER_SIZE = 6
        
        % Jumps
        DEFAULT_JUMP_COLOR = 'red';
        DEFAULT_JUMP_LINE_WIDTH = 0.5;
        DEFAULT_JUMP_LINE_STYLE = '--';
        DEFAULT_JUMP_START_MARKER = '.';
        DEFAULT_JUMP_START_MARKER_SIZE = 6;
        DEFAULT_JUMP_END_MARKER = '*';
        DEFAULT_JUMP_END_MARKER_SIZE = 6;
        
        % Axis Labels
        DEFAULT_X_LABEL_FORMAT = [];
        DEFAULT_T_LABEL = []; 
        DEFAULT_J_LABEL = [];

        % PLOTTING FUNCTIONS
        DEFAULT_PLOT_FUNCTION_2D = @plot;
        DEFAULT_PLOT_FUNCTION_3D = @plot3;
        
        % Subplot Settings
        DEFAULT_AUTO_SUBPLOTS = false;
        DEFAULT_PLOTS_CALLBACK = @(ax, component) disp('');
        DEFAULT_MAX_SUBPLOTS = 4;
        
        % Slice and Filter
        DEFAULT_TIMESTEPS_FILTER = [];
        DEFAULT_COMPONENT_INDICES = [];
        
        % Scaling
        DEFAULT_TEXT_SCALE = 1.0;
        DEFAULT_LINE_SCALE = 1.0;
        DEFAULT_MARKER_SCALE = 1.0;

        % The default colors used by MATLAB plot functions.
        % Used for the flow colors when flow_color is set to 'matlab'.
        MATLAB_DEFAULT_PLOT_COLORS = {
            [0 0.447 0.741]; % blue
            [0.85 0.325 0.098]; % red
            [0.929 0.694 0.125]; % yellow
            [0.494 0.184 0.556]; % purple
            [0.466 0.674 0.188]; % green
            [0.301 0.745 0.933]; % light blue
            [0.635 0.078 0.184]}; % burgundy
        % Darkened varients of the default colors used by MATLAB plot functions.
        % Used for the jump colors when jump_color is set to 'matlab'.
        MATLAB_DEFAULT_PLOT_COLORS_DARKENED = {
            0.8*[0 0.447 0.741]; % blue
            0.8*[0.85 0.325 0.098]; % red
            0.8*[0.929 0.694 0.125]; % yellow
            0.6*[0.494 0.184 0.556]; % purple
            0.8*[0.466 0.674 0.188]; % green
            0.6*[0.301 0.745 0.933]; % light blue
            0.6*[0.635 0.078 0.184]}; % burgundy
    end
    
    methods
        function obj = PlotSettings()
           obj.reset(); % Make all the values equal to the defaults;
        end
        
        function set(this, varargin)
            % Set the value of properties using name/value pairs.
            % The name of each property is case insensitive and underscores can
            % be replaced with spaces.
            if mod(length(varargin), 2) ~= 0
                error('Hybrid:MissingValue', ...
                    'Must have an even number of Name/Value arguments') 
            end
            for k = 1:2:length(varargin)
               property_name = varargin{k};
               if ~isa(property_name, 'string') && ~ischar(property_name)
                   error('Hybrid:NameNotString', ...
                       'Expected a string for the name, but instead was %s', ...
                       class(property_name));
               end
               value = varargin{k+1};
               property_name = sanitize_property_name(property_name);
               this.(property_name) = value;
            end
        end
        
        function value = get(this, property_name)
            property_name = sanitize_property_name(property_name); 
            value = this.(property_name);
        end

        function reset(this)
            % Reset to default values.
            names = hybrid.PlotSettings.getSettingNames();
            for name = names
                default_name = strcat('DEFAULT_', upper(name));
                this.(name{1}) = this.(default_name{1});
            end
        end
    end    

    methods(Access = {?HybridPlotBuilder,?hybrid.tests.PlotSettingsTest,?hybrid.internal.PlotData}) % Arguments generation
        function val = flowArguments(this)
            if iscell(this.flow_color)
                color = this.flow_color{1};
                % We pick the shift dimension based on the dimension that is the
                % longest. 
                [~, shift_dim] = max(size(this.flow_color)); 
                this.flow_color = circshift(this.flow_color, -1, shift_dim);
            else
                color = this.flow_color;
            end
            val = {'Color', color, ...
                    'LineStyle', this.flow_line_style, ...
                    'LineWidth', this.flow_line_width, ...
                    'MarkerEdgeColor', color, ...
                    'Marker', this.flow_marker, ...
                    'MarkerSize', this.flow_marker_size, ...
                    this.user_plot_args{:}, ...
                    this.user_plot_flow_args{:}};
        end
    
        function args = jumpArguments(this)
            if iscell(this.jump_color)
                color = this.jump_color{1};
                % We pick the shift dimension based on the dimension that is the
                % longest. 
                [~, shift_dim] = max(size(this.jump_color)); 
                this.jump_color = circshift(this.jump_color, -1, shift_dim);
            else
                color = this.jump_color;
            end
            % JUMP LINE ARGUMENTS (Cell array)
            args.line = {'Color', color, ...
                    'LineStyle', this.jump_line_style, ...
                    'LineWidth', this.jump_line_width, ...
                    this.user_plot_args{:}, ...
                    this.user_plot_jump_args{:}, ...
                    this.user_plot_jump_line_args{:}}; %#ok<CCAT> Cell-array concatentation is OK.
            % JUMP START ARGUMENTS (Cell array)
            args.start = {'MarkerEdgeColor', color, ...
                    'Marker', this.jump_start_marker, ...
                    'MarkerSize', this.jump_start_marker_size, ...
                    this.user_plot_args{:}, ...
                    this.user_plot_jump_args{:}, ...
                    this.user_plot_jump_start_args{:}}; %#ok<CCAT> Cell-array concatentation is OK.
            % JUMP END ARGUMENTS (Cell array)
            args.end = {'MarkerEdgeColor', color, ...
                    'Marker', this.jump_end_marker, ...
                    'MarkerSize', this.jump_end_marker_size, ...
                    this.user_plot_args{:}, ...
                    this.user_plot_jump_args{:}, ...
                    this.user_plot_jump_end_args{:}}; %#ok<CCAT> Cell-array concatentation is OK.
        end

        function val = labelArguments(this)
            val = {'interpreter', this.label_interpreter, ...
                   'FontSize', this.label_size};
        end 
    
        function val = titleArguments(this)
            val = {'interpreter', this.title_interpreter, ...
                    'FontSize', this.title_size};
        end 
        
        function val = legendArguments(this)
            val = {'Interpreter', this.label_interpreter, ...
                   'FontSize', this.label_size};
           val = [val, this.legend_options];
        end 
        
        function val = tickLabelArguments(this)
            val = {'TickLabelInterpreter', this.tick_label_interpreter, ...
                   'TickLabelFontSize', this.tick_label_size};
        end 
        
    end
    
    methods % Setters
        function set.title_interpreter(this, interpreter)
            % Set the text interpreter used in titles. 
            check_interpreter(interpreter)
            this.title_interpreter = char(interpreter);
        end 
        
        function set.label_interpreter(this, interpreter)
            % Set the text interpreter used in labels and legend entries. 
            check_interpreter(interpreter);
            this.label_interpreter = char(interpreter);
        end
        
        function set.tick_label_interpreter(this, interpreter)
            % Set the text interpreter used in labels and legend entries. 
            check_interpreter(interpreter);
            this.tick_label_interpreter = char(interpreter);
        end
        
        function set.flow_color(this, color)
            if strcmpi(color, 'matlab')
                color = this.MATLAB_DEFAULT_PLOT_COLORS;
            else
                color = parseColorArgument(color);
            end
            this.flow_color = color;
        end
        
        function set.flow_line_style(this, style)
            style = convert_empty_arg_to_none_string(style);
            assert_ischar_or_isstring(style)
            this.flow_line_style = char(style);
        end
        
        function set.flow_line_width(this, width)
            assert(isnumeric(width), 'Line width must be numeric')
            assert(width > 0, 'Line width must be positive')
            this.flow_line_width = width;
        end
        
        function set.flow_marker(this, marker)
            marker = convert_empty_arg_to_none_string(marker);
            assert_ischar_or_isstring(marker);
            this.flow_marker = char(marker);
        end
        
        function set.flow_marker_size(this, size)
            assert(isnumeric(size), 'Marker size must be numeric')
            assert(size > 0, 'Marker size must be positive')
            this.flow_marker_size = size;
        end
        
        function set.jump_color(this, color)
            if strcmpi(color, 'matlab')
                color = this.MATLAB_DEFAULT_PLOT_COLORS_DARKENED;
            else
                color = parseColorArgument(color);
            end
            this.jump_color = color;
        end
        
        function set.jump_line_style(this, style)
            style = convert_empty_arg_to_none_string(style);
            assert_ischar_or_isstring(style);
            this.jump_line_style = char(style);
        end
        
        function set.jump_line_width(this, width)
            assert(isnumeric(width), 'Line width must be numeric')
            assert(width > 0, 'Line width must be positive')
            this.jump_line_width = width;
        end
        
        function set.jump_start_marker(this, marker)
            marker = convert_empty_arg_to_none_string(marker);
            assert_ischar_or_isstring(marker);
            this.jump_start_marker = char(marker);
        end
        
        function set.jump_end_marker(this, marker)
            marker = convert_empty_arg_to_none_string(marker);
            assert_ischar_or_isstring(marker);
            this.jump_end_marker = char(marker);
        end
        
        function set.jump_start_marker_size(this, size)
            assert(isnumeric(size), 'Marker size must be numeric')
            assert(size > 0, 'Marker size must be positive')
            this.jump_start_marker_size = size;
        end
        
        function set.jump_end_marker_size(this, size)
            assert(isnumeric(size), 'Marker size must be numeric')
            assert(size > 0, 'Marker size must be positive')
            this.jump_end_marker_size = size;
        end
        
        function set.x_label_format(this, fmt)
            this.x_label_format = char_or_empty(fmt);
        end
        
        function set.t_label(this, fmt)
            this.t_label = char_or_empty(fmt);
        end
        
        function set.j_label(this, fmt)
            this.j_label = char_or_empty(fmt);
        end        
        
        function set.component_titles(this, titles)
           this.component_titles = cellstr(titles); 
        end   
        
        function set.component_labels(this, labels)
           this.component_labels = cellstr(labels); 
        end   
        
        function set.component_legend_labels(this, labels)
           this.component_legend_labels = cellstr(labels); 
        end
        
        function set.component_indices(this, component_indices)
            assert(isempty(component_indices) || isvector(component_indices))
            if size(component_indices, 1) > 1
                % We need component_indices to be a row vector so that when
                % we use it to create a for-loop (i.e., 'for
                % i=component_indices'), every entry is used for 
                % one iteration each. If component_indices is a column
                % vector, instead, then the entire column is used as the
                % value of 'i' for only a single iteration.
                component_indices = component_indices';
            end
            this.component_indices = component_indices;
        end
                
        function set.auto_subplots(this, auto_subplots)
            this.auto_subplots = parse_logical_arg(auto_subplots);
        end

        function set.plot_function_2D(this, plot_function_2D)
            if isa(plot_function_2D, 'function_handle')
                this.plot_function_2D = plot_function_2D;
            else
                this.plot_function_2D = str2func(plot_function_2D);
            end
        end

        function set.plot_function_3D(this, plot_function_3D)
            if isa(plot_function_3D, 'function_handle')
                this.plot_function_3D = plot_function_3D;
            else
                this.plot_function_3D = str2func(plot_function_3D);
            end
        end
    end
    
    methods % Getters
        function val = get.label_size(this)
           val = this.text_scale*this.label_size;
        end
        
        function val = get.title_size(this)
           val = this.text_scale*this.title_size;
        end
        
        function val = get.tick_label_size(this)
           val = this.text_scale*this.tick_label_size;
        end
        
        function val = get.flow_line_width(this)
           val = this.line_scale*this.flow_line_width;
        end
        
        function val = get.jump_line_width(this)
           val = this.line_scale*this.jump_line_width;
        end
        
        function val = get.jump_start_marker_size(this)
           val = this.marker_scale*this.jump_start_marker_size;
        end
        
        function val = get.jump_end_marker_size(this)
            val = this.marker_scale*this.jump_end_marker_size;
        end
    end
    
    methods 
        function value = getTLabel(this)
            % t_label is cast to char on creation if it is a string.
            if ischar(this.t_label) 
                value = this.t_label;
                return
            end
            
            % Otherwise, use defaults, given here.
            if strcmp(this.label_interpreter, 'none')
                value = 't'; % No formatting
            elseif strcmp(this.label_interpreter, 'tex')
                value = 't';
            elseif strcmp(this.label_interpreter, 'latex')
                value = '$t$';
            else
                error('text interpreter ''%s'' unrecognized',... 
                            this.label_interpreter);
            end
        end
        
        function value = getJLabel(this)
            if ischar(this.j_label)
                value = this.j_label;
                return
            end
            
            % Otherwise, use defaults, given here.
            if strcmp(this.label_interpreter, 'none')
                value = 'j'; % No formatting
            elseif strcmp(this.label_interpreter, 'tex')
                value = 'j';
            elseif strcmp(this.label_interpreter, 'latex')
                value = '$j$';
            else
                error('text interpreter ''%s'' unrecognized',... 
                            this.label_interpreter);
            end
        end
        
        function fmt = getXLabelFormat(this)
            if ~isempty(this.x_label_format)
                fmt = this.x_label_format;
                return
            end
            
            % Otherwise, use defaults, given here.
            if strcmp(this.label_interpreter, 'none')
                fmt = 'x(%d)'; % No formatting
            elseif strcmp(this.label_interpreter, 'tex')
                fmt = 'x_{%d}';
            elseif strcmp(this.label_interpreter, 'latex')
                fmt = '$x_{%d}$';
            else
                error('text interpreter ''%s'' unrecognized',...
                    this.label_interpreter);
            end
        end 
        
        function title = getTitle(this, title_id)
            if isempty(this.component_titles)
                % If there are no titles set, then the title returned is empty.
                title = [];
                return
            end

            if strcmp('single', title_id)
                title = this.component_titles(1);
            elseif title_id <= length(this.component_titles)
                title = this.component_titles(title_id);
            else
                % No title if there are not enough titles given.
                title = '';
            end            
        end
        
        function label = labelFromId(this, label_id)
            % Get the axis label based on the 'label_id'. The output for each
            % choice of 'label_id' is as follows:
            %
            %      't' -> continuous time 't' label
            %      'j' -> discrete time 'j' label
            %      []  -> empty (for axes that don't exist)
            % 'single' -> the first state component label (if it was given
            %             explicitly).
            %  integer -> the corresponding state component label (if given),
            %             otherwise a label is generated automatically based on 
            %             the XLabelFormat.

            if strcmp('t', label_id)
                label = this.getTLabel();
                return
            elseif strcmp('j', label_id)
                label = this.getJLabel();
                return
            end 

            if isempty(label_id)
                % 'label_id' is empty for axes that don't exist (such as the
                % nonexistent z-axis in a x-y plot).
                label = [];
                return
            end
            
            if strcmp('single', label_id)
                if isempty(this.component_labels)
                    % When using the 'single' label, we don't use the x label
                    % format to generate a label if one is not given explicitly.
                    label = [];
                else
                    label = this.component_labels{1};
                end
                return;
            end

            if label_id <= length(this.component_labels)
                label = this.component_labels{label_id};  
            else
                fmt = this.getXLabelFormat();
                label = sprintf(fmt, label_id);
            end
        end
 
        function [xlabel, ylabel, zlabel] = generateLabels(this, axis_ids)
            % Create axis labels given axis_ids in one of the following forms
            % {'t', int}, {'j', int}, {'t', 'j', int}, {int, int}, {int, int, int}.
            x_axis_id = axis_ids{1};
            y_axis_id = axis_ids{2};
            if numel(axis_ids) == 3
                z_axis_id = axis_ids{3};
            else
                z_axis_id = [];
            end

            xlabel = this.labelFromId(x_axis_id);
            ylabel = this.labelFromId(y_axis_id);
            zlabel = this.labelFromId(z_axis_id);

            if ~this.auto_subplots
                is_x_a_time_axis = any(strcmp(x_axis_id, {'t', 'j'}));
                is_y_a_time_axis = strcmp(y_axis_id, 'j');
                first_nontime_axis = 1 + is_x_a_time_axis + is_y_a_time_axis;
                switch first_nontime_axis
                    case 1
                        % If the first nontime axis is 1, then the plot is a 2D
                        % or 3D phase plot, so the component labels should be
                        % used.
                        return
                    case 2
                        ylabel = this.labelFromId('single');
                    case 3
                        zlabel = this.labelFromId('single');
                end
            end
        end
    end 
    
    methods % Candidates to move to a 'PlotData' class
        function label = createLegendLabel(this, index)
            if isempty(this.component_legend_labels)
                label = [];
                return
            end

            if strcmp('single', index)
                label = this.component_legend_labels(1);
            elseif index <= length(this.component_legend_labels)
                label = this.component_legend_labels(index);  
            else
                label = [];
            end
        end
        
        function indices_to_plot = indicesToPlot(this, n)
            if isempty(this.component_indices)
                if this.auto_subplots
                    last_index = min(n, this.max_subplots);
                else
                    last_index = n;
                end
                indices_to_plot = (1:last_index)';
            else
                indices_to_plot = this.component_indices';
            end
            assert(~isempty(indices_to_plot), 'There must be at least one index to plot')
            assert(min(indices_to_plot) >= 1)
            assert(max(indices_to_plot) <= n, ...
                'max(indices_to_plot)=%d is greater than n=%d', ...
                max(indices_to_plot), n)
            assert(size(indices_to_plot, 2) == 1)
        end
        
    end
    
    methods(Hidden, Static)
        function names = getSettingNames()
            % Get a list of all the setting names as a string array.
            mc = ?hybrid.PlotSettings;
            props = findobj(mc.PropertyList,'Constant',false);
            names = {props.Name};
        end
    end
end

function name = sanitize_property_name(name)
% Cleanup the name given by the user as an argument. 
% 1. Convert to lower case.
% 2. Trim whitespace from beginning and end.
% 3. Replace spaces with underscores. 
% 
% Example:
% 'Title Size ' -> 'title_size'
name = lower(name);
name = strtrim(name);

% Replace underscores with spaces.
name = safe_replace(name, ' ', '_');
name = char(name);
end

function arg = parse_logical_arg(arg)
if islogical(arg)
    assert(isscalar(arg), 'Hybrid:InvalidArgument', ...
        'Argument must be a scalar')
    return
elseif isnumeric(arg)
    assert(isscalar(arg), 'Hybrid:InvalidArgument', ...
        'Argument must be a scalar')
    assert(arg == 0 || arg == 1, 'Hybrid:InvalidArgument', ...
        'Numeric value must be 0 or 1.');
    arg = logical(arg);
elseif strcmp('on', arg)
    arg = true;
elseif strcmp('off', arg)
    arg = false;
else
    error('Hybrid:InvalidArgument', 'String value must be ''on'' or ''off''')
end
end

function s = convert_empty_arg_to_none_string(s)
if isempty(s) || strcmp(s, '')
    s = 'none';
end
end

function check_interpreter(interpreter)
INTERPRETERS = {'none', 'tex', 'latex'};
if ~ismember(interpreter, INTERPRETERS) % works for both strings and char arrays.
    e = MException('Hybrid:InvalidInterpreter', ...
        '''%s'' is not a valid interpreter. Use one of these values: ''none'' | ''tex'' | ''latex''.', ...
        interpreter);
    throwAsCaller(e)
end        
end

function color = parseColorArgument(color)
    if iscell(color) && ~isempty(color)
        
        for i = 1:length(color)
            if iscell(color{i}) && ~isempty(color{i})
               e = MException('Hybrid:InvalidColor', 'Color argument cannot have nested cell arrays.');
               throwAsCaller(e);
            end
            color{i} = parseColorArgument(color{i});
        end
    else
        color = convert_empty_arg_to_none_string(color);
        color = checkColorArg(color);
    end
end

function color = checkColorArg(color)
    if isa(color, 'string')
        color = char(color);
    end
    if verLessThan('matlab', '9.9')
        % The validatecolor function was added in R2020b (v9.9), so we
        % first check the version to make sure we can call it.
        return
    end
    if strcmp(color, 'none')
       % the validatecolor function fails if color='none', but, for our
       % purposes, 'none' is acceptable .
       return 
    end
    try
        validatecolor(color);
    catch e_caught
        % Check that the exception is caused by validatecolor throwing an error,
        % not because of some other reason, such as validatecolor not
        % existing in older versions of MATLAB.
        if startsWith(e_caught.identifier, 'MATLAB:graphics:validatecolor')
            msg = {'Invalid color argument. Colors can be given as a: '
                   'char (''r'', ''g'', ...),'
                   'string ("red", "green", ...), '
                   'RGB triplet ([1, 0, 0], [0, 1, 0], ...), or '
                   'hexidecimal code (''#FF0000'', ''#00FF00'', ...).'};
            e = MException('Hybrid:InvalidColor', '%s\n\t', msg{:});
            e = addCause(e, e_caught);
            throwAsCaller(e)
        end
    end
end

function s = char_or_empty(s)
    if isempty(s) && ~ischar(s)
        s = [];
    else
        assert_ischar_or_isstring(s);
        s = char(s);
    end
end

function assert_ischar_or_isstring(s)
if ~ischar(s) && ~isa(s, 'string')
   e = MException('Hybrid:InvalidArgument', ...
       'Argument must be a char array or (on Matlab 2016b or later) a string. Instead is was a %s.',...
       class(s));
   throwAsCaller(e);
end
end

function str = safe_replace(str, old_char, new_char)
try
    str = replace(str, old_char, new_char);
catch
    % The replace function is not defined prior to 2016b, when strings were
    % introduced. Thus, we compute the replacement manually.
    assert(ischar(str), 'Expected char array, instead was ', class(str))
    assert(length(old_char) == 1, 'Only one char can be replaced')
    assert(length(new_char) == 1, 'Only one char can be replaced')
    is_old_char = str == old_char;
    str(is_old_char) = new_char;
end
end