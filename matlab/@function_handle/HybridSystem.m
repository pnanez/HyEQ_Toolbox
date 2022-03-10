function sys = HybridSystem(f, g, C, D)
% Create a HybridSystem object from the function handles f, g, C, and D.
%  
% See also HybridSystem,
% <a href="matlab:hybrid.internal.openHelp('ConvertingLegacyCodeToVersion3_demo')">Updating Code That Was Desiged for HyEQ Toolbox v2.04 to Use HyEQ Toolbox v3.0</a>.
% 
% Added in HyEQ Toolbox version 3.0.

% Written by Paul K. Wintz, Hybrid Systems Laboratory, UC Santa Cruz (©2022). 
sys = hybrid.internal.EZHybridSystem(f, g, C, D); 
end