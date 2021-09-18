function [strings, options] = parseStringVararginWithOptionalOptions(varargin)
if isempty(varargin)
    % Clear legend labels.
    strings_cell = {};
    options = {};
elseif iscell(varargin{1})
    strings_cell = varargin{1};
    varargin(1) = []; % delete first entry.
    options = varargin;
    if nargout < 2 && ~isempty(options)
        e = MException("Hybrid:UnexpectedOptions", "This function does not support option arguments.");
        throwAsCaller(e);
    end
else
    % No options
    strings_cell = varargin;
    options = {};
end

% Sanitize strings
for i = 1:length(strings_cell)
    % Convert empty entries to empty strings.
    if isempty(strings_cell{i})
        strings_cell{i} = ""; %#ok<AGROW>
    else
        strings_cell{i} = string(strings_cell{i}); %#ok<AGROW>
    end
end

% Convert to string array
strings = string(strings_cell);
end