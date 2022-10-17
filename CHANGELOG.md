# HyEQ Toolbox Change Log

This file documents changes to the Hybrid Equations Toolbox between versions.

## New Features in Version 3.0
Version 3.0 of the Hybrid Equations Toolbox is a substantial update to 
components throughout the Toolbox. This section describes changes between v2.04 and v3.0 (all code that works in version 2.04 is expected to work in v3.0 without modification). 

Version 3.0 is compatible with MATLAB versions back to R2014b.

 ### **General Improvements**
 
 The following updates apply to the entire toolbox:

 **Easier Installation and Updates**. v3.0 is packaged using MATLAB's toolbox packaging, so it can be installed and updated through MATLAB's [Add-on manager](https://www.mathworks.com/help/matlab/matlab_env/get-add-ons.html).
 
 **Improved Help Files and Example.** All documentation files for the HyEQ Toolbox have been redone to make them easier to access and navigate in MATLAB Help.

### **MATLAB-based Library**
 
 The following improvements were made to the HyEQ MATLAB Library:

 **Class-based Definitions of Hybrid Systems.** Each hybrid system can now 
 be defined in a single [class](https://www.mathworks.com/help/matlab/object-oriented-programming.html) file (namely a subclass of the new `HybridSystem` class) instead of spreading the definition across multiple function files (e.g., `f.m`, `g.m`, `C.m`, and `D.m`). This has numerous benefits:
 
 - Name conflicts are easier to avoid (instead of creating, say, eight files named `f_bouncing_ball.m`, `f_drone.m`, `g_bouncing_ball.m`, `g_drone.m`, etc. you could simply have two files, `BouncingBall.m` and `Drone.m`).
 - System parameters can be defined as class [properties](https://www.mathworks.com/help/matlab/matlab_oop/how-to-use-properties.html) instead of via [global variables](https://www.mathworks.com/help/matlab/matlab_prog/share-data-between-workspaces.html#f0-38470).
 - Multiple instances of the same `HybridSystem` class can exist at the same time with different parameter values.
 - Each hybrid system is automatically checked to verify that it is well-defined (e.g., that the inputs and outputs of the flow and jump maps have matching dimensions). Assertion functions are provided that allow you to easily verify that given points are or are not in the flow or jump sets.
 
 **Interconnected Hybrid Systems.** It is now possible in MATLAB to define 
 several hybrid systems with inputs and outputs, such as a plant and 
 a controller, then link them together to form a composite hybrid system. 
 
 **More Informative Solutions.** When a solution to a `HybridSystem` object is computed, 
 the output is a `HybridSolution` object that includes the values of the 
 state and the hybrid time domain plus additional information, 
 such as the duration of each interval of 
 flow and the reason the solution terminated. Methods in the `HybridSolution` class 
 allow you to 
 - select components by index, 
 - apply a map to transform the state values, and 
 - truncate the hybrid time domain to given intervals of discrete or continuous time. 
 
 **Improved Progress Updates.** A new progress bar displays 
 the percent completed while computing hybrid solutions. The progress bar updates during 
 both flows and at jumps (in v2.04, progress updates were printed to the 
 command window and only at jumps, not during flows).
 
 **Improved Plotting.** Plotting hybrid arcs is easier and allows more control over the appearance of plots. New features include the following:
 
 - easy control of the marker and line styles for flows and jumps
 - support for adding legend entries
 - ability to hide portions of hybrid arcs from plots using a filter (useful for plotting different modes in different styles)
 - automatic creation of subplots for hybrid arcs with multiple components
 - customizable default settings
 - plotting hybrid arcs with many jumps is up to 200x faster than in v2.04.
 
 **Error Checking and Code Correctness.** New error checking features help you catch programming mistakes earlier when using the toolbox. Over 350 automated tests verify the correctness of the toolbox's code. 
 
A bug in `HyEQsolver` was fixed (in v2.04, `HyEQsolver` would sometimes generate solutions that erroneously flowed outside of the flow set **C**).
 
 **Code Auto-completion.** The Hybrid Equations Toolbox supports MATLAB's recent [code suggestion and completion feature](https://www.mathworks.com/help/releases/R2021b/matlab/matlab_env/check-syntax-as-you-type.html#bswj2of-1) (introduced to the MATLAB code editor in R2021b).

 ### **Simulink-based Library**
 
 The following improvements were made to the HyEQ Simulink library:
 
 **New Block: Hybrid System with External Functions and Inputs.** A new Simulink block
 allows for a hybrid system with inputs to be defined using plain-text `.m` 
 MATLAB function files to specify the hybrid system.
 
 **Block Parameters.** HyEQ blocks now allow you to set block parameters without modifing
 anything inside the block. Parameters are set in a popup dialog that opens when each block is clicked.
 
 **Signal Sizes.** HyEQ blocks now explicitly sets the signal sizes for inputs and outputs based on user-provided values. This eliminates cryptic errors and cumbersome workarounds due to Simulink's automatic (and unreliable) calculations of signal sizes.

 **"Set <Callback> Script" Blocks** Two new HyEQ blocks named *Set Initialization Script* and *Set Post-Processing Script* allow you to select scripts that automatically run each time before and after your Simulink model is executed.

 **Block Instructions.** Each block in the HyEQ Simulink library
 now includes instructions how to use it that can be viewed in the popup dialog that opens when the block is
 clicked.
