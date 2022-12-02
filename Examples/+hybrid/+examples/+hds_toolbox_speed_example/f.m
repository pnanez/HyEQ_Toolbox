function StatesDot = f(States, t)
    
    tau       = States(2);
    StatesDot = zeros(size(States));
    
    
    StatesDot(1) = cos(tau * 10 * pi); 
    StatesDot(2) = 1; 

end