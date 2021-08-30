classdef HybridSolution < handle

    properties(SetAccess = immutable)
        t (:, 1) double;
        j (:, 1) double;
        x (:, :) double;
        
        % Initial state
        x0 (1, :) double;
        % Final state
        xf (1, :) double;
        termination_cause TerminationCause; 

        % The duration of each interval of flow.
        flow_lengths (:,1) double; 
        % The continuous time of each jump.
        jump_times (:,1) double; 
        shortest_flow_length double;
        total_flow_length double;
        jump_count uint32;
    end

    properties(GetAccess = protected, SetAccess = immutable)
        system;
        C_end;
        D_end;
    end

    methods
        function this = HybridSolution(t, j, x, C_vals, D_vals, tspan, jspan)
            checkVectorSizes(t, j, x);
            this.t = t;
            this.j = j;
            this.x = x;
            this.x0 = x(1,:)';
            this.xf = x(end,:)';
            this.jump_times = HybridUtils.jumpTimes(t, j);
            this.total_flow_length = t(end) - t(1);
            this.jump_count = length(this.jump_times);
            this.flow_lengths = HybridUtils.flowLengths(t, j);
            this.shortest_flow_length = min(this.flow_lengths);
            
            if nargin == 7
                assert(t(1) == tspan(1), "t(1)=%f does equal the start of tspan=%s", t(1), mat2str(tspan))
                assert(j(1) == jspan(1), "j(1)=%d does equal the start of jspan=%s", j(1), mat2str(jspan))
                
                this.C_end = C_vals(end);
                this.D_end = D_vals(end);
                
                this.termination_cause = TerminationCause.getCause(...
                    this.t, this.j, this.x, C_vals, D_vals, tspan, jspan);
            else
                this.termination_cause = TerminationCause.getCause(...
                    this.t, this.j, this.x);
            end
        end

        function plot(this)
            HybridPlotBuilder().plot(this);
        end

        function plotflows(this)
            HybridPlotBuilder().plotflows(this);
        end

        function plotjumps(this)
            HybridPlotBuilder().plotjumps(this);
        end
        
        function plotHybridArc(this)
            HybridPlotBuilder().plotHybridArc(this);
        end
        
        function out = evaluateFunction(this, func_hand, time_indices)
            % EVALUATEFUNCTION Evaluate a function handle at each point along the solution.
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
            assert(isa(func_hand, "function_handle"), "The 'func_hand' argument must be a function handle.")
            
            if ~exist("indices", "var")
                time_indices = 1:length(this.t);
            end
            
            if isempty(time_indices) 
                return
            end
            
            assert(length(time_indices) <= length(this.t), ...
                "The length of time_indices (%d) is greater than the length of this solution (%d).", ...
                length(time_indices), length(this.t))
            
            ndx0 = time_indices(1);
            val0 = evaluate_function(func_hand, this.x(ndx0, :)', this.t(ndx0), this.j(ndx0))';
            assert(isvector(val0), "Function handle does not return a vector")
            
            out = NaN(length(time_indices), length(val0));
            
            for k=time_indices
                out(k, :) = evaluate_function(func_hand, this.x(k, :)', this.t(k), this.j(k))';
            end
        end
    end
    
    methods(Static)
        function hs = fromLegacyData(t, j, x, C, D, tspan, jspan)
            % fromLegacyData Create a HybridSolution given the input and
            % output arguments of HyEQsolver.
            C_end = evaluate_function(C, x(end,:)', t(end), j(end));
            D_end = evaluate_function(D, x(end,:)', t(end), j(end));
            hs = HybridSolution(t, j, x, C_end, D_end, tspan, jspan);
        end
    end
end

% Local functions %
function val_end = evaluate_function(fh, x, t, j)
switch nargin(fh)
    case 1
        val_end = fh(x);
    case 2
        val_end = fh(x, t);
    case 3
        val_end = fh(x, t, j);
    otherwise
        error("Function handle must have 1, 2, or 3 arguments. Instead %s had %d",...
            func2str(fh), nargin(fh))
end
end

function checkVectorSizes(t, j, x)
    if size(t, 2) ~= 1
        error('HybridSolution:WrongShape', ...
            "The vector t must be a column vector. Instead its shape was %s", ...
            mat2str(size(t)));
    end
    if size(j, 2) ~= 1
        error('HybridSolution:WrongShape', ...
            "The vector j must be a column vector. Instead its shape was %s", ...
            mat2str(size(j)));
    end
    if size(t, 1) ~= size(j, 1)
        error('HybridSolution:WrongShape', ...
            "The length(t)=%d and length(j)=%d must match.", ...
            size(t, 1), size(j, 1));
    end
    if size(t, 1) ~= size(x, 1)
        error('HybridSolution:WrongShape', ...
            "The length(t)=%d and length(x)=%d must match.", ...
            size(t, 1), size(x, 1));
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
            error("Function must have 1,2, or 3 arguments")
    end
end