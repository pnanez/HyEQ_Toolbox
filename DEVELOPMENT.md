# Steps to setup git and git Large File System (LFS):
Download and install git and git LFS. 
After installing the git LFS binary, run `git lfs install`. 
Generate a SSH key on your computer as described here : Generating SSH keys.
Login to your GitHub account: GitHub Login.
In your account, add the newly generated SSH Key: My account SSH keys.
Tell Paul Wintz your GitHub username or email address so that I can add you as a collaborator on the repository. 

# Setup the HyEQ toolbox repository:
Uninstall or disable any existing versions of the toolbox (you will replace it with the development version downloaded with git).
Clone the repository from GitHub with the following command: `git clone git@github.com:pwintz/HyEQ_Toolbox.git`. The repository will be downloaded to your current working directory. 
Change your working directory to HyEQ_Toolbox/.
Make sure you are on the `dev` branch by running `git branch`. If you are not on `dev`, run the command `git checkout dev`. 
In MATLAB, open the HyEQ_Toolbox directory and run configure_development_path.m to add the toolbox's folders to the MATLAB path (this needs to be rerun each time MATLAB restarts).
In MATLAB, run `hybrid.tests.run` to verify everything is working.

Now you can start creating examples. The Simulink source code for the CPS examples are in the `Examples/CPS_Examples/` folder. You will write documentation as `.m` files placed in the `doc/` folder. The `.m` files are translated into an HTML file (which we display in MATLAB Help) by clicking the "Publish" button within the Publish tab at the top of MATLAB. For details about using "publish" see here. Links to other `.m` files in `doc/` can included with the following code `<matlab:hybrid.internal.openHelp('filename') Link Text>`, where `filename` is the name of one of the `.m` files in `doc/` not including `.m`.

To save and share progress on your example, please follow these steps: 
1. Create a new branch off of `dev` by running `git checkout -b <name_of_branch>`, where `<name_of_branch>` is a short, unique, and descriptive name of what you are working on (e.g., `CPS_examples_FSM`). 
1. Add your branch to the remote repository with the command `git push --set-upstream origin <name_of_branch>` so that your changes are saved (this won't affect the `dev` branch until we merge your branch into it). To modify the remote repository, you must be added as a collaborator, so if using git push fails, contact Paul Wintz.
1. Create commits to save the work you have done (see here and other web resources for guidance).
1. After committing, you can update the remote copy of your branch with `git push`.

#Converting LaTeX documents to MATLAB Publish documents 
Make the following replacements: 
* `\mathbb` with `\mathbf`
* `\Re` with `\mathbf{R}`
* `\eqarray` with `\array`

# Modifying Examples
Simulink files need to remain compatible with version R2014B of MATLAB, so they should only be modified in R2014B. (If a Simulink file is modified using a more recent version of MATLAB, it's possible to later export a R2014b compatible version, but let's try to avoid needing to do that.)

# Modifying LaTeX help pages. 
The HTML help pages in `doc/html` are generated from `.m` LaTeX files in `doc/`. All the PDFs and HTMLs can be compiled by navigating to doc/src/
Some of the help files include code from `.m` and `.slx` files elsewhere in the toolbox. The script `doc/src/RebuildTexFiles.m` collects these snippets and places them into subdirectories in  `doc/src`.

# Notes on Simulink Library
For most blocks in the HyEQ Simulink library, adding the block to a Simulink model will create a _linked_ copy of the block (changes to the block will be reflected automatically in all of the linked blocks). This is not the case, however, for the Hybrid System blocks with embedded functions and the Continuous-time Plant block because these blocks because the internals of the blocks must be modified by users in order to specify the hybrid system. In particular, users must modify the `f`, `g`, `C`, and `D` blocks. To see the code that "breaks the link" when a library block is added to a model, see Block Properties > Callbacks (particularly `CopyFcn` and `LoadFcn`).