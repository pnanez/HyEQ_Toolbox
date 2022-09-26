classdef EZHybridSubsystem < HybridSubsystem
    
    properties(SetAccess = immutable)
        f
        g
        C_indicator
        D_indicator
    end
    
    methods
        function obj = EZHybridSubsystem(f, g, C_indicator, D_indicator,...
                state_dim, input_dim, output_dim, flow_output_fnc, jump_output_fnc)
            obj = obj@HybridSubsystem(state_dim, input_dim, output_dim, ...
                                      flow_output_fnc, jump_output_fnc);
            if ~isa(f, 'function_handle')
                error('f must be a function handle')
            end
            if ~isa(g, 'function_handle')
                error('g must be a function handle')
            end
            if ~isa(C_indicator, 'function_handle')
                error('C_indicator must be a function handle')
            end
            if ~isa(D_indicator, 'function_handle')
                error('D_indicator must be a function handle')
            end
            obj.f = f;
            obj.g = g;
            obj.C_indicator = C_indicator;
            obj.D_indicator = D_indicator;
        end
            
        function xdot = flowMap(this, x, u, t, j)
            xdot = evaluate_with_correct_args(this.f, x, u, t, j);
        end

        function xplus = jumpMap(this, x, u, t, j) 
            xplus = evaluate_with_correct_args(this.g, x, u, t, j);
        end 

        function C = flowSetIndicator(this, x, u, t, j) 
            C = evaluate_with_correct_args(this.C_indicator, x, u, t, j);
        end

        function D = jumpSetIndicator(this, x, u, t, j)
            D = evaluate_with_correct_args(this.D_indicator, x, u, t, j);
        end
    end
    
end


function result = evaluate_with_correct_args(func_handle, x, u, t, j)
    narginchk(5,5)
    nargs = nargin(func_handle);
    switch nargs
        case 1
            result = func_handle(x);
        case 2
            result = func_handle(x, u);
        case 3
            result = func_handle(x, u, t);
        case 4
            result = func_handle(x, u, t, j);
        otherwise
            error('Functions must have 1-4 arguments. Instead the function had %d.', nargs) 
    end
end