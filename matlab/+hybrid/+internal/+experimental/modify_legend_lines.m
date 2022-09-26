clf
x = 1:10;
y1 = rand(1,10); % 10 random numbers 
y2 = randn(1,10); % 10 normally distributed random numbers 
plot(x,y1,'rx--',x,y2,'bo-')
[legh,objh] = legend('curve1','curve2'); % handles to the legend and its objects
legh
for i=3:length(objh)
    objh(i)
    if length(objh(i).XData) == 1
        objh(i).XData = [0.25, 0.5];
        objh(i).YData = [objh(i).YData, objh(i).YData];
    else
        objh(i).XData = [0, 0.25];
%         objh(i).YData = [objh(i).YData(1), objh(i).YData(1)-0.2];
    end
end
objh(end+1) = objh(end).copy
objh(7).Color = [0, 1, 0]
objh(7).LineStyle = '-'

legh.Position = [0.5299 0.8134 0.4568 0.0869];
objh(7).Marker = 'none'

% legh.addToLayout(objh)
% legh.fireUpdateLayoutEvent(objh)
% methods(legh,'-full')