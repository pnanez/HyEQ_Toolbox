function plotflows(t,j,x,jstar,resolution)
%PLOTFLOWS  Hybrid arc plot (n states and n hybrid time domains).
%   PLOTFLOWS(t,j,x) plots (in blue) the projection of the trajectory x
%   onto the flow time axis t.  The value of the trajectory for intervals
%   [t_j,t_{j+1}] with empty interior is marked with * (in blue).  Dashed
%   lines (in red) connect the value of the trajectory before and after the
%   jump.
%
%   PLOTFLOWS(t,j,x,jstar) plots hybrid time vector (matrix) (t,j) versus
%   vector (matrix) x taking into account jumps j, and the plot is cut
%   regarding the jstar interval (jstar = [j-initial j-final]).
%
%   PLOTFLOWS(t,j,x,[jstar],resolution) plots hybrid time vector (matrix)
%   (t,j) versus vector (matrix) x taking into account jumps j, and the
%   plot is cut regarding the jstar interval (jstar = [j-initial j-final]).
%   Also, a maximum resolution in between jumps is given by the input
%   variable resolution.
%
%   Example
%         % Generate a hybrid arc
%         % initial conditions
%         x1_a = 1/2;
%         x2_a = 0;
%         x0_a = [x1_a;x2_a];
%         x1_b = 1;
%         x2_b = 0;
%         x0_b = [x1_b;x2_b];
%         x1_c = 1+1/2;
%         x2_c = 0;
%         x0_c = [x1_c;x2_c];
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
%         [ta ja xa] = HyEQsolver( @f_ex1_2,@g_ex1_2,@C_ex1_2,@D_ex1_2,...
%             x0_a,TSPAN,JSPAN,rule,options);
%         % simulate
%         [tb jb xb] = HyEQsolver( @f_ex1_2,@g_ex1_2,@C_ex1_2,@D_ex1_2,...
%             x0_b,TSPAN,JSPAN,rule,options);
%         % simulate
%         [tc jc xc] = HyEQsolver( @f_ex1_2,@g_ex1_2,@C_ex1_2,@D_ex1_2,...
%             x0_c,TSPAN,JSPAN,rule,options);
% 
%         figure(1) % position
%         clf
%         subplot(2,1,1),PLOTFLOWS(ta,ja,xa(:,1))
%         grid on
%         ylabel('x1')
% 
%         subplot(2,1,2),plotjumps(ta,ja,xa(:,1))
%         grid on
%         ylabel('x1')
% 
%         figure(2) % velocity
%         clf
%         subplot(2,1,1),PLOTFLOWS(ta,ja,xa(:,2))
%         grid on
%         ylabel('x2')
% 
%         subplot(2,1,2),plotjumps(ta,ja,xa(:,2))
%         grid on
%         ylabel('x2')
%
%        % Plot the hybrid arc Vs the hybrid time domain (t,j) for a specified jump span $j\in[3,5]$
%
%         figure(3)
%         PLOTFLOWS(tb,jb,xb,[3,5]);
%         xlabel('time')
%         ylabel('x_1, x_2')
%         grid on
%
%         % Plot the arc for a specified jump
%
%         figure(4)
%         PLOTFLOWS(tc,jc,xc,[5]);
%         xlabel('time')
%         ylabel('x_1, x_2')
%         grid on
%
%         % Plot different hybrid arcs Vs the hybrid time domains (t,j)
%         % prepare the data      
%         minarc = min([length(xa),length(xb),length(xc)]);
%         t = [ta(1:minarc),tb(1:minarc),tc(1:minarc)];
%         j = [ja(1:minarc),jb(1:minarc),jc(1:minarc)];
%         x1 = [xa(1:minarc,1),xb(1:minarc,1),xc(1:minarc,1)];
%         x2 = [xa(1:minarc,2),xb(1:minarc,2),xc(1:minarc,2)];
%         
%         figure(5)
%         subplot(2,1,1),PLOTFLOWS(t,j,x1);
%         xlabel('x_1')
%         ylabel('time')
%         grid on
%         subplot(2,1,2),PLOTFLOWS(t,j,x2);
%         xlabel('x_2')
%         ylabel('time')
%         grid on
%
%         % Plot different hybrid arcs Vs the hybrid time domains (t,j) using reduced resolution
%         
%         figure(6)
%         subplot(2,1,1),PLOTFLOWS(t,j,x1,[3,5],7);
%         xlabel('x_1')
%         ylabel('time')
%         grid on
%         subplot(2,1,2),PLOTFLOWS(t,j,x2,[3,5],7);
%         xlabel('x_2')
%         ylabel('time')
%         grid on
%
%--------------------------------------------------------------------------
% Matlab M-file Project: HyEQ Toolbox @  Hybrid Systems Laboratory (HSL), 
% https://hybrid.soe.ucsc.edu/software
% http://hybridsimulator.wordpress.com/
% Filename: PLOTFLOWS.m
%--------------------------------------------------------------------------
%   See also PLOTARC, PLOTARC3, PLOTFLOWS, PLOTHARC, PLOTHARCCOLOR,
%   PLOTHARCCOLOR3D, PLOTHYBRIDARC, PLOTJUMPS.
%   Copyright @ Hybrid Systems Laboratory (HSL),
%   Revision: 0.0.0.4 Date: 03/29/2016 00:26:00

if ~exist('jstar','var') || isempty(jstar)
    jstar = [];
end
modificatorF{1} = 'b';
modificatorJ{1} = 'r--';
if ~exist('resolution','var') || isempty(resolution)
    resolution = [];
end

plotarc(t,j,x,[],jstar,modificatorF,modificatorJ,resolution);
