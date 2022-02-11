    %% Example: Bouncing ball with Lite HyEQ Solver
% The example below shows how to use the HyEQ solver to simulate a bouncing ball.
% Consider the hybrid system model for the bouncing ball with 
% data given in Example 1.1 in the instructions file.

%%
% For this example, we consider the ball to be bouncing on a floor at zero height. 
% The constants for the bouncing ball system are |\gamma = 9.81| and |\lambda=0.8|.
% The following procedure is used to simulate this example in the Lite HyEQ Solver:
% 
% * Inside the MATLAB script |run.m|, initial conditions, simulation horizons, 
%       a rule for jumps, ode solver options, and a step size coefficient are defined. 
%       The function |HyEQsolver.m| is called in order to run the simulation, 
%       and a script for plotting solutions is included.
% * Then the MATLAB functions |f.m, C.m, g.m, D.m| 
%       are edited according to the data given above.
% * Finally, the simulation is run by clicking the run button in |run.m| 
%       or by calling |run.m| in the MATLAB command window.

wd_before = hybrid.openExampleFolder('Example_1.2-Bouncing_Ball');
run_ex1_2 

%%
% A solution to the bouncing ball system from 
% $x(0,0)=[1,0]^\top$ and with 
% |TSPAN = [0 10], JSPAN = [0 20], rule = 1|, 
% is depicted in Figure~\ref{fig:lite-1} (height) 
% and Figure~\ref{fig:lite-2} (velocity).  
% Both the projection onto $t$ and $j$ are shown. 
% Figure~\ref{fig:lite-3} depicts the corresponding hybrid arc for the position state.
% 
%% Figure 1
%   \includegraphics{figures/Example_1_2/FlowsAndJumpsHeight}
%   \includegraphics[width=0.48\textwidth]{figures/Example_1_2/FlowsAndJumpsVelocity}
% \caption{Solution of Example \ref{ex:bblite}
% 
%% Figure 2
%     \includegraphics[width=.8\textwidth]{figures/Example_1_2/plotHybrid.eps}
%     \caption{Hybrid arc corresponding to a solution of Example~\ref{ex:bblite}
%       %TODO: Replace figures with labels formatted using LaTeX interpreter.
%     }
%     \label{fig:lite-3}
%   \end{center}
% \end{figure} 
%%
% The MATLAB source code for this example, located at 
% <matlab:hybrid.openExampleFolder('Example_1.2-Bouncing_Ball') Examples/Example_1.2-Bouncing_Ball>, 
% is included below.

%% Example Code
% *run_ex1_2.m:*
%
% <include>../Examples/Example_1.2-Bouncing_Ball/run_ex1_2.m</include>
%
% *f_ex1_2.m:*
% 
% <include>../Examples/Example_1.2-Bouncing_Ball/f_ex1_2.m</include>
%
% *C_ex1_2.m:*
% 
% <include>../Examples/Example_1.2-Bouncing_Ball/C_ex1_2.m</include>
%
% *g_ex1_2.m:*
% 
% <include>../Examples/Example_1.2-Bouncing_Ball/g_ex1_2.m</include>
%
% *D_ex1_2.m:*
% 
% <include>../Examples/Example_1.2-Bouncing_Ball/D_ex1_2.m</include>

cd(wd_before)