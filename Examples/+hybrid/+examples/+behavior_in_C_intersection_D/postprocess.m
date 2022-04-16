% Postprocessing script for Jump/Flow Behavior in the Intersection of C and D

sol_a = HybridArc(t, j, x); %#ok<*IJCL> <- suppress warning about 'j'. 

% Plot solution
figure(1)
clf
hpb = HybridPlotBuilder();
hpb.label('$x$').jumpLineStyle(':').tLabel('Flows [$t$]').jLabel('Jumps [$j$]');

subplot(2,1,1)
% figure(1)
switch rule
    case 1
        figure_title = 'Jump Priority (\texttt{rule=1})';
    case 2
        figure_title = 'Flow Priority (\texttt{rule=2})';
    case 3
        figure_title = 'Random Priority (\texttt{rule=3})';
    otherwise
        error('Unrecognized rule')
end
hpb.title(figure_title).plotFlows(sol_a)
xlim([t(1), t(end)])
ylim([0, 9])
grid minor

subplot(2,1,2)
hpb.title('').plotJumps(sol_a)
xlim([j(1)-0.5, j(end)+0.5])
ylim([0, 9])
grid minor