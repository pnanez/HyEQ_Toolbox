function deprecationWarning(function_name, replacement)
% function_name: a string containing the name of the class (if applicable) and
% the name of the function, separated by a period. For example,
% "HyrbidPlotBuilder.select".
% 
% replacement: a string containing the name of the replacement function that
% users should switch to using.

% Replace "." in function_name with underscores, so that it is a valid warning ID.
function_name_with_underscores = replace(function_name, '.', '_');
warning_id = ['Hybrid:Deprecated:', function_name_with_underscores];
deactivate_warning_cmd = sprintf('warning(''off'',''%s'')', warning_id);
warning_msg = sprintf(['The function %s is deprecated. Use %s instead.\n' ...
    '(To disable this warning, run <a href="matlab:%s">%s</a>.)'], ...
    function_name, replacement, deactivate_warning_cmd, deactivate_warning_cmd);
warning(warning_id, warning_msg); %#ok<SPWRN> 

end