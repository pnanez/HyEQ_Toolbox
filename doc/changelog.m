%% Change Log for the Hybrid Equations Toolbox
%% Version 3.1
% Changes in version 3.1.
% 
% * Added |HybridArc.interpolateToArray| and |HybridArc.interpolateToHybridArc|.
% * Added |HybridArc.is_jump_start|, |HybridArc.is_jump_end|,
% |HybridArc.jump_start_indices|, and |HybridArc.jump_end_indices|. 
% * Deprecated |HybridArc.jump_indices|.
% * Added |HybridPlotBuilder.reorderLegendEntries|,
% |HybridPlotBuilder.circshiftLegendEntries|, |HybridPlotBuilder.legendOptions|. 
% * Changed behavior of |HybridPlotBuilder| legend options so that the default
% options are used regardless of options used in current legend. *This means
% that legend options must be set in the last call to |HybridPlotBuilder.legend|
% or by calling |HybridPlotBuilder.legendOptions| after all legends are added.*
% * Added |HybridPlotBuilder.plotTimeDomain| for plotting hybrid time domains.
% * Added |HybridPlotBuilder.flowMarker| and |HybridPlotBuilder.flowMarkerSize|
% to control markers drawn at each time step during flows (default is no marker).
% * Change |HybridSystem| verification so that no error is thrown during inital
% checks if |C(x0)=0| and |f(x0)| raises an error (similarly, no error is thrown
% if |D(x0)=0| and |g(x0)| raises an error). 
% * Improved error checking and messages.
% * Fix some typos in the documentation (see Issue #88)
% * Add array preallocation to |HyEQsolver| to speed up computations with many
% time steps and large state spaces.
% * Change default |'refine'| setting for |HybridSolverConfig| to |1|. 
% * See GitHub issues for a list of fixed bugs (in particular, #92.

%% Version 3.0
% Version 3.0 of the Hybrid Equations Toolbox is a substantial update to 
% components throughout the toolbox. 
% 
% <html><h3>MATLAB-based Library</h3></html> 
% 
% The following improvements were made to the MATLAB-based Hybrid System solver:
%
% *Object-Oriented Definitions of Hybrid Systems.* A hybrid system can now 
% be defined in a single file by creating a subclass of the |HybridSystem| class. 
% This allows for the definition of multiple hybrid systems without name conflicts 
% and enables the definition of system parameters without using global variables.
% 
% *Interconnected Hybrid Systems.* It is now possible, in MATLAB, to define 
% several hybrid subsystem systems with inputs and outputs, such as a plant and 
% a controller, then link them together to form a composite hybrid system. 
% Solutions to the composite system can be computed like any other system.
% 
% *More Informative Solutions.* The new |HybridSolution| class includes additional 
% useful information about solutions such as the duration of each interval of 
% flow and the reason the solution terminated. Methods are provided for modifying 
% solution objects by, e.g., applying a map to transform the state values or truncating 
% the time span. 
% 
% *Improved Progress Updates.* While computing solutions, a progress bar displays 
% the percent completed and the current hybrid time. The progress updates during 
% both flows and at jumps (in v2.04, progress updates were only printed to the 
% command line at jumps).
% 
% *Improved Plotting.* Plotting hybrid arcs is easier and allows more control 
% over the appearance of plots. New features include 
% 
% # easy control of the marker 
% and line styles for flows and jumps, 
% # ability to hide portions of hybrid 
% arcs from plots using a filter (useful for plotting different modes in different 
% styles),
% # support for legends, 
% # automatic creation of subplots for hybrid 
% arcs with multiple components, and 
% # ability to set default plot settings. 
% 
% Plotting methods are up to 200x faster than in v2.04 for hybrid arcs with many 
% jumps.
% 
% *Bug Fix.* Fixed a bug in v2.04 where |HyEQsolver| would sometimes 
% generate solutions that erroneously flowed outside $C$.
% 
% *Validation and error reporting.* New error checking features catch programming 
% mistakes earlier when using the toolbox. Over 350 automated tests verify the 
% correctness of the toolbox's code.
% 
% *Code Autocompletion.* The Hybrid Equations Toolbox supports MATLAB's auto-completion 
% (introduced to the MATLAB code editor in R2021b).
%%
% 
% <html><h3>Simulink-based Library</h3></html> 
% 
% The following improvements were made to the Simulink-based 
% Hybrid System solver:
% 
% *Hybrid System with External Functions and Inputs.* A new Simulink block
% allows for a hybrid system with an input to be defined using plaintext |.m| 
% MATLAB function files to specify $f, g, C,$ and $D$.
% 
% *Block Parameters.* Simulink block masks were added to the
% HyEQ blocks to allow users to set block parameters without needing to modify
% anything inside the block. Parameters are now set in a popup dialog that opens
% when each block is clicked.
% 
% *Instructions for How To Use Blocks.* Each block in the HyEQ Simulink library
% now includes instructions in the popup dialog that opens when the block is
% clicked.
% 
% *Signal Sizes.* HyEQ Simulink library blocks now determine the signal sizes
% for inputs and outputs to help identify errors and aid in debugging.

%% 
% 
% <html><h3>General Improvements</h3></html> 
% 
% The following updates apply to the entire toolbox:
%
% * *Easier Installation and Updates*. v3.0 is packaged using MATLAB's toolbox 
% packaging, so it can be installed and updated automatically through MATLAB's 
% Add-on manager.
% * *Backward Compatibility.* All code that works in Toolbox version 2.04 is 
% expected to work in v3.0 without modification. Version 3.0 is compatible with 
% MATLAB versions back to R2014b.
% * *Improved Help Files and Example.* All documentation for the HyEQ Toolbox 
% has been redone to make it easier to access and navigate in MATLAB Help.

%% Changes Between Builds
% *3.0.0.66* $\to$ *3.0.0.68*
% (Built September 21, 2022)
% 
% * Improve HybridSystem assertion functions.
% * Replace 'Double click to...' blocks in Simulink library with blocks that
% set model callback functions.
% * Minor improvements to documentation.
%
% *3.0.0.56* $\to$ *3.0.0.66*
% (Built August 30, 2022)
% 
% * Fix tests and examples that failed on R2014b, R2015a, R2016a, and R2016b.
%
% *3.0.0.50* $\to$ *3.0.0.56*
% (Built August 25, 2022)
% 
% * RENAMED: |HybridArc.slice| to |HybridArc.select| (|HybridArc.slice| will 
% print a deprecation warning, if used).
% * DEPRECATED: |HybridPlotBuilder.slice| (use |HybridArc.select| instead).
% * Misc. improvements to documentation and warning messages.
% * Fixed: Errors that occured if the active figure was closed while
% HybridPlotBuilder was currently creating a plot.
% * Fixed: Allow |t| and |j| labels to be disabled in HybridPlotBuilder.
% * Updated HybridPlotBuilder.plotJumps and .plotHybrid to hide
% decimal-valued tick marks for the |j| axis.
% * Add step to toolbox configuration to open and save the Simulink library
% file. This prevents warnings that say it was last saved on an old version of
% Simulink, and mitigates an Simulink defect where the mask dialogs are laid out
% incorrectly.


%%
% *3.0.0.40* $\to$ *3.0.0.50*
% (Built July 5, 2022)
% Simulink Library:
% 
% * Refactor how parameters are passed to Hybrid System Simulink blocks.
% * Change to using linked blocks for library blocks except for Hybrid
% Systems with Embedded Functions, Finite State Machines, and Continuous
% Plants.
% * Use dropdown menu for Flow/Jump priority option in Hybrid System
%   blocks.
% * Added Integrator System as a block in the Simulink library. All
%   instances are now linked copies of the library version.
% * Add field datatype hints for fields in mask dialogs.
% * Add signal size data to hybrid system blocks to help with debugging. 
%
% *3.0.0.33* $\to$ *3.0.0.40*
% (Built March 26, 2022)
%
% * Moved documention source files to doc/src.
% * Reoraganized help files and switched from using LaTeX to MATLAB Publish.
% * Added missing documentation for CPS examples.
% * Added tests for examples to check that they run.
% * Fixed links from examples to documentation
% * In Simulink example models, made it so initialization and postprocessing 
% happens automatically.
%
% *3.0.0.22* $\to$ *3.0.0.33* 
% (Built February 2, 2022)
%
% * *In |HybridSolution| and |CompositeHybridSolution|: the behavior of |length| 
% and |numel| functions changed*. In previous builds, for a |HybridSolution| |sol,| 
% then |length(sol)| gave the number of time-steps in the solution, and for a 
% |CompositeHybridSolution| |comp_sol|, both |length(comp_sol)| and |numel(comp_sol)| 
% gave the number of subsystems. From now on, |length| and |numel| will have the 
% default MATLAB behavior by returning the length and number of elements in arrays. 
% Added |CompositeHybridSolution.subsys_count| and |CompositeHybridSystem.subsys_count| 
% to get the number of subsystems.
% * Improved and reorganized the documentation. All of the documentation is 
% now found in the "doc" folder and can be accessed through MATLAB Help (F1). 
% Added links to PDF files for documents compiled from LaTeX.
% * Fixed tests that were failing on R2014b.
% * Removed development files from deployed toolbox package (reduced installation 
% size by half!)
%
% *3.0.0.20* $\to$ *3.0.0.22* 
% (Built November 19, 2021)
%
% * |HybridSubsystem|: Added support for defining separate output functions 
% for flows and jumps.
% * Added functions to |HybridSystem| and |HybridSubsystem| to check that the 
% data for a given hybrid (sub)system return values of the correct sizes and to 
% assert that particular points are or are not inside $C$ or $D$. See |checkFunctions|, 
% |assertInC|, |assertInD|, |assertNotInC|, and |assertNotInD.|
% * Changed installation process so that autocomplete is disabled until |configure_toolbox| 
% is run (a prompt is shown in |GettingStarted|). Previously, users on older versions 
% of MATLAB had to run |configure_toolbox| to disable autocompletions or else 
% see errors in the command line.
% * Added functions for transforming |HybridSolution| objects. See |HybridSolution.transform|, 
% |HybridSolution.select|, |HybridSolution.restrictT|, and |HybridSolution.restrictJ.|
% * Reorganized files.
%
% *3.0.0.13* $\to$ *3.0.0.20* 
% (Built November 4, 2021)
% 
% Changes to |HybridPlotBuilder:|
%
% * Labels and titles can now be given as cell arrays.
% * Replaced |HybridPlotBuilder.plot()| function with |HybridPlotBuilder().plotPhase()| 
% for plotting the trajectory of state values through state space. (Previously, 
% |plot| automatically selected whether to make |plotFlows| and |plotPhase| style 
% plot based on the dimension of the state space. This is no longer supported.)
% * Added ability to set multiple colors in |HybridPlotBuilder| so that if auto-subplots 
% are off, each component is drawn in a different color. Modified |HybridPlotBuilder.configurePlots()| 
% to take a function handle with two arguments, instead of one. The (new) first 
% argument is the axes to configure and the second is the component index (previously 
% the only argument).
% * Renamed |HybridPlotBuilder.autoSubplots| method to |HybridPlotBuilder.subplots| 
% and changed the default value to |'off'|. For a |HybridSolution| object |sol|, 
% calling |plotFlows(sol)|, |plotJumps(sol)|, or |plotHybrid(sol)| (without prefixing 
% "|HybridPlotBuilder.")| automatically selects whether automatic subplots are 
% on or off based on the dimension of the system.
%
% Changes to |HybridSolverConfig:|
%
% * Added option to set flow or jump priority in |HybridSolverConfig| as |config.priority('flow') 
% and config.priority('jump'), respectively|.
% * Removed |HybridSolverConfig.flowPriority| and |HybridSolverConfig.jumpPriority| 
% methods. Use |HybridSolverConfig.priority('flow')| and |HybridSolverConfig.priority('jump')| 
% instead
%
% Changes to |HybridSubsystemSolution| (previously  |HybridSolutionWithInput|)|:|
%
% * Added output values |y|.
%
% Miscellaneous Changes
%
% * Added autocomplete information for |HyEQsolver|, |Hybridsystem|, |CompositeHybridSystem|, 
% |HybridSolution|, |HybridPlotBuilder|, |HybridSubsystem, HybridSolverConfig,| 
% and |HybridSystemBuilder.build| (Try it in the MATLAB 2021b code editor!)
% * Extended compatibility back to MATLAB 2014b.
% * Removed |HybridSolution.fromLegacy(t, j, x, f, g, C, D, tspan, jspan)| function. 
% Use |HybridSolution(t, j, x, C, D, tspan, jspan)| instead.
% 
% *3.0.0.11* $\to$ *3.0.0.13*
% 
% In |HybridPlotBuilder:|
%
% * It is now possible to chain calls to |HybridPlotBuilder| functions, such 
% as |HybridPlotBuilder().plotflows(sol1).plotflows(sol2)|. This means it is often 
% unnecessary to save the |HybridPlotBuilder| object to a variable.
% * Changed how adding legends works in |HybridPlotBuilder|.
% * Fixed how the label and title are selected when automatic subplots is off. 
% * Fix x-axis limits when using subplots. (Previously, the x limits did not 
% updated when subsequent plots were added after the first)
% * Renamed |configureSubplots| in |HybridPlotBuilder| to |configurePlots|. 
% The given function is now called in 2D and 3D phase plots, and when automatic 
% subplots are off, as well as the other plotting functions.
% * Add default configuration to |HybridPlotBuilder| (Still a work in progress!).
%
% In |CompositeHybridSystem| (Previously |CompoundHybridSystem|)
%
% * Renamed |CompoundHybridSystem| to |CompositeHybridSystem.|
% * subsystems can now be referenced by ordinal number, object reference, or 
% by name (if given in constructor) when setting inputs and referencing subsystem 
% solutions. 
% * The output functions for |HybridSubsystems| can now be a function of |x|, 
% |u|, |t|, and/or |j|, instead of only |x|. 
% * Input and output functions must be given as anonymous functions and unused 
% arguments should be marked as ignored by replacing the argument name with a 
% tilde (~). 
% * Input functions can omit arguments from the end of their argument list any 
% arguments (i.e., unneeded output values from other subsystems). 
% * The way the dimensions and output of |HybridSubsystem| subclasses are set 
% has changed.
%
% Miscellaneous changes
%
% * Automated toolbox tests can be run by calling |hybrid.tests.run()|.
%
% *3.0.0.6* $\to$ *3.0.0.11*
% 
% Name changes (see the |rename_variables.sh| script for automatic renaming 
% for all occurances)
%
% * Renamed all method names to use camelCase naming. That is, we renamed |flow_map| 
% to |flowMap, jump_map| to |jumpMap|, |plotflows| to |plotFlows| etc. (Functions 
% from v2.04 are left unchanged for backward compatibility)
% * |ControlledHybridSystem| to |HybridSubsystem|
% * |ControlledHybridSolution| to |HybridSolutionWithInput|
% * |control_dimension| to |input_dimension| in |HybridSubsystem|
% * |plotHybridArc| to |plotHybrid| in |HybridPlotBuilder|.
%
% Changes in |HybridSystem|
%
% * A |HybridSystem| object can now be created from function handles |@f, @g, 
% @C, @D| simply by calling |sys = HybridSystem(@f, @g, @C, @D).|
% * Add checks if the |"this"| argument is missing from |flowMap(this, x, t, 
% j), jumpMap(this, x, t, j),| etc.
% * In |solve(), a|dd default values |tspan=[0, 10]| and |jspan=[0, 10].|
%
% Changes in |HyEQsolver|
%
% * Rewrote solver algorithm 
% * Fixed all known bugs!
% * Fix: close progress bar regardless of how |HyEQsolver| exits.
%
% Changes in |CompoundHybridSystem| and |HybridSubsystem| (previously |ControlledHybridSystem)|
%
% * Add output function to |HybridSubsystem| class.
% * Rewrote |CompoundHybridSystem| to support an arbitrary number of subsystems.
% * Add |PairHybridSystem| to support faster computations and cleaner code for 
% systems with only two subsystems.
% * Renamed |HybridSubsystem| property from "|control_dimension|" to "|input_dimension|"
%
% Changes in |HybridPlotBuilder|
%
% * Fix: legends now correctly placed in subplots.
% * Add padding to top and bottom of plots made with |plotFlows|, and |plotJumps.|
% * Add |configureSubplots| function to allow the full range of plot customization 
% offered by MATLAB.
% * Add |autoSubplots| function to set whether subplots are automatically created 
% for each state component.
% * Fixed linking between 3D subplots generated by |plotHybrid| so they rotate 
% and pan together.
% * Improved plotting speed by up to ~200x.
% * Add |addLegendEntry| function to include plots in the legend that were not 
% created by |HybridPlotBuilder|. 
%
% Miscellaneous changes
%
% * Add ability to set ode solver options such as "AbsTol" and "MaxStep" via 
% arguments to the |HybridSolverConfig| constructor, as well as "silent" to disable 
% progress bar.
% * In |HybridSolution,| removed the values of f, g, C, and D along solutions. 
% Instead, they can be computed as need using |HybridSystem.generateFGCD()|. To 
% compute the values of an arbitrary vector-valued function along a solution, 
% use |HybridSolution.evaluateFunction()|.
% * Move several functions from |HybridUtils| the |hybrid.internal| package.
% * Make |hybrid.interal.jumpTimes| returns the values of $j$ and indices immediately 
% before a jump, instead of immediately after.
% * Expanded documentation and unit tests.