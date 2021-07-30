classdef SystemWithZOH < CompoundHybridSystem
         
    methods  
        function obj = SystemWithZOH(plant, kappa, sample_time)
            zoh_dim = plant.control_dimension;
            zoh_controller = ZOHController(zoh_dim, kappa, sample_time);
            obj = obj@CompoundHybridSystem(plant, zoh_controller);
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