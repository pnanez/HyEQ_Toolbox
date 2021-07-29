%% Implementing and Solving a Hybrid System
%% Creating a HybridSystem subclass
% In this tutorial, we walk through how to create and solve a hybrid system 
% using the |HybridSystem| class. To demonstrate, consider the bouncing ball system 
% |ExampleBouncingBallHybridSystem|. The entire bouncing ball implementation will 
% be displayed below followed by a description of the file.

% Print the output of ExampleBouncingBallHybridSystem.m
type("ExampleBouncingBallHybridSystem.m")
%% 
% In the first line of file, |"classdef"| specifies that this file defines a 
% class, |"ExampleBouncingBallHybridSystem"| is the name of the class and |" < 
% HybridSystem"| indicates that this class is a subclass of the |HybridSystem| class, 
% which means it inherits all the methods and properties of that class. Next, 
% we define several variables in the |properties| block and functions in the |methods| 
% block.
% 
% Every subclass of |HybridSystem| must define the |flow_map, jump_map, flow_set_indicator,| 
% and |jump_set_indicator| functions. The indicator functions should return |1| 
% inside their respective sets and 0 otherwise.
%% Solving the HybridSystem
% Now that we have an implementation of the |HybridSystem|, we can create an 
% instance of it.

bb_system = ExampleBouncingBallHybridSystem();
%% 
% Values of the properties can be modified using dot indexing on the object:

bb_system.gravity = 3.72;
bb_system.bounce_coeff = 0.5;
%% 
% To compute a solution, pass the initial state and time spans to the 
% |solve| function (defined in the |HybridSystem| class; |bb_system| is a 
% |HybridSystem| object because |ExampleBouncingBallHybridSystem| 
% is a subclass of |HybridSystem|).

x0 = [10, 0];
tspan = [0, 30];
jspan = [0, 30];
sol = bb_system.solve(x0, tspan, jspan);
%% Interpreting the Solution
% The return value of the |solve| method is a |HybridSoltion| object and contains 
% various information about the solution.

sol
%% 
% A description of each HybridSolution property is as follows:
%
% * |t|: The continuous times at each entry of the solution.
% * |j|: The discrete times at each entry of the solution.
% * |x|: The state vector at the solution.
% * |x0|: The initial state of the solution.
% * |xf|: The final state of the solution.
% * |f_vals|: The value of the flow map at each point along the solution.
% * |g_vals|: The value of the jump map at each point along the solution.
% * |C_vals|: The value of the flow set indicator function at each point
% along the solution. When the solution is in the flow set, |C_vals| has a
% value of |1|, otherwise it is |0|.
% * |D_vals|: The value of the jump set indicator function at each point
% along the solution. When the solution is in the jump set, |D_vals| has a
% value of |1|, otherwise it is |0|.
% * |flow_lengths|: the durations of each interval of flow.
% * |jump_times|: the continuous times when each jump occured.
% * |min_flow_length|: the length of the shortest interval of flow.
% * |total_flow_length|: the length of the entire solution in continuous time.
% * |jump_count|: the number of discrete jumps.
% * |termination_cause|: the reason that the solution terminated. 
%
% The possible values for |termination_cause| are 
% 
% * |STATE_IS_INFINITE|,  
% * |STATE_IS_NAN|, 
% * |STATE_NOT_IN_C_UNION_D|,  
% * |T_REACHED_END_OF_TSPAN|, 
% * |J_REACHED_END_OF_JSPAN|, and  
% * |NO_CAUSE| (the only expected reason for this to occur is if the solver
% was canceled).
%