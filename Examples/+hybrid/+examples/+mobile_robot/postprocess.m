% Postprocessing script for Continuous-time Plant Example

% Plot state trajectory
figure(1)
clf
plotHarcColor(x(:,1), j, x(:,2),t); %#ok<IJCL> 
xlabel('x1')
ylabel('x2')
grid on
c = colorbar;
c.Label.String = '$t$ [s]';
c.Label.Interpreter = 'latex';
axis([-maxX, maxX, -maxX, maxX])
hold on

% Plot circles
hold on
hybrid.examples.mobile_robot.circle([0,0], maxX, 1000, 'k-');
legend('Trajectory', 'Target Set')
