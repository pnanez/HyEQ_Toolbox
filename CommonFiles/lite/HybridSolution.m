classdef HybridSolution

    properties(SetAccess = immutable)
        t (:, 1) double;
        j (:, 1) double;
        x (:, :) double;
        
        % Initial state
        x0 (1, :) double;
        % Final state
        xf (1, :) double;

        % Values of the flow and jump maps and sets along solution.
        f_vals (:, :) double;
        g_vals (:, :) double;
        C_vals (:, 1) uint8;
        D_vals (:, 1) uint8;

        % The duration of each interval of flow.
        flow_lengths (:,1) double; 
        % The continuous time of each jump.
        jump_times (:,1) double; 
        shortest_flow_length double;
        total_flow_length double;
        jump_count uint32;

        termination_cause TerminationCause; 
    end

    properties(GetAccess = private, SetAccess = immutable)
        hybrid_system;
        tspan;
        jspan;
    end

    methods
        function this = HybridSolution(t, j, x, f_vals, g_vals, C_vals, D_vals, tspan, jspan)
            checkVectorSizes(t, j, x);
            this.t = t;
            this.j = j;
            this.x = x;
            this.x0 = x(1,:);
            this.xf = x(end,:);
            this.f_vals = f_vals;
            this.g_vals = g_vals;
            this.C_vals = C_vals;
            this.D_vals = D_vals;
            this.jump_times = HybridUtils.jumpTimes(t, j);
            this.total_flow_length = t(end) - t(1);
            this.jump_count = length(this.jump_times);
            this.flow_lengths = HybridUtils.flowLengths(t, j);
            this.shortest_flow_length = min(this.flow_lengths);

            this.termination_cause = TerminationCause.getCause(...
                    this.t, this.j, this.x, this.C_vals, this.D_vals, tspan, jspan);
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

end

% Local functions %

function checkVectorSizes(t, j, x)
    if size(t, 2) ~= 1
        error('HybridSolution:WrongShape', ...
            "The vector t must be a column vector");
    end
    if size(j, 2) ~= 1
        error('HybridSolution:WrongShape', ...
            "The vector j must be a column vector");
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
