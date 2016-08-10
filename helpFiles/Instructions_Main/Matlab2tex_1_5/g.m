function xplus = g(x, u)
% state
xi = z(statevect);
xi1 = xi(1);      %x-position
xi2 = xi(2);      %y-position
xi3 = xi(3);      %orientation angle
q = xi(4);
% q = 1 --> going left
% q = 2 --> going right
xi1plus=xi1;
xi2plus=xi2;
xi3plus=xi3;
qplus=q;
% jump map
if ((xi1 >= 1) && (q == 2)) || ((xi1 <= -1) && (q == 1))
   qplus = 3-q;
else
    qplus = q;
end
xplus = [xi1plus;xi2plus;xi3plus;qplus];
