classdef (Abstract) HybridSystem < handle

    properties
        % State dimension is an optional property. If set, additional error
        % checking is enabled.
        state_dimension;
    end

    %%%%%% System Data %%%%%% 
    methods(Abstract) 
        % Each of these functions must be implemented in subclasses with 
        % 2, 3, or 4 arguments (j, or t and j can be omitted). 
        % If the arguments 'x' or 'this' are not used in an implementations,
        % Matlab will show a warning. This can be surpressed by
        % adding "%#ok<INUSD>" (for 'x') or "%#ok<INUSL>" (for "this") at 
        % the end of the line.

        % In a concrete implemention of the HybridSystem class, the 
        % flowMap function must be implemented with one of the following 
        % signatures: flowMap(this, x, t, j), flowMap(this, x, t)
        % or flowMap(this, x). 
        xdot = flowMap(this, x, t, j)  

        % In a concrete implemention of the HybridSystem class, the 
        % jumpMap function must be implemented with one of the following 
        % signatures: jumpMap(this, x, t, j), jumpMap(this, x, t)
        % or jumpMap(this, x). 
        xplus = jumpMap(this, x, t, j)  

        % In a concrete implemention of the HybridSystem class, the 
        % flowSetIndicator function must be implemented with one of the 
        % following signatures: flowSetIndicator(this, x, t, j), 
        % flowSetIndicator(this, x, t) or flowSetIndicator(this, x). 
        C = flowSetIndicator(this, x, t, j) 

        % In a concrete implemention of the HybridSystem class, the 
        % jumpSetIndicator function must be implemented with one of the 
        % following signatures: jumpSetIndicator(this, x, t, j), 
        % jumpSetIndicator(this, x, t) or jumpSetIndicator(this, x). 
        D = jumpSetIndicator(this, x, t, j)
    end

    methods
        function this = HybridSystem()
            % WARNING: Don't reference function handles for 
            % "@this.flowMap," "@this.jumpMap," etc. in the constructor, it does
            % not work as expected. It appears to store a reference to this
            % as it is at this point, in its unconstructed state.
            
            names = {'flowMap', 'jumpMap', ...
                      'flowSetIndicator', 'jumpSetIndicator'};            
            mc = metaclass(this);
            for iName = 1:length(names)        
                name = names{iName};
                mask = arrayfun(@(x)strcmp(x.Name, name), mc.MethodList);
                method = mc.MethodList(mask);
                
                % Check that the first argument is a reference to 'this'
                % object, rather than the state vector.
                first_argument_name = method.InputNames{1};
                is_this = strcmp(first_argument_name, 'this');
                is_self = strcmp(first_argument_name, 'self');
                is_obj = strcmp(first_argument_name, 'obj');
                is_tilde = strcmp(first_argument_name, '~');
                assert(is_this || is_self || is_obj || is_tilde, ...
                    'The first argument in %s must be ''this'', ''self'', or ''~'' but instead was ''%s''.', ...
                    name, first_argument_name)
                
                % Check that the second argument is the state vector. 
                % For the state vector, we expect users to choose various
                % names for the state other than simply 'x' (e.g., 'z',
                % 'xhat', etc.), so instead of checking that the name
                % matches some list of strings, we make sure it does not match 't'.
                second_argument_name = method.InputNames{2};
                is_t = strcmp(second_argument_name, 't');
                assert(~is_t , ...
                    'The second argument in %s should be the state vector (e.g. ''x'') ' + ...
                    'but instead was ''t''. Did you remember the first ''this'' argument?', ...
                    name)
            end
        end
        
        function sol = solve(this, x0, tspan, jspan, config)
            % SOLVE Compute a solution to this hybrid system starting from
            % initial state 'x0' over continuous time 'tspan' and discrete
            % time 'jspan'. If 'tspan' and 'jspan' are not supplied, then
            % the default span [0, 10] is used. The optional 'config'
            % argument can either be an instance of HybridSolverConfig or
            % the string 'silent' to disable progress updates.
            
            % Check arguments
            narginchk(2,5);
            if ~exist('tspan', 'var')
               tspan = [0, 10]; 
            end
            if ~exist('jspan', 'var')
               jspan = [0, 10]; 
            end
            if length(tspan) ~= 2
                e = MException('HybridSystem:InvalidArgs', ...
                    'tspan must be an array of two values in the form [tstart, tend]');
                throwAsCaller(e);
            end
            if length(jspan) ~= 2
                e = MException('HybridSystem:InvalidArgs', ...
                    'jspan must be an array of two values in the form [jstart, jend]');
                throwAsCaller(e);
            end
            if ~exist('config', 'var')
                config = HybridSolverConfig();
            elseif strcmp(config, 'silent')
                config = HybridSolverConfig('silent');
            end

            if ~isempty(this.state_dimension)
                assert(length(x0) == this.state_dimension, ...
                    'size(x0)=%d does not match the dimension of the system=%d',...
                    length(x0), this.state_dimension)
            end
            this.assert_functions_can_be_evaluated_at_point(x0, tspan(1), jspan(1));           

            % Compute solution
            [t, j, x] = HyEQsolver(this.flowMap_3args, ...
                                   this.jumpMap_3args, ...
                                   this.flowSetIndicator_3args, ...
                                   this.jumpSetIndicator_3args, ...
                                   x0, tspan, jspan, ...
                                   config.hybrid_priority, config.ode_options, ...
                                   config.ode_solver, config.mass_matrix, ...
                                   config.progressListener);
                        
            % Wrap solution in HybridSolution class (or another class if
            % the function wrap_solution is overriden).
            sol = this.wrap_solution(t, j, x, tspan, jspan);
        end

    end
    
    methods(Access = protected)
        % Override this function to use other wrappers.
        function sol = wrap_solution(this, t, j, x, tspan, jspan)    
            xf = x(end, :)';
            Cf = this.flowSetIndicator_3args(xf, t(end), j(end));
            Df = this.jumpSetIndicator_3args(xf, t(end), j(end));
            sol = HybridSolution(t, j, x, Cf, Df, tspan, jspan);
        end
        
    end
    
    methods
        
        function [f_vals, g_vals, C_vals, D_vals] = generateFGCD(this, sol)            
            assert(isa(sol, 'HybridSolution'))

            t = sol.t;
            j = sol.j;
            x = sol.x;
            
            if ~isempty(this.state_dimension)
                assert(this.state_dimension == size(x, 2), ...
                    'Expected length of x to be %d, instead was %d',...
                    this.state_dimension, size(x, 2))
            end
            
            % Compute the values of the flow and jump maps and sets at each
            % point in the solution trajectory.
            f_vals = NaN(size(x));
            g_vals = NaN(size(x));
            C_vals = NaN(size(t));
            D_vals = NaN(size(t));
            for i=1:length(t)
                x_curr = x(i, :)';
                C_vals(i) = this.flowSetIndicator_3args(x_curr, t(i), j(i));
                D_vals(i) = this.jumpSetIndicator_3args(x_curr, t(i), j(i));
                if C_vals(i) % Only evaluate flow map in the flow set.
                    f_vals(i, :) = this.flowMap_3args(x_curr, t(i), j(i))';
                end
                if D_vals(i) % Only evaluate jump map in the jump set.
                    g_vals(i, :) = this.jumpMap_3args(x_curr, t(i), j(i))';
                end
            end
        end
    end

    properties(SetAccess = private, Hidden)
        % It can be difficult to work with generic HybridSystem objects
        % because the functions have an undetermined number of arguments.
        % Additionally, we cannot pass the function handles @this.jumpMap,
        % @this.jumpMap, etc. directly to HyEQsolver because each is a
        % function of one extra argument (the reference to "this" object.)
        % Thus, we construct function handles with with three arguments 
        % "x, t, j" (the "this" argument is removed).
        flowMap_3args
        jumpMap_3args
        flowSetIndicator_3args
        jumpSetIndicator_3args
    end

    methods % Define getters for "<function name>_3arg" functions
        function value = get.flowMap_3args(this)
            if(isempty(this.flowMap_3args))
                % If flowMap_3args has not yet been constructed,
                % then we use convert_to_3_args to do so.
                this.flowMap_3args = this.convert_to_3_args(@this.flowMap, 'flowMap');
            end
            value = this.flowMap_3args;
        end
        
        function value = get.jumpMap_3args(this)
            if isempty(this.jumpMap_3args)
                % If jumpMap_3args has not yet been constructed,
                % then we use convert_to_3_args to do so.
                this.jumpMap_3args = this.convert_to_3_args(@this.jumpMap, 'jumpMap');
            end
            value = this.jumpMap_3args;
        end
        
        function value = get.flowSetIndicator_3args(this)
            if isempty(this.flowSetIndicator_3args)
                % If flowSetIndicator_3args has not yet been 
                % constructed, then we use convert_to_3_args to do so.
                this.flowSetIndicator_3args ...
                    = this.convert_to_3_args(@this.flowSetIndicator, 'flowSetIndicator');
            end
            value = this.flowSetIndicator_3args;
        end
        
        function value = get.jumpSetIndicator_3args(this)
            if isempty(this.jumpSetIndicator_3args)
                % If jumpSetIndicator_3args has not yet been 
                % constructed, then we use convert_to_3_args to do so.
                this.jumpSetIndicator_3args ...
                    = this.convert_to_3_args(@this.jumpSetIndicator, 'jumpSetIndicator');
            end
            value = this.jumpSetIndicator_3args;
        end
    end

    methods (Access = private)        
        function func_lambda = convert_to_3_args(this, func_handle, func_name)
            nargs = this.implementated_nargs(func_name);
            switch nargs - 1 % number of args in func_handle, not counting the first "this" argument.
                case 1
                    func_lambda = @(x, t, j) func_handle(x);
                case 2
                    func_lambda = @(x, t, j) func_handle(x, t);
                case 3
                    % We cannot simplify this as "func_lambda =
                    % func_handle" because func_handle has varargsin, which
                    % includes "this" in the first argument.
                    func_lambda = @(x, t, j) func_handle(x, t, j);
                otherwise
                    error('Functions must have 2,3, or 4 arguments (including ''this''). Instead the function had %d.', nargs) 
            end
        end

        function assert_functions_can_be_evaluated_at_point(this, x, t, j)
            assert_function_can_be_evaluated(this.flowMap_3args, x, t, j, 'flowMap')
            assert_function_can_be_evaluated(this.jumpMap_3args, x, t, j, 'jumpMap')
            assert_function_can_be_evaluated(this.flowSetIndicator_3args, x, t, j, 'flowSetIndicator')
            assert_function_can_be_evaluated(this.jumpSetIndicator_3args, x, t, j, 'jumpSetIndicator')
        end

        function nargs = implementated_nargs(this, function_name)
            % For abstract methods, we cannot use the function nargin to
            % get the number of arguments for the subclass implementation
            % of a function, so we use the 'metaclass' class instead.
            % WARNING: This function call is SLOW. Avoid calling
            % repeatedly.
            mc = metaclass(this);
            method_data = mc.MethodList(strcmp({mc.MethodList.Name}, function_name));
            nargs = length(method_data.InputNames);
        end
    end
end

function assert_function_can_be_evaluated(func_handl, x, t, j, function_name)
    try
        func_handl(x, t, j);
    catch e        
        cause = MException('HybridSystem:CannotEvaluateFunction', ...
            'Could not evaluate ''%s'' at x0=%s, t=%0.2f, j=%d.', ...
            function_name, mat2str(x), t, j);
        e = e.addCause(cause);
        rethrow(e)
    end
end