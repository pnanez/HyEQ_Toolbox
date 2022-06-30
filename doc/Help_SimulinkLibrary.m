%% Introduction to the Simulink-based Hybrid Equation Simulator
% This document describes the Simulink-based hybrid
% equation simulator from the Hybrid Equations Toolbox, including an introduction
% to the primary components and a description of their internal workings. 
% For documentation regarding cyber-physical components, see 
% <matlab:hybrid.internal.openHelp('CPS_Components') here>. A list of examples are
% available <matlab:hybrid.internal.openHelp('TOC_examples') here>.

%% Primary Components
% The HyEQ Toolbox includes four main Simulink library blocks that allow for simulation of 
% hybrid systems:
% 
% * $\mathcal{H}$ *defined with external functions*. For this block, the data of
% the system $(C, f, D, g)$ are defined as MATLAB functions in plain-text |.m|
% files. This block does not support systems with inputs.
% * $\mathcal{H}$ *defined with external functions and inputs*. 
% This block is the same as the prior one, except that it has inputs.
% * $\mathcal{H}$ *defined with embedded functions*. For this block, the data of
% the system $(C, f, D, g)$ are defined as embedded functions that can only be
% edited within Simulink. This block does not support systems with inputs. 
% * $\mathcal{H}$ *defined with embedded functions and inputs*. This block is the
% same as the prior one, except that it has inputs.
% 
% The following image shows these blocks in the Simulink Library Browser.
% 
% <<images/SimulinkimplementationMac.png>>
% 
% Next, we see inside the Simulink blocks for simulating 
% a hybrid system $\mathcal{H}$ with inputs implemented with using _embedded
% MATLAB function blocks_.  
% 
% <<images/HSinput.png>>
% 
% In this implementation, four blocks are used to define the _data_ 
% of the hybrid system $\mathcal{H}$:
%
% * The flow map is implemented in the embedded function block |flow map f|
% executing the function |f.m|. 
% Its input is a vector with components defining the state of the system $x$,
% and the input $u$. Its output is the value of the flow map $f$ which is
% connected to the  input of an integrator. 
% * The flow set is implemented in the embedded function block |flow set C|. Its
% input is a vector with components $x^-$ and 
% input $u$ of the _Integrator system_.  
% Its output is equal to $1$ if the state belongs to the set $C$ or equal to $0$ otherwise.
% The minus notation denotes the previous value of the variables (before integration). 
% The value $x^-$ is obtained from the state port of the integrator.
% * The jump map is implemented in the embedded function block |jump map g|. Its
% input is a vector with components $x^-$ and 
% input $u$ of the _Integrator system_.  
% Its output is the value of the jump map $g$.
% * The jump set is implemented in the embedded function block |jump set D|. Its
% input is a vector with components $x^-$ and 
% input $u$ of the _Integrator system_.  
% Its output is equal to $1$ if the state belongs to $D$ or equal to $0$ otherwise.

%% Initialization and Postprocessing Scripts
% In the HyEQ Toolbox examples, MATLAB |.m| script files are used to initialize
% variables and plot results.
% The file |initialize.m| is used to define initial variables before simulation and 
% |postprocess.m| is used to plot the solutions after a simulation
% is complete (see "Postprocessing and Plotting solutions", below). 
% 
% These scripts are run automatically when the model is simulated using
% _model callbacks_. 
% To define model callbacks, open the "Modeling" tab in Simulink
% and select the "Modeling Setup" menu and click "Model Properties".  In the
% Model Properties dialog, select the "Callbacks" tab. Use |InitFcn| to specify
% code to run before the Simulink model starts and |StopFcn| to specify code to
% run after the model finishes.
%
% The initialization and postprocessing scripts can also be run by
% double-clicking the blocks labeled "Double Click to..."

%% Initialization
% The script |initialize.m| defines the initial conditions
% of the state components, parameters, 
% the maximum flow time |T|, the maximum number of jumps |J|, 
% and the relative integration tolerance |RelTol|. 
% The following sample code is used to initialize the
% <matlab:hybrid.internal.openHelp('Example_1_2') bouncing ball example>.
% 
% <include>src/Matlab2tex_1_2/initialize.m</include>
%
% After initialization, the simulation is run by clicking the run button 
% or selecting |Simulation>Start|.

%% Block Parameters
% It is important to note that variables called in the 
% _Embedded MATLAB function blocks_
% must be added as inputs and labeled as "parameters". 
% This can be done by opening the embedded function block,
% selecting |Tools>Edit Data/Ports|, and setting the scope to |Parameter|.

%% Postprocessing and Plotting solutions
% A similar procedure is used to define the plots of solutions after the simulation is run. 
% The solutions can be plotted by double-clicking on the block at the top of the Simulink Model 
% labeled _Double Click to Plot Solutions_ which calls the script |postprocess.m|. 
% The script |postprocess.m| may be edited to include the desired postprocessing and solution plots. 
% See below for sample code to plot solutions to the bouncing ball example. 
% The functions used to generate the plots are described in
% <matlab:hybrid.internal.openHelp('HybridPlotBuilder_demo') Creating plots with HybridPlotBuilder>.
% 
% <include>src/Matlab2tex_1_2/postprocess.m</include>

%% Configuring the Integration Scheme
% Using the default integration settings does not always give the most 
% efficient or most accurate simulations. 
% Before a simulation is started, it is sometimes important to change the integrator scheme, 
% zero-cross detection settings, precision, and other tolerances. 
% One way to edit these settings is to open the Simulink Model, 
% select |Simulation>Configuration Parameters>Solver|, 
% and change the settings there. To simplify modifying the values, we have defined variables 
% for configuration parameters in the |initialize.m| file. 
% The last few lines of the |initialize.m| file are shown below.
% 
% <include>src/Matlab2tex/config_inst.m</include>
%
% In these lines, |RelTol = 1e-8| and |MaxStep = 1e-3| define the relative tolerance 
% and maximum step size of the ODE solver, respectively. 
% See
% <https://www.mathworks.com/help/matlab/ref/odeset.html#namevaluepairarguments
% odeset for a description of |RelTol| and |MaxStep|>.
% These parameters can have significant effects on the speed and accuracy of solutions.

%% The Integrator System
% In this section we discuss the internals of the _Integrator System_: 
% 
% <<images/Integrator.png>>

%% Continuous Time (CT) Dynamics
%
% The block containing the Continuous Time (CT) Dynamics is shown here:
% 
% <<images/CTdynamics.png>>
% 
% It defines the CT dynamics by assembling the 
% time derivative of the state $[t\ j\ x^\top]^\top$. 
% States $t$ and $j$ are considered states of the system because 
% they need to be updated throughout the simulation in order to 
% keep track of the time and number of jumps. Without $t$ and $j$, 
% solutions could not be plotted accurately.
% This is given by
% 
% $$
% \dot{t} = 1, \qquad \dot{j} = 0, \qquad \dot{x} = f(x,u).
% $$
% 
% Note that input port $1$ takes the value of $f(x,u)$ through the output of the
% _Embedded MATLAB function block f_.
%% Jump Logic
% The inputs to the jump logic block, shown below, are the output of the blocks _C_ and _D_
% indicating whether the state is in those sets or not, 
% and a random signal with uniform distribution in $[0,1]$. 
% 
% <<images/JumpLogic.png>>
% 
% The variable _rule_ defines whether the simulator gives priority to jumps, 
% priority to flows, or no priority. It is initialized in |initialize.m|.
% 
% The output of the Jump Logic is equal to |1|, triggering a jump, when:
%
% * the output of the _D block_ is equal to one and |rule=1|,
% * the output of the _C block_ is equal to zero, 
%       the output of the _D block_ is equal to one, and |rule=2|,
% * the output of the _C block_ is equal to zero, 
%       the output of the _D block_ is equal to one, and |rule=3|,
% * or the output of the _C block_ is equal to one, 
%       the output of the _D block_ is equal to one, |rule = 3|, 
%       and the random signal $r$ is larger or equal than $0.5$.
% 
% Under these events, the output of this block, which is connected to the integrator external 
% reset input, triggers a reset of the integrator, that is, a jump of $\mathcal{H}$. 
% The reset or jump is activated since the configuration of the reset input is set 
% to "level hold", which executes resets when this external input is equal to one 
% (if the next input remains set to one, multiple resets would be triggered). 
% Otherwise, the output is equal to zero.
% 
%% Update Logic
% 
% The _Update Logic_ block is shown here:
% 
% <<images/UpdateLogic.png>>
% 
% The update logic uses the _state port_ information of the integrator. 
% This port reports the value of the state of the integrator, $[t\ j\ x^\top]^\top$, 
% at the exact instant that the reset condition becomes true. 
% Notice that $x^-$ differs from $x$ since at a jump, 
% $x^-$ indicates the value of the state that triggers the jump, 
% but it is never assigned as the output of the integrator. 
% In other words, $x \in D$ is checked using $x^-$ and if true, 
% $x$ is reset to $g(x^-,u)$. Notice, however, that $u$ is the same because at a jump, 
% $u$ indicates the next evaluated value of the input, 
% and it is assigned as the output of the integrator. 
% The flow time $t$ is kept constant at jumps and $j$ is incremented by one. 
% More precisely,
% 
% $$
% t^+=t^-, \qquad j^+=j^{-}+1,\qquad x^+=g(x^-,u)
% $$
% 
% where $[t^-\ j^-\ {x^-}^\top]^\top$ is the state that triggers the jump. 

%% Stop Logic
% 
% The _Stop Logic_ block is shown here:
% 
% <<images/StopLogic.png>>
% 
% It stops the simulation under any of the
% following events:
%
% * The flow time is larger than or equal to the maximum flow time specified by $T$.
% * The jump time is larger than or equal to the maximum number of jumps specified by $J$.
% * The state of the hybrid system $x$ is neither in $C$ nor in $D$.
% 
% Under any of these events, the output of the logic operator
% connected to the _Stop block_ becomes one, stopping the simulation.
% Note that the inputs $C$ and $D$ are routed from the output of the blocks 
% computing whether the state is in $C$ or $D$ and use the value of $x^-$.
