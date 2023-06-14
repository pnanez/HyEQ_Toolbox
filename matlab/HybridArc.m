classdef HybridArc
% A numerical representation of a hybrid arc. 
%
% See also: HybridSolution, <a href="matlab: showdemo HybridSystem_demo">Demo: How to Implement and Solve a Hybrid System</a>.

% Written by Paul K. Wintz, Hybrid Systems Laboratory, UC Santa Cruz. 
% © 2021. 
    
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
    end
    
    properties(SetAccess = immutable, Hidden)
        % Column vector containing a 1 at each entry where a jump starts and 0 otherwise.
        is_jump_start
        jump_indices
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
                this.total_flow_length = 0;
                this.jump_count = 0;
                this.flow_lengths = [];
                this.shortest_flow_length = 0;
            else
                [this.jump_times, ~, this.jump_indices, this.is_jump_start] ...
                                            = hybrid.internal.jumpTimes(t, j);
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

    end

    methods(Access = private)
        function plotByFnc(this, plt_fnc, varargin)
            % Shortcut for HybridPlotBuilder.plot function.
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