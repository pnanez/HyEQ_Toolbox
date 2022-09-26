function selectSimulinkModelCallbackScript(callback_name, callback_description)
% Prompt the user so set a callback for the currently active Simulink model. 
% 'callback_name': the name of callback as shown in Model Properties > Callbacks
% 'callback_description': A short user-friendly description of the callback.

% Check that the current system does not already have the given callback.
% If it does, then prompt user to replace it.
current_callback = get_param(gcs, callback_name);

MAX_N_CHARS = 600; % Truncate long scripts to this length.
if numel(current_callback) >= MAX_N_CHARS
    current_callback = sprintf('%s ... <remainder omitted>', current_callback(1:MAX_N_CHARS));
end

if ~isempty(current_callback)
    promptMessage = sprintf(['This model already has a %s callback (''%s'').\n', ...
        '\n%s\n\n', ... 
        'Do you want to replace it?'], callback_description, callback_name, current_callback);
    button = questdlg(promptMessage, ...
                    sprintf('Replace %s callback?', callback_description), ... % Title
                    'Keep', ...      % Button 2
                    'Replace', ... % Button 1
                    'Replace');    % Default button
    if ~strcmpi(button, 'Replace')
        return
    end
end

% Open a file selection prompt for the user to select a MATLAB script.
[file_name, script_path] = uigetfile('*.m',sprintf('Select the %s script.', callback_description));
% file_name = 'configure_development_path.m';
% script_path = 'C:\Users\pwintz\code\hybrid-toolbox-fork-temp\';

% Check that if the file selection was canceled.
if isscalar(file_name) && file_name == 0
    warning('No %s script was selected.', callback_description)
    return
end

% Strip off '.m' file extension from file_name.
if isequal(file_name(end-1:end), '.m')
    script_name = file_name(1:end-2);
else 
    error('The selected file ''%s'' did not have a ''.m'' extension.', file_name)
end

if hybrid.internal.isPackagePath(script_path)
    % For scripts in a package namespace, we need to parse the file path to
    % reference the correct script. Then, the callback_string is simply the
    % fully packaged referenced path to the script (we don't need to change
    % directories).
    package_path = hybrid.internal.convertPathToPackage(script_name, script_path);
    callback_string = package_path;
else
    % Set the callback to a script in the form 
    %
    %   wd = cd(<script_path>);
    %   <script_name>;
    %   cd(wd); % Restore original working directory
    %
    callback_string = sprintf(['wd = cd(''%s'');\n', ...
                               '%s;\n', ...
                               'cd(wd); %% Restore original working directory'], ...
                               script_path, script_name);
end
set_param(gcs, callback_name, callback_string)
promptMessage = sprintf(['This model %s callback (''%s'') has been set to:\n', ...
    '\n%s'], callback_description, callback_name, callback_string);
msgbox(promptMessage, 'Callback set');

end