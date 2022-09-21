function is_package_path = isPackagePath(path)
% For the given file 'path' char array, check if the path represents
% a package namespace directory. In particular, check if the name of the 
% last directory in the 'path' starts with '+'.

    % Strip off a trailing "/" or "\" (depending on the OS).
    if isequal(path(end), filesep())
        path = path(1:(end-1));
    end

    % Split into a cell array.
    pathparts = strsplit(path, filesep());

    % Check if the parent directory (the last one in the 'path' string)
    % starts with a '+', which marks it as a package directory.
    last_dir = pathparts{end};
    is_package_path = isequal(last_dir(1), '+');
end