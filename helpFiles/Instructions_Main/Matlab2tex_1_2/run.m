function run
% initial conditions
x1_0 = 1;
x2_0 = 0;
x0 = [x1_0;x2_0];
% simulation horizon
TSPAN=[0 10];
JSPAN = [0 20];
% rule for jumps
% rule = 1 -> priority for jumps
% rule = 2 -> priority for flows
rule = 1;
options = odeset('RelTol',1e-6,'MaxStep',.1);
% simulate
[t,j,x] = HyEQsolver(@f,@g,@C,@D,x0,TSPAN,JSPAN,rule,options);
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
figure(3)
plotHybridArc(t,j,x)
xlabel('j')
ylabel('t')
zlabel('x1')
grid on
view(37.5,30)