%% CPS Example: Sample-and-hold Feedback Control for a Continuous Plant
% 
%  
% Click
% <matlab:hybrid.open('CPS_examples/ContinuousPlant','ContinuousPlant_example.slx') here> 
% to change your working directory to the ContinuousPlant folder and open the
% Simulink model.
%%
% Consider a physical process modeled as a linear system of the form 
% $\dot x = Ax + Bu$, defined below. 
% The algorithm (static gain) uses measurements of its output and
% controls the input of the physical process with the goal of steering its state to zero. 
% 
% Suppose the sampling device is ideal and that the signals 
% are connected to the plant via a Digital-to-analog converter (DAC) modeled as follows. The digital
% signals in the cyber components need to be converted to analog signals for their use in the physical world. 
% A DAC performs such a task by converting digital signals into analog equivalents.
% One of the most common models for a DAC is the zero-order hold model (ZOH). In simple terms, a ZOH
% converts a digital signal at its input into an analog signal at its output. Its output is updated at discrete
% time instants, typically periodically, and held constant in between updates, until new information is available
% at the next sampling time. We will model DACs as ZOH devices with similar dynamics. 
% Let $\tau_{h}\in\mathbf{R}_{\geq 0}$ be
% the timer state, $m_h \in R^{rC}$ be the sample state (note that the value of $h$ indicates the number of DACs in
% the interface), and $v_h \in R^{rC}$ be the inputs of the DAC. Its operation is as follows. When $\tau_h \leq 0$, the timer
% state is reset to $\tau_r$ and the sample state is updated with $v_h$ (usually the output of an embedded computer),
% where $\tau_r \in [T_{min} , T_{max}]$ is a random variable that models the time in-between communication instants and
% $T_{min} \leq T_{max}$.
% 
% A model that captures this mechanism is given by 
% $\dot\tau_h = -1, \dot m _h = 0$ when $\tau_h \in [T_{min},T_{max}]$ and 
% $\tau_h^+ = \tau_h, m _h^+ = v_h$ when $\tau_h \leq T_{min}.$

%% Mathematical Model
% <html><h3>Physical Plant</h3></html>
%
% $$\left\{\begin{array}{ll}
% f_P(x,u):= Ax + Bu, & C_P := \mathbf{R}^{2} \times \mathbf{R}^{2} \\ \\
% g_P(x,u):=x, & D_P: = \emptyset, \\ \\
% y = h(x) := x,
% \end{array}\right.$$
%
% where $x = (x_1,x_2)\in\mathbf{R}^{2}$, $u \in\mathbf{R}$, and
%
% $$\begin{array}{lll}
% A := \left[\begin{array}{cc}
%    0 & 1 \\
%    0 & -b/m
%  \end{array}\right] \in \mathbf{R}^{2 \times 2}, & 
% B := \left[\begin{array}{c}
%   1  \\ 1/m
%  \end{array}\right] \in \mathbf{R}^{1 \times 2}. 
% \end{array}$$
%
% <html><h3>Analog-to-digital converter (ADC)</h3></html>
% 
% $$\left\{\begin{array}{ll}
% f(x,u):=\left[\begin{array}{c}
%    0 \\
%    0 \\
%    1
%  \end{array}\right],
%    & C := \{ (x,u) \mid \tau_s \in [0,T_s^*]\} \\ \\
% g(x,u):=\left[ \begin{array}{c} 
%                    u \\
%                    0 
%                \end{array}\right],
%    & D: = \{ (x,u) \mid \tau_s \geq [0,T_s^*]\}, \\ \\
% y = h(x) := x,
% \end{array}\right.$$
%
% where $x = (m_s,\tau_s) \in \mathbf{R}^2 \times \mathbf{R}$, and
% $u\in \mathbf{R}$.
% 
% <html><h3>Zero-Order Hold (ZOH)</h3></html>
% 
% $$\left\{\begin{array}{ll}
% f(x,u):=\left[\begin{array}{c}
%    0 \\
%    1
%  \end{array}\right],
%    & C := \{ (x,u) \mid \tau_s \in [0,T_s^*]\} \\ \\
% g(x,u):=\left[ \begin{array}{c} 
%                    u \\
%                    0 
%                \end{array}\right],
%    & D: = \{ (x,u) \mid \tau_s \geq [0,T_s^*]\}, \\ \\
% y = h(x) := x,
% \end{array}\right.$$
%
% where $x = (m_s,\tau_s) \in \mathbf{R} \times \mathbf{R}$, and
% $u\in \mathbf{R}$.
% 

% Change working directory to the example folder.
hybrid.internal.openExampleFile({'CPS_examples', 'ContinuousPlant'});

% Run the initialization script.
initialization_exContinuousPlant

% Run the Simulink model.
sim('ContinuousPlant_example')

%% Simulink Model
% The Simulink model of the interconnection between the models of the physical
% process, the sampling device, and the DAC is shown below. In
% particular, the output of the DAC is connected to the input |u| of the physical
% process by a matrix gain |K|, while the input |v| of the finite state machine
% is equal to the output |y| of the physical process at every sampling instant. 

% Open ContinuousPlant_example.slx. A screenshot of the subsystem will be
% automatically included in the published document.
open_system('ContinuousPlant_example')

%% Continuous Time Plant
% The Simulink blocks for the plant subsystem in this example are included below.
%
% *flow map* |f| *block*
% 
% <include>src/Matlab2tex_CPS_ContinuousPlant/f.m</include>
%
% *flow set* |C| *block*
% 
% <include>src/Matlab2tex_CPS_ContinuousPlant/g.m</include>
%
% *jump map* |g| *block*
% 
% <include>src/Matlab2tex_CPS_ContinuousPlant/C.m</include>
%
% *jump set* |D| *block*
% 
% <include>src/Matlab2tex_CPS_ContinuousPlant/D.m</include>

%% Analog-to-Digital Converter (ADC)
% The Simulink blocks for the ADC subsystem are included below.
%
% *flow map* |f| *block*
% 
% <include>src/Matlab2tex_CPS_ContinuousPlant/f_ADC.m</include>
%
% *flow set* |C| *block*
% 
% <include>src/Matlab2tex_CPS_ContinuousPlant/g_ADC.m</include>
%
% *jump map* |g| *block*
% 
% <include>src/Matlab2tex_CPS_ContinuousPlant/C_ADC.m</include>
%
% *jump set* |D| *block*
% 
% <include>src/Matlab2tex_CPS_ContinuousPlant/D_ADC.m</include>

%% Zero-Order hold (ZOH)
% The Simulink blocks for the ZOH subsystem in this example are included below.
%
% *flow map* |f| *block*
% 
% <include>src/Matlab2tex_CPS_ContinuousPlant/f_ZOH.m</include>
%
% *flow set* |C| *block*
% 
% <include>src/Matlab2tex_CPS_ContinuousPlant/g_ZOH.m</include>
%
% *jump map* |g| *block*
% 
% <include>src/Matlab2tex_CPS_ContinuousPlant/C_ZOH.m</include>
%
% *jump set* |D| *block*
% 
% <include>src/Matlab2tex_CPS_ContinuousPlant/D_ZOH.m</include>

%% Example output
% A solution to the system in this example is plotted below.
postprocessing_exContinuousPlant

%% 

% Clean up. It's important to include an empty line before this comment so it's
% not included in the HTML. 

% Close the Simulink file.
close_system 

% Change to the doc directory so that the example code is correctly included.
cd(hybrid.getFolderLocation('doc'))

