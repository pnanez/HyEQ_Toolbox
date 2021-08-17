classdef HybridSolution < handle

    properties(SetAccess = immutable)
        t (:, 1) double;
        j (:, 1) double;
        x (:, :) double;
        
        % Initial state
        x0 (1, :) double;
        % Final state
        xf (1, :) double;

        % The duration of each interval of flow.
        flow_lengths (:,1) double; 
        % The continuous time of each jump.
        jump_times (:,1) double; 
        shortest_flow_length double;
        total_flow_length double;
        jump_count uint32;
    end
    
    properties(SetAccess = protected)
        % Values of the flow and jump maps and sets along solution.
        f_vals (:, :) double;
        g_vals (:, :) double;
        C_vals (:, 1) uint8;
        D_vals (:, 1) uint8; 
        termination_cause TerminationCause; 
    end

    properties(GetAccess = protected, SetAccess = immutable)
        system;
        tspan;
        jspan;
    end

    methods
        function this = HybridSolution(system, t, j, x, tspan, jspan)
            checkVectorSizes(t, j, x);
            assert(t(1) == tspan(1), "t(1)=%f does equal the start of tspan=%s", t(1), mat2str(tspan))
            assert(j(1) == jspan(1), "j(1)=%d does equal the start of jspan=%s", j(1), mat2str(jspan))
            
            this.system = system;
            this.tspan = tspan;
            this.jspan = jspan;
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
        end

        function plot(this, indices)
            n = size(this.x, 2);
            if ~exist("indices", "var")
                last_index = min(n, 4);
                indices = 1:last_index;
            end
            HybridPlotBuilder()...
                .slice(indices)...
                .plot(this);
        end

        function plotflows(this, indices)
            n = size(this.x, 2);
            if ~exist("indices", "var")
                last_index = min(n, 4);
                indices = 1:last_index;
            end
            HybridPlotBuilder()...
                .slice(indices)...
                .plotflows(this);
        end

        function plotjumps(this, indices)
            n = size(this.x, 2);
            if ~exist("indices", "var")
                last_index = min(n, 4);
                indices = 1:last_index;
            end
            HybridPlotBuilder()...
                .slice(indices)...
                .plotjumps(this);
        end

        function plotHybridArc(this, indices)
            n = size(this.x, 2);
            if ~exist("indices", "var")
                last_index = min(n, 4);
                indices = 1:last_index;
            end
            HybridPlotBuilder()...
                .slice(indices)...
                .plotHybridArc(this);
        end
    end

    methods
        function val = get.f_vals(this)
            if isempty(this.f_vals)
                generateDependentData(this);
            end
            val = this.f_vals;
        end
        function val = get.g_vals(this)
            if isempty(this.g_vals)
                generateDependentData(this);
            end
            val = this.g_vals;
        end
        function val = get.C_vals(this)
            if isempty(this.C_vals)
                generateDependentData(this);
            end
            val = this.C_vals;
        end
        function val = get.D_vals(this)
            if isempty(this.D_vals)
                generateDependentData(this);
            end
            val = this.D_vals;
        end
        function val = get.termination_cause(this)
            if isempty(this.D_vals)
                generateDependentData(this);
            end
            val = TerminationCause.getCause(...
                    this.t, this.j, this.x, this.C_vals, this.D_vals, this.tspan, this.jspan);
        end
    end
    
    methods(Access = protected)
        function generateDependentData(this) % This should only be called once.
           [this.f_vals, this.g_vals, this.C_vals, this.D_vals] ...
                    = this.system.generateFGCD(this.t, this.j, this.x); 
        end
    end
    
    methods(Static)
        function hs = fromLegacyData(t, j, x, f, g, C, D, tspan, jspan)
            % fromLegacyData Create a HybridSolution given the input and
            % output arguments of HyEQsolver.
            sys = HybridSystem(f, g, C, D);
            hs = HybridSolution(sys, t, j, x, tspan, jspan);
        end
    end
end

% Local functions %

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