% Configure the MATLAB path to include the files in this repository. 
% This script must be run from the root of the hybrid equations toolbox project.

if ~isempty(which('HyEQsolver'))
    warning('A version of the toolbox is already setup.')
    return
end

% Check that the working dirctory is the root of the HyEQ toolbox by checking
% that it contains the file "HybridEquationsToolbox.prj".
proj_root = pwd();
assert(isfile(fullfile(proj_root, 'HybridEquationsToolbox.prj')), ...
        'The working directory is not the root of the HyEQ toolbox.') 

toolbox_dirs = {...
    fullfile(proj_root, 'doc'), ...
    fullfile(proj_root, 'matlab'), ...
    fullfile(proj_root, 'matlab', 'legacyPlottingFunctions'), ...
    fullfile(proj_root, 'simulink', 'Library2014b')};

% Setup path
addpath(toolbox_dirs{:}) 

disp('hybrid-toolbox development path configured.')