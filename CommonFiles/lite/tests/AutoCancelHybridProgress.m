classdef AutoCancelHybridProgress < HybridProgress
% MOCKHYBRIDPROGRESS 
    
    properties 
       t_cancel = Inf;
       j_cancel = Inf;
    end

    methods
        function update(this) 
            if this.t >= this.t_cancel || this.j >= this.j_cancel
                this.cancelSolver();
            end
        end
    end
end

