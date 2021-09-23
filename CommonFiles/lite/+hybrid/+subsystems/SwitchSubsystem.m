classdef SwitchSubsystem < HybridSubsystem
          
    properties (SetAccess = immutable)
        
    end
    
    properties(GetAccess = private, SetAccess = immutable)
        u0_indices
        u1_indices
        q_to_0_index
        q_to_1_index
    end
    
    methods
        function obj = SwitchSubsystem(switched_input_dimension)
            p = switched_input_dimension;
            in_dim = 2*p + 2;
            out_dim = p;
            u0_indices = 1:p;
            u1_indices = p + u0_indices;
            q_to_0_index = 2*p + 1;
            q_to_1_index = 2*p + 2;
            
            function y = output_switch(q, u)
                switch q
                    case 0
                        y = u(u0_indices);
                    case 1
                        y = u(u1_indices);
                    otherwise
                        error('q=%f was not 0 or 1.', q)
                end
            end
            
            state_dim = 1;
            output = @(q, u) output_switch(q, u);
            obj = obj@HybridSubsystem(state_dim, in_dim, out_dim, output);
            obj.u0_indices = u0_indices;
            obj.u1_indices = u1_indices;
            obj.q_to_0_index = q_to_0_index;
            obj.q_to_1_index = q_to_1_index;
        end       
        
        function u = wrapInput(~, u0, u1, q_to_0, q_to_1)
            u = [u0; u1; q_to_0; q_to_1];
        end
        
        function [u0, u1, q_to_0, q_to_1] = unwrapInput(this, u)
            u0 = u(this.u0_indices);
            u1 = u(this.u1_indices);
            q_to_0 = u(this.q_to_0_index);
            q_to_1 = u(this.q_to_1_index);
        end
        
        function qdot = flowMap(this, q, u, t, j) %#ok<INUSD>
            qdot = 0;
        end

        function qplus = jumpMap(this, q, u, t, j)  %#ok<INUSD>
            [~, ~, q_to_0, q_to_1] = this.unwrapInput(u);
            if q == 0 && q_to_1
                qplus = 1;
            elseif q == 1 && q_to_0
                qplus = 0;
            else
                qplus = q;
            end
        end 

        function C = flowSetIndicator(this, q, u, t, j)  %#ok<INUSD>
            C = 1;
        end

        function D = jumpSetIndicator(this, q, u, t, j) %#ok<INUSD>
            [~, ~, q_to_0, q_to_1] = this.unwrapInput(u);
            if q == 0 && q_to_1
                D = 1;
            elseif q == 1 && q_to_0
                D = 1;
            else
                D = 0;
            end
        end
    end
    
end