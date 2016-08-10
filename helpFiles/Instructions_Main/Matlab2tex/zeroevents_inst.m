function [value,isterminal,direction] = zeroevents(x,t,j,C,D,rule,nargC,nargD)
switch rule
    case 1 % -> priority for jumps
        isterminal(1) = 1; % InsideC
        isterminal(2) = 1; % Inside(C \cap D)
        isterminal(3) = 1; % OutsideC
        direction(1) = -1; % InsideC
        direction(2) = -1; % Inside(C \cap D)
        direction(3) =  1; % OutsideC
    case 2 %(default) -> priority for flows
        isterminal(1) = 1; % InsideC
        isterminal(2) = 0; % Inside(C \cap D)
        isterminal(3) = 1; % OutsideC
        direction(1) = -1; % InsideC
        direction(2) = -1; % Inside(C \cap D)
        direction(3) =  1; % OutsideC
end

insideC = fun_wrap(x,t,j,C,nargC);
insideD = fun_wrap(x,t,j,D,nargD);
outsideC = -fun_wrap(x,t,j,C,nargC);


value(1) = 2*insideC;
value(2) = 2-insideC - insideD;
value(3) = 2*outsideC;

end

