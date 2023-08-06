classdef HybridArc
% A numerical representation of a hybrid arc. 
%
% See also: HybridSolution, <a href="matlab: showdemo HybridSystem_demo">Demo: How to Implement and Solve a Hybrid System</a>.

% Written by Paul K. Wintz, Hybrid Systems Laboratory, UC Santa Cruz. 
% © 2021-2023. 
% 
% Tests for this class can be opened with the command 
%   open('hybrid.tests.HybridArcTest')
% and run with the command 
%   runtests('hybrid.tests.HybridArcTest')
% 
% See also: open('hybrid.tests.HybridSolutionTest')
    
    properties(SetAccess = immutable)
        % A column vector containing the continuous time value for each entry in the solution.
        t % double (:, 1)

        % A column vector containing the discrete time value for each entry in the solution.
        j % double (:, 1)

        % An array containing the state vector for each entry in the solution.
        % Each row i of x contains the transposed state vector at the ith
        % timestep.
        x % double (:, :)

        % The duration of each interval of flow.
        flow_lengths % double (:, 1)

        % The continuous time of each jump (column vector).
        jump_times % double (:, 1)

        % The duration (in ordinary time) of the shortest interval of flow.
        shortest_flow_length % double

        % The cumulative duration of all intervals of flow.
        total_flow_length % double

        % The number of jumps in the solution.
        jump_count % integer

        % Column vector containing a 1 at each entry where a jump starts and 0 otherwise.
        is_jump_start

        % Column vector containing a 1 at each entry where a jump end and 0 otherwise.
        is_jump_end

        % Column vector containing each index in t, j, and x arrays 
        % where a jump starts (that is, the index immediately before a jump).
        jump_start_indices

        % Column vector containing each index in t, j, and x arrays 
        % where a jump ends (that is, the index immediately after a jump).
        jump_end_indices
    end

    properties(SetAccess = immutable, Hidden)
        jump_indices % Deprecated.
    end

    methods

        function this = HybridArc(t, j, x)
            % Construct a HybridArc object.
            %
            % Input arguments:
            % 1) t: a column vector containing the continuous time at each time step.
            % 2) j: a column vector containing the discrete time at each time step.
            % 3) x: an array where each row contains the transpose of the state
            % vector at that time step.

            checkVectorSizes(t, j, x);

            this.t = t;
            this.j = j;
            this.x = x;
            if isempty(t)
                this.jump_times = [];
                this.is_jump_start = [];
                this.is_jump_end = [];
                this.jump_start_indices = [];
                this.jump_end_indices = [];
                this.jump_indices = [];% Deprecated.
                this.total_flow_length = 0;
                this.jump_count = 0;
                this.flow_lengths = [];
                this.shortest_flow_length = 0;
            else
                [this.jump_times, ~, this.jump_start_indices, this.is_jump_start] ...
                                            = hybrid.internal.jumpTimes(t, j);

                this.is_jump_end = [false; this.is_jump_start(1:(end-1))];
                this.jump_end_indices = find(this.is_jump_end);

                this.jump_indices = this.jump_start_indices;% For backward compatibility.

                this.total_flow_length = t(end) - t(1);
                this.jump_count = length(this.jump_times);
                this.flow_lengths = hybrid.internal.flowLengths(t, j);
                this.shortest_flow_length = min(this.flow_lengths);
            end
        end

        function transformed_arc = transform(this, f)
            % Create a new HybridArc with the values of x replaced by f(x, t, j).
            % 
            % Evaluate a function at each point along the solution.
            % The function handle 'f' is evaluated with the
            % arguments of the state 'x', continuous time 't' (optional),
            % and discrete time 'j' (optional). This function returns a
            % HybridArc with the same hybrid time domain as the original
            % HybridArc. 
            % 
            % The argument 'f' must be a function handle
            % that has the input arguments "(x)", "(x, t)", or "(x, t, j)", and
            % returns a column vector of fixed length with type 'double'.
            x_transformed = this.evaluateFunction(f);
            transformed_arc = HybridArc(this.t, this.j, x_transformed);
        end

        function selected_arc = select(this, ndxs)
            % Create a new HybridArc with only the selected component indicies.
            % 
            % ndxs: A vector of positive integers less than or equal to the
            %       dimension of this HybridArc. Repeated values are OK and the 
            %       values can be in any order.
            %
            % Example: 
            %     n = 3;        % State dimension
            %     tsteps = 100; % Number of time steps.
            %     x = rand(tsteps, n);
            %     t = linspace(0, 100, tsteps)';
            %     j = zeros(tsteps, 1);
            %     h_arc = HybridArc(t, j, x); % Create an example HybridArc
            %     
            %     % Select the first component.
            %     x1_arc = h_arc.select(1);
            %
            %     % Select the first and second component.
            %     x12_arc = h_arc.select(1:2);
            %
            %     % Select the third and first component (in that order).
            %     x31_arc = h_arc.select([3, 1]);
            
            if min(ndxs) < 1
                error('Hybrid:InvalidArgument', ...
                    'All selected indices must be at least 1, but the smallest index was %d.', ...
                    min(ndxs));
            elseif max(ndxs) > size(this.x, 2)
                error('Hybrid:InvalidArgument', ['The largest selected index was %d ' ...
                    'but there are only %d components in x.'], ...
                    max(ndxs), size(this.x, 2));
            end

            x_selected = this.x(:, ndxs);
            selected_arc = HybridArc(this.t, this.j, x_selected);
        end

        function restricted_sol = restrictT(this, tspan)
            % Create a new HybridArc by restricting the domain in ordinary time to the interval 'tspan'.
            % 'tspan' must be a 2x1 array of real numbers. 
            % 
            % See also: HybridArc/restrictJ
            if ~isnumeric(tspan)
                throwAsCaller(MException('HybridArc:NonNumericArgument', ...
                    ['Error in HybridArc.restrictT: "tspan" argument must be numeric.' ...
                    ' Instead it had type "%s".'], class(tspan)))
            end
            if ~all(size(tspan) == [1 2])
                throwAsCaller(MException('HybridArc:WrongShapeArgument', ...
                    ['Error in HybridArc.restrictT: "tspan" argument be a 1x2 array. ' ...
                    'Instead its shape was %s.'], mat2str(size(tspan))))
            end
            
            ndxs_in_span = this.t >= tspan(1) & this.t <= tspan(2);

            restricted_sol = HybridArc(this.t(ndxs_in_span), ...
                                            this.j(ndxs_in_span), ...
                                            this.x(ndxs_in_span, :));
        end

        function restricted_sol = restrictJ(this, jspan)
            % Create a new HybridArc by restricting the domain in discrete time to the interval 'jspan'.
            % 'jspan' must be either a 2x1 array of integers or a single integer. 
            % 
            % See also: HybridArc/restrictT
            if ~isnumeric(jspan)
                throwAsCaller(MException('HybridArc:NonNumericArgument', ...
                    ['Error in HybridArc.restrictJ: "jspan" argument must be numeric.' ...
                    ' Instead it had type "%s".'], class(jspan)))
            end
            if isscalar(jspan)
                jspan = [jspan jspan];
            end
            if ~all(size(jspan) == [1 2])
                throwAsCaller(MException('HybridArc:WrongShapeArgument', ...
                    ['Error in HybridArc.restrictJ: "jspan" argument be a 1x2 array. ' ...
                    'Instead its shape was %s.'], mat2str(size(jspan))))
            end
            ndxs_in_span = this.j >= jspan(1) & this.j <= jspan(2);

            restricted_sol = HybridArc(this.t(ndxs_in_span), ...
                                        this.j(ndxs_in_span), ...
                                        this.x(ndxs_in_span, :));
        end

        function plotFlows(this, varargin)
            % Shortcut for HybridPlotBuilder.plotFlows function with automatic formatting based on the number of state components.
            %
            % See also: HybridPlotBuilder.plotFlows.
            this.plotByFnc('plotFlows', varargin{:})
        end

        function plotJumps(this, varargin)
            % Shortcut for HybridPlotBuilder.plotJumps function with automatic formatting based on the number of state components.
            %
            % See also: HybridPlotBuilder.plotJumps.
            this.plotByFnc('plotJumps', varargin{:})
        end

        function plotHybrid(this, varargin)
            % Shortcut for HybridPlotBuilder.plotHybrid function with automatic formatting based on the number of state components.
            %
            % See also: HybridPlotBuilder.plotHybrid.
            this.plotByFnc('plotHybrid', varargin{:})
        end

        function plotPhase(this, varargin)
            % Shortcut for HybridPlotBuilder.plotPhase function.
            %
            % See also: HybridPlotBuilder.plotPhase.
            this.plotByFnc('plotPhase', varargin{:})
        end
        
        function plotTimeDomain(this, varargin)
            % Shortcut for HybridPlotBuilder.plotTimeDomain function.
            %
            % See also: HybridPlotBuilder.plotTimeDomain.
            this.plotByFnc('plotTimeDomain', varargin{:})
        end

        function [x_interp, t_interp] = interpolateToArray(this, t_interp, varargin)
            % Interpolate a function at each point along the solution.
            % 
            % Returns a display of the interpolated x-values at t_grid times.
            %
            % Required Input Arguments:
            % * 't_grid': list of times for interpolation or an integer with
            % value of at least 2 that specifies a number of evenly distributed
            % interpolation points.
            % Name-value Pair Input Arguments:
            % * 'InterpMethod': String argument that gives the name of the interpolation method to use. One of
            % 'spline', 'linear' ... 
            % 
            % linear
            % nearest
            % next
            % previous
            % pchip
            % cubic
            % makima
            % splineSee <a
            % href="matlab:doc('interp1')">interp1</a> for details.
            % 'ValueAtJumpFnc' Function handle argument with 
            %   Input: x_and_gx -- an array containing x, g(x), g(g(x)) 
            %       and so on in for each jumps that occur at the
            %       current interpolation point.
            %   Output: an array containing zero or more columns that represent the output values to appear in the interpolated array. 
            % By default, ValueAtJumpFnc outputs a single column that is the
            % average of [x, g(x), g(g(x)), ...]. 

            % TODO: Add documentation
            ip = inputParser;
            ip.FunctionName = 'HybridArc.interpolateToArray';
            addOptional(ip, 'InterpMethod', 'spline');
            
            % 'X_and_gX' is a matrix containing---in each column---the value immediately
            % before the jump, and the values immediately after (one or more)
            % jumps. The output must be a colu
            ValueAtJumpFnc_DEFAULT = @(X_and_gX) mean(X_and_gX, 2);
            addOptional(ip, 'ValueAtJumpFnc', ValueAtJumpFnc_DEFAULT);

            parse(ip, varargin{:});
            interp_method = ip.Results.InterpMethod;
            value_at_jump_fnc = ip.Results.ValueAtJumpFnc;
            
            % Check that the input t_interp for interpolateToArray and
            % interpolateToHybridArc is well-formed. If it is, then transform it
            % into a standard form, namely a column vector. 
            t_interp = this.preprocess_t_interp(t_interp);

            % Cell array that contains in each entry, a row array of the t-entries during
            % the corresponding interval of flow.
            t_iofs_cell = {};
            
            % Cell array that contains in each entry, an array of the x-entries during
            % the corresponding interval of flow, which each column containing the vector
            % 'x' at the correpsonding time step.
            x_iofs_cell = {};
            
            % % To improve efficiency, we should preallocate cells.
            % t_iofs_cell = cell(1, hybrid_arc.jump_count);
            % x_iofs_cell = cell(1, hybrid_arc.jump_count);
            for j_iof = unique(this.j)'
                % Indices that are in the jth interval of flow.
                iof_indices = this.j == j_iof;
            
                t_iof = this.t(iof_indices);
                x_iof = this.x(iof_indices, :);% 'x' in rows (each row is a time-step).

                t_grid_in_iof = t_interp(t_interp >= t_iof(1) & t_interp <= t_iof(end));
                
                if isempty(t_grid_in_iof)
                    % If t_grid doesn't not intersect with this iof, then 
                    % we don't add any values to the arrays.
                    continue
                end

                % If t_iof has only one element, then we cannot interpolate.
                if numel(t_iof) == 1
                    assert(numel(t_grid_in_iof) == 1, 'Multiple interpolation points at a jump time. ')
                    assert(t_grid_in_iof == t_iof)
                    x_interp_iof = x_iof;
                else
                    x_interp_iof = interp1(t_iof, x_iof, t_grid_in_iof, interp_method);% 'x' in rows (each row is a time-step).
                end 

                % If this is not an interval of flow (i.e., has zero length in
                % t), then we skip it. Instead, we process all sequential
                % jumps together at one time.
                is_first_t_grid_in_iof_a_jump_time = t_iof(1) == t_grid_in_iof(1);
                is_start_of_hybrid_domain = t_iof(1) == this.t(1);
                is_first_t_immediately_after_a_jump = is_first_t_grid_in_iof_a_jump_time && ~is_start_of_hybrid_domain;
                if is_first_t_immediately_after_a_jump
                    t_grid_in_iof = t_grid_in_iof(2:end);
                    x_interp_iof = x_interp_iof(2:end, :);% 'x' in rows (each row is a time-step).

                    % If there are multiple jumps that coincide with an
                    % interpolation point, then t_grid_in_iof will be empty,
                    % here, which will cause subsequent code to fail.
                    if isempty(t_grid_in_iof)
                        continue
                    end
                end

                % Check if the end of this interval of flow (iof) is immediately
                % prior to a jump. If it is, then we trim off the last entry. 
                is_last_t_grid_in_iof_a_jump_time = t_grid_in_iof(end) == t_iof(end);
                is_end_of_hybrid_domain = t_grid_in_iof(end) == this.t(end);
                is_immediately_prior_to_a_jump = is_last_t_grid_in_iof_a_jump_time && ~is_end_of_hybrid_domain;
                if is_immediately_prior_to_a_jump
                    % Trim off last point
                    t_grid_in_iof = t_grid_in_iof(1:(end-1));
                    x_interp_iof = x_interp_iof(1:(end-1), :);

                    % Get the value of x before and after (one or more) jumps.
                    X = x_iof(end, :)';% Each column is a time-step.
                    j_next = j_iof + 1;
                    while true
                        j_next_indices = j_next == this.j;
                        first_ndx = find(j_next_indices, 1);
                        x_next = this.x(first_ndx, :)'; % Column vector.
                        assert(iscolumn(x_next), 'x_next should be a column vector.')
                        X(:, end+1) = x_next;

                        % We continue the 'while' loop until j_next corresponds
                        % to an interval of flow or nothing (i.e., the end of
                        % the hybrid arc).
                        if sum(j_next_indices) ~= 1
                            break
                        end

                        % Update j_next
                        j_next = j_next + 1;
                    end
                    values_at_jump = value_at_jump_fnc(X)'; % x in rows
                    x_dim = size(values_at_jump, 2);
                    if x_dim ~= size(this.x, 2)
                        % TODO: Clean up and add test.
                        error('HybridArc:WrongFunctionHandleOutputSize', ...
                            ['Output of value_at_jump_fnc function is wrong size. ' ...
                            'Expected %d rows, instead the shape was %s'], ...
                            x_dim, mat2str(size(values_at_jump')))
                    end
                    n_values_at_jump = size(values_at_jump, 1);
                    x_interp_iof = [x_interp_iof; values_at_jump]; %#ok<AGROW>    % Each x stored in rows
                    t_grid_in_iof = [t_grid_in_iof; t_iof(end)*ones(n_values_at_jump, 1)]; %#ok<AGROW>
                end

                t_iofs_cell{end+1} = t_grid_in_iof'; %#ok<AGROW> % Time-steps in columns
                x_iofs_cell{end+1} = x_interp_iof'; %#ok<AGROW> % 'x' in columns (so that we can use cell-expansion).
            end
            t_interp = [t_iofs_cell{:}]';
            x_interp = [x_iofs_cell{:}]'; % Transpose so time-steps are in rows.
            
        end

        function hybrid_arc = interpolateToHybridArc(this, t_interp, varargin)
            % Generate a new HybridArc object with time steps at the interpolation points given in t_interp.
            % t_interp must be a nondecreaing vector of values that within the
            % interval [this.t(1), this.t(end)].
            % There is an optional name-value argument: 
            % * "InterpMethod" with possible values...

            % TODO: Add documentation
            % DONE: Add autocomplete signiture.
            ip = inputParser;
            ip.FunctionName = 'HybridArc.interpolateToHybridArc';
            addOptional(ip, 'InterpMethod', 'spline');
            parse(ip, varargin{:});
            interp_method = ip.Results.InterpMethod;

            if ~exist('interp_method', 'var')
                interp_method = 'spline';
            end

            % Check that the input t_interp for interpolateToArray and
            % interpolateToHybridArc is well-formed. If it is, then transform it
            % into a standard form, namely a column vector. 
            t_interp = this.preprocess_t_interp(t_interp, true);

            % Add jump times to t_interp that were not already there.
            t_interp = this.ensure_before_and_after_jump_times_are_in_array(t_interp);

            j_interp = this.tToJIncrementingJForRepeatedTValuesAtJumps(t_interp);

            x_interp = nan(numel(t_interp), size(this.x, 2));
            for j_iof = unique(j_interp')
                interp_iof_ndxs = find(j_interp == j_iof);
                % is_this_iof = ;
                t_interp_iof = t_interp(interp_iof_ndxs);
                t_iof = this.t(this.j == j_iof);
                x_iof = this.x(this.j == j_iof, :);
                if numel(t_iof) == 1
                    assert(numel(t_interp_iof) == 1)
                    assert(t_interp_iof == t_iof)
                    x_interp(interp_iof_ndxs, :) = x_iof;
                    continue
                end

                x_interp(interp_iof_ndxs, :) = interp1( ...
                    t_iof, ... Select the t values from this interval of flow
                    x_iof, ... Select the x values from this interval of flow
                    t_interp_iof, ... Give the interpolation grid in this interval of flow.
                    interp_method); 
            end

            hybrid_arc = HybridArc(t_interp, j_interp, x_interp);
        end

    end

    methods(Access = {?HybridArc, ?matlab.unittest.TestCase})
        function plotByFnc(this, plt_fnc, varargin)
            % Shortcut for HybridPlotBuilder.plot* functions.
            [~, x_ndxs] = hybrid.internal.convert_varargin_to_solution_obj([{this}, varargin(:)']);
            MAX_COMPONENTS_FOR_SUBPLOTS = 4;
            if length(x_ndxs) <= MAX_COMPONENTS_FOR_SUBPLOTS
                HybridPlotBuilder()...
                    .subplots('on')...
                    .(plt_fnc)(this, varargin{:});
            else
                legend_labels = num2cell(x_ndxs);
                legend_labels = cellfun(@(n) {sprintf('$x_{%d}$', n)},legend_labels);
                HybridPlotBuilder()...
                    .subplots('off')...
                    .color('matlab')...
                    .legend(legend_labels)...
                    .(plt_fnc)(this, varargin{:});
            end
        end

        function t_interp = preprocess_t_interp(this, t_interp, ensure_sorted)
            % Check that the input t_interp for interpolateToArray and
            % interpolateToHybridArc is well-formed. If it is, then transform it
            % into a standard form, namely a column vector. 

            if ~exist('ensure_sorted', 'var')
                ensure_sorted = false;
            end

            if ~isnumeric(t_interp)
                error('t_interp must be numeric. Instead, its type was "%s".', class(t_interp))
            end

            if ~isvector(t_interp)
                error(['t_interp must be a vector. ' ...
                    'Instead its shape was %s'], mat2str(size(t_interp)))
            end

            % If t_interp is a single value, then we interpret it as the number
            % of evenly spaced interpolation points.
            if isscalar(t_interp)
                assert(round(t_interp) == t_interp && t_interp >= 2, ...
                    ['If a scalar value is given for ''t_interp'', ' ...
                    'it must be an integer greater than or equal to 2, ' ...
                    'which is interpreted as the number of evenly spaced ' ...
                    'interpolation points.'])
                interp_steps = t_interp;
                t_interp = linspace(this.t(1), this.t(end), interp_steps)';
            elseif isrow(t_interp)
                % Make sure t_interp is a column vector.
                t_interp = t_interp';
            end

            if ensure_sorted && ~issorted(t_interp)
                error('HybridArc:ArgumentNotSorted', ...
                    'The argument ''t_interp'' is not sorted in increasing order.')
            end

            assert(iscolumn(t_interp), 't_interp needs to be a column after preprocessing.')
            
            % Check that all of the t_interp values are inside TSPAN.
            is_outside_tspan = t_interp < this.t(1) | t_interp > this.t(end);
            if any(is_outside_tspan)
                error('HybridArc:InterpolationPointOutsideOfTSpan', ...
                    'The following values in t_interp are outside of tspan=%s: \n\t%s.', ...
                    mat2str([this.t(1), this.t(end)]), ...
                    mat2str(t_interp(is_outside_tspan)))
            end
        end

        function t_out = ensure_before_and_after_jump_times_are_in_array(this, t_in)
            % Input: A sorted array of times within the tspan of this arc.
            % Output: The same array, except that every jump time t_jump of this
            % arc is included in the array n+1 times where n is the
            % number of jumps at time t_jump.

            % In order to insert missing jump times, we append them to an
            % array and then sort it. Thus, if the user gives an array that
            % is not sorted, then we will be changing the order.
            assert(issorted(t_in), ['Input ''t_in'' is not sorted. ' ...
                'This function sorts the output array, which would lead to an ' ...
                'unexpected ordering, so intead we raise this error.'])

            % Strip out any jump times from the input.
            t_in_without_jump_times = t_in(~ismember(t_in, this.jump_times));

            t_before_and_after_jump = this.t(this.is_jump_start | this.is_jump_end);

            % Remove any jump times that are not in the range of 't_in'.
            is_in_range = t_before_and_after_jump >= t_in(1) & t_before_and_after_jump <= t_in(end);
            t_before_and_after_jump = t_before_and_after_jump(is_in_range);

            % Add jump times and sort the resulting array.
            t_out = sort([t_in_without_jump_times; t_before_and_after_jump]);
        end
        
        % function j = tToJ(this, t)
        %     % Map a given value of time to the  Work in progress. 
        %     % t_excluding_after_jumps = this.t
        %     [unique_t, unique_t_ndxs, ~] = unique(this.t);
        % 
        %     % if t < this.t(1) or t > this.t(end
        %     %   j = []
        %     %   return
        %     % end
        % 
        %     j = interp1(unique_t, this.j(unique_t_ndxs), t, 'previous');
        % end

        function j_out = tToJIncrementingJForRepeatedTValuesAtJumps(this, t_in)

            j_out = nan(numel(t_in), 1);

            t_ndx = 1;

            % For each entry in the given array 't_in', index with 'in_and_out_ndx', 
            % we find the index 't_ndx' that 
            for in_and_out_ndx = 1:numel(t_in)

                % Increase t_ndx until this.t(t_ndx) >= t_in(in_and_out_ndx)
                while this.t(t_ndx) < t_in(in_and_out_ndx)
                    t_ndx = t_ndx + 1;
                end

                assert(this.t(t_ndx) >= t_in(in_and_out_ndx))

                j_out(in_and_out_ndx) = this.j(t_ndx);

                % If t_in(in_and_out_ndx) is the start of a jump, then we
                % increment t_ndx so that j_out increases. This is important if
                % there are multiple jumps in a row.
                if this.t(t_ndx) == t_in(in_and_out_ndx) && this.is_jump_start(t_ndx)
                    t_ndx = t_ndx + 1;
                    if numel(this.t) >= t_ndx
                        assert(this.t(t_ndx-1) == this.t(t_ndx), ...
                            ['Incrementing t_ndx here caused this.t(t_ndx) to ' ...
                            'change but it should have the same value.'])
                    end
                end
            end
        end

        % function t = jToT(this, j)
        % 
        % end
    end

    methods(Hidden)
        function sliced_arc = slice(this, ndxs)
            % Create a new HybridArc with only the selected component indicies (DEPRECATED). 
            % 
            % This function is deprecated. Use HybridArc.select(ndxs) insted. 
            %
            % See also: HybridArc/select.
            hybrid.internal.deprecationWarning('HybridArc.slice', 'HybridArc.select')
            sliced_arc = this.select(ndxs);
        end

        function plotflows(varargin)
            warning('Please use the plotFlows function instead of plotflows.')
            this.plotFlows(varargin{:});
        end

        function plotjumps(varargin)
            warning('Please use the plotJumps function instead of plotjumps.')
            this.plotJumps(varargin{:});
        end

        function plotHybridArc(varargin)
            warning('Please use the plotHybrid function instead of plotHybridArc.')
            this.plotHybrid(varargin{:});
        end

        function plot(this, varargin)
            % Deprecated: Do not use.
            HybridPlotBuilder.plot(this)
        end
    end

    methods

        function out = evaluateFunction(this, func_hand, time_indices)
            % Evaluate a function at each point along the solution.
            % The function handle 'func_hand' is evaluated with the
            % arguments of the state 'x', continuous time 't' (optional),
            % and discrete time 'j' (optional). This function returns an
            % array with length equal to the length of 't' (or
            % 'time_indices', if provided). Each row of the output array
            % contains the vector returned by 'func_hand' at the
            % corresponding entry in this HybridSolution.
            %
            % The argument 'func_hand' must be a function handle
            % that has the input arguments "x", "x, t", or "x, t, j", and
            % returns a column vector of fixed length.
            % The argument "time_indices" is optional. If supplied, the
            % function is evaluated only at the indices specificed and the
            % "out" vector matches the legnth of "time_indices."
            assert(isa(func_hand, 'function_handle'), ...
                'The ''func_hand'' argument must be a function_handle. Instead it was %s.', class(func_hand))

            if ~exist('indices', 'var')
                time_indices = 1:length(this.t);
            end

            if isempty(time_indices)
                out = [];
                return
            end

            assert(length(time_indices) <= length(this.t), ...
                'The length of time_indices (%d) is greater than the length of this solution (%d).', ...
                length(time_indices), length(this.t))

            ndx0 = time_indices(1);
            val0 = evaluate_function(func_hand, this.x(ndx0, :)', this.t(ndx0), this.j(ndx0))';
            assert(isvector(val0), 'Function handle does not return a vector')

            out = NaN(length(time_indices), length(val0));

            for k=time_indices
                out(k, :) = evaluate_function(func_hand, this.x(k, :)', this.t(k), this.j(k))';
            end
        end
    end
end

%%%% Local functions %%%%

function val_end = evaluate_function(fh, x, t, j)
switch nargin(fh)
    case 1
        val_end = fh(x);
    case 2
        val_end = fh(x, t);
    case 3
        val_end = fh(x, t, j);
    otherwise
        error('Function handle must have 1, 2, or 3 arguments. Instead %s had %d.',...
            func2str(fh), nargin(fh))
end
end

function checkVectorSizes(t, j, x)
    
    if ~isnumeric(t)
        throwAsCaller(MException('HybridArc:NonNumericArgument', ...
            ['Error in HybridArc: "t" argument must be numeric.' ...
            ' Instead it had type "%s".'], class(t)))
    end
    if ~isnumeric(j)
        throwAsCaller(MException('HybridArc:NonNumericArgument', ...
            ['Error in HybridArc: "j" argument must be numeric.' ...
            ' Instead it had type "%s".'], class(j)))
    end
    if ~isnumeric(x)
        throwAsCaller(MException('HybridArc:NonNumericArgument', ...
            ['Error in HybridArc: "x" argument must be numeric.' ...
            ' Instead it had type "%s".'], class(x)))
    end

    if size(t, 2) ~= 1
        e = MException('HybridArc:WrongShape', ...
            'The vector t (first argument) must be a column vector. Instead its shape was %s.', ...
            mat2str(size(t)));
        throwAsCaller(e);
    end
    if size(j, 2) ~= 1
        e = MException('HybridArc:WrongShape', ...
            'The vector j (second argument) must be a column vector. Instead its shape was %s.', ...
            mat2str(size(j)));
        throwAsCaller(e);
    end
    if size(t, 1) ~= size(j, 1)
        e = MException('HybridArc:WrongShape', ...
            'The size(t,1)=%d and size(j,1)=%d must match.', ...
            size(t, 1), size(j, 1));
        throwAsCaller(e);
    end
    if size(t, 1) ~= size(x, 1)
        e = MException('HybridArc:WrongShape', ...
            'The size(t,1)=%d and size(x,1)=%d must match.', ...
            size(t, 1), size(x, 1));
        throwAsCaller(e);
    end
end
