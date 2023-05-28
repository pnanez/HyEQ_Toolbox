# Hybrid Equations Toolbox

[![View Hybrid Equations Toolbox on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/41372-hybrid-equations-toolbox)

The Hybrid Equation (HyEQ) Toolbox provides MATLAB and Simulink libraries for the simulation of hybrid dynamical systems. The Toolbox supports definitions of hybrid systems with inputs, allowing for the creation of interconnected hybrid systems in modular configurations. The hybrid arcs output by simulations can be transformed and plotted with a suite of tools that allow easy customization. Detailed documentation and numerous examples are provided in the MATLAB Help browser or at [hyeq.github.io](https://hyeq.github.io/).

## Requirements

Installing v3.0 of the HyEQ Toolbox requires MATLAB R2014b or newer.

This toolbox officially supports the following combinations of operating system and MATLAB/Simulink version:
- Windows: R2014b-R2022b
- Mac (MATLAB only): R2014b-R2022b
- Mac (MATLAB+Simulink): R2016a-R2022b
- Linux: R2021a-R2022b

MATLAB versions R2014b through R2015b are not compatible with recent versions of macOS, such as macOS Monterey. See MATLAB and Simulink's [system requirements](https://www.mathworks.com/support/requirements/previous-releases.html) to find a compatible OS/software version pair.

When the Toolbox was tested on Linux in MATLAB R2014b, Simulink caused the automated test runner to crash. Manual testing indicates that the HyEQ MATLAB library might work, but use at your own risk. For a MATLAB version tested with Linux, use R2021a or later (earlier versions than 2021a may work but were not tested).

## How to Install the HyEQ Toolbox version 3.0

Before installing version 3.0 of the HyEQ Toolbox, it is necessary to manually uninstall any installed earlier versions (v2.04 or earlier). Subsequently, it is not necessary to manually uninstall the HyEQ Toolbox (v3.0 or later) before updating to a newer version. 

### Uninstalling HyEQ Toolbox Version 2.04. 
The process for uninstalling v2.04 is as follows (earlier versions are similar).

1. Open Matlab.
2. Navigate to the HyEQ Toolbox folder. The toolbox folder can be located by running `which('HyEQsolver')` in the MATLAB command window (note that `HyEQsolver` is in a subdirectory of the HyEQ Toolbox folder).
	* On Windows, the HyEQ Toolbox folder path is typically `C:\Program Files\Matlab\toolbox\HyEQ_Toolbox_v204`.
    * On Macintosh, the HyEQ Toolbox folder path is typically `~/matlab/HyEQ_Toolbox_v204`.  
3. While in the HyEQ Toolbox folder, run the uninstallation script `tbclean` in the MATLAB command window. **This script deletes all the files in the HyEQ Toolbox folder!**
4. Restart Matlab.
5. Check that the HyEQ Toolbox is uninstalled by running `which('HyEQsolver')`. The output should be `'HyEQsolver' not found`.

### Installing v3.0 via the Add-On Explorer (MATLAB R2017b and later)
On MATLAB R2017b and later, the HyEQ Toolbox can be installed through the MATLAB Add-on Explorer.

1. Open MATLAB
2. Select the “Home” tab at the top of the window.
3. Click the “Add-Ons” button to open the [Add-On explorer](https://www.mathworks.com/help/matlab/matlab_env/get-add-ons.html).
4. Search for “Hybrid Equations Toolbox” and select the entry by Ricardo Sanfelice.
5. Click the “Add” button to open a drop-down menu and select “Add to MATLAB”.
6. A license agreement will open. Click “I Accept” to start the installation.
7. When the installation is complete, a “Getting Started” guide will open in MATLAB with instructions for next steps. 

If the above steps do not work because the Add-On Explorer is unavailable, then you can install the toolbox using the steps described below for installing without the Add-On Explorer.

### Installing v3.0 Without the Add-On Explorer (MATLAB R2014b through R2017a)
The MATLAB Add-on Manager is not supported on versions of MATLAB before MATLAB R2017b, so for these versions the HyEQ Toolbox must be installed by the following process.

1. Open the [Hybrid Equations Toolbox](https://www.mathworks.com/matlabcentral/fileexchange/41372-hybrid-equations-toolbox) page on the MATLAB Central File Exchange.
2. Click “Download” and select “Toolbox” from the drop-down menu.
3. Select any convenient location to save the `.mltbx` file.
4. Open the `.mltbx` file in MATLAB. 
5. A dialog box will prompt you to install the toolbox. Click “Install.” 
6. To finish setting up the toolbox, run `hybrid.configureToolbox` in the MATLAB command window. This command 
	1. checks that only one version of the toolbox is installed, 
	2. upgrades the Simulink library and example model files to the current MATLAB version (this prevents warnings that they were last saved on an old version of Simulink), and 
	3. opens a prompt to run automated tests (there will be several skipped tests for functionality that is not tested on older versions of MATLAB).
7. You may delete the `.mltbx` file at this point.

# Help Using the Toolbox

To access the HyEQ Toolbox documentation, open MATLAB Help (F1) and navigate to Supplemental Software>Hybrid Equations Toolbox.
The documentation is also available online at [hyeq.github.io](https://hyeq.github.io/).

To ask for help, report a problem, or request a feature, please [submit an issue](https://github.com/pnanez/HyEQ_Toolbox/issues/new/choose) on [GitHub](https://github.com/pnanez/HyEQ_Toolbox).

## Troubleshooting
**Problem**: When I call `HybridSystem.solve()`, after installing v3.0, the following error appears: “`Error using HyEQsolver. Too many input arguments.`” 

**Cause**: A previous version of the toolbox is still installed. 

**Solution**: Uninstall the previous hybrid toolbox version by following the [steps above](#uninstalling-hyeq-toolbox-version-204).

---

**Problem**: Opening a Simulink example model produces the following error:
```
File '<path to toolbox>\Examples\+hybrid\+examples\+<example package>\<model name>.slx' cannot be loaded because it is
shadowed by another file of the same name higher on the MATLAB path.  For more information see "Avoiding Problems with Shadowed Files" in the Simulink documentation.

The file that is higher on the MATLAB path is: <path to another file>.
```

**Solution**: Either rename the example file name or rename the file that is shadowing it (or remove it from the MATLAB Path). After renaming the example file to `<new model name>`, you can open the model to by running `hybrid.examples.<example package>.<new model name>` or by navigating to it in the file browser. Links to open the example from the MATLAB Help browser will no longer work.

---

**Problem**: A Simulink model produces the following error message: 
```
An error occurred while running the simulation and the simulation was terminated
Simulink cannot solve the algebraic loop containing '<model name>/Integrator System/ICx' at time 0.0 using the TrustRegion-based algorithm due to one of the following reasons: the model is ill-defined i.e., the system equations do not have a solution; or the nonlinear equation solver failed to converge due to numerical issues.
```

**Cause**: The Simulink model contains an [algebraic loop](https://www.mathworks.com/help/simulink/ug/algebraic-loops.html) (a closed signal loop that contains only direct feedthrough blocks) that is preventing Simulink from propagating the dynamics of the system.

**Solution**: For one of the HyEQ blocks in the loop, use the “x-” output instead of the “x” output to pass the output to the next block in the loop. This introduces a one time-step delay to the output signal in order to break the algebraic loop.

# Credits 
## Version 2.04 
Version 2.04 of the Hybrid Equations Toolbox was developed by 
Ricardo G. Sanfelice, David A. Copp, and Pablo Nanez. 

## Version 3.0
Version 3.0 of the HyEQ Toolbox was developed by Paul Wintz.

See [**Credits and Acknowledgments**](https://hyeq.github.io/credits) in the HyEQ Toolbox documentation for further acknowledgments.


# See Also
* [Web-based Documentation](https://hyeq.github.io)
* [Hybrid Systems Laboratory](https://hybrid.soe.ucsc.edu/) at [UC, Santa Cruz](https://engineering.ucsc.edu/)
* [Previous versions of the HyEQ Toolbox](https://hybrid.soe.ucsc.edu/software)
* [Examples of Hybrid Systems](http://hybridsimulator.wordpress.com/) (blog)
