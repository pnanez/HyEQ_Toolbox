%% Updating Code That Was Designed for HyEQ Toolbox v2.04 to Use HyEQ Toolbox v3.0.
% Version 3.0 of the Hybrid Equation Toolbox includes substantial improvements
% to most aspects of the MATLAB-based solver and plotting functions. All code
% written using v2.04 should continue to work on v3.0, but will need to be to
% modified to take advantage of some of the new features. This document
% describes how to make those change. Hybrid systems defined in Simulink can be
% left unmodified, but the plotting of solutions can be updated to
% take advantage of new tools.

%% Defining Hybrid Systems
% In v2.04, a hybrid system was defined by creating four MATLAB function files
% |C.m|, |f.m|, |D.m|, and |g.m| anywhere on the MATLAB search path. Examples
% for the bouncing ball are shown at the end of this section. The only way that
% these four functions are grouped together, as far as MATLAB knows, is that
% they are all be passed together to |HyEQsolver|, e.g., 
% |HyEQsolver(@f, @g, @C, @D, ...)|.
% 
% In v3.0, we introduced the |HybridSystem| class so that all of the data 
% of a hybrid system is encapsulated in a single place. This has numerous
% benfits:
% 
% * All of the data of hybrid system are defined in one place.
% * It is possible to have many hybrid systems defined on the MATLAB path
% without worrying about name conflicts. 
% * It is no longer necessary to use global variables to define constants (see
% |gamma| and |lambda|, below).
% 
% For a detailed description of how to write |HybridSystem| classes, see 
% <matlab:hybrid.internal.openHelp('HybridSystem_demo') How to Implement and Solve a Hybrid
% System>. Now, you might not be interested in rewriting existing code
% but still want to take advantage of new features. As a half-way step, we have
% provided a method for creating a |HybridSystem| object from existing |C.m|,
% |f.m|, |D.m|, and |g.m| files:
% 
%   sys = HybridSystem(@f, @g, @C, @D);
% 
% The |sys| object can then be used just like any other |HybridSystem|. There
% are a couple of disadvantages of this approach, however. Namely, it misses out
% on the advantages associated with defining all of a hybrid system's data in a
% single file, listed above, and the computation of solutions is slower and
% harder to debug. For these reasons, we strongly reccomend writing new
% |HybridSystem| subclasses whenever writing new code.
% 
% *Example Function Files for the Bouncing Ball Hybrid System*
% 
% *C.m*:
% 
%   function in_C = C(x) % Flow set indicator function
%       in_C = x(1) >= 0;
%   end
% 
% *f.m*:
% 
%   function xdot = f(x) % Flow map
%       global gamma
%       xdot = [x(2); gamma];
%   end
% 
% *D.m*:
% 
%   function in_D = D(x) % Jump set indicator function
%       in_D = x1 <= 0 && x2 <= 0
%   end
% 
% *g.m*:
% 
%   function xplus = g(x) % Jump map
%       global lambda
%       xplus = [-x(1) ; -lambda*x2];
%   end

%% Solving Hybrid Systems
% In v2.04, computing a solution required the data of the system, the initial
% condition, time horizons, jump/flow priority, and ODE solver options to
% |HyEQsolver|: 
% 
%   % Initial conditions
%   x0 = [1; 0];
%   
%   % Simulation horizon
%   TSPAN = [0 10];
%   JSPAN = [0 20];
%   
%   % Set the behavior of the simulation in the intersection of C and D.
%   rule = 1;
%   
%   % ODE solver options.
%   options = odeset('RelTol',1e-6, 'MaxStep', 0.1);
%   
%   [t j x] = HyEQsolver(@f, @g, @C, @D, x0, TSPAN, JSPAN, rule, options);
% 
% For v3.0, the above process is split into two steps. First, you define a
% hybrid system, as we did for |sys|, above. Then, call the function |sys.solve| 
% to compute a solution. 
% The function |sys.solve| function takes as arguments |x0|,
% |tspan|, and |jspan|, similar to |HyEQsolver|. Where it differs is in the
% (optional) fourth argument |config|, which is a |HybridSolverConfig| object
% used to define the jump/flow priorty and ODE solver options, as well as
% controlling how progress updates are displayed. 
% To use the ODE option |options = odeset('RelTol',1e-6, 'MaxStep', 0.1);|, 
% given above, define
% 
%   config = HybridSolverConfig('RelTol',1e-6, 'MaxStep', 0.1);
% 
% Then, to set jump priority in the intersection of C and D, call
% |config.priority('jump');| (to set flow priority, this would be
% |config.priority('flow');|). Finally, to compute the solution, call
% 
%   sol = sys.solve(x0, tspan, jspan, config);
% 
% The resulting object is a |HybridSolution| object (which is a subclass of
% the |HybridArc| class). To extract the values of |x, t, j| in order to, say,
% continue using the v2.04 plotting functions, simply call  
% 
%   t = sol.t;
%   j = sol.j;
%   x = sol.x;

%% Plotting Solutions
% Creating plots with v3.0 is easier and more flexible. However, it requires
% that the data you want to plot is contained in a |HybridArc| object (or a
% |HybridSolution| object). If you are still using |HyEQsolver| to compute
% solutions, then your data is in the form of three variables, |t, j, x|.
% You can generate a |HybridArc| from this data by calling 
% 
%   sol = HybridArc(t, j, x);
% 
% Then, the hybrid arc can be plotted using all of the tools described in 
% <matlab:hybrid.internal.openHelp('HybridPlotBuilder_demo') Plotting Hybrid Arcs>.
