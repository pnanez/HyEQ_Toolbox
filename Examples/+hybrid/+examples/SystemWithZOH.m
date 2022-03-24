classdef SystemWithZOH < CompositeHybridSystem
% 
% Added in HyEQ Toolbox version 3.0 

% Written by Paul K. Wintz, Hybrid Systems Laboratory, UC Santa Cruz (©2022). 
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