classdef FireflySubsystem < HybridSubsystem
    
% Adapted from Simulink example by Ricardo Sanfelice.
    
    properties 
        epsilon = 0.3;
    end
    
    %%%%%% System Data %%%%%% 
    methods 
        
        function this = FireflySubsystem()
            this = this@HybridSubsystem(1, 1);
        end

        function taudot = flowMap(~, ~, ~, ~, ~) 
            taudot = 1;
        end

        function tauplus = jumpMap(this, tau, ~, ~, ~)             
            % jump map
            if (1+this.epsilon)*tau < 1
                tauplus = (1+this.epsilon)*tau;
            elseif (1+this.epsilon)*tau >= 1
                tauplus = 0;
            else
                tauplus = tau;   
            end
        end 

        function C = flowSetIndicator(~, tau, u, ~, ~) 
            if ((tau >= 0) && (tau <= 1)) || ((u > 0) && (u <= 1))  % flow condition
                C = 1;  % report flow
            else
                C = 0;  % do not report flow
            end
        end

        function D = jumpSetIndicator(~, tau, u, ~, ~)
            if tau >= 1 || u >= 1 % jump condition
                D = 1;  % report jump
            else
                D = 0;  % do not report jump
            end
        end
    end

end