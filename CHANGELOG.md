# HyEQ Toolbox Change Log

This file documents changes to the Hybrid Equations Toolbox between versions.

## New Features in Version 3.0
Version 3.0 of the Hybrid Equations Toolbox is a substantial update to 
components throughout the Toolbox. This section describes changes between v2.04 and v3.0 (all changes preserve backwards compatibility with existing code that uses v2.04).

### **MATLAB-based Library**
 
 The following improvements were made to the MATLAB-based Hybrid System solver:

 **Object-Oriented Definitions of Hybrid Systems.** A hybrid system can now 
 be defined in a single file by creating a subclass of the `HybridSystem` class. 
 This allows for the definition of multiple hybrid systems without name conflicts 
 and enables the definition of system parameters without using global variables.
 
 **Interconnected Hybrid Systems.** It is now possible in MATLAB to define 
 several hybrid subsystem systems with inputs and outputs, such as a plant and 
 a controller, then link them together to form a composite hybrid system. 
 Solutions to the composite system can be computed like any other system.
 
 **More Informative Solutions.** The new `HybridSolution` class includes additional 
 useful information about solutions such as the duration of each interval of 
 flow and the reason the solution terminated. Methods are provided for modifying 
 solution objects by, e.g., applying a map to transform the state values or truncating the time span. 
 
 **Improved Progress Updates.** While computing solutions, a progress bar displays 
 the percent completed and the current hybrid time. The progress updates during 
 both flows and at jumps (in v2.04, progress updates were only printed to the 
 command line at jumps).
 
 **Improved Plotting.** Plotting hybrid arcs is easier and allows more control over the appearance of plots. New features include the following:
 
 - easy control of the marker and line styles for flows and jumps
 - ability to hide portions of hybrid 
 arcs from plots using a filter (useful for plotting different modes in different 
 styles)
 - support for legends
 - automatic creation of subplots for hybrid 
 arcs with multiple components
 - customizable default plot settings
 - up to 200x faster than in v2.04 for hybrid arcs with many jumps.
 
 **Bug Fix.** Fixed a bug in v2.04 where `HyEQsolver` would sometimes 
 generate solutions that erroneously flowed outside of the flow set **C**.
 
 **Code Verification and Error Reporting.** New error checking features catch programming mistakes earlier when using the toolbox. Over 350 automated tests verify the correctness of the toolbox's code.
 
 **Code Auto-completion.** The Hybrid Equations Toolbox supports MATLAB's [code suggestion and completion feature](https://www.mathworks.com/help/releases/R2021b/matlab/matlab_env/check-syntax-as-you-type.html#bswj2of-1) (introduced to the MATLAB code editor in R2021b).

 ### **Simulink-based Library**
 
 The following improvements were made to the Simulink-based 
 Hybrid System solver:
 
 **Hybrid System with External Functions and Inputs.** A new Simulink block
 allows for a hybrid system with inputs to be defined using plain-text `.m` 
 MATLAB function files to specify the hybrid system.
 
 **Block Parameters.** Simulink block masks were added to the
 HyEQ blocks to allow users to set block parameters without needing to modify
 anything inside the block. Parameters are now set in a popup dialog that opens
 when each block is clicked.
 
 **Instructions for How To Use Blocks.** Each block in the HyEQ Simulink library
 now includes instructions in the popup dialog that opens when the block is
 clicked.
 
 **Signal Sizes.** HyEQ Simulink library blocks now explicitly sets the signal sizes for inputs and outputs based on user-provided values. This eliminates cryptic errors and cumbersome workarounds due to Simulink's automatic (and frequently incorrect) calculations of signal sizes.


 ### **General Improvements**
 
 The following updates apply to the entire toolbox:

 **Easier Installation and Updates**. v3.0 is packaged using MATLAB's toolbox packaging, so it can be installed and updated automatically through MATLAB's Add-on manager.
 
 **Backward Compatibility.** All code that works in Toolbox version 2.04 is expected to work in v3.0 without modification. Version 3.0 is compatible with MATLAB versions back to R2014b.
 
 **Improved Help Files and Example.** All documentation files for the HyEQ Toolbox have been redone to make them easier to access and navigate in MATLAB Help.
