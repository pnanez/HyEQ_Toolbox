%% Package Namespaces in the HyEQ Toolbox
% In MATLAB, _package namespaces_ (or simply _packages_) are used to 
% distinguish between functions, scripts, and classes
% that otherwise have the same name. 
% We use packages in the HyEQ Toolbox to avoid cluttering the MATLAB base
% namespace and organize components into logical groups. 

%% Description of HyEQ Package Organization
% The most commonly used classes in the MATLAB library, 
% such as |HybridSystem|, |HybridSolverConfig|, etc., are not in any
% package. These classes and functions can be found in the
% <matlab:cd(hybrid.getFolderLocation('matlab')) |matlab/|>
% directory.
% 
% The rest of the HyEQ Toolbox components are organized into the following 
% package hierarchy.
% 
% * *<matlab:doc('hybrid') |hybrid|>* Contains classes and functions that the 
% average HyEQ Toolbox user will not often need, but may be occasionally be useful.
% * *<matlab:doc('hybrid.examples') |hybrid.examples|>* Contains
% examples of how to use both the MATLAB- and Simulink-based libraries.
% * *<matlab:doc('hybrid.subsystems') |hybrid.subsystems|>* Contains
% subclasses of |HybridSubsystem| that are useful for
% creating |CompositeHybridSystems|.
% * *|hybrid.tests|* Contains automated tests that verify the correctness of the
% HyEQ Toolbox's code. Primarily used during developement, but can be run after
% installing the toolbox by running <matlab:hybrid.configureToolbox
% |hybrid.configureToolbox|>.
% * *|hybrid.internal|* Reserved for internal use by the Toolbox. You should not
% need to access these components directly.
%

%% Finding and Using Components in Packages
% The components in a package named |mypackage.mysubpackage| can be viewed by running 
% 
%   help mypackage.mysubpackage
% 
% In the file system, package contents are located in a _package directory_
% indicated by a "+" prefix. Thus, the files in |mypackage| package would be located in a
% directory named |+mypackage| and within that would be a folder named |+mysubpackage|.
% In the HyEQ Toolbox, most of the package directory are located in the 
% <matlab:cd(hybrid.getFolderLocation('matlab')) |matlab/|> directory except for
% |hybrid.examples|, which is located in 
% <matlab:cd(hybrid.getFolderLocation('Examples')) |Examples/|>
% 
% Referencing a function or class from within a package requires 
% the full package path. 
% For example, to use |ZeroOrderHold|, 
% it must be referenced as |hybrid.subsystems.ZeroOrderHold|. 
% The package path can be omitted
% if the package is first imported by calling 
% 
%   import hybrid.subsystems.*
% 
% For clarity, however, we use the explicit package path for classes throughout
% the HyEQ Toolbox documentation. 
% 
% For more information on MATLAB package namespaces, see the 
% <https://www.mathworks.com/help/matlab/matlab_oop/scoping-classes-with-packages.html 
% online documentation>.