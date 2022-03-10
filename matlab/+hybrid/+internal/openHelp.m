function openHelp(name)
    % Open a help page stored in doc/html/ (which are published based on the
    % MATLAB .m files stored in doc/. If no 'name' is given, then the root of
    % the HyEQ Toolbox help is opened.

    if nargin == 0
        name = 'GettingStarted.html';
    end

    % Use strcmp and 'name((end-4):end)' instead of 'endswith' because
    % 'endswith' was not added until after R2014b.
    if strcmp(name((end-4):end), '.html')
        name_with_html = name;
    else
        name_with_html = [name, '.html'];
    end

    path = fullfile(hybrid.getFolderLocation('doc', 'html'), name_with_html);
    open(path);
end