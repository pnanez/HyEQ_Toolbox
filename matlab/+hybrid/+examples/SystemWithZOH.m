classdef SystemWithZOH < CompositeHybridSystem
         
    methods  
        function obj = SystemWithZOH(plant, sample_time)
            zoh_dim = plant.input_dimension;
            zoh = hybrid.subsystems.ZeroOrderHold(zoh_dim, sample_time);
            obj = obj@CompositeHybridSystem(plant, zoh);
            obj.setInput(plant, @( ~, y_zoh) y_zoh);
            obj.setInput(  zoh, @(y1,     ~) y1);
        end
       
    end

end