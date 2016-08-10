function [j tout jout xout] = jump(g,j,tout,jout,xout,nargfun)
% Jump
j = j+1;
y = fun_wrap(xout(end,:).',tout(end),jout(end),g,nargfun); 
% Save results
tout = [tout; tout(end)];
xout = [xout; y.'];
jout = [jout; j];
end

