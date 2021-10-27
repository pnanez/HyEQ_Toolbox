function axis_ids = makeAxisIds(x_ndxs, axis_symbols)
plot_count = size(x_ndxs, 1);
axis_ids = {};
j_x_ndx = 1;
for i=1:length(axis_symbols)
    if strcmp(axis_symbols{i}, 'x')
        x_ndx_next = x_ndxs(:, j_x_ndx);
        j_x_ndx = j_x_ndx+1;
        axis_ids(:, i) = num2cell(x_ndx_next); %#ok<AGROW>
    end
end
for i=1:length(axis_symbols)
    if strcmp(axis_symbols{i}, 't')
        axis_ids(:, i) = cellstr(repmat('t', plot_count, 1)); %#ok<AGROW>
    elseif strcmp(axis_symbols{i}, 'j')
        axis_ids(:, i) = cellstr(repmat('j', plot_count, 1)); %#ok<AGROW>
    end
end
end