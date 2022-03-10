%% Cyber-physical components
% The HyEQ Toolbox includes a series of blocks that model elements 
% of a cyber-physical system (CPS). Those models are special instances 
% of the hybrid systems blocks described above, particularly the blocks 
% that use embedded MATLAB functions.
% A cyber-physical system is given by the interconnection between a physical process, 
% _the plant_, a computer algorithm used for control, _the controller_; 
% and  the subsystems needed to interconnect the plant and the controller, i.e., 
% _the interfaces, converters, and signal conditioners_. 
% Most of the elements described in this section are presented in an extended form in~\cite{San17}.
% 
% In these notes, the temporal evolution of the variables of a cyber-physical system
% are captured using dynamical models.
% In this document, we advocate that hybrid dynamical system models
% can be employed to capture the behavior of cyber-physical systems.
% More precisely, the evolution of the continuous variables is captured by 
% _differential equations_
% while the evolution of the discrete variables is captured by
% _difference equations_.
% These equations are typically nonlinear
% due to the complexity of the dynamics of those variables.
% Furthermore, conditions determining the change of 
% the continuous and discrete variables according to the said
% equations/inclusions can be conveniently captured by functions of the
% variables, inputs, and outputs.  
% The following Simulink blocks for cyber and physical blocks are provided with the HyEQ simulator:
%  
% <<images/CPS_components.png>>
% 

%% Models of physical components
% 
% The physical components of a cyber-physical system include the analog elements, 
% physical systems, and the environment. 
% Consider a model of a physical system given by a differential equation $\dot{x} = f(x,u)$ 
% and a output map $y = h(x,u)$. Among the many possible models available, 
% we capture the dynamics of the physical components
% by using the hybrid systems framework by
% 
% $$
% \begin{array}{ll}
% \dot{x} = f(x,u), & C := \mathbf{R}^n,\\
% x^+ = g(x) =\emptyset, &  D := \emptyset,\\
% y = h(x,u)
% \end{array}
% $$
% 
% This model can be implemented with the |HSu| simulink block found
% <matlab:hybrid.internal.openHelp('SimulinkLibrary_doc.m') at this link> 
% and above.
% 
%% Models of cyber components
% 
% The cyber components of a cyber-physical system 	
% include those in charge of performing computations, 
% implementing algorithms, and transmitting digital data over networks.
% The tasks performed by the code (at the software level) 
% and the logic-based mechanisms (at the circuit level)
% involve variables that only change at discrete events, not necessarily periodically.
% 
% We denote the state
% variable of the cyber components by $x_c \in \Upsilon$, where $\Upsilon \subset \mathbf{R}^{n_C}$ is the state space. 
% The dynamics of $\eta$ are defined by a difference equation with
% right-hand side defined by the map $G_c$. 
% We let $v \in {\cal V} \subset \mathbf{R}^{m_C}$ denote the input signals affecting the cyber components
% and $\zeta\in\mathbf{R}^{r_C}$ to be the output defined by
% the output function $\kappa$, which is a function of the state $x_c$ and
% of the input $v$. With these definitions, the general mathematical
% description of the cyber component is
% 
% $$
% x_c^+ = G_c(x_c,v), \quad \zeta = \kappa(x_c,v)
% $$
% 
% In certain cases, it would be needed to impose restrictions on the state and inputs to the cyber component. 
% Such conditions can be modeled 
% imposing that $x_c$ and $v$ belong to a subset of their state space,
% namely,
% 
% $$
% (x_c,v) \in D_c \subset \Upsilon \times {\cal V}
% $$
% 
% Next, we provide specific constructions of models of cyber components.
% 
% *1. Pure Finite State Machines.*
% A finite state machine (FSM) or deterministic finite automaton (DFA) is a system with
% inputs, states, and outputs taking values from discrete sets 
% that are updated at discrete transitions (or jumps) triggered by its inputs. 
% Then, given a FSM and an initial state $q_0 \in Q$,  
% a transition to a state $q_1 = \delta(q_0,v)$ is performed
% when an input $v \in \Sigma$ is applied to it.
% After the transition, the output of the FSM is updated to $\kappa(q_1)$.
% This mechanism can be captured by the difference equation
% 
% $$ 
%   q^+ = \delta(q,v)  \qquad \zeta  = \kappa(q) \qquad (q,v) \in Q \times \Sigma
% $$
% 
% This model captures the dynamics the model of the cyber components 
% given above with 
% 
% $$
%   x_c = q, \qquad \Upsilon = Q, \qquad 
%   {\cal V} = \Sigma, \qquad G_c = \delta, \qquad D_c = \Upsilon\times{\cal V}
% $$
% 
% Note that there is no notion of ordinary time $t$ associated with the FSM model above. 
% An example of this model is presented in <matlab:hybrid.internal.openHelp('Example_4_1') Example 1.4>.
% In addition, the |FSM| block shown at the top of this pave can be used to model
% these type of systems. 
% 
% *2. Analog-to-Digital Converters.*
% _Analog-to-digital converters_ (ADCs), also called _sampling devices_,
% are commonly used to provide measurements of the physical systems
% to the cyber components. Their main function is to sample their input, which
% is usually the output of the sensors measuring 
% the output $y$, at a given periodic rate $T^*_s$ and to make these samples
% available to the embedded computer. A basic model for a sampling device
% consists of a timer state and a sample state.  When the timer reaches
% the value of the sampling time $T^*_s$, the timer is reset to zero and
% the sample state is updated with the inputs to the sampling device. 
% 
% The model for the sampling device we propose
% has both continuous and discrete dynamics.
% If the timer state has not reached $T^*_s$, then the dynamics are such that the timer state
% increases continuously with a constant, unitary rate. When $T^*_s$ is
% reached, the timer state is reset to zero and the sample state is
% mapped to the inputs of the sampling device. 
% To implement this mechanism, we employ a timer state 
% $\tau_s \in \mathbf{R}_{\geq}$ and a sample state $m_s \in \mathbf{R}^{r_P}$.
% The input to the sampling device is denoted by $v_s \in \mathbf{R}^{r_p}$. 
% The model of the sampling devices is
% 
% $$
% \begin{array}{ll}
% \dot{\tau}_s = 1, \quad \dot{m}_s = 0
%   & \textrm{ when } \tau_s \in [0,T^*_s] \\ 
% \tau_s^+ = 0, \quad  m_s^+ = v_s 
%   & \textrm{ when } \tau_s \geq T^*_s
% \end{array}
% $$
% 
% In practice,
% there exists a time, usually called _the ADC acquisition time_,
% between the triggering of the ADC with the sampling device and the update of its output. Such a
% delay limits the number of samples per second 
% that the ADC can provide. 
% Additionally, an ADC can store and process finite-length digital words, which causes quantization. 
% The model above omits effects such as acquisition delays
% and quantization effects, but those can be incorporated if needed.
% In particular, quantization effects can be added to the ADC model 
% by replacing the update law for $m_s$ to
% $m_s^+ = \textrm{round}(v_s)$, where $\textrm{round}(v_s)$ is the
% closest number to $v_s$ that the machine precision can represent.
% 
% *3. Digital-to-Analog Converters.*
% The digital signals in the cyber components need to be converted
% to analog signals for their use in the physical world.
% A _Digital-to-analog converter_ (DAC) performs such a task 
% by converting digital signals into analog equivalents.
% One of the most common models for a DAC
% is the _zero-order hold_ (ZOH) model. The output of a ZOH
% is updated at discrete time instants, typically periodically,
% and held constant in between updates, until new information is available at the
% next sampling time. We will model DACs as ZOH devices with dynamics
% similar to the ADC model. Let
% $\tau_h\in\mathbf{R}_{\geq}$ be the timer state, $m_h \in \mathbf{R}^{r_C}$ be the
% sample state (note that the value of $h$ indicates the number of DACs
% in the interface), and $v_h \in \mathbf{R}^{r_C}$ be the inputs of the DAC.
% Its operation is as follows. When $\tau_h \leq 0$, the timer state
% is reset to $\tau_r$ and the sample state is updated with $v_h$ (usually
% the output of the embedded computer), where $\tau_r\in[T^{\textrm{min}},T^{\textrm{max}}]$ 
% is a random variable that models the time in-between communication instants and 
% $T^{\textrm{min}}\leq T^{\textrm{max}}$. A model that captures this
% mechanism is given by
% 
% $$ 
% \begin{array}{ll}
% \dot{\tau}_h = -1, \quad
% \dot{m}_h = 0 
% &\textrm{ when } \tau_h \in [T^{\textrm{min}},T^{\textrm{max}}] \\ 
% \tau_h^+  = \tau_r, \quad 
% m_h^+ = v_h  & \textrm{ when } \tau_h \leq T^{\textrm{min}}.
% \end{array}
% $$
% 
% *4. Digital Networks.*
% The information transfer between the physical and cyber components, or between 
% subsystems within the cyber components, might occur over a digital communication network.  
% The communication links bridging each of these components
% are not capable of continuously transmitting information, but rather,
% they can only transmit sampled (and quantized) information at discrete time instants.
% Combining the ideas in the models of the converters in the previous items, 
% we propose a model of a  digital network link that has a variable that 
% triggers the transfer of information provided at its input, and that
% stores that information until new information arrives.
% We assume that the transmission of information occurs at instants 
% $\{t_i\}_{i=1}^{i^*}$, $i^* \in \mathbf{N}\cup \{\infty\}$, satisfying
% $T^{*\min}_{N} \leq t_{i+1}-t_i\,\leq T^{*\max}_{N}$ for all $i\in \{1,2,\ldots, i^*-1\}$
% where $T^{*\min}_{N}$ and $T^{*\max}_{N}$ are constants satisfying 
% $T^{*\min}_{N}, T^{*\max}_{N} \in [0,\infty]$,
% $T^{*\min}_{N} \leq T^{*\max}_{N}$,
% and $i^*$ is the number of transmission events, which might be finite or infinite.
% The constant $T^{*\min}_{N}$ determines the minimum possible time in between 
% transmissions while the constant $T^{*\max}_{N}$ defines the maximum amount of time elapsed between transmissions.
% In this way, a communication channel that allows transmission events at a high rate
% would have $T^{*\min}_{N}$ small (zero for infinitely fast transmissions), 
% while one with slow data rate would have $T^{*\min}_{N}$ large.
% The constant $T^{*\max}_{N}$ determines
% how often transmissions may take place.
% Note that the constants $T^{*\min}_{N}$ and $T^{*\max}_{N}$ can be
% generalized to functions so as to change according to other states or inputs.
% 
% At every $t_i$, the information at the input $v_N$ of the
% communication link is used to update the internal variable 
% $m_N$, which is accessible at the output end of the network
% and remains constant between communication events.
% This internal variable acts as an information buffer, which
% can contain not only the latest piece of information transmitted
% but also previously transmitted information.
% A record of the number of communication events is logged in the internal variable $j_N$. 
% At communication events, the value of $j_N$ gets updated 
% and remains constant in-between events. 
% A mathematical model capturing the said mechanism is given by
% 
% $$ 
% \begin{array}{ll}
% \dot{\tau}_N =\ -1,   \ \
% \dot{m}_N  =\ 0,   \ \
% \dot{j}_N =\ 0 & \textrm{ when } \tau_N \in [0,T^{*\max}_{N}] \\
% \tau_N^+  \in [T^{*\min}_{N},T^{*\max}_{N}],  \ \
% m_N^+ =\ v_N,  \ \
% j_N^+ = j_N+1 &  \textrm{ when } \tau_N \leq 0
% \end{array}
% $$
% 
% Note that the update law for $\tau_N$ at jumps is given in terms of a difference inclusion,
% which implies that the new value of $\tau_N$ is taken from the set $[T^{*\min}_{N},T^{*\max}_{N}]$.
% The dimension of the states and the input would depend on 
% the type of components that connect to and from it, and also the size of data transmitted and buffered.
% Similar to the models proposed for conversion, 
% the model of the digital link does not include delays nor quantization, but
% such effects can be incorporated if needed. 
