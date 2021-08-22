classdef LinearControlledHybridSystem < ControlledHybridSystem
    
    properties(SetAccess = immutable)
        state_dimension
        control_dimension
        A_c
        B_c
        A_d
        B_d
        P_c
        P_d
        p_c
        p_d
    end
    
    %%%%%% System Data %%%%%% 
    methods
        function obj = LinearControlledHybridSystem(...
                A_c, B_c, ...
                A_d, B_d, ...
                P_c, p_c, ...
                P_d, p_d)
            n = size(A_c, 1);
            m = size(B_c, 2);
            obj.state_dimension = n;
            obj.control_dimension = m;
            % Check state matrices
            % assert(size(A_c, 1) == n, "A_c has wrong number of rows.") always true.
            assert(all(size(A_c) == [n, n]), "A_c has wrong size.")
            assert(all(size(A_d) == [n, n]), "A_d has wrong size.")
            % Check input matrices
            % assert(size(B_c, 1) == m) always true.
            assert(all(size(B_c) == [n m]), "B_c has wrong size.")
            assert(all(size(B_d) == [n m]), "B_d has wrong size.")
            obj.A_c = A_c;
            obj.B_c = B_c;
            obj.A_d = A_d;
            obj.B_d = B_d;
            obj.P_c = P_c;
            obj.p_c = p_c;
            obj.P_d = P_d;
            obj.p_d = p_d;
        end
            
        % The jump_map function must be implemented with the following 
        % signature (t and j cannot be ommited)
        function xdot = flow_map(this, x, u, t, j)
            xdot = this.A_c * x + this.B_c * u;
        end

        function xplus = jump_map(this, x, u, t, j) 
            xplus = this.A_d * x + this.B_d * u;
        end 

        function C = flow_set_indicator(this, x, u, t, j) 
            C = (x'*this.P_c*x + this.p_c) <= 0;
        end

        function D = jump_set_indicator(this, x, u, t, j)
            D = (x'*this.P_d*x + this.p_d) <= 0;
        end
    end
    
end