%% Hybrid Equations Toolbox Help
% The Hybrid Equation (HyEQ) Toolbox provides methods in MATLAB and Simulink 
% for computing and plotting numerical solutions to hybrid dynamical systems. 
% 
% A list of help topics is given below.
% To learn more about a particular component of the toolbox, execute  
% |help [name]| or |doc [name]| in the MATLAB command window, 
% where |[name]| is the name 
% of a class, function, or package
% (|help| prints a short description and |doc| opens the documentation page).
% For example, to learn about |HybridSystem|, run |help HybridSystem| or |doc
% HybridSystem|. 
% 
% To report a problem, request a feature, or ask for help, <https://github.com/pnanez/HyEQ_Toolbox/issues/new 
% submit an issue> on our GitHub repository. A webinar introducing the HyEQ Toolbox v2.04 is available 
% <http://www.mathworks.com/videos/hyeq-a-toolbox-for-simulation-of-hybrid-dynamical-systems-81992.html here> 
% (a free MathWorks registration is required).
% 
% <html><h2>Using the Hybrid Equations MATLAB Library</h2></html>
% 
% The following pages contain introductory guides for how to use the
% MATLAB-based portion of the Hybrid Equations Toolbox.
% 
% * <matlab:hybrid.internal.openHelp('HybridSystem_demo') 
%       How to Implement and Solve a Hybrid System> 
% * <matlab:hybrid.internal.openHelp('HybridPlotBuilder_demo') 
%       Creating plots with HybridPlotBuilder> 
% * <matlab:hybrid.internal.openHelp('CompositeHybridSystem_demo') 
%       Create and Solve Multiple Interlinked Hybrid Subsystems> 
% * <matlab:hybrid.internal.openHelp('ConvertingLegacyCodeToVersion3_demo') 
%       Update Code Designed for HyEQ Toolbox v2.04 to Use v3.0 Features.> 
% 
% <html><h2> Using the Hybrid Equations Simulink Library</h2></html>
% 
% The following pages describe how to use the
% Simulink-based portion of the Hybrid Equations Toolbox.
% 
% * <matlab:hybrid.internal.openHelp('SimulinkLibrary_doc') 
%       Introduction to HyEQ Simulink library.>
% * <matlab:hybrid.internal.openHelp('Example_1_2')
%       Modeling a Hybrid System with Interpreted Function Blocks (Bouncing Ball)>
% * <matlab:hybrid.internal.openHelp('Example_1_3')
%       Modeling a Hybrid System with Embedded Function Blocks (Bouncing Ball with Input)>
% * <matlab:hybrid.internal.openHelp('Example_1_6') 
%       Composition of Multiple Hybrid Subsystems (Bouncing Ball on Moving Platform)>
% * <matlab:hybrid.internal.openHelp('Example_1_8')
%       Defining Jump/Flow Behavior in the Intersection of |C| and |D|>
% 
% <html><h2>Cyber-physical System (CPS) Components</h2></html>
% 
% * <matlab:hybrid.internal.openHelp('CPS_Components_doc') 
%       Introduction to Cyber-physical Component Blocks.> 
% * <matlab:hybrid.internal.openHelp('Example_ContinuousPlant2.html') 
%       Continuous Plant>
% * <matlab:hybrid.internal.openHelp('Example_4_3')
%        Zero Order Hold (ZOH)>
% * <matlab:hybrid.internal.openHelp('ADC_1') 
%       Analog to Digital Converter (ADC)>
% * <matlab:hybrid.internal.openHelp('Example_4_1')
%       Finite State Machine (FSM)>
% 
% <html><h2>Applications of Hybrid Systems</h2></html>
% 
% * <matlab:hybrid.internal.openHelp('Example_1_5') Example 1: 
%       A Vehicle Following a Path>
% * <matlab:hybrid.internal.openHelp('Example_1_7') Example 2: 
%       Synchronization of Two Fireflies>
% * <matlab:hybrid.internal.openHelp('Example_ContinuousPlant.html') Example 3: 
%       Sample-and-hold Feedback Control>
% * <matlab:hybrid.internal.openHelp('Example_4_2') Example 4: 
%       Estimation over a Network>
%

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
% subsections to their respective files, the <html><h2> tags must be replaced by
% "%%".
