function [x_sliced,t_sliced] = plotHarc(t,j,x,jstar,modificatorF,modificatorJ,resolution)
%PLOTHARC   Hybrid arc plot (n states and n hybrid time domains).
%   [x_sliced,t_sliced] = PLOTHARC(t,j,x) plots hybrid time vector (matrix)
%   (t,j) versus vector (matrix) x taking into account jumps j. If x is a
%   matrix, then the vector is plotted versus the rows or columns of the
%   matrix, whichever line up. If t and j are a matrices, then each column
%   of x will be plotted according to the hybrid time domain composed for
%   each column of t and j. The function returns an array of cell elements
%   with x and t data indexed by j.
%
%   [x_sliced,t_sliced] = PLOTHARC(t,j,x,jstar) plots hybrid time vector
%   (matrix) (t,j) versus vector (matrix) x taking into account jumps j,
%   and the plot is cut regarding the jstar interval (jstar = [j-initial
%   j-final]).
%
%   PLOTHARC(t,j,x,[jstar],modificatorF,modificatorJ) plots hybrid time
%   vector (matrix) (t,j) versus vector (matrix) x taking into account
%   jumps j, and the plot is cut regarding the jstar interval (jstar =
%   [j-initial j-final]). The inputs modificatorF and modificatorJ modifies
%   the type of line used for flows and jumps, respectively. modificatorF
%   (modificatorJ) must be a cell array that contains the standard matlab
%   ploting modificators (see example). The default values are
%   modificatorF{1} = '', and modificatorJ{1} = '*--'.
%
%   PLOTHARC(t,j,x,[jstar],[modificatorF],[modificatorJ],resolution) plots
%   hybrid time vector (matrix) (t,j) versus vector (matrix) x taking into
%   account jumps j, and the plot is cut regarding the jstar interval
%   (jstar = [j-initial j-final]). Modificators must be cell arrays that
%   contains the standard matlab ploting modificators (see example). Also,
%   a maximum resolution in between jumps is given by the input variable
%   resolution.
%
%   Various line types, plot symbols and colors may be obtained with
%   PLOTHARC(t,j,x,jstar,modificator) where modificator is a cell array
%   created with the following strings:
%
%          b     blue          .     point              -     solid
%          g     green         o     circle             :     dotted
%          r     red           x     x-mark             -.    dashdot
%          c     cyan          +     plus               --    dashed
%          m     magenta       *     star             (none)  no line
%          y     yellow        s     square
%          k     black         d     diamond
%          w     white         v     triangle (down)
%                              ^     triangle (up)
%                              <     triangle (left)
%                              >     triangle (right)
%                              p     pentagram
%                              h     hexagram
%
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
%         JSPAN = [0 60];
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
%
%         % Plot the hybrid arc Vs the hybrid time domain (t,j)
%         figure(1)
%         PLOTHARC(ta,ja,xa);
%         xlabel('time')
%         ylabel('x_1, x_2')
%         grid on
%
%         % Plot the hybrid arc Vs the hybrid time domain (t,j) for a specified jump span $j\in[3,5]$
%
%         figure(2)
%         PLOTHARC(tc,jc,xc,[3,5]);
%         xlabel('time')
%         ylabel('x_1, x_2')
%         grid on
%
%         % Plot and get the hybrid arc Vs the hybrid time domain (t,j) for a specified jump
%
%         figure(3)
%         [x_sliced,t_sliced] = PLOTHARC(tc,jc,xc,[5]);
%         xlabel('time')
%         ylabel('x_1, x_2')
%         grid on
%
%
%         % Use the modificators
%         figure(4)
%         modificatorF{1} = 'b';
%         modificatorF{2} = 'LineWidth';
%         modificatorF{3} = 3;
%         modificatorJ{1} = '-.';
%         modificatorJ{2} = 'LineWidth';
%         modificatorJ{3} = 2;
%         modificatorJ{4} = 'Marker';
%         modificatorJ{5} = 'p';
%         modificatorJ{6} = 'MarkerEdgeColor';
%         modificatorJ{7} = 'r';
%         modificatorJ{8} = 'MarkerFaceColor';
%         modificatorJ{9} = 'b';
%         modificatorJ{10} = 'MarkerSize';
%         modificatorJ{11} = 6;
%
%         PLOTHARC(ta,ja,xa,[],modificatorF,modificatorJ);
%         xlabel('time')
%         ylabel('x_1, x_2')
%         hold on
%         grid on
%
%         % Plot a phase plane e.g., $x_1$ Vs $x_2$
%
%         figure(5)
%         PLOTHARC(xb(:,1),jb,xb(:,2));
%         xlabel('x_1')
%         ylabel('x_2')
%         xlim([-0.1, 1])
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
%         figure(6)
%         subplot(2,1,1),PLOTHARC(t,j,x1);
%         xlabel('x_1')
%         ylabel('time')
%         grid on
%         subplot(2,1,2),PLOTHARC(t,j,x2);
%         xlabel('x_2')
%         ylabel('time')
%         grid on
%
%         % Plot different hybrid arcs Vs the hybrid time domains (t,j) using reduced resolution
%         
%         figure(7)
%         subplot(2,1,1),PLOTHARC(t,j,x1,[3,5],[],[],7);
%         xlabel('x_1')
%         ylabel('time')
%         grid on
%         subplot(2,1,2),PLOTHARC(t,j,x2,[3,5],[],[],7);
%         xlabel('x_2')
%         ylabel('time')
%         grid on
%
%--------------------------------------------------------------------------
% Matlab M-file Project: HyEQ Toolbox @  Hybrid Systems Laboratory (HSL), 
% https://hybrid.soe.ucsc.edu/software
% http://hybridsimulator.wordpress.com/
% Filename: PLOTHARC.m
%--------------------------------------------------------------------------
%   See also PLOTARC, PLOTARC3, PLOTFLOWS, PLOTHARC, PLOTHARCCOLOR,
%   PLOTHARCCOLOR3D, PLOTHYBRIDARC, PLOTJUMPS.
%   Copyright @ Hybrid Systems Laboratory (HSL),
%   Revision: 0.0.0.3 Date: 03/28/2016 23:54:00

if ~exist('jstar','var') || isempty(jstar)
    jstar = [];
end
if ~exist('modificatorF','var') || isempty(modificatorF)
    modificatorF = [];
end
if ~exist('modificatorJ','var') || isempty(modificatorJ)
    modificatorJ = [];
end
if ~exist('resolution','var') || isempty(resolution)
    resolution = [];
end

[x_sliced,t_sliced] = plotarc(t,j,x,[],jstar,modificatorF,modificatorJ,resolution);
