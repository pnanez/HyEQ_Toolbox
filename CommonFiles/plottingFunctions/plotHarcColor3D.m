function [x_sliced,t_sliced] = plotHarcColor3D(t,j,x,L,jstar,modif_in,resolution)
%PLOTHARCCOLOR3D   Hybrid arc (3D) plot in 3 dimensions with color.
%   PLOTHARCCOLOR3D(t,j,x,L) plots hybrid time vector (t,j) versus the 3D
%   vector x (3D) taking into account jumps j. The hybrid arc is plotted
%   with L data as color. The input vectors t,j, x, L must have the same
%   length and x must have three columns.
%
%   PLOTHARCCOLOR3D(t,j,x,L,jstar) If a specific interval in j is required,
%   jstar = [j-initial j-final] must be provided.
%
%   PLOTHARCCOLOR3D(t,j,x,L,jstar,modif_in) Modificator must be a cell
%   array that contains the standard matlab ploting modificators (see
%   example)
%
%   Various line types, plot symbols and colors may be obtained with
%   plotHarc(t,j,x,jstar,modificator) where modificator is a cell array
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
%   Example
%         % Load a hybrid arc
% 
%         load Data_Example_1_2_BB
%         
%         % Compute a test function
%         L = x(:,2).^2*1/2+9.81.*x(:,1);
% 
%         % Plot the hybrid arc Vs the hybrid time domain (t,j)
%         figure(1)
%         PLOTHARCCOLOR3D(t,j,[t,x],L);
%         view(3)
%         xlabel('time')
%         ylabel('x_1')
%         zlabel('x_2')
%         grid on
% 
% 
%         % Plot the hybrid arc Vs the hybrid time domain (t,j) for a specified jump span $j\in[3,5]$
% 
%         figure(2)
%         PLOTHARCCOLOR3D(t,j,[x,L],L,[3,5]);
%         view(3)
%         xlabel('x_1')
%         ylabel('x_2')
%         zlabel('L')
%         grid on
% 
%         % Plot and get the hybrid arc Vs the hybrid time domain (t,j) for a specified jump
% 
%         figure(3)
%         [x_sliced,t_sliced] = PLOTHARCCOLOR3D(t,j,[x,L],t,[5]);
%         view(3)
%         xlabel('x_1')
%         ylabel('x_2')
%         zlabel('L')
%         grid on
% 
% 
%         % Use the modificators
%         figure(4)
% 
%         modif_in{1} = 'LineWidth';
%         modif_in{2} = 2;
%         modif_in{3} = 'Marker';
%         modif_in{4} = 'p';
%         modif_in{5} = 'MarkerEdgeColor';
%         modif_in{6} = 'r';
%         modif_in{7} = 'MarkerFaceColor';
%         modif_in{8} = 'b';
%         modif_in{9} = 'MarkerSize';
%         modif_in{10} = 6;
% 
%         PLOTHARCCOLOR3D(t,j,[x,L],L,[],modif_in);
%         view(3)
%         xlabel('x_1')
%         ylabel('x_2')
%         zlabel('L')
%         hold on
%         grid on
% 
%         % Plot a phase plane e.g., $x_1$ Vs $x_2$
% 
%         figure(5)
%         PLOTHARCCOLOR3D(x(:,1),j,[x,L],L);
%         view(3)
%         xlabel('x_1')
%         ylabel('x_2')
%         zlabel('L')
%         xlim([-0.1, 1])
%         grid on
%
%--------------------------------------------------------------------------
% Matlab M-file Project: HyEQ Toolbox @  Hybrid Systems Laboratory (HSL), 
% https://hybrid.soe.ucsc.edu/software
% http://hybridsimulator.wordpress.com/
% Filename: PLOTHARCCOLOR3D.m
%--------------------------------------------------------------------------
%   See also PLOTARC, PLOTARC3, PLOTFLOWS, PLOTHARC, PLOTHARCCOLOR,
%   PLOTHARCCOLOR3D, PLOTHYBRIDARC, PLOTJUMPS.
%   Copyright @ Hybrid Systems Laboratory (HSL),
%   Revision: 0.0.0.4 Date: 03/29/2016 5:36:00


if ~exist('L','var') || isempty(L)
    L = [];
end
if ~exist('jstar','var') || isempty(jstar)
    jstar = [];
end
if ~exist('modif_in','var') || isempty(modif_in)
    modif_in = [];
end
if ~exist('resolution','var') || isempty(resolution)
    resolution = [];
end
modificatorJ{1} = '*--';
DDD = true;
real3D = true;

[x_sliced,t_sliced] = plotarc(t,j,x,L,jstar,modif_in,modificatorJ,resolution,DDD,real3D);

