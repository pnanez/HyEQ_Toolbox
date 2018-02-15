%--------------------------------------------------------------------------
% Matlab M-file Project: HyEQ Toolbox @  Hybrid Systems Laboratory (HSL), 
% https://hybrid.soe.ucsc.edu/software
% http://hybridsimulator.wordpress.com/
% Filename: postprocessing_ex1_8a.m
%--------------------------------------------------------------------------
% Project: Simple Example
% Description: postprocessing for Simple Example
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%   See also HYEQSOLVER, PLOTARC, PLOTARC3, PLOTFLOWS, PLOTHARC,
%   PLOTHARCCOLOR, PLOTHARCCOLOR3D, PLOTHYBRIDARC, PLOTJUMPS.
%   Copyright @ Hybrid Systems Laboratory (HSL),
%   Revision: 0.0.0.3 Date: 05/20/2015 3:42:00


% plot solution
figure(1)
clf
clear modificatorF modificatorJ
modificatorF{1} = 'b'; % pick the color for the flow
modificatorJ{1} = 'LineStyle';
modificatorJ{2} = '--';
modificatorJ{3} = 'marker';
modificatorJ{4} = '*';
modificatorJ{5} = 'MarkerEdgeColor';
modificatorJ{6} = 'r';
subplot(2,1,1),plotarc(t,j,x,[],[],modificatorF,modificatorJ);
grid on
ylabel('x')

modificatorF{1} = 'b--';
modificatorJ{1} = 'LineStyle';
modificatorJ{2} = 'none';
modificatorJ{3} = 'marker';
modificatorJ{4} = '*';
modificatorJ{5} = 'MarkerEdgeColor';
modificatorJ{6} = 'r';
subplot(2,1,2),plotarc(j,j,x,[],[],modificatorF,modificatorJ);
grid on
ylabel('x')
                