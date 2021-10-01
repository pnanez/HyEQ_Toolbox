classdef EZHybridSystem < HybridSystem 
% EZHybridSystem is an implementation of HybridSystem that takes 
% the flow map, jump map, flow set indicator, and jump set indicator 
% functions as function handles in the constructor. This allows for a 
% HybridSystem to be quickly written in-line using anonymous functions 
% (also called "lambda functions" in some programming languages),
% which is useful for quickly writing simple systems in self-contained
% scripts.
%
% For example, to create a system with the data 
%   f(x) = -x^2, 
%   g(x, t, j) -x / (t + j), 
%   C = {x | x <= 0}, and 
%   D = {x | x >= 0}, 
% then the following function call can be used to construct the system:
% 	system = EZHybridSystem(@(x) -x^2, @, @(x) x <= 0, @(x) >= 0);
% Each of the functions in the data (f, g, C indicator, and D 
% indicator) can have 1, 2, or 3 arguments corresponding to (x, t, j). 
% The number of arguments need not match. 
%
% See the HybridSystemBuilder class for an clearer, but slightly more
% verbose approach to constructing an EZHybridSystem.
%
% WARNING: Although the function handles passed to the constructor 
% have variable numbers of arguments, the EZHybridSystem implements 
% the abstract HybridSytem functions flowMap, jumpMap, flowSetIndicator,
% jumpSetIndicator with the four arguments "(this, x, t, j)". 
%
% There are several noteworthy drawbacks to EZHybridSystem: 
%     1. For complicated systems, the EZHybridSystem syntax is 
%        impractical and difficult to read.
%     2. The implementation of EZHybridSystem introduces several layers 
%        of redirection, adding complexity to debugging function calls.
%     3. EZHybridSystem does not preserve the number of arguments for 
%        the given functions. 
% Thus, the usage of EZHybridSystem should be limited to simple examples, 
% tests, or prototypes. For more complicated systems, write a subclass of 
% HybridSystem (see the documentation of HybridSystem for details).

    properties(GetAccess = private, SetAccess = immutable)
        flowMap_handle;
        jumpMap_handle;
        flowSetIndicator_handle;
        jumpSetIndicator_handle;
    end

    methods
        function this = EZHybridSystem(flowMap_handle, jumpMap_handle, ...
                        flowSetIndicator_handle, jumpSetIndicator_handle)
            check_function_handle(flowMap_handle)
            check_function_handle(jumpMap_handle)
            check_function_handle(flowSetIndicator_handle)
            check_function_handle(jumpSetIndicator_handle)
            this.flowMap_handle = flowMap_handle;
            this.jumpMap_handle = jumpMap_handle;
            this.flowSetIndicator_handle = flowSetIndicator_handle;
            this.jumpSetIndicator_handle = jumpSetIndicator_handle;
        end

        function xdot = flowMap(this, x, t, j)
            xdot = evaluate_with_correct_args(this.flowMap_handle, x, t, j);
        end

        function x_plus = jumpMap(this, x, t, j)
            x_plus = evaluate_with_correct_args(this.jumpMap_handle, x, t, j);
        end
        
        function C = flowSetIndicator(this, x, t, j)
            C = evaluate_with_correct_args(this.flowSetIndicator_handle, x, t, j);
        end

        function D = jumpSetIndicator(this, x, t, j)
            D = evaluate_with_correct_args(this.jumpSetIndicator_handle, x, t, j);
        end
    end

end

function result = evaluate_with_correct_args(func_handle, x, t, j)
    narginchk(4,4)
    nargs = nargin(func_handle);
    switch nargs
        case 1
            result = func_handle(x);
        case 2
            result = func_handle(x, t);
        case 3
            result = func_handle(x, t, j);
        otherwise
            error('Functions must have 1,2, or 3 arguments. Instead the function had %d.', nargs) 
    end
end

function check_function_handle(function_handle)
    assert(isa(function_handle, 'function_handle'), 'Argument ''%s'' was not a function handle!', function_handle)
    nargs = nargin(function_handle);
    assert(nargs >= 1, 'There must be at least one argument (namely, ''x'')!')
    assert(nargs <= 3, 'There must be no more than three arguments (''x, t, j'')!')
end