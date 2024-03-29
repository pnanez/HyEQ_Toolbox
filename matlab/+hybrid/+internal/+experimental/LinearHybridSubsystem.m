classdef LinearHybridSubsystem < HybridSubsystem
    
    properties(SetAccess = immutable)
        A_c
        B_c
        A_d
        B_d
%         P_c
%         P_d
%         p_c
%         p_d
        C_indicator
        D_indicator
    end
    
    properties(GetAccess = private, SetAccess = immutable)
       no_discrete
       no_control
    end
    
    %%%%%% System Data %%%%%% 
    methods
        function obj = LinearHybridSubsystem(...
                A_c, B_c, ...
                A_d, B_d, ...
                C_indicator, D_indicator)
%                 P_c, p_c, ...
%                 P_d, p_d...
                
            if isempty(A_d) && isempty(B_d)
               % No discrete motion
               no_discrete = true;
            else 
                no_discrete = false;
            end
            if isempty(B_c)
               B_c = zeros(size(A_c, 1), 0);
            end
            if isempty(B_d)
               B_d = zeros(size(B_c));
            end
            n = size(A_c, 1);
            m = size(B_c, 2);
            obj = obj@HybridSubsystem(n, m);
            obj.no_discrete = no_discrete;
            % Check state matrices
            % assert(size(A_c, 1) == n, "A_c has wrong number of rows.") always true.
            assert(all(size(A_c) == [n, n]), "A_c has wrong size.")
            if ~obj.no_discrete
                assert(all(size(A_d) == [n, n]), "A_d has wrong size.")
            end
            if ~obj.no_control
                % Check input matrices
                % assert(size(B_c, 1) == m) always true.
                assert(all(size(B_c) == [n m]), "B_c has wrong size.")
                if ~obj.no_discrete
                    assert(all(size(B_d) == [n m]), "B_d has wrong size.")
                end
            end
            obj.A_c = A_c;
            obj.B_c = B_c;
            obj.A_d = A_d;
            obj.B_d = B_d;
            
            obj.C_indicator = C_indicator;
            obj.D_indicator = D_indicator;
            
%             if ~obj.no_discrete
%                 obj.P_c = P_c;
%                 obj.p_c = p_c;
%                 obj.P_d = P_d;
%                 obj.p_d = p_d;
%             end
        end
            
        % The jumpMap function must be implemented with the following 
        % signature (t and j cannot be ommited)
        function xdot = flowMap(this, x, u, t, j)
            xdot = this.A_c * x + this.B_c * u;
        end

        function xplus = jumpMap(this, x, u, t, j) 
            xplus = this.A_d * x + this.B_d * u;
        end 

        function C = flowSetIndicator(this, x, u, t, j) 
            C = this.C_indicator(x, u, t, j);
            
%             if this.no_discrete
%                 C = 1;
%             else
%                 C = (x'*this.P_c*x + this.p_c) <= 0;
%             end
        end

        function D = jumpSetIndicator(this, x, u, t, j)
            D = this.D_indicator(x, u, t, j);
%             if this.no_discrete
%                 D = 0;
%             else
%                 D = (x'*this.P_d*x + this.p_d) <= 0;
%             end
        end
    end
    
end