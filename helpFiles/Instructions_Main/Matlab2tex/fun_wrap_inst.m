function xdelta = fun_wrap(x,t,j,h,nargfun)
%fun_wrap   Variable input arguments function (easy use for users).
%   fun_wrap(x,t,j,h,nargfun) depending on the function h written by the
%   user, this script selects how the HyEQ solver should call that
%   function.
%    x: state
%    t: time
%    j: discrete time
%    h: function handle
%    nargfun: number of input arguments of function h    
%--------------------------------------------------------------------------
% Matlab M-file Project: HyEQ Toolbox @  Hybrid Systems Laboratory (HSL), 
% https://hybrid.soe.ucsc.edu/software
% http://hybridsimulator.wordpress.com/
% Filename: fun_wrap.m
%--------------------------------------------------------------------------
%   See also HYEQSOLVER, PLOTARC, PLOTARC3, PLOTFLOWS, PLOTHARC,
%   PLOTHARCCOLOR, PLOTHARCCOLOR3D, PLOTHYBRIDARC, PLOTJUMPS.
%   Copyright @ Hybrid Systems Laboratory (HSL),
%   Revision: 0.0.0.3 Date: 01/28/2016 5:12:00


switch nargfun
    case 1
        xdelta = h(x);
    case 2
        xdelta = h(x,t);
    case 3
        xdelta = h(x,t,j);        
end
end
