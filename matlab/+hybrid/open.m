function wd_before = open(example_name, main_file_name)
    % Change the current working directory to the example of the given name.
    % This function returns the path of the working directory prior to changing
    % directories to facilitate returning to that directory. If main_file_name
    % is given, then that file is opened, within the example directory (if it
    % exists).

    wd_before = pwd(); % Save current working directory.
    path = hybrid.getFolderLocation('Examples', example_name);

    cd(path);
    
    if exist('main_file_name', 'var')
        open(fullfile(path, main_file_name))
    end

    if nargout == 0
        % Delete the wd_before variable if it is not being saved to a variable,
        % so that the function doesn't print anything if it is called without a
        % semicolon afterwards.
        clearvars('wd_before')
    end
end