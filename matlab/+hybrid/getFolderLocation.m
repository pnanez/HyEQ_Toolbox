function f = getFolderLocation(name, varargin)
% Get the absolute path to various directories in the Hybrid Equations Toolbox.
%
% Supported names (case insensitive) are:
% * 'root' or '': the root directory of the toolbox.
% * 'doc': The documentation directory.
% * 'examples': The examples directory.
% * 'matlab': The directory containing the MATLAB source code.
% * 'simulink': The directory containing the SIMULINK source code.
%
% Subdirectories and files can be accessed by including additional input arguments.
% 
% Added in HyEQ Toolbox version 3.0.

% Written by Paul K. Wintz, Hybrid Systems Laboratory, UC Santa Cruz (©2022).
    matlab_src_dir = fileparts(which('HyEQsolver'));
    toolbox_root_dir = fileparts(matlab_src_dir);
    
    if ~exist('name', 'var') || isempty(name) || strcmpi(name, 'root')
            f = toolbox_root_dir;
    elseif strcmpi(name, 'doc')
            f = fullfile(toolbox_root_dir, 'doc');
    elseif strcmpi(name, 'examples')
            f = fullfile(toolbox_root_dir, 'Examples');
    elseif strcmpi(name, 'matlab')
            f = fullfile(toolbox_root_dir, 'matlab');
    elseif strcmpi(name, 'simulink')
            f = fullfile(toolbox_root_dir, 'simulink');
    else
            error(['Name not recognized: ', name])
    end

    % Append subdirectories provided in the 'varargin'.
    f = fullfile(f, varargin{:});

end