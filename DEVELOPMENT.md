# Hybrid Equations Toolbox Development

This file describes how to setup the development environment for the HyEQ Toolbox
and includes instructions for various tasks related to modifying and packaging
the Toolbox.

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