function package_path = convertPathToPackage(script_name, dir_path)

    % Strip off a trailing "/" or "\" (depending on the OS).
    if isequal(dir_path(end), filesep())
        dir_path = dir_path(1:(end-1));
    end

    % Split into a cell array.
    pathparts = strsplit(dir_path, filesep());

    package_path = script_name;
    for i = numel(pathparts):-1:1
        part = pathparts{i};
        if part(1) == '+'
            % Add 'part' (without the '+') to the package path.
            package_path = [part(2:end), '.', package_path]; %#ok<AGROW> 
        else
            % Check that we have found at least one package directory.
            assert(i < numel(pathparts),...
                   'Parent directory ''%s'' was not a package directory.', part)
            % Once we find one non-package directory, we stop.
            break
        end
    end

    assert(isequal(which(package_path), fullfile(dir_path, [script_name, '.m'])))
end