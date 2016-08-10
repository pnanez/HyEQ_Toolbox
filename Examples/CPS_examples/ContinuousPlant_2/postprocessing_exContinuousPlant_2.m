%--------------------------------------------------------------------------
% Matlab M-file Project: HyEQ Toolbox @  Hybrid Systems Laboratory (HSL), 
% https://hybrid.soe.ucsc.edu/software
% http://hybridsimulator.wordpress.com/
% Filename: postprocessing_exContinuousPlant.m
%--------------------------------------------------------------------------
% Project: Simulation of a hybrid system (Continuous plant)
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%   See also plotflows, plotHarc, plotHarcColor, plotHarcColor3D,
%   plotHybridArc, plotjumps.
%   Copyright @ Hybrid Systems Laboratory (HSL),
%   Revision: 0.0.0.3 Date: 05/20/2015 3:42:00


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% full trajectory
%%%%%%%%%%

plotHarcColor(x(:,1),j,x(:,2),t);
xlabel('x1')
ylabel('x2')
grid on
axis([-maxX maxX -maxX maxX])
hold on
legend('solution')

%%%%%%%%%%%%%%%%%%%%%
% circles
%%%%%%%%%%%%%%%%%%%%

hold on
circle([0,0],maxX,1000,'r--');
