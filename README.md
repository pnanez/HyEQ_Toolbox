# Hybrid Equations Toolbox

The Hybrid Equation (HyEQ) Toolbox provides MATLAB and Simulink libraries for the simulation of hybrid dynamical systems. The toolbox supports definitions of hybrid systems with inputs, allowing for the creation of interconnected hybrid systems in modular configurations. The hybrid arcs output by simulations can be transformed and plotted with a suite of tools that allow easy customization. Detailed documentation and numerous examples are provided in the MATLAB Help browser.

This toolbox officially supports the following combinations of operating system and MATLAB/Simulink version:
- Windows: R2014b - R2022b
- Mac (MATLAB only): R2014b - R2022b
- Mac (MATLAB+Simulink): R2016a - R2022b
- Linux: R2021a-R2022b 

(earlier versions may work but were not tested)

## How to Install the HyEQ Toolbox version 3.0

In order to install the HyEQ Toolbox v3.0, MATLAB R2014b or newer is required.

The Toolbox is compatible (and tested) with MATLAB versions R2014b through the R2022b on Windows, Mac, and Linux except for the following cases:
* On macOS Monterey (and possibly other versions), Simulink R2014b is not supported and will cause MATLAB to crash. Update to R2016a or later.
* On Linux with MATLAB R2014b, having Simulink installed causes _all_ HyEQ Toolbox tests to fail. Manual testing indicates that the HyEQ MATLAB library might work, but use at your own risk. For a tested MATLAB version with Linux, use R2021a or later.

### Uninstall HyEQ Toolbox Version 2.04. 
Before installing version 3.0 of the HyEQ Toolbox, it is necessary to uninstall prior versions. The process for uninstalling v2.0 is described below. The process for earlier versions is similar. Once version 3.0 or later is installed, it is not necessary to manually uninstall the toolbox before updating to another version.

1. Open Matlab.
2. Go to the HyEQ Toolbox folder. 
	* The toolbox folder can be located by running `which('HyEQsolver')` in the MATLAB command window.
	* On Windows, the toolbox path is typically `C:\Program Files\Matlab\toolbox\HyEQ_Toolbox_v204`.
    * On Macintosh, the toolbox path is typically `~/matlab/HyEQ_Toolbox_v204`.  
3. Run the uninstallation script `tbclean` in the MATLAB command window. This procedure erases all the files in the HyEQ Toolbox folder.
4. Restart Matlab.
5. Check that the HyEQ Toolbox is uninstalled by running `which('HyEQsolver')`. The output should be `'HyEQsolver' not found.`

### Installing via Add-On Explorer (MATLAB R2017b and later)
On MATLAB R2017b and later, the HyEQ Toolbox can be installed through the MATLAB Add-on Explorer.

1. Open MATLAB
2. Select the "Home" tab at the top of the window.
3. Click the "Add-Ons" button to open the [Add-On explorer](https://www.mathworks.com/help/matlab/matlab_env/get-add-ons.html).
4. Search for "Hybrid Equations Toolbox" and select the entry by Ricardo Sanfelice.
5. Click the "Add" button to open a drop-down menu and select "Add to MATLAB".
6. A license agreement will open. Click "I Accept" to start the installation.
7. When the installation is complete, a "Getting Started" guide will open in MATLAB with instructions for next steps. 

If the above steps do not work because the Add-On Explorer is unavailable, then you can install the toolbox using the steps described below for installing without the Add-On Explorer.

### Installing without Add-On Explorer (MATLAB R2014b through R2017a)
The MATLAB Add-on Manager is not supported on versions of MATLAB before MATLAB R2017b, so for these versions the HyEQ Toolbox must be installed by the following process.

1. Open the [Hybrid Equations Toolbox](https://www.mathworks.com/matlabcentral/fileexchange/41372-hybrid-equations-toolbox-v2-04) page on the MATLAB Central File Exchange.
2. Click "Download" and select "Toolbox" from the drop-down menu.
3. Select any convenient location to save the `.mltbx` file.
4. Open the `.mltbx` file in MATLAB. 
5. A dialog box will prompt you to install the toolbox. Click "Install". 
6. To finish setting up the toolbox, run `hybrid.configureToolbox` in the MATLAB command window. This command (1) checks that only one version of the toolbox is installed, (2) upgrades the Simulink library and example model files to the current MATLAB version (this prevents warnings that they were last saved on an old version of Simulink), and (3) opens a prompt to run automated tests (there will be several skipped tests for functionality that is not tested on older versions of MATLAB).
7. You may delete the `.mltbx` file.

## Troubleshooting and Known Issues
**Problem**: When I call `HybridSystem.solve()`, after installing v3.0, the following error appears: "`Error using HyEQsolver. Too many input arguments.`" 

**Cause**: A previous version of the toolbox still installed. 

**Solution**: Uninstall the previous hybrid toolbox version by following the steps above.

---

**Problem**: After installing v3.0 of the Hybrid Equations Toolbox, something is not working.

**Solution**: Try restarting MATLAB.

---

**Problem**: Opening a Simulink example model produces the following error:
```
File '<path to toolbox>\Examples\+hybrid\+examples\+<example package>\<model name>.slx' cannot be loaded because it is
shadowed by another file of the same name higher on the MATLAB path.  For more information see "Avoiding Problems with Shadowed Files" in the Simulink documentation.

The file that is higher on the MATLAB path is: <path to another file>.
```

**Solution**: To fix this problem, you need to either rename the example file name or rename the other file (or remove it from the MATLAB Path). After renaming the example file, you can open the model by running `hybrid.examples.<example package>.<new model name>` or by navigating to it in the file browser, but links to open the example from the MATLAB Help browser will no longer work.

---

**Problem** A Simulink model produces the following error message: 
```
An error occurred while running the simulation and the simulation was terminated
Simulink cannot solve the algebraic loop containing '<model name>/Integrator System/ICx' at time 0.0 using the TrustRegion-based algorithm due to one of the following reasons: the model is ill-defined i.e., the system equations do not have a solution; or the nonlinear equation solver failed to converge due to numerical issues.
```

**Solution** This error is caused by creating closed-loop systems out of several subsystem blocks. When passing the state of a Hybrid Subsystem block to another block, use the "x-" output, not the "x" output.

---
**Problem** Running Simulink in MATLAB R2014b (and other early versions) does not work on modern versions of Linux and the macOS.

**Solution** Install MATLAB R2021b or later. The HyEQ Toolbox was not tested on any pre-R2021b versions of Simulink on Linux. The MATLAB library was tested in R2014b on macOS Monterey and worked, but Simulink R2014b is not compatible with this OS and would not open.

## More Help

To access the HyEQ Toolbox documentation, open MATLAB Help (F1) and navigate to Supplemental Software>Hybrid Equations Toolbox.

To report a problem, request a feature, or ask for help, please [submit an issue](https://github.com/pnanez/HyEQ_Toolbox/issues/new/choose) on the project's GitHub repository.

### Related Links
* [Current Version of the HyEQ Toolbox on the MATLAB File exchange](http://www.mathworks.com/matlabcentral/fileexchange/41372-hybrid-equations-toolbox-v2-02)
* [Archive of previous versions of the HyEQ Toolbox](https://hybrid.soe.ucsc.edu/software)
* [Manual for HyEQ Toolbox v2.04](https://hybrid.soe.ucsc.edu/biblio/2014/hybrid-equations-hyeq-toolbox)
* [WordPress Blog Containing Example Hybrid Systems](http://hybridsimulator.wordpress.com/)
