% Project: Simple Example
% Description: postprocessing for Simple Example

% plot solution
figure(1)
clf
clear modificatorF modificatorJ
modificatorF{1} = 'b'; % pick the color for the flow
modificatorJ{1} = 'LineStyle';
modificatorJ{2} = '--';
modificatorJ{3} = 'marker';
modificatorJ{4} = '*';
modificatorJ{5} = 'MarkerEdgeColor';
modificatorJ{6} = 'r';
subplot(2,1,1),plotarc(t,j,x,[],[],modificatorF,modificatorJ);
grid on
ylabel('x')

modificatorF{1} = 'b--';
modificatorJ{1} = 'LineStyle';
modificatorJ{2} = 'none';
modificatorJ{3} = 'marker';
modificatorJ{4} = '*';
modificatorJ{5} = 'MarkerEdgeColor';
modificatorJ{6} = 'r';
subplot(2,1,2),plotarc(j,j,x,[],[],modificatorF,modificatorJ);
grid on
ylabel('x')
                