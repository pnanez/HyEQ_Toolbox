%% Example 4.2: Estimation Over a Network in Simulink
% In this example, a physical plant, its output digitally transmitted 
% through a network, and a state estimator are 
% modeled in Simulink as a hybrid system.
% Click
% <matlab:hybrid.open({'CPS_examples','Network_1'},'Network_example.slx') here> 
% to change your working directory to the Example 4.2 folder and open the
% Simulink model.

%% Mathematical Model
% 
% Consider a physical process given in terms of the state-space model
%
% $$
% \begin{array}{ll}
% \dot{x}&=A x ,\\
% y&= M x
% \end{array}  
% $$
%
% where $x \in \mathbf{R}^{n_P}$ is the state and $y \in \mathbf{R}^{r_P}$ is the measured output.
% The output is digitally transmitted through a network.
% At the other end of the network, a computer receives the information
% and runs an algorithm that takes the measurements of 
% $y$ to estimate the state $x$ of the physical process.
% 
% We consider an estimation algorithm with a state variable $\hat{x} \in \mathbf{R}^{n_P}$,
% which denotes the estimate of $x$, that is appropriately reset
% to a new value involving the information received.
% More precisely, denoting the transmission times by $t_i$
% and $L$ a constant matrix to be designed,
% the estimation algorithm updates its state as follows
%
% $$
% \hat{x}^+=\hat{x}+L(y-M\hat{x})
% $$
%
% at every instant information is received.
% In between such events, the algorithm
% updates its state continuously so as to match the evolution
% of the state of the physical process, that is, via
%
% $$
% \dot{\hat{x}} = A \hat{x}
% $$
%
% Modeling the network as a hybrid system,
% which, in particular, assumes zero transmission delay,
% the state variables of the entire system are 
% $j_N$, $\tau_N \in \mathbf{R}$, $m_N \in \mathbf{R}^{r_P}$, and $x,\ \hat{x}\in \mathbf{R}^{n_P}$.  
% Then, transmissions occur when $\tau_N \leq 0$, 
% at which events the state of the network is updated via
%
% $$
% \tau_N^+ \in [T^{*\min}_{N},T^{*\max}_{N}],\quad j_N^+ = j_N+1, \qquad m_N^+ = y
% $$
%
% and the state of the algorithm is updated via $\hat{x}^+=\hat{x}+L(y-M\hat{x})$.
% Note that since the state of the physical process does not change at such
% events, we can use the following trivial difference equation to update it at the
% network events:
%
% $$
% x^+ = x
% $$
%
% In between events, the state of the network is updated as
%
% $$
% \dot{\tau}_N = -1, \qquad \dot{j}_N,\dot{m}_N = 0
% $$
%
% the state of the algorithm changes continuously according to $\dot{\hat{x}} = A \hat{x}$, and the 
% state of the physical process changes according to $\dot{x}=A x , y= M x$.
% Based on the equations above, we pick the following data for each of the subsystems in the Simulink Model:
% 
% 
% *Physical process:*
%
% $$ \begin{array}{l@{}l}
% f_P(x, u):= Ax + Bu, \quad
%    &C_P := \mathbf{R}^{n_p}\times\mathbf{R}, \\
% G_P(x, u):= x, \quad
%     &D_P := \emptyset,\\ 
% y = h(x) : =Mx
% \end{array}$$
%
% where 
%
% $$\begin{array}{l@{}l}
% A = 
% \left[\begin{tabular}{cccc} 
% 0&1&0&0\\
% -1&0&0&0\\
% -2&1&-1&0\\
% 2&-2&0&-2
% \end{tabular}\right],\quad
% B = \left[\begin{tabular}{c} 0\\0\\1\\0 \end{tabular}\right],\quad
% M = \left[\begin{tabular}{cccc}1&0&0&0\end{tabular}\right],
% \end{array}$$
%
% $n_p=4$, $r_p=1$, $x \in\mathbf{R}^{n_p}$, $y\in\mathbf{R}^{r_p}$, and $u\in\mathbf{R}$.
% 
% *Network:* 
% 
% $$\begin{array}{l@{}l}
% f(x_N, u_N):= \left[\begin{tabular}{c}
% 0\\0\\-1
% \end{tabular}\right],\quad 
%    &C := \{(x_N,u_N)\mid \tau_N \geq 0 \},\\
% g(x_N, u_N):= \left[\begin{tabular}{c}
% $u_N$ \\ $j_N +1$ \\  $\tau_r$ 
% \end{tabular}\right],\quad 
%     &D :=\{(x_N,u_N)\mid \tau_N \leq 0 \},\\
% y_N = h(x_N) : =x_N
% \end{array}$$
%
% where 
%
% $\tau_r\in[T^{*\min}_{N},T^{*\max}_{N}]$ is a random variable that models the time in-between communication instances. Also, the sate and the input are given by $x_N=(m_N,j_N,\tau_N)\in\mathbf{R}\times\mathbf{R}\times\mathbf{R}$, and $u_N=y\in\mathbf{R}^{r_p}$, respectively.
%
% *Estimator:*
%
% $$\begin{array}{ll}
% f(x_E, u_E):= 
% \left[\begin{tabular}{cc}
% $A$ &0 \\ 0 & 0
% \end{tabular}\right]x_E + \left[\begin{tabular}{c}
% $B$\\0
% \end{tabular}\right]v,\quad
%    &C := \{(x_E,u_E) \mid j_E = j_N \},\\ 
% g((\hat{x},j_E), u_E):= \left[\begin{tabular}{c}
% $\hat{x} + L(m_N-M\hat{x})$\\
% $j_N$
% \end{tabular}\right],\quad
%     &D :=\{(x,u) \mid j_E\in\mathbf{N}\setminus j_N\},
% \end{array}$$
%
% where $L$, which is designed as in [1], is given by
%
% $$\begin{array}{l}
% L := \left[\begin{tabular}{c} 
% 1 \\ -0.9433\\ -0.6773\\1.6274
% \end{tabular}\right],
% \end{array}$$
%
% the input and the state are given by $u_E = (x_N,v) = ((m_N,j_N,\tau_N),v)\in\mathbf{R}\times\mathbf{R}\times\mathbf{R}\times\mathbf{R}$, 
% and $x_E=(\hat{x},j_E)\in\mathbf{R}^{4}\times\mathbf{R}$, respectively. 
% Notice that the estimator block (Estimator) in the Simulink Model 
% is implemented using a regular hybrid system block with embedded functions.
% 
% 
% 
% For each hybrid system in the Simulink Model (Continuous Process, network, and Estimator) we have the following Matlab embedded functions that describe the sets $C$ and $D$ and functions $f$ and $g$.

%% Steps to Run Zero-input Model
% 
% The following procedure is used to simulate the zero-input example using the model in the file |Network_example.slx|:
% 
% * Navigate to the directory <matlab:hybrid.open({'CPS_examples','Network_1'}) Examples/CPS_examples/Network_1>
% (clicking this link changes your working directory).
% * Open
% <matlab:hybrid.open({'CPS_examples','Network_1'},'Network_example.slx') |Network_example.slx|> 
% in Simulink (clicking this link changes your working directory and opens the model).   
% * Double-click the block labeled _Double Click to Initialize_.
% * To start the simulation, click the _run_ button or select |Simulation>Run|.
% * Once the simulation finishes, click the block labeled _Double Click to Plot
% Solutions_. Several plots of the computed solution will open.

% Change working directory to the example folder.
wd_before = hybrid.open({'CPS_examples', 'Network_1'});

% Set seed for random number generator so we have reproducable outputs.
rng(2)

% Run the initialization script.
initialization_exNetwork

% Run the Simulink model.
sim('Network_example')

% Convert the values t, j, and x output by the simulation into a HybridArc object.
solz = HybridArc(tz, jz, z);
solhatz = HybridArc(thatz, jhatz, hatz);

%% Simulink Model
% The following diagram shows the Simulink model of the estimator over a network zero-input example. The
% contents of the blocks *flow map* |f|, *flow set* |C|, etc., are shown below. 
% When the Simulink model is open, the blocks can be viewed and modified by
% double clicking on them.
 open_system('Network_example')
 
%%
% The Simulink blocks for the hybrid systems in this example are included below.
%
%
% *Continuous Process:*
%
% *flow map* |f| *block*
% 
% <include>src/Matlab2tex_CPS_Network_1/f.m</include>
%
% *flow set* |C| *block*
% 
% <include>src/Matlab2tex_CPS_Network_1/C.m</include>
%
% *jump map* |g| *block*
% 
% <include>src/Matlab2tex_CPS_Network_1/g.m</include>
%
% *jump set* |D| *block*
% 
% <include>src/Matlab2tex_CPS_Network_1/D.m</include>
%
% *Network:*
%
% *flow map* |f_network| *block*
% 
% <include>src/Matlab2tex_CPS_Network_1/f_network.m</include>
%
% *flow set* |C_network| *block*
% 
% <include>src/Matlab2tex_CPS_Network_1/C_network.m</include>
%
% *jump map* |g_network| *block*
% 
% <include>src/Matlab2tex_CPS_Network_1/g_network.m</include>
%
% *jump set* |D_network| *block*
% 
% <include>src/Matlab2tex_CPS_Network_1/D_network.m</include>
%
% *Estimator:*
%
% *flow map* |f_Estimator| *block*
% 
% <include>src/Matlab2tex_CPS_Network_1/f_Estimator.m</include>
%
% *flow set* |C_Estimator| *block*
% 
% <include>src/Matlab2tex_CPS_Network_1/C_Estimator.m</include>
%
% *jump map* |g_Estimator| *block*
% 
% <include>src/Matlab2tex_CPS_Network_1/g_Estimator.m</include>
%
% *jump set* |D_Estimator| *block*
% 
% <include>src/Matlab2tex_CPS_Network_1/D_Estimator.m</include>
%

%% Zero-input Example Output
% The solution to the estimation over network system from $z(0,0)=[1, 0.1, 1, 0.6]^\top, \hat{z}(0,0)=[0, 0.5, 0, 0, 0]^\top$, zero input and with
% |T=50, J=50, rule=1| shows that the estimated state approaches the system's state before $t
% = 30$, with a relatively small error.
clf
hpb = HybridPlotBuilder().subplots('on').color('matlab');
hpb.legend({'System state $x_1$','System state $x_2$',...
    'System state $x_3$','System state $x_4$'},'Location', 'best')...
    .plotFlows(solz) 
hold on
hpb.legend({'Estimation $\hat{x}_1$',...
    'Estimation $\hat{x}_2$','Estimation $\hat{x}_3$',...
    'Estimation $\hat{x}_4$'},'Location', 'eastoutside')...
    .plotFlows(solhatz.slice(1:4)) 

%% 

% Close the Simulink file.
close_system 

% Restore previous working directory.
cd(wd_before) 

%% Steps to Run Sinusoidal-input Model
% The following procedure is used to simulate this example using the model in the file |Network_2_example.slx|:
% 
% * Navigate to the directory <matlab:hybrid.open({'CPS_examples','Network_2'}) Examples/CPS_examples/Network_2>
% (clicking this link changes your working directory).
% * Open
% <matlab:hybrid.open({'CPS_examples','Network_2'},'Network_2_example.slx') |Network_2_example.slx|> 
% in Simulink (clicking this link changes your working directory and opens the model).   
% * Double-click the block labeled _Double Click to Initialize_.
% * To start the simulation, click the _run_ button or select |Simulation>Run|.
% * Once the simulation finishes, click the block labeled _Double Click to Plot
% Solutions_. Several plots of the computed solution will open.
% 

% Change working directory to the example folder.
hybrid.open({'CPS_examples','Network_2'});

% Run the initialization script.
initialization_exNetwork_2

% Run the Simulink model.
sim('Network_2_example')

% Convert the values t, j, and x output by the simulation into a HybridArc object.
solz = HybridArc(tz, jz, z);
solhatz = HybridArc(thatz, jhatz, hatz);

%% Simulink Model
% The following diagram shows the Simulink model of the estimator over a network with a sinusoidal input. The
% contents of the blocks *flow map* |f|, *flow set* |C|, etc., are as shown above. 
% When the Simulink model is open, the blocks can be viewed and modified by
% double clicking on them.
 open_system('Network_2_example')

%% Sinusoidal-input Example Output
% The solution to the estimation over network system from $z(0,0)=[1, 0.1, 1, 0.6]^\top, \hat{z}(0,0)=[0, 0, 0, 0, 0]^\top$, 
% u(t)=sin(t),and with
% |T=20|, |J=20|, |rule=1| shows that the estimated state approaches the system's state before $t
% = 10$, with a small error.
clf
hpb = HybridPlotBuilder().subplots('on').color('matlab');
hpb.legend('System state $x_1$','System state $x_2$',...
    'System state $x_3$','System state $x_4$')...
    .plotFlows(solz) 
hold on
hpb.legend({'Estimation $\hat{x}_1$',...
    'Estimation $\hat{x}_2$','Estimation $\hat{x}_3$',...
    'Estimation $\hat{x}_4$'},'Location', 'eastoutside')...
    .plotFlows(solhatz.slice(1:4)) 

%% Modifying the Model
% * The _Embedded MATLAB function blocks_ |f, C, g, D, f_network, C_network, g_network,
%   D_network, f_Estimator, C_Estimator, g_Estimator, D_Estimator| are edited by
%   double-clicking on the corresponding block and editing the script.    
% * The initialization script |initialization_exNetwork.m| is edited by opening the file
%   and editing the script.  
%   The flow time and jump horizons, |T| and |J| are defined as well as the
%   initial conditions for the linear system state, $z_0$, the network state, $\tau_0, j_0,y_0$,
%   and the estimator state, $\hat{z}_0$, and a rule for jumps, |rule|.
% * The postprocessing script |postprocessing_Network.m| is edited by opening the file
%   and editing the script. Flows and jumps may be plotted by calling the
%   functions |plotFlows| and |plotJumps|, respectively. The hybrid arc
%   may be plotted in hybrid time by calling the function |plotHybrid|.   
% * The simulation stop time and other simulation parameters are set to the
%   values defined in |initialization_exNetwork.m| by selecting |Simulation>Configuration
%   Parameters>Solver| and inputting |T|, |RelTol|, |MaxStep|, etc..  
% * The masked integrator system is double-clicked and the simulation horizons
%   and initial conditions are set as desired. 

%% 

% Close the Simulink file.
close_system 

% Restore previous working directory.
cd(wd_before) 

%% References
% [1] F. Ferrante, F. Gouaisbaut, R. G. Sanfelice, and S. Tarbouriech. State estimation of linear systems in
% the presence of sporadic measurements. Automatica, 73:101–109, November 2016.
