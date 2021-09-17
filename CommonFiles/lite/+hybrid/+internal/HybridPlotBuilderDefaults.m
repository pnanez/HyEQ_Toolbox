classdef HybridPlotBuilderDefaults < handle
    
    properties(SetAccess = private)
        % Set the text sizes and line widths explicitly.
        label_size = 10;
        title_size = 11;
        flow_line_width = 0.5;
        jump_line_width = 0.5;
        
        % Configure scaling of text, lines widths, and marker sizes.
        text_scale = 1.0;
        line_scale = 1.0;
        marker_scale = 1.0;
        
        % Other Defaults
        label_interpreter = "latex"
        title_interpreter = "latex"
    end
    
    properties(Constant)
        DEFAULT_LABEL_SIZE = 11;
        DEFAULT_TITLE_SIZE = 10;
        DEFAULT_LABEL_INTERPRETER = "latex";
        DEFAULT_TITLE_INTERPRETER = "latex";
        DEFAULT_FLOW_LINE_WIDTH = 0.5;
        DEFAULT_JUMP_LINE_WIDTH = 0.5;
    end
    
    methods
        function set(this, key, value)
            key = lower(key);
            key = strtrim(key);
            if     strcmp("label size", key)
                this.label_size = value;
            elseif strcmp("title size", key)
                this.title_size = value;
            elseif strcmp("label interpreter", key)
                this.label_interpreter = value;
            elseif strcmp("title interpreter", key)
                this.title_interpreter =  value;
            elseif strcmp("flow line width", key)
                this.flow_line_width = value;
            elseif strcmp("jump line width", key)
                this.jump_line_width = value;
            elseif strcmp("line scale", key)
                this.line_scale = value;
            elseif strcmp("text scale", key)
                this.text_scale = value;
            elseif strcmp("marker scale", key)
                this.marker_scale = value;
            else
                e = MException("HybridPlotBuilderDefaults:UnknownKey", ...
                        "Key=%s not recognized", key);
                throwAsCaller(e);
            end
        end
        
        function reset(this)
            this.label_size = this.DEFAULT_LABEL_SIZE;
            this.title_size = this.DEFAULT_TITLE_SIZE;
            this.label_interpreter = this.DEFAULT_LABEL_INTERPRETER;
            this.title_interpreter = this.DEFAULT_TITLE_INTERPRETER;
            this.flow_line_width = this.DEFAULT_FLOW_LINE_WIDTH;
            this.jump_line_width = this.DEFAULT_JUMP_LINE_WIDTH;
            this.text_scale = 1.0;
            this.line_scale = 1.0;
            this.marker_scale = 1.0;
        end
    end
end