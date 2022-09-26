function [char_cell, options] = parseStringVararginWithOptionalOptions(varargin)
if isempty(varargin)
    % No strings or options
    strings_cell = {};
    options = {};
elseif iscell(varargin{1}) 
    % Cell array followed by name/value options
    strings_cell = varargin{1};
    varargin(1) = []; % delete first entry.
    options = varargin;
    if nargout < 2 && ~isempty(options)
        e = MException('Hybrid:UnexpectedOptions', ...
                        'This function does not support option arguments.');
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
        strings_cell{i} = ''; %#ok<AGROW>
    end
end
for i = 1:2:length(options)
    % Convert names in options to char arrays
    options{i} = char(options{i}); %#ok<AGROW>
    if isa(options{i+1}, 'string')
        options{i+1} = char(options{i+1}); %#ok<AGROW>
    end
end

% Convert to string array
char_cell = cellstr(strings_cell);
end