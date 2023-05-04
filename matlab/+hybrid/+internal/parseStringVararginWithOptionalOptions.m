function [char_cell, options] = parseStringVararginWithOptionalOptions(varargin)
% Inputs can be given in two forms: 
%   Form 1: no arguments. The output are two empty cell arrays.
%   Form 2: Two or more arguments. 
%       * varargin{1}: a cell array of char arrays or string. 
%       * varargin{2:end}: A list of zero or more name-value pairs, with the first item in
%       each pair either a string or char array.
%       The output are:
%       * char_cell: Cell array from varargin{1} with all strings converted to char arrays.
%       * options: Cell array containing name-value pairs with all strings converted to char arrays.

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

% Sanitize strings for first argument
for i = 1:length(strings_cell)
    % Convert empty entries to empty strings.
    if isempty(strings_cell{i})
        strings_cell{i} = ''; %#ok<AGROW>
    end
end
% Convert to string array
char_cell = cellstr(strings_cell);

% Sanitize strings for name-value pairs
for i = 1:2:length(options)
    % Convert strings names in options to char arrays
    options{i} = char(options{i}); %#ok<AGROW>

    % Convert strings in values to chararrays.
    if isa(options{i+1}, 'string')
        options{i+1} = char(options{i+1}); %#ok<AGROW>
    end
end
end