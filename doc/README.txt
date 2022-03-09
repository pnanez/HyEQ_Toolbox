This directory contains documentation files for the HyEQ Toolbox. These should only need to be opened by developers of the toolbox. As an end-user of the Toolbox, please read the documentation files in MATLAB Help (F1)>Supplemental Software>Hybrid Equations Toolbox.

The organization of the doc/ directory is as follows:

* GettingStarted.mlx: This is a MATLAB live script. On recent versions of MATLAB, it is automatically opened after installing the HyEQ Toolbox. The name is imposed by MathWorks. 
* helptoc.xml: Defines the list of documents that are displayed in MATLAB Help, and their tree structure therein. The name is imposed by MathWorks. 
* Files with the .m extension are published as HTML pages by the publish_toolbox.m script (found in the root directory of the toolbox). The generated HTML files are placed in doc/html/.  Files with names that end with "_demo.m" are published with code displayed because these documents contain demonstrations of how to use the code. All other .m files in doc/ are published with code hidden (but the output of the code is displayed).
* The files with names that end with "_TOC.m" are are tables of content that are associated with groups of documents in helptoc.xml. 
* src/: This directory contains source material that is used in generating help documentation. The important the script RebuildTexFiles.m populates the directories "Matlab2Tex*" with files that are included in various help documents.
