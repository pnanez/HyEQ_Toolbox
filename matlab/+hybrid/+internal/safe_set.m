function safe_set(ID, object, varargin) 
% safe_set: Set one or more properties on "object", if possible. 
% If running set(object, key, value) would fail, the error is caught and
% the remainder of the key-value property pairs are set, and a warning is 
% displayed.
% 
% Example:
%   safe_set(lgd, 'FontSize', [10], 'NumColumns, 3)
    assert(ischar(ID), 'ID must be a character array')

    for i = 1:2:numel(varargin)
        key = varargin{i};
        value = varargin{i+1};

        try
            set(object, key, value)
            % fprintf('Set "%s" to "%s"\n', key, string(value))
        catch e
            warning([ID, ':MissingProperty'], ...
                    ['Failed to set "%s" to "%s" for %s because of %s: %s\n', ...
                     'This may caused by using a MATLAB version prior to the property "%s" was added.\n',...
                     'To disable this warning, click <a href="matlab:warning(''off'', ''HybridPlotBuilder:MissingProperty'')">here</a>.\n', ...
                     'To renable the warning, run warning(''on'', ''HybridPlotBuilder:MissingProperty'')'], ...
                     key, string(value), ID, e.identifier, e.message, key)
        end
    end

end