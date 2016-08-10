function xdot = f(x, u)
% state
xi = z(statevect);
xi1 = xi(1);      %x-position
xi2 = xi(2);      %y-position
xi3 = xi(3);      %orientation angle
q = xi(4);
% q = 1 --> going left
% q = 2 --> going right
if q == 1
    r = 3*pi/4;
elseif q == 2
    r = pi/4;
else
    r = 0;
end
% flow map: xidot=f(xi,u);
xi1dot = u*cos(xi3);  %tangential velocity in x-direction
xi2dot = u*sin(xi3);  %tangential velocity in y-direction
xi3dot = -xi3 + r;      %angular velocity
qdot = 0;
xdot = [xi1dot;xi2dot;xi3dot;qdot];
