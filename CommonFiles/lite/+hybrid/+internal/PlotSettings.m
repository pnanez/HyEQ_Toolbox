classdef PlotSettings < matlab.mixin.Copyable
    
    properties
        % Text
        label_size
        title_size
        label_interpreter
        title_interpreter
        
        % Text data
        component_titles
        component_labels
        component_legend_labels
        
        % Name-value pair options.
        legend_options
        
        % Flows
        flow_color
        flow_line_width
        flow_line_style
        
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
        DEFAULT_LABEL_INTERPRETER = 'latex';
        DEFAULT_TITLE_INTERPRETER = 'latex';
        
        % Text data
        DEFAULT_COMPONENT_TITLES = {};
        DEFAULT_COMPONENT_LABELS = {};   
        DEFAULT_COMPONENT_LEGEND_LABELS = {}; 
        
        DEFAULT_LEGEND_OPTIONS = {};
        
        % Flows
        DEFAULT_FLOW_COLOR = 'blue';
        DEFAULT_FLOW_LINE_WIDTH = 0.5;
        DEFAULT_FLOW_LINE_STYLE = '-'
        
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
        
        % Subplot Settings
        DEFAULT_AUTO_SUBPLOTS = true;
        DEFAULT_PLOTS_CALLBACK = @(component) disp('');
        DEFAULT_MAX_SUBPLOTS = 4;
        
        % Slice and Filter
        DEFAULT_TIMESTEPS_FILTER = [];
        DEFAULT_COMPONENT_INDICES = [];
        
        % Scaling
        DEFAULT_TEXT_SCALE = 1.0;
        DEFAULT_LINE_SCALE = 1.0;
        DEFAULT_MARKER_SCALE = 1.0;
    end
    
    methods
        function obj = PlotSettings()
           obj.reset(); % Make all the values equal to the defaults;
        end
        
        function set(this, varargin)
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
        
%         function reset(this)
%             % Text
%             this.label_size = this.DEFAULT_LABEL_SIZE;
%             this.title_size = this.DEFAULT_TITLE_SIZE;
%             this.label_interpreter = this.DEFAULT_LABEL_INTERPRETER;
%             this.title_interpreter = this.DEFAULT_TITLE_INTERPRETER;
%             
%             % Flows
%             this.flow_color = this.DEFAULT_FLOW_COLOR;
%             this.flow_line_width = this.DEFAULT_FLOW_LINE_WIDTH;
%             this.flow_line_style = this.DEFAULT_FLOW_LINE_STYLE;
%             
%             % Jumps
%             this.jump_color = this.DEFAULT_JUMP_COLOR;
%             this.jump_line_width = this.DEFAULT_JUMP_LINE_WIDTH;
%             this.jump_line_style = this.DEFAULT_JUMP_LINE_STYLE;
%             this.jump_start_marker = this.DEFAULT_JUMP_START_MARKER;
%             this.jump_start_marker_size = this.DEFAULT_JUMP_START_MARKER_SIZE;
%             this.jump_end_marker = this.DEFAULT_JUMP_END_MARKER;
%             this.jump_end_marker_size = this.DEFAULT_JUMP_END_MARKER_SIZE;            
%             
%             % Axis Labels
%             this.t_label = this.DEFAULT_T_LABEL;
%             this.j_label = this.DEFAULT_J_LABEL;
%             this.x_label_format = this.DEFAULT_X_LABEL_FORMAT;
%             
%             % Scaling of text, lines widths, and marker sizes.
%             this.text_scale = this.DEFAULT_TEXT_SCALE;
%             this.line_scale = this.DEFAULT_LINE_SCALE;
%             this.marker_scale = this.DEFAULT_MARKER_SCALE;            
%         end

        function reset(this)
            names = hybrid.internal.PlotSettings.getSettingNames();
            for name = names
                default_name = strcat('DEFAULT_', upper(name));
                this.(name{1}) = this.(default_name{1});
            end
        end
    end    

    %%% The following function provides an alternative way to reset defaults
    %%% that requires less code, but relies on metaclass.
    % function resetFromPropertyDefaults(this)
    %    mc = ?hybrid.internal.PlotSettings;
    %    props = findobj(mc.PropertyList,'Constant',false);
    %    for i_prop = 1:length(props)
    %        p = props(i_prop);
    %        this.(p.Name) = p.DefaultValue ;
    %    end
    % end
    
    methods % Arguments generation
        function val = flowArguments(this)
            val = {'Color', this.flow_color, ...
                    'LineStyle', this.flow_line_style, ...
                    'LineWidth', this.flow_line_width};
        end
    
        function val = jumpLineArguments(this)
            val = {'Color', this.jump_color, ...
                    'LineStyle', this.jump_line_style, ...
                    'LineWidth', this.jump_line_width};
        end
    
        function val = jumpStartArguments(this)
            val = {'MarkerEdgeColor', this.jump_color, ...
                    'Marker', this.jump_start_marker, ...
                    'MarkerSize', this.jump_start_marker_size};
        end
    
        function val = jumpEndArguments(this)
            val = {'MarkerEdgeColor', this.jump_color, ...
                    'Marker', this.jump_end_marker, ...
                    'MarkerSize', this.jump_end_marker_size};
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
        
        function set.flow_color(this, color)
            color = convert_empty_arg_to_none_string(color);
            this.flow_color = checkColorArg(color);
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
        
        function set.jump_color(this, color)
            color = convert_empty_arg_to_none_string(color);
            this.jump_color = checkColorArg(color);
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
    end
    
    methods % Getters
        function val = get.label_size(this)
           val = this.text_scale*this.label_size;
        end
        
        function val = get.title_size(this)
           val = this.text_scale*this.title_size;
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
            if ~isempty(this.t_label)
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
            if ~isempty(this.j_label)
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
            if strcmp('single', title_id)
                if isempty(this.component_titles)
                    title = [];
                else
                    title = this.component_titles(1);
                end
            elseif title_id <= length(this.component_titles)
                title = this.component_titles(title_id);
            else
                % No title
                title = '';
                return
            end            
        end
        
        function label = labelFromId(this, label_id)
            if strcmp('t', label_id)
                label = this.getTLabel();
                return
            elseif strcmp('j', label_id)
                label = this.getJLabel();
                return
            elseif strcmp('single', label_id)
                if isempty(this.component_labels)
                    label = [];
                else
                    label = this.component_labels(1);
                end
                return;
            end

            if label_id <= length(this.component_labels)
                label = this.component_labels(label_id);  
            else
                fmt = this.getXLabelFormat();
                label = sprintf(fmt, label_id);
            end
        end
    end 
    
    methods % Candidates to move to a 'PlotData' class
        function label = createLegendLabel(this, index)
            if strcmp('single', index) || index == -1
                if isempty(this.component_legend_labels)
                    label = [];
                else
                    label = this.component_legend_labels(1);
                end
                return
            end

            if index <= length(this.component_legend_labels)
                label = this.component_legend_labels(index);  
            else
                % warning('No label given for plot')
                label = [];
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
            mc = ?hybrid.internal.PlotSettings;
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
    assert(isscalar(arg), 'Argument must be a scalar')
    return
elseif isnumeric(arg)
    assert(isscalar(arg), 'Argument must be a scalar')
    assert(arg == 0 || arg == 1, 'Numeric value must be 0 or 1.');
    arg = logical(arg);
elseif strcmp('on', arg)
    arg = true;
elseif strcmp('off', arg)
    arg = false;
else
    error('String value must be ''on'' or ''off''')
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
       % the validatecolor function fails if color='none', but none is
       % acceptable for our purposes.
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
    if isempty(s)
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