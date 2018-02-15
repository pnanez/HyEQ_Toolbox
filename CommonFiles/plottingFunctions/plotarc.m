function [x_sliced,t_sliced] = plotarc(t,j,x,L,jstar,modificatorF,modificatorJ,resolution,DDD,true3D)
%   PLOTARC   Hybrid arc plot (n states and n hybrid time domains).
%   [x_sliced,t_sliced] = PLOTARC(t,j,x) plots hybrid time vector (matrix)
%   (t,j) versus vector (matrix) x taking into account jumps j. If x is a
%   matrix, then the vector is plotted versus the rows or columns of the
%   matrix, whichever line up. If t and j are a matrices, then each column
%   of x will be plotted according to the hybrid time domain composed for
%   each column of t and j. The function returns an array of cell elements
%   with x and t data indexed by j.
%
%   [x_sliced,t_sliced] = PLOTARC(t,j,x,L) plots hybrid time vector
%   (matrix) (t,j) versus vector (matrix) x taking into account jumps j.
%   The hybrid arc is plotted with L data (matrix) as color. The input
%   vectors (matrices) t, j, x, L must have the same length (number of
%   rows).
%
%   [x_sliced,t_sliced] = PLOTARC(t,j,x,[L],jstar) plots hybrid time vector
%   (matrix) (t,j) versus vector (matrix) x taking into account jumps j,
%   and the plot is cut regarding the jstar interval (jstar = [j-initial
%   j-final]). The parameter L is optional.
%
%   [x_sliced,t_sliced] = PLOTARC(t,j,x,[L],[jstar],modificatorF,modificatorJ)
%   plots hybrid time vector (matrix) (t,j) versus vector (matrix) x taking
%   into account jumps j, and the plot is cut regarding the jstar interval
%   (jstar = [j-initial j-final]). The inputs modificatorF and modificatorJ
%   modifies the type of line used for flows and jumps, respectively.
%   modificatorF (modificatorJ) must be a cell array that contains the
%   standard matlab ploting modificators (see example). The default values
%   are modificatorF{1} = '', and modificatorJ{1} = '*--'.
%
%   Various line types, plot symbols and colors may be obtained with
%   PLOTARC(t,j,x,[],[jstar],modificatorF,modificatorJ) where modificator
%   is a cell array created with the following strings:
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
%   [x_sliced,t_sliced] = PLOTARC(t,j,x,[L],[jstar],[modificatorF],
%   [modificatorJ],resolution) plots hybrid time vector (matrix) (t,j)
%   versus vector (matrix) x taking into account jumps j, and the plot is
%   cut regarding the jstar interval (jstar = [j-initial j-final]).
%   Modificators must be cell arrays that contains the standard matlab
%   ploting modificators (see example). Also, a maximum resolution in
%   between jumps is given by the input variable resolution.
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
%         PLOTARC(ta,ja,xa);
%         xlabel('time')
%         ylabel('x_1, x_2')
%         grid on
%
%         % Compute a test function
%         L = xb(:,2).^2*1/2+9.81.*xb(:,1);
%
%         % Plot the hybrid arc Vs the hybrid time domain (t,j) using the data of L as color.
%
%         figure(2)
%         PLOTARC(tb,jb,xb,L);
%         xlabel('time')
%         ylabel('x_1, x_2')
%         grid on
%
%         % Plot the hybrid arc Vs the hybrid time domain (t,j) for a specified jump span $j\in[3,5]$
%
%         figure(3)
%         PLOTARC(tc,jc,xc,[],[3,5]);
%         xlabel('time')
%         ylabel('x_1, x_2')
%         grid on
%
%         % Plot and get the hybrid arc Vs the hybrid time domain (t,j) for a specified jump
%
%         figure(4)
%         [x_sliced,t_sliced] = PLOTARC(tc,jc,xc,[],[5]);
%         xlabel('time')
%         ylabel('x_1, x_2')
%         grid on
%
%
%         % Use the modificators
%         figure(5)
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
%         PLOTARC(ta,ja,xa,[],[],modificatorF,modificatorJ);
%         xlabel('time')
%         ylabel('x_1, x_2')
%         hold on
%         grid on
%
%         % Plot a phase plane e.g., $x_1$ Vs $x_2$
%
%         figure(6)
%         PLOTARC(xb(:,1),jb,xb(:,2),L);
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
%         figure(7)
%         subplot(2,1,1),PLOTARC(t,j,x1);
%         xlabel('x_1')
%         ylabel('time')
%         grid on
%         subplot(2,1,2),PLOTARC(t,j,x2);
%         xlabel('x_2')
%         ylabel('time')
%         grid on
%
%         % Plot different hybrid arcs Vs the hybrid time domains (t,j) using reduced resolution
%
%         figure(8)
%         subplot(2,1,1),PLOTARC(t,j,x1,j,[3,5],[],[],7);
%         xlabel('x_1')
%         ylabel('time')
%         grid on
%         subplot(2,1,2),PLOTARC(t,j,x2,j,[3,5],[],[],7);
%         xlabel('x_2')
%         ylabel('time')
%         grid on
%
%--------------------------------------------------------------------------
% Matlab M-file Project: HyEQ Toolbox @  Hybrid Systems Laboratory (HSL),
% https://hybrid.soe.ucsc.edu/software
% http://hybridsimulator.wordpress.com/
% Filename: PLOTARC.m
%--------------------------------------------------------------------------
%   See also PLOTARC, PLOTARC3, PLOTFLOWS, PLOTHARC, PLOTHARCCOLOR,
%   PLOTHARCCOLOR3D, PLOTHYBRIDARC, PLOTJUMPS.
%   Copyright @ Hybrid Systems Laboratory (HSL),
%   Revision: 0.0.0.1 Date: 03/25/2016 12:25:00

%% check matlab version
mver = ver('matlab');
mverok = ~verLessThan('matlab', '8.4');
if mverok==0 % pre R2014b plot behaviour
    ColOrd = get(0,'DefaultAxesColorOrder');
end


%  if possible, fast plot
fastpl = false;


%% input management
if ~exist('L','var')
    L = [];
end
% Define type of plot
if isempty(L) % hybrid arc plot
    color = false;
else
    color = true;
end
if ~exist('DDD','var') || isempty(DDD)
    DDD = false;
end
if ~exist('true3D','var') || isempty(true3D)
    true3D = false;
end
    
[rx,cx] = size(x);
[rt,ct] = size(t);
[rj,cj] = size(j);
[rl,cl] = size(L);
% reorientate x, t, or j if necessary
if rt~=rj || ct~=cj || (color==true && (rl~=rj||cl~=cj))
    fprintf('Error, t, j, or L does not have the proper sizes\n')
    return
elseif rx==rt
    nt = rt;
elseif rx==ct && rx~=cx
    nt = rx;
    t = t';
    j = j';
    L = L';
    [rt,ct] = size(t);
    [rj,cj] = size(j);
    [rl,cl] = size(L);
elseif ct==1 && cx==rt
    nt = rt;
    x = x';
    [rx,cx] = size(x);
else
    fprintf('Error, x does not have the proper size\n')
    return
end

if ct>cx
    fprintf('Error, there are more hybrid time domains than arcs\n')
    return
elseif rt == 1
    nt = ct;
    x = x';
    t = t';
    j = j';
    L = L';
    [rx,cx] = size(x);
    [rt,ct] = size(t);
    [rj,cj] = size(j);
    [rl,cl] = size(L);
elseif ct<cx
    if ct==1
        fastpl = true; % fast plot
    end
    ttemp = repmat(t(:,1),1,cx-ct);
    t = [t,ttemp];
    jtemp = repmat(j(:,1),1,cx-ct);
    j = [j,jtemp];
    if color
        Ltemp = repmat(L(:,1),1,cx-ct);
        L = [L,Ltemp];
        [rl,cl] = size(L);
    end
    [rt,ct] = size(t);
    [rj,cj] = size(j);
    fprintf('Warning, there are some missing hybrid time domains\n')
end

if true3D && cx == 3
    true3D = true;
    DDD = false;
else
    true3D = false;
end

if ~exist('jstar','var') || isempty(jstar) % pick the max and the min!
    jstar = [min(j(1,:)) max(j(end,:))];
    iini = jstar(1);
    ifini = jstar(end);
elseif exist('jstar','var')
    iini = jstar(1);
    try
        ifini = jstar(2);
    catch
        ifini = jstar(1);
    end
    
end

if ~exist('modificatorF','var') || isempty(modificatorF)
    modificatorF{1} = '';
end
if DDD || true3D
    if ~exist('modificatorJ','var') || isempty(modificatorJ)
        modificatorJ{1} = '--';
    end
else
    if ~exist('modificatorJ','var') || isempty(modificatorJ)
        modificatorJ{1} = '*--';
    end
end

if ~exist('resolution','var') || isempty(resolution)
    resolution = nt;
end

%% output management

% Outputs
nout = nargout;

%  if possible, fast plot
if color==false && cj>1
    for ij = 1:rj
        fastpl = sum(j(ij,:)==j(ij,1))==cj;
        if fastpl==0,
            break;
        end
    end
elseif cj==1
    fastpl = 1;
end

% ------------- Fast plot
if fastpl==1 && color == false % Fast plot possible
    if nout~=0 % improve speed
        x_sliced{ifini-iini+1,cx} = [];
        t_sliced{ifini-iini+1,cx} = [];
    end
    for ij=1:ifini-iini+1
        indexi = find(j(:,1) == iini+ij-1);
        iij = indexi(1);
        if (length(indexi) > resolution)
            step = round(length(indexi) / resolution);
            indexitemp = indexi(1:step:end);
            if indexitemp(end) ~= indexi(end)
                indexitemp(end+1) = indexi(end);
            end
            indexi = indexitemp;
        end
        if nout~=0 % improve speed
            for ix=1:cx
                x_sliced{ij,ix} = x(indexi,ix);
                t_sliced{ij,ix} = t(indexi,ix);
            end
        end
        if mverok==1 % post R2014b plot behaviour
            set(gca,'ColorOrderIndex',1);
        end
        if length(indexi)>1
            if DDD
                plot3(j(indexi,:),t(indexi,:),x(indexi,:),modificatorF{1:end})
            elseif true3D
                plot3(x(indexi,1),x(indexi,2),x(indexi,3),modificatorF{1:end})                
            else
                plot(t(indexi,:),x(indexi,:),modificatorF{1:end})
            end            
        end
        if ij>1
            if mverok==1 && color==false % post R2014b plot behaviour
                set(gca,'ColorOrderIndex',1);
            end
            if DDD
                plot3(j(iij-1:iij,:),t(iij-1:iij,:),x(iij-1:iij,:),...
                    modificatorJ{1:end});
            elseif true3D
                plot3(x(iij-1:iij,1),x(iij-1:iij,2),x(iij-1:iij,3),...
                    modificatorJ{1:end});                
            else
                plot(t(iij-1:iij,:),x(iij-1:iij,:),...
                    modificatorJ{1:end});
            end
        end
        hold on;
    end
    hold off;
    return
    % ------------- arc plot and color plot
elseif color || fastpl==0 % color plot or no fast plot
    if true3D
        eacharc = 1;
    else
        eacharc = cx;
    end
    for ix=1:eacharc % for each arc
        for ij=1:ifini-iini+1
            indexi = find(j(:,ix) == iini+ij-1);
            if ~isempty(indexi)
                iij = indexi(1);
                if (length(indexi) > resolution)
                    step = round(length(indexi) / resolution);
                    indexitemp = indexi(1:step:end);
                    if indexitemp(end) ~= indexi(end)
                        indexitemp(end+1) = indexi(end);
                    end
                    indexi = indexitemp;
                end
                if nout~=0 % improve speed
                    for tempix=1:cx
                        x_sliced{ij,tempix} = x(indexi,tempix);
                        t_sliced{ij,tempix} = t(indexi,tempix);
                    end
                end
                if color % COLOR PLOT
                    col{ij} = L(indexi,ix);
                    if length(indexi)>1
                        if DDD
                            Xdata = [j(indexi,ix),j(indexi,ix)];
                            Ydata = [t(indexi,ix),t(indexi,ix)];
                            Zdata = [x(indexi,ix),x(indexi,ix)];
                            Cdata = [col{ij},col{ij}];
                        elseif true3D
                            Xdata = [x(indexi,1),x(indexi,1)];
                            Ydata = [x(indexi,2),x(indexi,2)];
                            Zdata = [x(indexi,3),x(indexi,3)];
                            Cdata = [col{ij},col{ij}];                            
                        else
                            Xdata = [t(indexi,ix),t(indexi,ix)];
                            Ydata = [x(indexi,ix),x(indexi,ix)];
                            Zdata = [zeros(size(indexi)),zeros(size(indexi))];
                            Cdata = [col{ij},col{ij}];
                        end
                    else
                        if DDD
                            Xdata = [j(indexi,ix)*ones(2)];
                            Ydata = [t(indexi,ix)*ones(2)];
                            Zdata = [x(indexi,ix)*ones(2)];
                            Cdata = [col{ij}*ones(2)];
                        elseif true3D                            
                            Xdata = [x(indexi,1)*ones(2)];
                            Ydata = [x(indexi,2)*ones(2)];
                            Zdata = [x(indexi,3)*ones(2)];
                            Cdata = [col{ij}*ones(2)];
                        else
                            Xdata = [t(indexi,ix)*ones(2)];
                            Ydata = [x(indexi,ix)*ones(2)];
                            Zdata = [zeros(size(indexi))*ones(2)];
                            Cdata = [col{ij}*ones(2)];
                        end                        
                    end
                    surface(...
                        'XData',Xdata,...
                        'YData',Ydata,...
                        'ZData',Zdata,...
                        'CData',Cdata,...
                        'facecol','no','edgecol','flat','linew',2);                    
                    hold on;
                    try
                        if DDD
                            Xdata = [j(iij-1:iij,ix),j(iij-1:iij,ix)];
                            Ydata = [t(iij-1:iij,ix),t(iij-1:iij,ix)];
                            Zdata = [x(iij-1:iij,ix),x(iij-1:iij,ix)];
                            Cdata = [L(iij-1:iij,ix),L(iij-1:iij,ix)];
                            surface(...
                                'XData',Xdata,...
                                'YData',Ydata,...
                                'ZData',Zdata,...
                                'CData',Cdata,...
                                'LineStyle','--',...
                                'facecol','no','edgecol','flat','linew',1);
                        elseif true3D
                            Xdata = [x(iij-1:iij,1),x(iij-1:iij,1)];
                            Ydata = [x(iij-1:iij,2),x(iij-1:iij,2)];
                            Zdata = [x(iij-1:iij,3),x(iij-1:iij,3)];
                            Cdata = [L(iij-1:iij,ix),L(iij-1:iij,ix)];
                            surface(...
                                'XData',Xdata,...
                                'YData',Ydata,...
                                'ZData',Zdata,...
                                'CData',Cdata,...
                                'LineStyle','--',...
                                'facecol','no','edgecol','flat','linew',1);                            
                        else
                            Xdata = [t(iij-1:iij,ix),t(iij-1:iij,ix)];
                            Ydata = [x(iij-1:iij,ix),x(iij-1:iij,ix)];
                            Zdata = [zeros(size(t(iij-1:iij,ix))),zeros(size(t(iij-1:iij,ix)))];
                            Cdata = [L(iij-1:iij,ix),L(iij-1:iij,ix)];
                            surface(...
                                'XData',Xdata,...
                                'YData',Ydata,...
                                'ZData',Zdata,...
                                'CData',Cdata,...
                                'LineStyle','--','Marker','*',...
                                'facecol','no','edgecol','flat','linew',1);
                        end
                    catch
                    end
                elseif fastpl==0 % NO FAST PLOT
                    if  mverok==0 % pre R2014b plot behaviour
                        set(0,'DefaultAxesColorOrder',circshift(ColOrd,1-ix))
                        set(gca,'ColorOrder',circshift(ColOrd,1-ix))
                    end
                    if length(indexi)>1
                        if mverok==1 % post R2014b plot behaviour
                            set(gca,'ColorOrderIndex',ix);
                        end
                        if DDD
                            plot3(j(indexi,ix),t(indexi,ix),x(indexi,ix),...
                                modificatorF{1:end})
                        elseif true3D
                            plot3(x(indexi,1),x(indexi,2),x(indexi,3),...
                                modificatorF{1:end})                            
                        else
                            plot(t(indexi,ix),x(indexi,ix),...
                                modificatorF{1:end})
                        end
                        hold on;
                    end
                    try
                        if mverok==1 % post R2014b plot behaviour
                            set(gca,'ColorOrderIndex',ix);
                        end
                        if DDD
                            plot3(j(iij-1:iij,ix),t(iij-1:iij,ix),x(iij-1:iij,ix),...
                                modificatorJ{1:end});
                        elseif true3D
                            plot3(x(iij-1:iij,1),x(iij-1:iij,2),x(iij-1:iij,3),...
                                modificatorJ{1:end});                            
                        else
                            plot(t(iij-1:iij,ix),x(iij-1:iij,ix),...
                                modificatorJ{1:end});
                        end
                    catch
                    end
                    
                end
            end
        end
    end
    if  mverok==0% pre R2014b plot behaviour
        set(0,'DefaultAxesColorOrder',ColOrd)
    end
end
