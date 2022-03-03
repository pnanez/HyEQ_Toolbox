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
sol_u = HybridArc(t, 0*t, vs);
sol = HybridArc(t, j, x); %#ok<IJCL> (suppress a warning about 'j')

clf
subplot(2,1,1)
pb = HybridPlotBuilder();
hold on
pb.legend('ADC input')...
.slice(1)...
.flowColor('green')...
.jumpColor('none')...
.plotFlows(sol_u);
pb.legend('ADC output')...
.slice(1)...
.flowColor('blue')...
.jumpColor('red')...
.plotFlows(sol);

subplot(2,1,2)
HybridPlotBuilder()...
.legend('','ADC timer')...
.slice(2)...
.plotFlows(sol);


 