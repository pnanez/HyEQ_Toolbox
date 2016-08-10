%postprocessing for the bouncing ball example
% plot solution
figure(1)
clf
subplot(2,1,1),plotflows(t,j,x)
grid on
ylabel('x')
subplot(2,1,2),plotjumps(t,j,x)
grid on
ylabel('x')
% plot hybrid arc
figure(2)
plotHybridArc(t,j,x)
xlabel('j')
ylabel('t')
zlabel('x')
grid on
view(37.5,30)