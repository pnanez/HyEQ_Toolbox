classdef (Abstract) HybridSystem < handle

    properties
        jump_priority = HybridPriorityRule.JUMP;
        mass_matrix = [];

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
        % flow_map function must be implemented with one of the following 
        % signatures: flow_map(this, x, t, j), flow_map(this, x, t)
        % or flow_map(this, x). 
        xdot = flow_map(this, x, t, j)  

        % In a concrete implemention of the HybridSystem class, the 
        % jump_map function must be implemented with one of the following 
        % signatures: jump_map(this, x, t, j), jump_map(this, x, t)
        % or jump_map(this, x). 
        xplus = jump_map(this, x, t, j)  

        % In a concrete implemention of the HybridSystem class, the 
        % flow_set_indicator function must be implemented with one of the 
        % following signatures: flow_set_indicator(this, x, t, j), 
        % flow_set_indicator(this, x, t) or flow_set_indicator(this, x). 
        C = flow_set_indicator(this, x, t, j) 

        % In a concrete implemention of the HybridSystem class, the 
        % jump_set_indicator function must be implemented with one of the 
        % following signatures: jump_set_indicator(this, x, t, j), 
        % jump_set_indicator(this, x, t) or jump_set_indicator(this, x). 
        D = jump_set_indicator(this, x, t, j)
    end

    methods
        function this = HybridSystem()
            % WARNING: Don't reference function handles for 
            % "@this.flow_map," "@this.jump_map," etc. in the constructor, it does
            % not work as expected. It appears to store a reference to this
            % as it is at this point, in its unconstructed state.
        end
        
        function sol = solve(this, x0, tspan, jspan, config)
            % SOLVE Compute a solution to this hybrid system starting from
            % initial state 'x0' over continuous time 'tspan' and discrete
            % time 'jspan'.

            if ~exist('config', 'var')
                config = ODESolverConfig();
            elseif strcmp(config, "silent")
                config = ODESolverConfig().progress("silent");
            end

            % Check arguments
            narginchk(4,5);
            assert(length(tspan) == 2, "tspan should be an array of two values in the form [tstart, tend]")
            assert(length(jspan) == 2, "jspan should be an array of two values in the form [jstart, jend]")
            if ~isempty(this.state_dimension)
                assert(length(x0) == this.state_dimension, "x0 does not match the dimension of the system")
            end
            this.assert_functions_can_be_evaluated_at_point(x0, tspan(1), jspan(1));           

            % Compute solution
            [t, j, x] = HyEQsolver(this.flow_map_without_self_arg, ...
                                   this.jump_map_without_self_arg, ...
                                   this.flow_set_indicator_without_self_arg, ...
                                   this.jump_set_indicator_without_self_arg, ...
                                   x0, tspan, jspan, ...
                                   this.jump_priority, config.ode_options, ...
                                   config.solver, this.mass_matrix, config.progressListener);
            
            % Wrap solution in HybridSolution class (or another class if
            % the function wrap_solution is overriden).
            sol = this.wrap_solution(t, j, x, tspan, jspan);
        end

        % Override this function to use other wrappers.
        function sol = wrap_solution(this, t, j, x, tspan, jspan)
            sol = HybridSolution(this, t, j, x, tspan, jspan);
        end
        
    end

    properties(Access = private)
        % We cannot pass the function handles @this.jump_map, 
        % @this.jump_map, etc to HyEQsolver because each is a function of 
        % one extra argument (the reference to "this" object.) Thus, we
        % construct function handles with the first argument removed.
        flow_map_without_self_arg
        jump_map_without_self_arg
        flow_set_indicator_without_self_arg
        jump_set_indicator_without_self_arg
    end

    methods % Define getters for "<function name>_without_self_arg" functions
        function value = get.flow_map_without_self_arg(this)
            if(isempty(this.flow_map_without_self_arg))
                % If flow_map_without_self_arg has not yet been constructed,
                % then we use convert_to_fixed_nargs to do so.
                value = this.convert_to_fixed_nargs(@this.flow_map, "flow_map");
                this.flow_map_without_self_arg = value;
            else
                value = this.flow_map_without_self_arg;
            end
        end
        
        function value = get.jump_map_without_self_arg(this)
            if(isempty(this.jump_map_without_self_arg))
                % If jump_map_without_self_arg has not yet been constructed,
                % then we use convert_to_fixed_nargs to do so.
                value = this.convert_to_fixed_nargs(@this.jump_map, "jump_map");
                this.jump_map_without_self_arg = value;
            else
                value = this.jump_map_without_self_arg;
            end
        end
        
        function value = get.flow_set_indicator_without_self_arg(this)
            if(isempty(this.flow_set_indicator_without_self_arg))
                % If flow_set_indicator_without_self_arg has not yet been 
                % constructed, then we use convert_to_fixed_nargs to do so.
                value = this.convert_to_fixed_nargs(@this.flow_set_indicator, "flow_set_indicator");
                this.flow_set_indicator_without_self_arg = value;
            else
                value = this.flow_set_indicator_without_self_arg;
            end
        end
        
        function value = get.jump_set_indicator_without_self_arg(this)
            if(isempty(this.jump_set_indicator_without_self_arg))
                % If jump_set_indicator_without_self_arg has not yet been 
                % constructed, then we use convert_to_fixed_nargs to do so.
                value = this.convert_to_fixed_nargs(@this.jump_set_indicator, "jump_set_indicator");
                this.jump_set_indicator_without_self_arg = value;
            else
                value = this.jump_set_indicator_without_self_arg;
            end
        end
    end

    methods 
        % It can be difficult to work with generic HybridSystem objects
        % because the functions have an undetermined number of arguments,
        % so we define the following convenience functions that allow each
        % of the functions to be called with all three arguments "x, t, j"
        % (plus the reference to "this" object) regardless of the actual
        % implementation. Any arguements not used by the
        % implementation are ignored.
        function f = flow_map_3args(this, x, t, j)
            f = HybridSystem.evaluate_handle_with_correct_args(this.flow_map_without_self_arg, x, t, j);
        end
        function g = jump_map_3args(this, x, t, j)
            g = HybridSystem.evaluate_handle_with_correct_args(this.jump_map_without_self_arg, x, t, j);
        end
        function C = flow_set_indicator_3args(this, x, t, j)
            C = HybridSystem.evaluate_handle_with_correct_args(this.flow_set_indicator_without_self_arg, x, t, j);
        end
        function D = jump_set_indicator_3args(this, x, t, j)
            D = HybridSystem.evaluate_handle_with_correct_args(this.jump_set_indicator_without_self_arg, x, t, j);
        end
    end

    methods (Access = private)        
        function func_lambda = convert_to_fixed_nargs(this, func_handle, func_name)
            nargs = this.implementated_nargs(func_name);
            switch nargs - 1 % number of args in h, not counting the first "this" argument.
                case 1
                    func_lambda = @(x) func_handle(x);
                case 2
                    func_lambda = @(x, t) func_handle(x, t);
                case 3
                    func_lambda = @(x, t, j) func_handle(x, t, j);
                otherwise
                    error("Functions must have 2,3, or 4 arguments (including 'this'). Instead the function had %d.", nargs) 
            end
            assert(nargin(func_lambda) == nargs - 1);
        end

        function assert_functions_can_be_evaluated_at_point(this, x, t, j)
            this.assert_function_can_be_evaluated(this.flow_map_without_self_arg, this.flow_map_nargs, x, t, j)
            this.assert_function_can_be_evaluated(this.jump_map_without_self_arg, this.jump_map_nargs, x, t, j)
            this.assert_function_can_be_evaluated(this.flow_set_indicator_without_self_arg, this.flow_set_indicator_nargs, x, t, j)
            this.assert_function_can_be_evaluated(this.jump_set_indicator_without_self_arg, this.jump_set_indicator_nargs, x, t, j)
        end

        function assert_function_can_be_evaluated(this, func_handl, nargs, x, t, j)
            try
                this.evaluate(func_handl, nargs, x, t, j);
            catch e
                warning("Could not evaluate '%s'=%s at x0=%s, t=%0.2f, j=%d.", nargs, char(func_handl), mat2str(x), t, j)
                rethrow(e)
            end
        end   

        function value = evaluate(this, func_handle, nargs, x, t, j)
            % Evaluate the given function with the correct number of
            % arguements. 
            switch nargs - 1 % number of args in h, not counting the first "this" argument.
                case 1
                    value = func_handle(x);
                case 2
                    value = func_handle(x, t);
                case 3
                    value = func_handle(x, t, j);
                otherwise
                    error("Functions must have 1,2, or 3 aruments. Instead the function had %d.", nargs)
            end
        end
    end

    properties(SetAccess = private)
        flow_map_nargs int8 = -1
        jump_map_nargs int8 = -1
        flow_set_indicator_nargs int8 = -1
        jump_set_indicator_nargs int8 = -1         
    end

    methods 
        function value = get.flow_map_nargs(this)
            if this.flow_map_nargs ~= -1
                value = this.flow_map_nargs;
            else 
                value = this.implementated_nargs("flow_map");
            end
        end
        function value = get.jump_map_nargs(this)
            if this.jump_map_nargs ~= -1
                value = this.jump_map_nargs;
            else 
                value = this.implementated_nargs("jump_map");
            end
        end
        function value = get.flow_set_indicator_nargs(this)
            if this.flow_set_indicator_nargs ~= -1
                value = this.flow_set_indicator_nargs;
            else 
                value = this.implementated_nargs("flow_set_indicator");
            end
        end
        function value = get.jump_set_indicator_nargs(this)
            if this.jump_set_indicator_nargs ~= -1
                value = this.jump_set_indicator_nargs;
            else 
                value = this.implementated_nargs("jump_set_indicator");
            end
        end
    end

    methods(Access = private)
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

    methods(Access = private, Static)
        function value = evaluate_handle_with_correct_args(func_handle, x, t, j)
            % Evaluate the given function with the correct number of
            % arguements. 
            nargs = nargin(func_handle);
            switch nargs % number of args in h, not counting the first "this" argument.
                case 1
                    value = func_handle(x);
                case 2
                    value = func_handle(x, t);
                case 3
                    value = func_handle(x, t, j);
                otherwise
                    error("Functions must have 1,2, or 3 arguments. Instead the function had %d.", nargs)
            end
        end
    end

end