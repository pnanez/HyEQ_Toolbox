function [x_sliced,t_sliced] = plotHarcColor(t,j,x,L,jstar,resolution)
%PLOTHARCCOLOR   Hybrid arc plot with color (n states and n hybrid time
%domains).
%   [x_sliced,t_sliced] = PLOTHARCCOLOR(t,j,x,L) plots hybrid time vector
%   (matrix) (t,j) versus vector (matrix) x taking into account jumps j.
%   The hybrid arc is plotted with L data (matrix) as color. The input
%   vectors (matrices) t, j, x, L must have the same length (number of
%   rows).
%
%   [x_sliced,t_sliced] = PLOTHARCCOLOR(t,j,x,L,jstar) plots hybrid time
%   vector (matrix) (t,j) versus vector (matrix) x taking into account
%   jumps j. The hybrid arc is plotted with L data (matrix) as color, and
%   the plot is cut regarding the jstar interval (jstar = [j-initial
%   j-final]). The parameter L is NOT optional.
%
%   [x_sliced,t_sliced] = PLOTHARCCOLOR(t,j,x,L,[jstar],resolution) plots
%   hybrid time vector (matrix) (t,j) versus vector (matrix) x taking into
%   account jumps j, and the plot is cut regarding the jstar interval
%   (jstar = [j-initial j-final]). jstar is optional. Also, a maximum
%   resolution in between jumps is given by the input variable resolution.
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
%         % Compute a test function
%         L = x(:,2).^2*1/2+9.81.*x(:,1);
%
%         % Plot $x_1$ Vs the hybrid time domain (t,j)
%
%         figure(1);
%         [x_sliced,t_sliced] = PLOTHARCCOLOR(t,j,x,L);
%         xlabel('t')
%         ylabel('x1')
%
%         % Plot $x_1$ Vs the hybrid time domain (t,j) using different color functions
%
%         figure(2);
%         PLOTHARCCOLOR([t,t],[j,j],x,[L,t.^2]);
%         xlabel('t')
%         ylabel('x1')
%
%         % Plot a phase plane e.g., $x_1$ Vs $x_2$
%
%         figure(3);
%         [x_sliced,t_sliced] = PLOTHARCCOLOR(x(:,1),j,x(:,2),L);
%         xlabel('x1')
%         ylabel('x2')
%
%         % Plot $x_1$ Vs $x_2$ for a specified jump span $j\in[3,5]$
%
%         figure(4);
%         [x_sliced,t_sliced] = PLOTHARCCOLOR(x(:,1),j,x(:,2),L,[1,3]);;
%         xlabel('x1')
%         ylabel('x2')
%
%--------------------------------------------------------------------------
% Matlab M-file Project: HyEQ Toolbox @  Hybrid Systems Laboratory (HSL), 
% https://hybrid.soe.ucsc.edu/software
% http://hybridsimulator.wordpress.com/
% Filename: PLOTHARCCOLOR.m
%--------------------------------------------------------------------------
%   See also PLOTARC, PLOTARC3, PLOTFLOWS, PLOTHARC, PLOTHARCCOLOR,
%   PLOTHARCCOLOR3D, PLOTHYBRIDARC, PLOTJUMPS.
%   Copyright @ Hybrid Systems Laboratory (HSL),
%   Revision: 0.0.0.3 Date: 03/28/2016 23:57:00

if ~exist('L','var') || isempty(L)
    L = [];
end
if ~exist('jstar','var') || isempty(jstar)
    jstar = [];
end
if ~exist('resolution','var') || isempty(resolution)
    resolution = [];
end

[x_sliced,t_sliced] = plotarc(t,j,x,L,jstar,[],[],resolution);
