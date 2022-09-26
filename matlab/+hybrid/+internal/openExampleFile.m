function openExampleFile(example_name, file_name)
    % Change the current working directory to the example of the given name.
    % This function returns the path of the working directory prior to changing
    % directories to facilitate returning to that directory. 
    % 'example_path' can be given as the name of a single folder within the
    % "<toolbox-root>/Examples/" directory, or as a cell array that specifies a
    % path containing multiple layers of directories.
    % *If file_name is given, then that file is opened, within the example directory.
        
    package_path = ['hybrid.examples.', example_name];
    if exist('file_name', 'var')
        package_path = [package_path, '.', file_name];
    else
        package_path = [package_path, '.', example_name];
    end
    file_path = which(package_path);
    open(file_path)
end