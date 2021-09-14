classdef SystemWithZOH < CompositeHybridSystem
         
    methods  
        function obj = SystemWithZOH(plant, sample_time)
            zoh_dim = plant.input_dimension;
            zoh_controller = ZeroOrderHold(zoh_dim, sample_time);
            obj = obj@CompositeHybridSystem(plant, zoh_controller);
        end
        
        function u_1C = kappa_1C(this, ~, x2)
            u_1C = x2(this.subsystem2.zoh_indices);            
        end
        
        function u_2C = kappa_2C(this, x1, ~)
            u_2C = x1; % Unused     
        end
        
        function u_1D = kappa_1D(this, ~, x2) 
            u_1D = x2(this.subsystem2.zoh_indices); 
        end
        
        function u_2D = kappa_2D(this, x1, ~)
            u_2D = x1;
        end
       
    end

end