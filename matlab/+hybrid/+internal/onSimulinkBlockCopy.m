function onSimulinkBlockCopy(varargin)
    % If "no link" is given as an input argument, then break the link to the
    % library block. This is important for blocks where users need to modify the
    % internal blocks.
    if ismember('no link', varargin)
        set_param(gcb, 'LinkStatus','none')
        disp('Disabled link to library block after copying.')
    elseif ~isempty(varargin) 
        error('Unsupported argument.')
    end

    % If the Simulink solver "MaxStep" setting is set to "auto" (the default), 
    % then prompt the user to set the value to something else.
    if strcmp('auto',  get_param(gcs, 'MaxStep'))
        % Create the popup box with a text field
        prompt = {['Enter the maximum step size as a numeric value or variable name. ' ...
            'It is important to choose a sufficiently small value to prevent the hybrid solver from missing jumps:']};
        dlgtitle = 'Max Step Size';
        dims = [1 45]; % dimensions of the input field
        definput = {'MaxStep'}; % default value in the text field
        userInput = inputdlg(prompt, dlgtitle, dims, definput);
        
        % Extract the user input
        if ~isempty(userInput)
            inputValue = userInput{1};
            % Call the callback function with the input value
            changeMaxStep(inputValue);
        end
        
    end
end

% Define your callback function
function changeMaxStep(inputValue)
    set_param(gcs, 'MaxStep', inputValue)
    disp(['The Simulink MaxStep parameter was changed to "' inputValue '".']); 
    disp('To change the MaxStep parameter again, open "Model Configuration Parameters"/"Solver"/"Solver Details".')
end