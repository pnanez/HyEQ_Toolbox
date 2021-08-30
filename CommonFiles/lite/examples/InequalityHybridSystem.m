classdef InequalityHybridSystem < HybridSystem


    methods(Abstract)
        val = flow_set_defining_map(this, x, t, j)
        val = jump_set_defining_map(this, x, t, j)
    end


    methods 
        function C = flowSetIndicator(this, x, t, j) 
            C = this.flow_set_defining_map(x, t, j) <= 0;
        end
        function D = jumpSetIndicator(this, x, t, j)
            D = this.jump_set_defining_map(x, t, j) <= 0;
        end

%         function plotSets(this, slice, xlim, ylim)
%             contourf
%         end
    end
end