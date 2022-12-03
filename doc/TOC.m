%% Hybrid Equations Toolbox Help
% The Hybrid Equation (HyEQ) Toolbox provides methods in MATLAB and Simulink 
% for computing and plotting numerical solutions to hybrid dynamical systems. 
% 
%% Where to Start
% Depending on your prior experience one of the following pages would be a good
% place to start learning how to use the HyEQ Toolbox.
% 
% * If you are unfamiliar with hybrid systems, read
% <matlab:hybrid.internal.openHelp('intro_to_hybrid_systems') 
%   Introduction to Hybrid Systems> 
% for a brief introduction to the mathematical modeling of hybrid systems. 
% * For users of HyEQ Toolbox version 2.40 (and earlier versions), see
% <matlab:hybrid.internal.openHelp('ConvertingLegacyCodeToVersion3_demo') 
%   the guide to quickly converting old code to use new features>.
% * All others should start with the documentation for the  
% <matlab:hybrid.internal.openHelp('TOC_matlab') HyEQ MATLAB library>
% or the <matlab:hybrid.internal.openHelp('TOC_simulink') HyEQ Simulink
% library>.
% 
% A full list of HyEQ Toolbox help pages is given below.

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
% submit an issue> on our GitHub repository.
% 
%% Table of Contents for HyEQ Toolbox Help
% A list of help topics is given below.
% 
% * <matlab:hybrid.internal.openHelp('intro_to_hybrid_systems') Introduction to Hybrid Systems>
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
% * <matlab:hybrid.internal.openHelp('MATLAB_ZOH_example_demo') 
%       Example: Composite Hybrid System with Zero-order Hold Subsystem.> 
% * <matlab:hybrid.internal.openHelp('MATLAB_switched_system_example_demo') 
%       Example: Composite Hybrid System with Switched Subsystem.> 
% 
% <html><h3>The Hybrid Equations Simulink Library</h3></html>
% 
% The following pages describe how to use the
% Simulink-based portion of the Hybrid Equations Toolbox.
% 
% * <matlab:hybrid.internal.openHelp('Help_SimulinkLibrary') 
%       Introduction to HyEQ Simulink library.>
% * <matlab:hybrid.internal.openHelp('Help_bouncing_ball')
%       Example: Hybrid System with External Functions (Bouncing Ball)>
% * <matlab:hybrid.internal.openHelp('Help_bouncing_ball_with_input')
%       Example: Hybrid System with Embedded Functions (Bouncing Ball with Input)>
% * <matlab:hybrid.internal.openHelp('Help_coupled_subsystems') 
%       Example: Composing Multiple Hybrid Subsystems (Bouncing Ball on Moving Platform)>
% * <matlab:hybrid.internal.openHelp('Help_behavior_in_C_intersection_D')
%       Defining Behavior in the Intersection of |C| and |D|>
% * <matlab:hybrid.internal.openHelp('help_integrator_system') 
%       The Integrator System>
% 
% <html><h4>Cyber-physical System (CPS) Components</h4></html>
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
% <html><h3>Other</h3></html>
% 
% * <matlab:hybrid.internal.openHelp('MATLAB_packages') Package Namespaces in the HyEQ Toolbox>
% * <matlab:hybrid.internal.openHelp('changelog') Change Log>
% * <matlab:hybrid.internal.openHelp('acknowledgements') Credits and Acknowledgements>


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
