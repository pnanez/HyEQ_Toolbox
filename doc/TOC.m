%% Hybrid Equations Toolbox Help
% The Hybrid Equation (HyEQ) Toolbox provides methods in MATLAB and Simulink 
% for computing and plotting numerical solutions to hybrid dynamical systems. 
% 
%% Introduction to Hybrid Systems
% A hybrid system $\mathcal{H}$ with state $x\in \mathbf{R}^n$ 
% is modeled as follows:
% 
% $$ 
% \mathcal{H}: \left\{\begin{array}{rl}
%     \dot x = f(x) & x \in C  
%       \\
%     x^+ = g(x) &x \in D
% \end{array} \right.
% $$ 
% 
% Throughout this documentation, $\mathbf{R}$ denotes the set of real numbers
% and $\mathbf{N} := \{0, 1, \dots\}$ denotes the set of natural numbers.
% 
% The representation of $\mathcal{H}$, above, indicates that the state $x$ can evolve or
% _flow_ according to the differential equation $\dot x = f(x)$ while $x \in C,$
% and can _jump_ according to the difference equation $x^+ = g(x)$ while $x \in D.$
% The function $f : C \to \mathbf{R}^n$ is called the _flow map_, the
% set $C \subset \mathbf{R}^n$ is called the _flow set_, the function $g :
% D \to \mathbf{R}^n$ is called the _jump map_, and the set $D
% \subset \mathbf{R}^n$ is called the _jump set_.
% 
% Roughly speaking, a function $\phi : \mathrm{dom}\:\phi \to \mathbf{R}^n$ is a _solution_ 
% to $\mathcal{H}$ if the following conditions are satisfied:
%  
% # $\phi(0, 0) \in \overline{C} \cup D.$
% # The domain $\mathrm{dom}\:\phi \subset \mathbf{R} \times \mathbf{N}$ is a 
% _hybrid time domain_ where the $\mathbf{R}$ component corresponds to the amount
% of ordinary time $t$ that has elapsed and the $\mathbf{N}$ component
% corresponds to the number $j$ of discrete jumps that have occured.
% # During each interval $[t_j, t_{j+1}]$ such that $t_j < t_{j+1},$ 
% $(t_j, j)\in \mathrm{dom}\:\phi$, and $(t_{j+1}, j+1) \in \mathrm{dom}\:\phi$, the solution $\phi$ satisfies 
% $\frac{d\phi}{dt} = f(\phi(t, j))$ and $\phi(t, j) \in C$ for almost all $t
% \in [t_j, t_{j+1}].$ 
% We call such an interval $[t_j, t_{j+1}]$ an _interval of flow_.
% # At each $(t, j) \in \mathrm{dom}\:$ such that $(t, j+1) \in E$, then
% $\phi(t, j) \in D$ and $\phi(t, j+1) = g(\phi(t, j))$. We call such a $(t, j)$
% a _jump time_.
% 
% For a rigorous definition of hybrid solutions, see Chapter 2 of _Hybrid
% Dynamical Systems_ by Goebel, Sanfelice, and Teel [1]. See also _Hybrid
% Feedback Control_ by Sanfelice [2].
% 
%% Getting Help
% To learn more about a particular component of the toolbox, execute  
% |help [name]| 
% or 
% |doc [name]| 
% in the MATLAB command window, 
% where |[name]| is the name 
% of a class, function, or package
% (|help| prints a short description and |doc| opens the documentation page).
% For example, to learn about |HybridSystem|, run 
% 
%   help HybridSystem
% 
% or 
% 
%   doc HybridSystem
% 
% To report a problem, request a feature, or ask for help, <https://github.com/pnanez/HyEQ_Toolbox/issues/new 
% submit an issue> on our GitHub repository. A webinar introducing the HyEQ Toolbox v2.04 is available 
% <http://www.mathworks.com/videos/hyeq-a-toolbox-for-simulation-of-hybrid-dynamical-systems-81992.html here> 
% (a free MathWorks registration is required).
% 
%% Table of Contents for HyEQ Toolbox Help
% A list of help topics is given below.
% 
% <html><h3>The Hybrid Equations MATLAB Library</h3></html>
% 
% The following pages contain introductory guides for how to use the
% MATLAB-based portion of the Hybrid Equations Toolbox.
% 
% * <matlab:hybrid.internal.openHelp('HybridSystem_demo') 
%       Creating and Simulating Hybrid Systems> 
% * <matlab:hybrid.internal.openHelp('HybridPlotBuilder_demo') 
%       Plotting Hybrid Arcs> 
% * <matlab:hybrid.internal.openHelp('CompositeHybridSystem_demo') 
%       Creating and Simulating Composite Hybrid Subsystems> 
% * <matlab:hybrid.internal.openHelp('ConvertingLegacyCodeToVersion3_demo') 
%       Updating Code Designed for HyEQ Toolbox v2.04 to Use v3.0 Features.> 
% 
% <html><h3>The Hybrid Equations Simulink Library</h3></html>
% 
% The following pages describe how to use the
% Simulink-based portion of the Hybrid Equations Toolbox.
% 
% * <matlab:hybrid.internal.openHelp('Help_SimulinkLibrary') 
%       Introduction to HyEQ Simulink library.>
% * <matlab:hybrid.internal.openHelp('Help_bouncing_ball')
%       Example Hybrid System with External Functions (Bouncing Ball)>
% * <matlab:hybrid.internal.openHelp('Help_bouncing_ball_with_input')
%       Example Hybrid System with Embedded Functions (Bouncing Ball with Input)>
% * <matlab:hybrid.internal.openHelp('Help_coupled_subsystems') 
%       Composing Multiple Hybrid Subsystems (Bouncing Ball on Moving Platform)>
% * <matlab:hybrid.internal.openHelp('Help_behavior_in_C_intersection_D')
%       Defining Behavior in the Intersection of |C| and |D|>
% * <matlab:hybrid.internal.openHelp('help_integrator_system') 
%       The Integrator System>
% 
% <html><h3>Cyber-physical System (CPS) Components</h3></html>
% 
% * <matlab:hybrid.internal.openHelp('CPS_Components') 
%       Introduction to Cyber-physical Component Blocks> 
% * <matlab:hybrid.internal.openHelp('CPS_continuous_plant') 
%       Continuous-time Plant>
% * <matlab:hybrid.internal.openHelp('CPS_zero_order_hold')
%        Zero-Order Hold (ZOH)>
% * <matlab:hybrid.internal.openHelp('CPS_analog_to_digital_converter') 
%       Analog-to-Digital Converter (ADC)>
% * <matlab:hybrid.internal.openHelp('CPS_finite_state_machine')
%       Finite State Machine (FSM)>
% 
% <html><h3>Applications of Hybrid Systems</h3></html>
% 
% * <matlab:hybrid.internal.openHelp('Example_vehicle_on_path') Example 1: 
%       A Vehicle Following a Path>
% * <matlab:hybrid.internal.openHelp('Example_fireflies') Example 2: 
%       Synchronization of Two Fireflies>
% * <matlab:hybrid.internal.openHelp('Example_zoh_feedback_control.html') Example 3: 
%       Sample-and-hold Feedback Control>
% * <matlab:hybrid.internal.openHelp('Example_network_estimation') Example 4: 
%       Estimation over a Network>
%
%% References
% [1] R. Goebel, R. G. Sanfelice, and A. R. Teel, _Hybrid dynamical systems:
% modeling, stability, and robustness_. Princeton University Press, 2012.  
% 
% [2] R. G. Sanfelice, _Hybrid Feedback Control_. Princeton University Press, 2021.


% DEVELOPEMENT NOTES (leave an empty line before this section so that it is
% excluded from published HTML):
% The contents of TOC.m serve as the master copy of the table of
% contents for the HyEQ Toolbox help subsections. 
% The subsections of this file should be
% copied to TOC_matlab.m, TOC_simulink.m, TOC_cps.m, and TOC_examples.m
% when the relevant portion is changed. 
% 
% Note that the section headings of this file are coded using <html> and <h3>
% tags instead of starting the line with "%%". This is to prevent a unwanted
% table of contents to be added at the top of this file. When copying
% subsections to their respective files, the <html><h3> tags must be replaced by
% "%%" to mark the line as the page title.
