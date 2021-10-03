classdef HybridSolution
% HybridSolution Solution to a hybrid dynamical system, with additional information. 
    
    properties(SetAccess = immutable)
        % A column vector containing the continuous time value for each entry in
        % the solution.
        t % double (:, 1) 
        
        % A column vector containing the discrete time value for each entry in
        % the solution.
        j % double (:, 1) 
        
        % A column vector containing the state vector for each entry in
        % the solution.
        x % double (:, :) 
        
        % Initial state vector.
        x0 % double (1, :) 
        
        % Final state vector.
        xf % double (1, :) 
        
        % The reason the simulation terminated.
        % The value of termination_cause is set to one of the the enumeration
        % values in TerminationCause.
        termination_cause % TerminationCause; 

        % The duration of each interval of flow.
        flow_lengths % double (:, 1)
        
        % The continuous time of each jump.
        jump_times % double (:, 1)
        
        % The legenth of the shortest interval of flow.
        shortest_flow_length % double
        
        % The cumulative length of all intervals of flow.
        total_flow_length % double
        
        % The number of jumps in the solution.
        jump_count % integer
    end

    properties(GetAccess = protected, SetAccess = immutable, Hidden)
        system;
        C_end;
        D_end;
    end

    methods
        function this = HybridSolution(t, j, x, C, D, tspan, jspan)
            % Construct a HybridSolution object. 
            %
            % Input arguments:
            % 1) t: a column vector containing the continuous time at each time step.
            % 2) j: a column vector containing the discrete time at each time step.
            % 3) x: an array where each row contains the transpose of the state
            % vector at that time step.
            % 4) C (optional): flow set indicator. Given as one of the following:
            %   * a column vector containing the value at each time step.
            %   * a scalar containing the value at only the last time step, or
            %   * a function handle.
            % 5) D (optional): jump set indicator. Given as one of the following:
            %   * a column vector containing the value at each time step.
            %   * a scalar containing the value at only the last time step, or
            %   * a function handle.
            % 6) tspan (optional): a 2x1 array containing the continuous time
            % span.
            % 7) jspan (optional): a 2x1 array containing the continuous time
            % span.
            % 
            % Arguments 4 through 7 are used to determine the termination cause.
            
            checkVectorSizes(t, j, x);
            this.t = t;
            this.j = j;
            this.x = x;
            this.x0 = x(1,:)';
            this.xf = x(end,:)';
            this.jump_times = hybrid.internal.jumpTimes(t, j);
            this.total_flow_length = t(end) - t(1);
            this.jump_count = length(this.jump_times);
            this.flow_lengths = hybrid.internal.flowLengths(t, j);
            this.shortest_flow_length = min(this.flow_lengths);
            
            if nargin == 7
                assert(t(1) == tspan(1), 't(1)=%f does equal the start of tspan=%s', t(1), mat2str(tspan))
                assert(j(1) == jspan(1), 'j(1)=%d does equal the start of jspan=%s', j(1), mat2str(jspan))
                
                if isa(C, 'function_handle')
                    C = evaluate_function(C, x(end,:)', t(end), j(end));
                end
                if isa(D, 'function_handle')
                    D = evaluate_function(D, x(end,:)', t(end), j(end));
                end
                
                this.C_end = C(end);
                this.D_end = D(end);
                
                this.termination_cause = TerminationCause.getCause(...
                    this.t, this.j, this.x, C, D, tspan, jspan);
            else
                this.termination_cause = TerminationCause.getCause(...
                    this.t, this.j, this.x);
            end
        end

        function plot(varargin)
            % Shortcut for HybridPlotBuilder.plot function.
            HybridPlotBuilder().plot(varargin{:});
        end

        function plotFlows(varargin)
            % Shortcut for HybridPlotBuilder.plotFlows function.
            HybridPlotBuilder().plotFlows(varargin{:});
        end

        function plotJumps(varargin)
            % Shortcut for HybridPlotBuilder.plotJumps function.
            HybridPlotBuilder().plotJumps(varargin{:});
        end
        
        function plotHybrid(varargin)
            % Shortcut for HybridPlotBuilder.plotHybrid function.
            HybridPlotBuilder().plotHybrid(varargin{:});
        end
        
        function plotPhase(varargin)
            % Shortcut for HybridPlotBuilder.plotPhase function.
            HybridPlotBuilder().plotPhase(varargin{:});
        end
        
    end
    
    methods(Hidden)
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
    if size(t, 2) ~= 1
        e = MException('HybridSolution:WrongShape', ...
            'The vector t must be a column vector. Instead its shape was %s.', ...
            mat2str(size(t)));
        throwAsCaller(e);
    end
    if size(j, 2) ~= 1
        e = MException('HybridSolution:WrongShape', ...
            'The vector j must be a column vector. Instead its shape was %s.', ...
            mat2str(size(j)));
        throwAsCaller(e);
    end
    if size(t, 1) ~= size(j, 1)
        e = MException('HybridSolution:WrongShape', ...
            'The length(t)=%d and length(j)=%d must match.', ...
            size(t, 1), size(j, 1));
        throwAsCaller(e);
    end
    if size(t, 1) ~= size(x, 1)
        e = MException('HybridSolution:WrongShape', ...
            'The length(t)=%d and length(x)=%d must match.', ...
            size(t, 1), size(x, 1));
        throwAsCaller(e);
    end
end

function f_handle = wrap_with_three_args(function_handle)
    switch nargin(function_handle)
        case 1
            f_handle = @(x, t, j) function_handle(x);
        case 2
            f_handle = @(x, t, j) function_handle(x, t);
        case 3
            f_handle = function_handle;
        otherwise
            error('Function must have 1,2, or 3 arguments')
    end
end