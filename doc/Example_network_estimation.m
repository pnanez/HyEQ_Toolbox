%% Example 4: Estimation Over a Network
% <html>
%   <!-- This block sets metadata that is used to generate the front matter 
%        for the Jekyll website.-->
%  <meta 
%    id="github_pages"
%    permalink="estimation-over-network" 
%    category="examples"
%   />
% </html>
%
% In this example, a physical plant, its output digitally transmitted 
% through a network, and a state estimator are 
% modeled in Simulink as a hybrid system.

%% 
% The files for this example are found in the <matlab:hybrid.internal.openHelp('MATLAB_packages') package>
% |hybrid.examples.network_estimation|:
% 
% * <matlab:open('hybrid.examples.network_estimation.initialize') |initialize.m|> 
% * <matlab:hybrid.examples.network_estimation.network_est |network_est.slx|>
% * <matlab:open('hybrid.examples.network_estimation.postprocess') |postprocess.m|> 
% 
% The contents of this package are located in
% <matlab:cd(hybrid.getFolderLocation('Examples','+hybrid','+examples','+network_estimation')) |Examples\+hybrid\+examples\network_estimation|>
% (clicking this link changes your working directory). 

%% Mathematical Model
% 
% Consider a physical process given in terms of the state-space model
%
% $$
% \begin{array}{l}
% \dot{x}=A x,\\
% y= M x
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
% y = h(x) := Mx
% \end{array}$$
%
% where 
%
% $$\begin{array}{l@{}l}
% A=\left[\begin{array}{cccc}
% 0 & 1 & 0 & 0 \\
% -1 & 0 & 0 & 0 \\
% -2 & 1 & -1 & 0 \\
% 2 & -2 & 0 & -2
% \end{array}\right],\quad
% B = \left[\begin{array}{c} 0\\0\\1\\0 \end{array}\right],\quad
% M = \left[\begin{array}{cccc}1&0&0&0\end{array}\right],
% \end{array}$$
%
% $n_p=4$, $r_p=1$, $x \in\mathbf{R}^{n_p}$, $y\in\mathbf{R}^{r_p}$, and $u\in\mathbf{R}$.
% 
% *Network:* 
% 
% $$\begin{array}{l@{}l}
% f(x_N, u_N):= \left[\begin{array}{c}
% 0\\0\\-1
% \end{array}\right],\quad 
%    &C := \{(x_N,u_N)\mid \tau_N \geq 0 \},\\
% g(x_N, u_N):= \left[\begin{array}{c}
% u_N \\ j_N + 1 \\ \tau_r 
% \end{array}\right],\quad 
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
% \left[\begin{array}{cc}
% A & 0 \\ 
% 0 & 0
% \end{array}\right]x_E + \left[\begin{array}{c}
% B \\ 0
% \end{array}\right]v,\quad
%    & C := \{(x_E,u_E) \mid j_E = j_N \},\\ 
% g((\hat{x},j_E), u_E):= \left[\begin{array}{c}
% \hat{x} + L(m_N-M\hat{x}) \\
% j_N
% \end{array}\right],\quad
%     &D :=\{(x,u) \mid j_E\in\mathbf{N}\setminus j_N\},
% \end{array}$$
%
% where $L$, which is designed as in [1], is given by
%
% $$\begin{array}{l}
% L := \left[\begin{array}{c} 
% 1 \\ -0.9433\\ -0.6773\\1.6274
% \end{array}\right],
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

%% Steps to Run Model
% 
% The following procedure is used to simulate the example using the model in the file |network_est.slx|:
% 
% * Open
% <matlab:hybrid.examples.network_estimation.network_est |network_est.slx|> 
% in Simulink.   
% * Double-click the block labeled _Double Click to Initialize_.
% * To start the simulation, click the _run_ button or select |Simulation>Run|.
% * Once the simulation finishes, click the block labeled _Double Click to Plot
% Solutions_. Several plots of the computed solution will open.

% Run the initialization script.
hybrid.examples.network_estimation.initialize

% Set seed for random number generator so we have reproducable outputs.
rng(2)

% Run the Simulink model.
warning('off','Simulink:Commands:LoadingOlderModel')
simulink_model_path = which('hybrid.examples.network_estimation.network_est');
sim(simulink_model_path)
close_system
close all

% Convert the values t, j, and x output by the simulation into a HybridArc object.
solz = HybridArc(tz, jz, z);
solhatz = HybridArc(thatz, jhatz, hatz);

%% Simulink Model
% The following diagram shows the Simulink model of the estimator over a network example. The
% contents of the blocks *flow map* |f|, *flow set* |C|, etc., are shown below. 
% When the Simulink model is open, the blocks can be viewed and modified by
% double clicking on them.

% Open .slx model. A screenshot of the subsystem will be
% automatically included in the published document.
model_path = 'hybrid.examples.network_estimation.network_est';
open_system(which(model_path))
 
%%
% The Simulink blocks for the hybrid systems in this example are included below.
%
% <html><h3>Continuous Process:</h3></html>
%
% *flow map* |f| *block*
% 
% <include>src/Matlab2tex_CPS_Network/f.m</include>
%
% *flow set* |C| *block*
% 
% <include>src/Matlab2tex_CPS_Network/C.m</include>
% 
% For more info about _Continuous-time Plant_ blocks, such as *Continuous
% Process*, see 
% <matlab:hybrid.internal.openHelp('CPS_continuous_plant') here>.
%
% <html><h3>Network:</h3></html>
%
% *flow map* |f| *block*
% 
% <include>src/Matlab2tex_CPS_Network/f_network.m</include>
%
% *flow set* |C| *block*
% 
% <include>src/Matlab2tex_CPS_Network/C_network.m</include>
%
% *jump map* |g| *block*
% 
% <include>src/Matlab2tex_CPS_Network/g_network.m</include>
%
% *jump set* |D| *block*
% 
% <include>src/Matlab2tex_CPS_Network/D_network.m</include>
%
% <html><h3>Estimator:</h3></html>
%
% *flow map* |f| *block*
% 
% <include>src/Matlab2tex_CPS_Network/f_Estimator.m</include>
%
% *flow set* |C| *block*
% 
% <include>src/Matlab2tex_CPS_Network/C_Estimator.m</include>
%
% *jump map* |g| *block*
% 
% <include>src/Matlab2tex_CPS_Network/g_Estimator.m</include>
%
% *jump set* |D| *block*
% 
% <include>src/Matlab2tex_CPS_Network/D_Estimator.m</include>
%

%% Example Output
% The solution to the estimation over network system from 
% $z(0,0)=[1, 0.1, 1, 0.6]^\top, \hat{z}(0,0)=[-10, 0.5, 0, 0, 0]^\top$, 
% u(t)=50*sin(0.1*t),and with |T=30|, |J=100|, |rule=1| shows that the estimated
% state approaches the system's state before $t = T$, with a small error.
f = figure(1);
clf
f.Position = [100 100 740 500]; % Increase width
hpb = HybridPlotBuilder().subplots('on').color('matlab');
hpb.legend({'System state $x_1$','System state $x_2$',...
    'System state $x_3$','System state $x_4$'},'Location', 'best')...
    .plotFlows(solz) 
hold on
hpb.legend({'Estimation $\hat{x}_1$',...
    'Estimation $\hat{x}_2$','Estimation $\hat{x}_3$',...
    'Estimation $\hat{x}_4$'},'Location', 'eastoutside')...
    .plotFlows(solhatz.select(1:4)) 

%% 

% Close the Simulink file.
close_system 
warning('on','Simulink:Commands:LoadingOlderModel') % Renable warning.

% Navigate to the doc/ directory so that code is correctly included with
% "<include>src/...</include>" commands.
cd(hybrid.getFolderLocation('doc')) 

%% References
% [1] F. Ferrante, F. Gouaisbaut, R. G. Sanfelice, and S. Tarbouriech. State estimation of linear systems in
% the presence of sporadic measurements. Automatica, 73:101–109, November 2016.
