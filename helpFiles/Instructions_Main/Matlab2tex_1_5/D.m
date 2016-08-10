function v = D(x, u)
% state
xi = z(statevect);
xi1 = xi(1);      %x-position
xi2 = xi(2);      %y-position
xi3 = xi(3);      %orientation angle
q = xi(4);
% q = 1 --> going left
% q = 2 --> going right
% jump set
if ((xi1 >= 1) && (q == 2)) || ((xi1 <= -1) && (q == 1))  % jump condition
     v = 1;  % report jump
 else
     v = 0; % do not report jump
 end
