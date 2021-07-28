%% Implementing and Solving a Hybrid System
%% Creating a HybridSystem subclass
% In this tutorial, we walk through how to create and solve a hybrid system 
% using the |HybridSystem| class. To demonstrate, consider the bouncing ball system 
% |ExampleBouncingBallHybridSystem|. The entire bouncing ball implementation will 
% be displayed below followed by a description of the file.

% Print the output of ExampleBouncingBallHybridSystem.m
type("ExampleBouncingBallHybridSystem.m")
%% 
% In the first line of file, "|classdef"| specifies that this file defines a 
% class, "|ExampleBouncingBallHybridSystem"| is the name of the class and "|< 
% HybridSystem"| indicates that this class is a subclass of the |HybridSystem| class, 
% which means it inherits all the methods and properties of that class. Next, 
% we define several variables in the |properties| block and functions in the |methods| 
% block.
% 
% Every subclass of |HybridSystem| must define the |flow_map, jump_map, flow_set_indicator,| 
% and |jump_set_indicator| functions. The indicator functions should return |1| 
% inside the respective set and 0 otherwise.
%% Solving the HybridSystem
% Now that we have an implementation of the |HybridSystem|, we can create an 
% instance of it.

bb_system = ExampleBouncingBallHybridSystem();
%% 
% Values of the properties can be modified using dot indexing on the object:

bb_system.gravity = 3.72;
bb_system.bounce_coeff = 0.5;
%% 
% The |HybridSystem| class defines a |solve| function that can be called on 
% any |HybridSystem| object to compute a solution for a given initial state and 
% time spans (|bb_system| is a |HybridSystem| object because |ExampleBouncingBallHybridSystem| 
% is a subclass of |HybridSystem|).

x0 = [10, 0];
tspan = [0, 30];
jspan = [0, 30];
sol = bb_system.solve(x0, tspan, jspan);
%% 
% The return value of the |solve| method is a |HybridSoltion| object and contains 
% various information about the solution.

sol
%% 
% The continuous time, discrete time, and state values of the solution are stored 
% in |sol.t, sol.j,| and |sol.x|. The HybridSolution object also contains the 
% values of the flow and jump maps along the solution in |f_values| and |g_vals,| 
% and the |C_vals| and |D_vals| contain |0|'s and |1|'s corresponding to where 
% the solution is in the flow and jump sets.
% 
%