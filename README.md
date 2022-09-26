# Hybrid Equations Toolbox
The Hybrid Equations (HyEQ) Toolbox is implemented in MATLAB and Simulink for the simulation of hybrid dynamical systems. This toolbox is capable of simulating individual and interconnected hybrid systems with inputs. Examples of systems that can be simulated include a bouncing ball on a moving platform, fireflies synchronizing their flashing, and more. The Toolbox is comprised of two parts: a Simulink-based simulator and one that runs purely in MATLAB, without Simulink.

## How to Uninstall HyEQ Toolbox Version 2.04. 
Before installing version 3.0 of the HyEQ Toolbox, it is necessary to uninstall prior versions. The process for uninstalling v2.0 is described below. The process for earlier versions is similar. Once version 3.0 or later is installed, it is not necessary to manually uninstall the toolbox before updating to another version.

1. Open Matlab.
2. Go to the HyEQ Toolbox folder. 
	* The toolbox folder can be located by running `which('HyEQsolver')` in the MATLAB command window.
	* On Windows, the toolbox path is typically `C:\Program Files\Matlab\toolbox\HyEQ_Toolbox_v204`.
    * On Macintosh, the toolbox path is typically `~/matlab/HyEQ_Toolbox_v204`.  
3. Run the uninstallation script `tbclean` in the MATLAB command window. This procedure erases all the files in the HyEQ Toolbox folder.
4. Restart Matlab.
5. Check that the HyEQ Toolbox is uninstalled by running `which('HyEQsolver')`. The output should be `'HyEQsolver' not found.`

## How to Install the HyEQ Toolbox version 3.0

In order to install the HyEQ Toolbox v3.0, MATLAB R2014b or newer is required.

The Toolbox is compatible (and tested) with MATLAB versions R2014b through the R2022b on Windows, Mac, and Linux except for the following cases:
* On macOS Monterey (and possibly other versions), Simulink R2014b is not supported and will cause MATLAB to crash. Update to R2016a or later.
* On Linux with MATLAB R2014b, having Simulink installed causes _all_ HyEQ Toolbox tests to fail. Manual testing indicates that the HyEQ MATLAB library might work, but use at your own risk. For a tested MATLAB version with Linux, use R2021a or later.

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

To report a problem, request a feature, or ask for help, please [submit an issue](https://github.com/pnanez/HyEQ_Toolbox/issues/new) on the project's GitHub repository.

### Related Links
* [MATLAB File exchange](http://www.mathworks.com/matlabcentral/fileexchange/41372-hybrid-equations-toolbox-v2-02)
* [Old versions of the toolbox](https://hybrid.soe.ucsc.edu/software)
* [Manual for version 2](https://hybrid.soe.ucsc.edu/biblio/2014/hybrid-equations-hyeq-toolbox)
* [Examples](http://hybridsimulator.wordpress.com/)

# Contributing

## Setting Up the Development Environment

### Step 1. Setup Git and Git Large File System (LFS):
1. Download and install [Git](https://git-scm.com/downloads) and [Git LFS](https://git-lfs.github.com/). 
1. After running the Git LFS installation binary, run `git lfs install`. 
1. Generate an SSH key on your computer as described here: [Generating SSH keys](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent).
1. Login to your [GitHub account](https://github.com/login).
In your account, [add the newly generated SSH Key](https://github.com/settings/ssh).

### Step 2. Set up a Local Version of the Repository
1. Install MATLAB R2014b or later and Simulink.
1. Uninstall or disable any existing versions of the toolbox (you will replace it with the development version downloaded with Git).
1. Clone the repository from GitHub with the following command: `git clone git@github.com:pnanez/HyEQ_Toolbox.git`. The repository will be downloaded to your current working directory. 
1. Open MATLAB and navigate to the root folder of the toolbox (`HyEQ_Toolbox/`, by default, in the directory where you cloned the repository).
1. Make sure you are on the `dev` branch by running `git branch`. If you are not on `dev`, run the command `git checkout dev`. 
1. In MATLAB, open the `HyEQ_Toolbox` directory and run `configure_development_path` in the MATLAB Command Window to add the necessary folders to the MATLAB path (**this must be rerun each time MATLAB restarts!**).
1. Run `hybrid.tests.run` in the MATLAB Command Window to verify everything is working.

## Directory Structure of the Hybrid Equations Toolbox
* `matlab/`: contains the source code for the MATLAB portion of the toolbox. 
* `simulink/`: contains the source code for the Simulink portion of the toolbox.
* `docs/`: contains the source code for Toolbox documentation.
* `Examples/`: contains the source code for the examples that are described in the documentation.

## Editing the Simulink Library
The HyEQ Simulink library is contained in `simulink/HyEQ_Library.slx`. 
In order to ensure that the Simulink library and examples are backward compatible to R2014b, the associated Simulink models should only be edited in R2014b. If a Simulink model is edited in a later version, then it must be exported using "Export to Previous Version" with compatibility set to R2014b. 

For most blocks in the HyEQ Simulink library, adding the block to a Simulink model will create a _linked_ copy of the block (changes to the block will be reflected automatically in all of the linked blocks). This is not the case, however, for the Hybrid System blocks with embedded functions and the Continuous-time Plant block because these blocks because the internals of the blocks must be modified by users in order to specify the hybrid system. In particular, users must modify the `f`, `g`, `C`, and `D` blocks. To see the code that "breaks the link" when a library block is added to a model, see Block Properties > Callbacks (particularly `CopyFcn` and `LoadFcn`).

## Packaging a New Version of the HyEQ Toolbox
To create a MATLAB toolbox package for the Toolbox:
1. Navigate to the root folder of the Toolbox in MATLAB.
2. Right-click (on Windows) or CMD-click (MAC) on the file `HybridEquationsToolbox.prj`
and select "Open As Text". 
3. In `HybridEquationsToolbox.prj`, increment `<param.version>` and save.
4. Run `package_toolbox` in the MATLAB command line to generate a `.mltbx`. This
file can then be uploaded to the MATLAB File Exchange. 

## Editing Documentation
We use MATLAB [Publish](https://www.mathworks.com/help/matlab/matlab_prog/publishing-matlab-code.html) to generate HTML documentation pages from the `.m` files contained in `doc/`. The `.m` files are translated into an HTML file (which we display in MATLAB Help) by clicking the "Publish" button within the Publish tab at the top of MATLAB. Links to other `.m` files in `doc/` can be included with the following code `<matlab:hybrid.internal.openHelp('filename') Link Text>`, where `filename` is the name of one of the `.m` files in `doc/` not including `.m`.

Each help document must be included in `helptoc.xml` to add it to the table of contents in the left panel and included in `TOC.m` to add it to the table of content _pages_ displayed when one of the headers in the left panel is clicked. After modifying `TOC.m`, copy the changes to the corresponding file `TOC_cps.m`, `TOC_examples.m`, `TOC_matlab.m`, 
or `TOC_simulink.m`.

### Using TeX in Documentation

TeX equations can be included using ``$$...$$`` delimiters, but the available macros are limited. Use the following replacements:
Make the following replacements: 
* `\mathbb` with `\mathbf` 
* `\Re` and `\reals` with `\mathbf{R}`
* `\begin{eqarray} . . .\end{eqarray}` with `\begin{array}{<column options>} . . . \end{array}` (make sure you have the right number of columns in `<column options>` (e.g., `cc` or `ll` if there are two columns).
* `\text` with `\textrm`

### Adding Images to Documentation
To add an image named `myimage.png` to a document, place the image in the `doc/html/images` folder and add the following code in the desired location:

`% <<images/myimage.png>>`

To add an image that fits to the width of the browser window, the following HTML 
code can be used. Note that an empty comment line is required before `<html>` and after `</html>`.
```
%
% <html> 
% <img src="images/myimage.png"  style='width: 100%; max-height: 200px; object-fit: contain'> 
% </html>
%
```