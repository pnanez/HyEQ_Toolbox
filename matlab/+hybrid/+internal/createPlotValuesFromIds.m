function plot_values = createPlotValuesFromIds(sol, xaxis_id, yaxis_id, zaxis_id)
% Create an array containing the values from the corresponding id in each column.
% xaxis_id can take values 't', 'j' or an integer.
% yaxis_id can take values 'j' or an integer.
% zaxis_id can take value of an integer or an empty set.
narginchk(4, 4)

    function values = values_from_id(id)
        if strcmp(id, 't')
            values = sol.t;
        elseif strcmp(id, 'j')
            values = sol.j;
        else
            if ~all(id <= size(sol.x, 2))
                e = MException('HybridPlotBuilder:InvalidStateIndex', 'The index %d was requested but sol.x only has %d entries', id, size(sol.x, 2));
                throwAsCaller(e);
            end
            values = sol.x(:, id);
        end
    end

xvalues = values_from_id(xaxis_id);
yvalues = values_from_id(yaxis_id);
% If zaxis_id is empty, then zvalues will be as well, which means the
% the plot will be only 2D.
zvalues = values_from_id(zaxis_id);
plot_values = [xvalues, yvalues, zvalues];

end