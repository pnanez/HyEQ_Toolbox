# Hybrid Equations Toolbox
The Hybrid Equations (HyEQ) Toolbox is implemented in MATLAB and Simulink for the simulation of hybrid dynamical systems. This toolbox is capable of simulating individual and interconnected hybrid systems with inputs. Examples of systems that can be simulated include a bouncing ball on a moving platform, fireflies synchronizing their flashing, and more. The Toolbox is comprised of two parts: a Simulink-based simulator and one that runs purely in MATLAB, without Simulink.

The Simulink implementation includes four basic blocks that define the dynamics of a hybrid system. These include a flow map, flow set, jump map, and jump set. The flows and jumps of the system are computed by the integrator system which is comprised of blocks that compute the continuous dynamics of the hybrid system, trigger jumps, update the state of the system and simulation time at jumps, and stop the simulation. 

The MATLAB-based simulator allows for faster simulation without using Simulink.

## How to Uninstall Version 2.04. 
Before intalling version 3.0 of the HyEQ Toolbox, it is necessary to uninstall prior versions. The process for uninstalling v2.0 is described below. The process for earlier versions is similar. Once version 3.0 or later is installed, it is not necessary to uninstall the toolbox before updating to another version.

1. Open Matlab.
2. Go to the HyEQ Toolbox folder. 
	* The toolbox folder can be located by running `which('HyEQsolver')` in the MATLAB command window.
	* On Windows, the toolbox path is typically `C:\Program Files\Matlab\toolbox\HyEQ_Toolbox_v204`.
    * On Macintosh, the toolbox path is typically `~/matlab/HyEQ_Toolbox_v204`.  
3. Run the unistall script `tbclean` in the MATLAB command window. This procedure erases all the files in the HyEQ Toolbox folder.
4. Restart Matlab.
5. Check that the HyEQ Toolbox is uninstalled by running `which('HyEQsolver')`. The output should be `'HyEQsolver' not found.`

## How to Install the Toolbox

In order to install the HyEQ Toolbox, MATLAB R2014b or newer is required.

**On MATLAB 2015? and later**
The HyEQ Toolbox can be installed through the MATLAB Add-on Manager.

1. Open MATLAB
2. Select the "Home" tab at the top of the window.
3. Click the "Add-Ons" button to open the [Add-On explorer](https://www.mathworks.com/help/matlab/matlab_env/get-add-ons.html).
4. Search for "Hybrid Equations Toolbox" and select the entry by Ricardo Sanfelice.
5. Click the "Add" button to open a dropdown menu and select "Add to MATLAB".
6. A license agreement will open. Click "I Accept" to start the installation.
7. When the installation is complete, a "Getting Started" guide will open in MATLAB. 
8. In the 

**On MATLAB R2014B**
The HyEQ Toolbox is installed by downloading the toolbox package file outside of MATLAB and then opening it in MATLAB.

1. Go to the [Hybrid Equations Toolbox](https://www.mathworks.com/matlabcentral/fileexchange/41372-hybrid-equations-toolbox-v2-04) page the MATLAB Central File Exchange.
2. Click "Download" and select "Toolbox" from the drop-down menu.
3. Select any convenient location to save the `.mltbx` file.
4. Open the `.mltbx` file in MATLAB. 
5. A dialog box will prompt you to install the toolbox. Click "Install". 
6. Check that the toolbox is installed correctly by running `hybrid.tests.run` in the MATLAB command window. The tests will take a minute or so to complete. If there are no failed tests, then everything is working as expected (there will be several skipped tests for functionality that is not tested on R2014b).
7. You may delete the `.mltbx` file.

## More Help

To access the HyEQ Toolbox documentation, open MATLAB Help (F1) and navigate to Supplemental Software>Hybrid Equations Toolbox.

Software downloads:
https://hybrid.soe.ucsc.edu/software
http://www.mathworks.com/matlabcentral/fileexchange/41372-hybrid-equations-toolbox-v2-02
[Manual](https://hybrid.soe.ucsc.edu/biblio/2014/hybrid-equations-hyeq-toolbox)
[Examples](http://hybridsimulator.wordpress.com/)