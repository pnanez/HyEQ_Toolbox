%% Example 1.4: alternate way to simulate the bouncing ball
% In this example, a ball bouncing on a moving platform is 
% modeled in Simulink as a hybrid system with an input, where the input
% determines the height of the platform. <Explain difference from Example 1.3>
% 
% Click
% <matlab:hybrid.open('Example_1.4-Bouncing_Ball_with_Simulink_operator_blocks','Example1_4.slx') here> 
% to change your working directory to the Example 1.4 folder and open the
% Simulink model. 

% Consider the bouncing ball system with a constant input and regular data as 
% given in Example~\IfSAE{1.4}{\ref{ex:bbinput}}. 
% This example shows that a MATLAB function block, 
% such as the jump set {\em D}, 
% can be replaced with operational blocks in Simulink. 
% Figure~\ref{fig:bbblocks} shows this implementation. 
% The other functions and solutions are the same as in 
% Example~\IfSAE{1.4}{\ref{ex:bbinput}}.

% \begin{figure}[ht]
%   \begin{center}
%     {\includegraphics[width=.95\textwidth]{figures/Simulink/HybridSimulatorBBblocks}}
%    \caption{Simulink implementation of bouncing ball example with operator blocks}
% \label{fig:bbblocks}
%   \end{center}
% \end{figure}

% For MATLAB/Simulink files of this example, see Examples/Example\_1.4 and Examples/Example\_1.4.

% \end{example}

%% Steps to Run Model
% 
% The following procedure is used to simulate this example using the model in the file |Example_1_4.slx|:
% 
% * Navigate to the directory <matlab:hybrid.open('Example_1.4-Bouncing_Ball_with_Simulink_operator_blocks') Examples/Example_1.4-Bouncing_Ball_with_Simulink_operator_blocks>
% (clicking this link changes your working directory).
% * Open
% <matlab:hybrid.open('Example_1.4-Bouncing_Ball_with_Simulink_operator_blocks','Example1_4.slx') |Example_1_4.slx|> 
% in Simulink (clicking this link changes your working directory and opens the model).   
% * Double-click the block labeled _Double Click to Initialize_.
% * To start the simulation, click the _run_ button or select |Simulation>Run|.
% * Once the simulation finishes, click the block labeled _Double Click to Plot
% Solutions_. Several plots of the computed solution will open.
% 

% Change working directory to the example folder.
wd_before = hybrid.open('Example_1.4-Bouncing_Ball_with_Simulink_operator_blocks');

% Run the initialization script.
initialization_ex1_4

% Run the Simulink model.
sim('Example1_4')

% Convert the values t, j, and x output by the simulation into a HybridArc object.
sol = HybridArc(t, j, x); %#ok<IJCL> (suppress a warning about 'j')

%% Simulink Model
% The following diagram shows the Simulink model of the bouncing ball. The
% contents of the blocks *flow map* |f|, *flow set* |C|, etc., are shown below. 
% When the Simulink model is open, the blocks can be viewed and modified by
% double clicking on them. <Exaplain operator blocks>

% Open subsystem "HS" in Example1_4.slx. A screenshot of the subsystem will be
% automatically included in the published document.
open_system('Example1_4/HS')

%% Example Output
% Let the input function be $u(t,j) = 0.5$ for $t \in [0, 2.5)$ and $u(t, j) = 0$
% for $t \geq 2.5$, and let $\gamma = 9.81$ and $\lambda=0.8$. 
% The solution to the bouncing ball system from $x(0,0)=[1,0]^\top$ and with
% |T=10, J=20, rule=1| shows that the ball bounces at a height of |0.5| until $t
% = 2.5$, when the platform drops to $0$.

clf
plotFlows(sol)

%%
% The following plot depicts the hybrid arc for the height of the ball in hybrid time. 
clf
plotHybrid(sol.slice(1))     
grid on
view(37.5, 30) 

%% Modifying the Model
% * The _Embedded MATLAB function blocks_ |f, C, g, D| are edited by
%   double-clicking on the block and editing the script. In each embedded function
%   block, parameters must be added as inputs and defined as parameters by
%   selecting |Tools>Edit Data/Ports|, and setting the scope to |Parameter|. For
%   this example, |gamma| and |lambda| are defined in this way.    
% * The initialization script |initialization.m| is edited by opening the file
%   and editing the script.  
%   The flow time and jump horizons, |T| and |J| are defined as well as the
%   initial conditions for the state vector, $x_0$, and input vector, $u_0$, and
%   a rule for jumps, |rule|.
% * The postprocessing script |postprocessing.m| is edited by opening the file
%   and editing the script. Flows and jumps may be plotted by calling the
%   functions |plotflows| and |plotjumps|, respectively. The hybrid arc
%   may be plotted by calling the function |plotHybridArc|.   
% * The simulation stop time and other simulation parameters are set to the
%   values defined in |initialization.m| by selecting |Simulation>Configuration
%   Parameters>Solver| and inputting |T|, |RelTol|, |MaxStep|, etc..  
% * The masked integrator system is double-clicked and the simulation horizons
%   and initial conditions are set as desired. 

%% 

% Clean up. It's important to include an empty line before this comment so it's
% not included in the HTML. 

% Close the Simulink file.
close_system 

% Restore previous working directory.
cd(wd_before) 


