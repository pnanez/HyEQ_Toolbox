classdef CompoundHybridSystem < HybridSystem
%%% COMPOUNDHYBRIDSYSTEM Creates a hybrid system that consists of two
%%% subsystems. The subsystems are provided as instances of
%%% ControlledHybridSystem with inputs generated by kappa_*C and kappa_*D, 
%%% where kappa_*C are feedbacks used during flows and kappa_*D are used at 
%%% jumps ("*" stands for either "1" or "2"). 
%%%
%%% The state for the compound system consists of [x1; x2; j1; j2] where x1
%%% is the state vector for the first subsystem, x2 is the state vector for
%%% the second subsystem, j1 is the discrete time for the first subsystem,
%%% and j2 is the discrete time for the second subsystem (the two
%%% subsystems jump separately of each other, so we maintain separate discrete 
%%% times).

    properties(SetAccess = immutable)
        subsystem1 ControlledHybridSystem = DummyControlledHybridSystem()
        subsystem2 ControlledHybridSystem = DummyControlledHybridSystem()
        
        % Indicies within the compound state of subsystem1's state 
        x1_indices (1,:) int32
        % Indicies within the compound state of subsystem2's state 
        x2_indices (1,:) int32 
        % Index within the compound state of subsystem1's discrete time.
        j1_index (1, 1) int32 
        % Index within the compound state of subsystem2's discrete time.
        j2_index (1, 1) int32
    end
    
    properties
        % Feedback function for subsystem1 during flows. 
        % Must be set to a function handle with a signiture matching 
        %    u_1C = kappa_1C(x1, x2)
        % The x1 and x2 arguments are the states of the two subsystems.
        kappa_1C
        
        % Feedback function for subsystem2 during flows. 
        % Must be set to a function handle with a signiture matching 
        %    u_2C = kappa_2C(x1, x2)
        % The x1 and x2 arguments are the states of the two subsystems.
        kappa_2C
        
        % Feedback function for subsystem1 at jumps. 
        % Must be set to a function handle with a signiture matching 
        %    u_1D = kappa_1D(x1, x2)
        % The x1 and x2 arguments are the states of the two subsystems.
        kappa_1D
        
        % Feedback function for subsystem2 at jumps. 
        % Must be set to a function handle with a signiture matching 
        %    u_2D = kappa_2D(x1, x2)
        % The x1 and x2 arguments are the states of the two subsystems.
        kappa_2D
    end
    
    methods
        function obj = CompoundHybridSystem(subsystem1, subsystem2) % Constructor
           obj = obj@HybridSystem();
           obj.subsystem1 = subsystem1;
           obj.subsystem2 = subsystem2;
           n1 = subsystem1.state_dimension;
           n2 = subsystem2.state_dimension;
           obj.x1_indices = 1:n1;
           obj.x2_indices = n1+(1:n2);
           obj.j1_index = n1 + n2 + 1;
           obj.j2_index = n1 + n2 + 2;
           obj.state_dimension = n1 + n2 + 2;
        end
    end
    
    methods(Sealed)
        function xdot = flow_map(this, x, t) 
            [x1, x2, j1, j2] = this.split(x);
            x1dot = this.subsystem1.flow_map(x1, this.kappa_1C(x1, x2), t, j1);
            x2dot = this.subsystem2.flow_map(x2, this.kappa_2C(x1, x2), t, j2);
            xdot = [x1dot; x2dot; 0; 0];
        end 

        function xplus = jump_map(this, x, t)  
            [x1, x2, j1, j2] = this.split(x);
            D1 = this.subsystem1.jump_set_indicator(x1, this.kappa_1D(x1, x2), t, j1);
            D2 = this.subsystem2.jump_set_indicator(x2, this.kappa_2D(x1, x2), t, j2);
            if D1
                % If the state is in D1 (possibly in D1 union D2), then a jump
                % given by the subsystem1 jump map occurs.
                x1plus = this.subsystem1.jump_map(x1, this.kappa_1D(x1, x2), t, j1);
                x2plus = x2;
                j1plus = j1 + 1;
                j2plus = j2;
            elseif D2
                % If the state is in D2, then a jump given by the subsystem1 
                % jump map occurs.
                x1plus = x1;
                x2plus = this.subsystem2.jump_map(x2, this.kappa_2D(x1, x2), t, j2);
                j1plus = j1;
                j2plus = j2 + 1;
            else
                % warning("jump_map called for x not in the jump set of either system")
                % We check that the jump maps can be evaluated.
                this.subsystem1.jump_map(x1, this.kappa_1D(x1, x2), t, j1);
                this.subsystem2.jump_map(x2, this.kappa_2D(x1, x2), t, j2);
                xplus = x;
                return
            end
            
            xplus = [x1plus; x2plus; j1plus; j2plus]; 
        end

        function C = flow_set_indicator(this, x, t) 
            [x1, x2, j1, j2] = this.split(x);
            C1 = this.subsystem1.flow_set_indicator(x1, this.kappa_1C(x1, x2), t, j1);
            C2 = this.subsystem2.flow_set_indicator(x2, this.kappa_2C(x1, x2), t, j2);
            % The system can only flow if both subsystems are in their
            % repsective flow sets (priority is honored, if the compound
            % state is in (C union D)).
            C = C1 && C2; 
        end

        function D = jump_set_indicator(this, x, t)
            [x1, x2, j1, j2] = this.split(x);            
            D1 = this.subsystem1.jump_set_indicator(x1, this.kappa_1D(x1, x2), t, j1);
            D2 = this.subsystem2.jump_set_indicator(x2, this.kappa_2D(x1, x2), t, j2);
            % If either subsystem is in a jump set, then a jump can occur 
            % (priority is honored, if the compound state is in (C union D)).
            D = D1 || D2; 
        end
    end

    methods
        
        function sol = solve(this, x1_0, x2_0, tspan, jspan, config)
            % SOLVE Compute the solution to the compound system with the
            % initial state of subsystem1 given by x1_0 and the initial
            % state of subsystem2 given by x2_0. See HybridSystem.solve() for
            % explanation of tspan, jspan, and config.
            
            % We concatenate the subsystem states and inital j-value (twice) to create 
            % the compound state. (The two subsystems can jump at separate times, 
            % so track the jumps for each in the last two components of the 
            % compound state).
            x0 = [x1_0; x2_0; jspan(1); jspan(1)];
            
            if ~exist("config", "var")
                config = HybridSystem.defaultSolverConfig();
            end
            
            sol = this.solve@HybridSystem(x0, tspan, jspan, config);
        end
        
        function [sol, ss1_sol, ss2_sol] = wrap_solution(this, t, j, x, tspan, jspan)
            % Create the HybridSolution object for the compound system.
            sol = this.wrap_solution@HybridSystem(t, j, x, tspan, jspan);
            
            % Next we generate HybridSolution objects for the subsystems.
            ss1 = this.subsystem1;
            ss2 = this.subsystem2;
            [x1, x2, j1, j2] = this.split(x);
            u1 = NaN(length(t), ss1.control_dimension);
            u2 = NaN(length(t), ss2.control_dimension);
            
            % Create arrays is_a_ss1_jump_index and is_a_ss2_jump_index,
            % which contain ones at entry where a jump occured in the
            % corresponding system.
            [~, ~, ss1_jump_indices] = HybridUtils.jumpTimes(t, j1);
            [~, ~, ss2_jump_indices] = HybridUtils.jumpTimes(t, j2);
            is_a_ss1_jump_index = ismember(1:length(t), ss1_jump_indices);
            is_a_ss2_jump_index = ismember(1:length(t), ss2_jump_indices);
            
            % Compute the input values u1 and u2.
            for i = 1:length(t)
                x1_i = x1(i, :)';
                x2_i = x2(i, :)';
                if is_a_ss1_jump_index(i)
                    u1(i, :) = this.kappa_1D(x1_i, x2_i);
                else
                    u1(i, :) = this.kappa_1C(x1_i, x2_i);
                end
                if is_a_ss2_jump_index(i)
                    u2(i, :) = this.kappa_2D(x1_i, x2_i);
                else
                    u2(i, :) = this.kappa_2C(x1_i, x2_i);
                end
            end
            
            % In order to find the TerminationCause for the subsystem
            % solutions, we need to adjust jspan for each so that we only count 
            % jumps in the appropriate subystem. To this end, we calculate the 
            % number of jumps in each subsystem. The results
            % are subtracted from the end of jspan to create jspan1 and
            % jspan2. 
            jump_count1 = j1(end) - j1(1);
            jump_count2 = j2(end) - j2(1);
            jspan1 = [jspan(1), jspan(2) - jump_count2];
            jspan2 = [jspan(1), jspan(2) - jump_count1];
            ss1_sol = generateSubsystemSolution(this.subsystem1, t, j1, x1, u1, tspan, jspan1);
            ss2_sol = generateSubsystemSolution(this.subsystem2, t, j2, x2, u2, tspan, jspan2);
            
            sol = CompoundHybridSolution(sol, ss1_sol, ss2_sol, tspan, jspan);
        end
        
        function [x1, x2, j1, j2] = split(this, x)
            if this.is_single_x_vector(x)
                x1 = x(this.x1_indices);
                x2 = x(this.x2_indices);
                j1 = x(this.j1_index);
                j2 = x(this.j2_index);
            else
                x1 = x(:, this.x1_indices);
                x2 = x(:, this.x2_indices);
                j1 = x(:, this.j1_index);
                j2 = x(:, this.j2_index);
            end
        end
       
    end

    methods(Access = private)

        function b = is_single_x_vector(this, x)
            if size(x, 1) == (this.state_dimension) && size(x, 2) == 1
                b = true;
            elseif size(x, 2) == (this.state_dimension)
                b = false;
            else            
                error("Unexpected size: %s", mat2str(size(x)))
            end
        end
    end
end
        
%%% Local functions %%% 

function ss1_sol = generateSubsystemSolution(subsystem, t, j_ss, x_ss, u_ss, tspan, jspan)
    % Compute the values of the flow and jump maps and sets at each
    % point in the solution trajectory.
    f_ss_vals = NaN(size(x_ss));
    g_ss_vals = NaN(size(x_ss));
    C_ss_vals = NaN(size(t));
    D_ss_vals = NaN(size(t));
    for i=1:length(t)
        x_i = x_ss(i, :)';
        u_i = u_ss(i, :)';
        C_ss_vals(i) = subsystem.flow_set_indicator(x_i, u_i, t(i), j_ss(i));
        D_ss_vals(i) = subsystem.jump_set_indicator(x_i, u_i, t(i), j_ss(i));
        if C_ss_vals(i) % Only evaluate flow map in the flow set.
            f_ss_vals(i, :) = subsystem.flow_map(x_i, u_i, t(i), j_ss(i))';
        end
        if D_ss_vals(i) % Only evaluate jump map in the jump set.
            g_ss_vals(i, :) = subsystem.jump_map(x_i, u_i, t(i), j_ss(i))';
        end
    end
    ss1_sol = ControlledHybridSolution(t, j_ss, x_ss, u_ss, f_ss_vals, g_ss_vals, C_ss_vals, D_ss_vals, tspan, jspan);
end
