classdef FireflySubsystem < HybridSubsystem
    
% Adapted from Simulink example by Ricardo Sanfelice.
    
    properties (SetAccess = immutable) 
        state_dimension = 1;
        input_dimension = 1;
        output_dimension = 1;
        e = 0.3;
    end
    
    %%%%%% System Data %%%%%% 
    methods 
        
        function taudot = flowMap(this, tau, u, t, j) 
            taudot = 1;
        end

        function tauplus = jumpMap(this, tau, u, t, j)             
            % jump map
            if (1+this.e)*tau < 1
                tauplus = (1+this.e)*tau;
            elseif (1+this.e)*tau >= 1
                tauplus = 0;
            else
                tauplus = tau;   
            end
        end 

        function C = flowSetIndicator(this, tau, u, t, j) 
            if ((tau >= 0) && (tau <= 1)) || ((u > 0) && (u <= 1))  % flow condition
                C = 1;  % report flow
            else
                C = 0;  % do not report flow
            end
        end

        function D = jumpSetIndicator(this, tau, u, t, j)
            if tau >= 1 || u >= 1 % jump condition
                D = 1;  % report jump
            else
                D = 0;  % do not report jump
            end
        end
    end

end