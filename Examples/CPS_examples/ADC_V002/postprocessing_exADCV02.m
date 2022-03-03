%--------------------------------------------------------------------------
% Matlab M-file Project: HyEQ Toolbox @  Hybrid Systems Laboratory (HSL), 
% https://hybrid.soe.ucsc.edu/software
% http://hybridsimulator.wordpress.com/
% Filename: postprocessing_exADC.m
%--------------------------------------------------------------------------
% Project: Simulation of a hybrid system (Analog-to-digital converter)
% Description: postprocessing ADC
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%   See also PLOTARC, PLOTARC3, PLOTFLOWS, PLOTHARC, PLOTHARCCOLOR,
%   PLOTHARCCOLOR3D, PLOTHYBRIDARC, PLOTJUMPS.
%   Copyright @ Hybrid Systems Laboratory (HSL),
%   Revision: 0.0.0.3 Date: 05/20/2015 3:42:00

% plot solution
sol = HybridArc(t, j, x); %#ok<IJCL> (suppress a warning about 'j)
sol1 = HybridArc(t1, j1, x1); %#ok<IJCL> (suppress a warning about 'j1')

clf
pb = HybridPlotBuilder()...
.subplots('on')...
.legend('Ball position', 'Ball velocity')...
.slice([1 2])...
.flowColor('green')...
.plotFlows(sol1);
hold on
pb.legend('ADC output', 'ADC output')...
.slice([1 2])...
.flowColor('blue')...
.plotFlows(sol);
 