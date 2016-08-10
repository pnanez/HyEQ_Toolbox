function plotHybridArc(t,j,x,jstar,resolution)
%PLOTHYBRIDARC   Hybrid arc plot (n states and n hybrid time domains).
%   PLOTHYBRIDARC(t,j,x) plots (in blue) the trajectory x on hybrid time
%   domains. The intervals [t_j,t_{j+1}] indexed by the corresponding j are
%   depicted in the t-j plane (in red).
%
%   PLOTHYBRIDARC(t,j,x,jstar) plots hybrid time vector (matrix) (t,j) versus
%   vector (matrix) x taking into account jumps j, and the plot is cut
%   regarding the jstar interval (jstar = [j-initial j-final]).
%
%   PLOTHYBRIDARC(t,j,x,[jstar],resolution) plots hybrid time vector (matrix)
%   (t,j) versus vector (matrix) x taking into account jumps j, and the
%   plot is cut regarding the jstar interval (jstar = [j-initial j-final]).
%   Also, a maximum resolution in between jumps is given by the input
%   variable resolution.
%
%   Example
%         % Generate a hybrid arc
%         % initial conditions
%         x1_0 = 1;
%         x2_0 = 0;
%         x0 = [x1_0;x2_0];
% 
%         % simulation horizon
%         TSPAN=[0 10];
%         JSPAN = [0 20];
% 
%         % rule for jumps
%         % rule = 1 -> priority for jumps
%         % rule = 2 -> priority for flows
%         rule = 1;
% 
%         options = odeset('RelTol',1e-6,'MaxStep',.1);
% 
%         % simulate
%         [t j x] = HyEQsolver( @f_ex1_2,@g_ex1_2,@C_ex1_2,@D_ex1_2,...
%             x0,TSPAN,JSPAN,rule,options);
%
%         % plot hybrid arc
% 
%         figure(1)
%         PLOTHYBRIDARC(t,j,x(:,1))
%         xlabel('jumps')
%         ylabel('time')
%         zlabel('x_1')
%         view(3)
%         grid on
%
%        % Plot the hybrid arc Vs the hybrid time domain (t,j) for a specified jump span $j\in[3,5]$
%
%         figure(2)
%         PLOTHYBRIDARC(t,j,x,[3,7]);
%         xlabel('jumps')
%         ylabel('time')
%         zlabel('x_1, x_2')
%         view(3)
%         grid on
%
%         % Plot a hybrid arc Vs the hybrid time domain (t,j) using reduced resolution
%         
%         figure(3)
%         PLOTHYBRIDARC(t,j,x(:,1),[3,7],4);
%         xlabel('jumps')
%         ylabel('time')
%         zlabel('x_1, x_2')
%         view(3)
%         grid on
%
%--------------------------------------------------------------------------
% Matlab M-file Project: HyEQ Toolbox @  Hybrid Systems Laboratory (HSL), 
% https://hybrid.soe.ucsc.edu/software
% http://hybridsimulator.wordpress.com/
% Filename: PLOTHYBRIDARC.m
%--------------------------------------------------------------------------
%   See also PLOTARC, PLOTARC3, PLOTFLOWS, PLOTHARC, PLOTHARCCOLOR,
%   PLOTHARCCOLOR3D, PLOTHYBRIDARC, PLOTJUMPS.
%   Copyright @ Hybrid Systems Laboratory (HSL),
%   Revision: 0.0.0.4 Date: 03/29/2016 15:09:00


if ~exist('jstar','var') || isempty(jstar)
    jstar = [];
end
    modificatorF{1} = 'b--';
    modificatorJ{1} = 'LineStyle';
    modificatorJ{2} = 'none';
if ~exist('resolution','var') || isempty(resolution)
    resolution = [];
end
DDD = true;

plotarc(t,j,x,[],jstar,modificatorF,modificatorJ,resolution,DDD);
hold on

modificatorF{1} = 'r';
modificatorJ{1} = 'LineStyle';
modificatorJ{2} = 'none';

plotarc(j,j,t,[],jstar,modificatorF,modificatorJ,resolution);

