% plot solution
figure(1) % position
clf
subplot(2,1,1),plotflows(t,j,x(:,1))
grid on
ylabel('x1')
subplot(2,1,2),plotjumps(t,j,x(:,1))
grid on
ylabel('x1')
figure(2) % velocity
clf
subplot(2,1,1),plotflows(t,j,x(:,2))
grid on
ylabel('x2')
subplot(2,1,2),plotjumps(t,j,x(:,2))
grid on
ylabel('x2')
% plot hybrid arc
figure(2)
plotHybridArc(t,j,x)
xlabel('j')
ylabel('t')
zlabel('x1')
grid on
view(37.5,30)