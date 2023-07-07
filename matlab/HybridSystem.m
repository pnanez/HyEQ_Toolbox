classdef (Abstract) HybridSystem < handle
% Abstract class for defining hybrid systems. A concrete hybrid system is defined by writing a subclass of HybridSystem.
% 
% Added in HyEQ Toolbox version 3.0.

% Written by Paul K. Wintz, Hybrid Systems Laboratory, UC Santa Cruz (©2022).
% 
% Tests for this class can be opened with the command 
%   open('hybrid.tests.HybridSystemTest')
% and run with the command 
%   runtests('hybrid.tests.HybridSystemTest')

    properties% (SetAccess = immutable) Making state_dimension immutable breaks the CompositeHybridSystem constructor.
        % Dimension of the state space (optional).
        % If set, additional error-checking is enabled.
        state_dimension;
    end

    %%%%%% System Data %%%%%% 
    methods(Abstract) 
        % The following functions define the data (f, g, C, D) of the hybrid
        % system.
        % Each of these functions must be implemented in subclasses with 
        % arguments (this, x), (this, x, t), or (this, x, t, j).
        % If the arguments 'x' or 'this' are not used in an implementations,
        % Matlab will show a warning. This can be surpressed by
        % adding "%#ok<INUSD>" (for 'x') or "%#ok<INUSL>" (for "this") at 
        % the end of the line.

        % Flow map 'f'. Must be implemented in subclasses.
        %
        % In a concrete implemention of the HybridSystem class, the flowMap
        % function must be implemented in subclasses as 
        % 'flowMap(this, x)', flowMap(this, x, t)', or 'flowMap(this, x, t, j)'. 
        xdot = flowMap(this, x, t, j)  

        % Jump map 'g'. Must be implmented in subclasses.
        % 
        % In a concrete implemention of the HybridSystem class, the 
        % jumpMap function must be implemented with one of the following 
        % signatures: jumpMap(this, x), jumpMap(this, x, t)
        % or jumpMap(this, x, t, j). 
        xplus = jumpMap(this, x, t, j) 

        % Indicator function for flow set 'C'. Must be implemented in subclasses.
        % 
        % In a concrete implemention of the HybridSystem class, the 
        % flowSetIndicator function must be implemented with one of the 
        % following signatures: flowSetIndicator(this, x), 
        % flowSetIndicator(this, x, t) or flowSetIndicator(this, x, t, j). 
        C = flowSetIndicator(this, x, t, j) 

        % Indicator function for jump set 'D'. Must be implemented in subclasses.
        % 
        % In a concrete implemention of the HybridSystem class, the 
        % jumpSetIndicator function must be implemented with one of the 
        % following signatures: jumpSetIndicator(this, x), 
        % jumpSetIndicator(this, x, t) or jumpSetIndicator(this, x, t, j). 
        D = jumpSetIndicator(this, x, t, j)
    end

    methods
        function this = HybridSystem(state_dimension)
            % Constructor for hybrid system.
            % 
            % The optional argument 'state_dimension' can be provided to enable
            % additional error checking. 
            
            % WARNING: Don't reference function handles for 
            % "@this.flowMap," "@this.jumpMap," etc. in the constructor, it does
            % not work as expected. It appears to store a reference to this
            % as it is at this point, in its unconstructed state.
            
            if exist('state_dimension', 'var')
               this.state_dimension = state_dimension;
            end
            
            try
                checkMethodArgumentNames(this);
            catch e
                % We throw the exception as caller from here to create a cleaner
                % stacktrace.
               throwAsCaller(e) 
            end
        end
        
        function sol = solve(this, x0, tspan, jspan, varargin)
            % Compute a solution to this hybrid system.
            %
            % Compute a solution to this hybrid system starting from
            % initial state 'x0' over continuous time 'tspan' and discrete
            % time 'jspan'. If 'tspan' and 'jspan' are not supplied, then
            % the default span [0, 10] is used. The optional 'config'
            % argument can either be an instance of HybridSolverConfig or
            % the string 'silent' to disable progress updates.
            
            % Check arguments
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
            if tspan(1) > tspan(2)
                warning('HybridSystem:BackwardTSPAN', ...
                    'The second entry of tspan was smaller than the first.');
            end
            if jspan(1) > jspan(2)
                warning('HybridSystem:BackwardTSPAN', ...
                    'The second entry of jspan was smaller than the first.');
            end
            if ~isempty(varargin) && isa(varargin{1}, 'HybridSolverConfig')
                assert(numel(varargin) == 1, ...
                    'If a HybridSolverConfig is provided in the 4th argument, then there cannot be any more arguments.')
                config = varargin{1};
            else
                config = HybridSolverConfig(varargin{:});
            end

            if ~isempty(this.state_dimension)
                assert(length(x0) == this.state_dimension, ...
                    'size(x0)=%d does not match the dimension of the system=%d',...
                    length(x0), this.state_dimension)
            end
            this.assert_functions_can_be_evaluated_at_initial_point(x0, tspan(1), jspan(1));           

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
            sol = this.wrap_solution(t, j, x, tspan, jspan, config);
        end

    end
    
    methods(Access = protected, Hidden)
        % Override this function to use other wrappers.
        function sol = wrap_solution(this, t, j, x, tspan, jspan, solver_config)   
            % Create a HybridSolution object from the data (x, t, j) and given simluation parameters.
            xf = x(end, :)';
            try
                Cf = this.flowSetIndicator_3args(xf, t(end), j(end));
            catch
                Cf = NaN;
            end
            try
                Df = this.jumpSetIndicator_3args(xf, t(end), j(end));
            catch
                Df = NaN;
            end
            sol = HybridSolution(t, j, x, Cf, Df, tspan, jspan, solver_config);
        end
    end
    
    methods
        
        function [f_vals, g_vals, C_vals, D_vals] = generateFGCD(this, sol)  
            % Compute the values of the data (f, g, C, D) at each point along a given hybrid solution.
            % 
            % The flow map 'f' and jump map 'g' are evaluated at each point (including
            % points not, respectively, in the flow set or jump set). 
            % If the flow map 'f' (jump map 'g') throws an error and the
            % solution is not in the flow set (jump set), then the values are set to
            % NaN, but if the solution is in the flow set (jump set), then the
            % error is rethrown. 
            %
            % HybridSystem.flowMap, HybridSystem.jumpMap,
            % HybridSystem.flowSetIndicator,
            % HybridSystem.jumpSetIndicator.
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

        function checkFunctions(this, varargin)
            % Check the user-defined functions for this HybridSystem for the given arguments.
            %
            % Verify that the functions 'flowMap', 'flowSetIndicator',
            % 'jumpMap', and 'jumpSetIndicator' can
            % be evaluated with the arguments 'x', 'x, t', 
            % or 'x, t, j' (any arguments not used by a particular
            % function are properly ignored). If varargin is empty, then 
            % zero vectors of the appropriate size. are used. The output values
            % of each function is checked to verify that they are the correct
            % shape. If any outputs are incorrect, then an error is thrown.
            %
            % Example: 
            %
            %   x_test = [10;0]
            %   t_test = 0;
            %   j_test = 0;
            %   sys.checkFunctions(x_test, t_test, j_test);
            %
            % If none of the functions use the arguments 't' or 'j', then they
            % can be omitted, e.g.:
            %
            %   x_test = [10;0]
            %   sys.checkFunctions(x_test);
            %
            this.checkPoint('flow', this.flowMap_3args, this.flowSetIndicator_3args, varargin{:});
            this.checkPoint('jump', this.jumpMap_3args, this.jumpSetIndicator_3args, varargin{:});
        end

        function assertInC(this, varargin)
            % Check that a given point is in the flow set. An error is thrown otherwise.
            % See also: flowSetIndicator, assertNotInC, assertInD, assertNotInD.
                        
            % Check that at least 'x' is given as an argument and at most 'x', 't', 'j'
            narginchk(2,4) 
            
            inC = this.checkPoint('flow', this.flowMap_3args, ...
                                    this.flowSetIndicator_3args, varargin{:});
            if ~inC
                str = xtj_arguments_to_string(varargin{:});
                error('HybridSystem:AssertInCFailed', ... 
                      'The point%swas expected to be inside C but was not.', str);
            end
        end

        function assertNotInC(this, varargin)
            % Check that a given point is in the flow set. An error is thrown otherwise.
            % See also: flowSetIndicator, assertInC, assertInD, assertNotInD.
                        
            % Check that at least 'x' is given as an argument and at most 'x', 't', 'j'
            narginchk(2,4) 

            inC = this.checkPoint('flow', [], this.flowSetIndicator_3args, varargin{:});
            if inC
                str = xtj_arguments_to_string(varargin{:});
                error('HybridSystem:AssertNotInCFailed', ...
                    'The point%swas expected to not be inside C but actually was.', str);
            end
        end

        function assertInD(this, varargin)
            % Check that a given point is in the jump set. An error is thrown otherwise.
            % See also: jumpSetIndicator, assertInC, assertNotInC, assertNotInD.
            
            % Check that at least 'x' is given as an argument and at most 'x', 't', 'j'
            narginchk(2,4) 

            inD = this.checkPoint('jump', this.jumpMap_3args, ...
                                  this.jumpSetIndicator_3args, varargin{:});
            if ~inD
                str = xtj_arguments_to_string(varargin{:});
                error('HybridSystem:AssertInDFailed', ... 
                      'The point%swas expected to be inside D but was not.', str);
            end
        end

        function assertNotInD(this, varargin)
            % Check that a given point is in the jump set. An error is thrown otherwise.
            % See also: jumpSetIndicator, assertInC, assertNotInC, assertInD.
            
            % Check that at least 'x' is given as an argument and at most 'x', 't', 'j'
            narginchk(2,4) 

            inD = this.checkPoint('jump', [], this.jumpSetIndicator_3args, varargin{:});
            if inD
                str = xtj_arguments_to_string(varargin{:});
                error('HybridSystem:AssertNotInDFailed', ...
                    'The point%swas expected to not be inside D but actually was.', str);
            end
        end
    end

    methods(Access = private)
        function is_inside = checkPoint(this, flow_or_jump_str, ...
                                        f_or_g, C_or_D_indicator, varargin)
            % Check that the given functions can be evaluated with the arguments
            % given in varargin. Returns the output value of 'C_or_D_indicator'.
            % Input arguments: 
            %   * flow_or_jump_str: either 'flow' or 'jump'. Used in error
            %     messages.
            %   * f_or_g: function handle for the flow map or jump map, or an
            %       empty array (to skip checks).
            %   * C_or_D_indicator: function handle for the flow or jump set
            %     indicator (cannot be empty).
            %   * varargin: arguments for each function in the form (x),
            %     (x, t), or (x, t, j). If empty, then functions are
            %     tested with 'x' equal to a zero vector of the appropriate size.

            switch flow_or_jump_str
                case 'flow'
                    err_id_base = 'HybridSystem:Flow';
                case 'jump'
                    err_id_base = 'HybridSystem:Jump';
            end
            assert(length(varargin) <= 3, 'Too many arguments. Must be at most (x, t, j).')

            % Get value for 'x'
            if ~isempty(varargin)
                test_point_x = varargin{1};

                % Check that the test point is numeric and the correct size.
                assert(isnumeric(test_point_x), ...
                    'Test point ''x'' is not numeric. Instead is %s.', ...
                    class(test_point_x))

                assert(isempty(test_point_x) || iscolumn(test_point_x), ...
                                        'test_point_x is not a column vector')
                                 
                % If the HybridSystem state_dimension property is not set, 
                % then we use the dimension of test_point_x to get an implicit
                % state dimension.
                if isempty(this.state_dimension)
                    expected_state_size = [numel(test_point_x), 1];
                else 
                    expected_state_size = [this.state_dimension, 1];
                end

                assert(isequal(size(test_point_x), expected_state_size), ...
                    'Test point ''x'' is wrong size. Expected: %s, actual: %s.', ...
                    mat2str([this.state_dimension, 1]), ...
                    mat2str(size(test_point_x)))

            else % No test point given.
                if isempty(this.state_dimension)
                    error('HybridSystem:NoStateDimensionAndNoTestPoint', ...
                           ['Neither the HybridSystem.state_dimension property ' ...
                           'was set nor a test point ''x'' was given. ' ...
                           'To use the HybridSystem assertion functions, you ' ...
                           'must either set the HybridSystem.state_dimension property ' ...
                           'or pass a test point ''x'' to the assertion function ' ...
                           '(e.g., sys.assertInC([1; 0])).'])
                end

                % Use default value
                test_point_x = zeros(this.state_dimension, 1);
                expected_state_size = [this.state_dimension, 1];
            end

            % Get value for 't'
            if length(varargin) >= 2
                test_t = varargin{2};
                assert(isnumeric(test_t), 'test_t is not numeric')
                assert(isscalar(test_t), 'test_t is not a scalar')
            else % Use default value
                test_t = 0;
            end

            % Get value for 'j'
            if length(varargin) >= 3
                test_j = varargin{3};
                assert(isnumeric(test_j), 'test_j is not numeric')
                assert(isscalar(test_j), 'test_j is not a scalar')
            else % Use default value
                test_j = 0;
            end
            args = {test_point_x, test_t, test_j};

            if ~isempty(f_or_g)
                % Check flow or jump map.
                x_out = f_or_g(args{:});
                if ~isnumeric(x_out)
                    err_id = [err_id_base, 'MapNotNumeric'];
                    error(err_id, 'The %s map return a ''%s'' instead of a numeric value or array.',...
                        flow_or_jump_str, class(x_out));
                end
                if ~all(size(x_out) == expected_state_size)
                    err_id = [err_id_base, 'MapWrongSizeOutput'];

                    % Change the error message based on whether or not the
                    % state_dimension property is set.
                    if isempty(this.state_dimension)
                        expected_size_str = sprintf('the size of the input was %s', mat2str(expected_state_size));
                    else
                        expected_size_str = sprintf('the state dimension is %d', this.state_dimension);
                    end
                    error(err_id, 'The %s map returned a %dx%d array, but %s.',...
                        flow_or_jump_str, ...
                        size(x_out, 1), size(x_out, 2), expected_size_str);
                end
            end

            % Check set indicator function.
            is_inside = C_or_D_indicator(args{:});
            if ~isscalar(is_inside)
                err_id = [err_id_base, 'SetIndicatorNonScalar'];
                error(err_id, 'The %s set indicator returned a nonscalar value.')
            end
            try
                logical(is_inside);
            catch e
                err_id = [err_id_base, 'SetIndicatorNotLogical'];
                error(err_id, ['The %s set indicator returned a value that could not ' ...
                       'be converted to type ''logical''.']);
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
                    % includes "this" in the first argument.a
                    func_lambda = @(x, t, j) func_handle(x, t, j);
                otherwise
                    error(['Functions must have 2, 3, or 4 arguments ' ...
                          '(including ''this''). Instead the function had %d.'], nargs) 
            end
        end

        function assert_functions_can_be_evaluated_at_initial_point(this, x, t, j)
            % The flow and jump set indicator functions must evaluatable
            % everywhere

            % Check flow set indicator
            assert_function_can_be_evaluated(this.flowSetIndicator_3args, x, t, j, 'flowSetIndicator')
            
            % Check flow map
            inC = this.flowSetIndicator_3args(x, t, j);
            if inC
                assert_function_can_be_evaluated(this.flowMap_3args, x, t, j, 'flowMap')
            else
                try 
                    assert_function_can_be_evaluated(this.flowMap_3args, x, t, j, 'flowMap')
                catch err 
                    warning('HybridSystem:FlowMapErrorOutsideFlowSet', ...
                        ['Evaluating the flow map at the initial point ' ...
                        '\n\tx=%s, \n\tt=%f, \n\tj=%d\n' ...
                        'failed, but the point is not in the flow set, so this might be OK. ' ...
                        '\nThe error message was:\n"%s"'], mat2str(x), t, j, err.message)
                end
            end

            % Check jump set indicator
            assert_function_can_be_evaluated(this.jumpSetIndicator_3args, x, t, j, 'jumpSetIndicator')
            
            % Check jump map
            inD = this.jumpSetIndicator_3args(x, t, j);
            if inD
                assert_function_can_be_evaluated(this.jumpMap_3args, x, t, j, 'jumpMap')
            else
                try 
                    assert_function_can_be_evaluated(this.jumpMap_3args, x, t, j, 'jumpMap')
                catch err
                    warning('HybridSystem:JumpMapErrorOutsideJumpSet', ...
                        ['Evaluating the jump map at the initial point ' ...
                        '\n\tx=%s, \n\tt=%f, \n\tj=%d\n' ...
                        'failed, but the point is not in the jump set, so this might be OK. ' ...
                        '\nThe error message was:\n"%s"'], mat2str(x), t, j, err.message)
                end
            end
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

    methods(Hidden) % Hide methods from 'handle' superclass from documentation.
        function addlistener(varargin)
             addlistener@HybridSystem(varargin{:});
        end
        function delete(varargin)
             delete@HybridSystem(varargin{:});
        end
        function eq(varargin)
            error('Not supported')
        end
        function findobj(varargin)
             findobj@HybridSystem(varargin{:});
        end
        function findprop(varargin)
             findprop@HybridSystem(varargin{:});
        end
        % function isvalid(varargin)  Method is sealed.
        %      isvalid@HybridSystem(varargin);
        % end
        function ge(varargin)
        end
        function gt(varargin)
        end
        function le(varargin)
            error('Not supported')
        end
        function lt(varargin)
            error('Not supported')
        end
        function ne(varargin)
            error('Not supported')
        end
        function notify(varargin)
            notify@HybridSystem(varargin{:});
        end
        function listener(varargin)
            listener@HybridSystem(varargin{:});
        end
    end
end

function checkMethodArgumentNames(this)

fnc_names = {'flowMap', 'jumpMap', 'flowSetIndicator', 'jumpSetIndicator'};
arg_name_validators = {
    @(arg1_name) any(strcmp(arg1_name, {'this', 'self', 'obj', '~'})), ...
    @(arg2_name)    ~strcmp(arg2_name, 't') ...
    };
error_string_fmts = {
    'The first argument in ''%s'' must be ''this'', ''self'', ''obj'', or ''~'' but instead was ''%s''.%0d',
    'The second argument in ''%s'' must be the state vector (e.g. ''x'') but instead was ''t''. Did you remember the first ''this'' argument?'
    }; %#ok<COMNL>
hybrid.internal.checkMethodArgumentNames(this, fnc_names, arg_name_validators, error_string_fmts);
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

function str = xtj_arguments_to_string(x, t, j)
    % Convert the arguments x, t (optional), and j (optional) to a user-friendly
    % string for use in error messages.
    newline = sprintf('\n'); % Backwards compatible version of 'newline'.
    str = [newline, '  x: '];
    str = [str, mat2str(x)];
    if exist('t', 'var')
        str = [str, newline, '  t: ', num2str(t)];
    end
    if exist('j', 'var')
        str = [str, newline, '  j: ', num2str(j)];
    end
    str = [str, newline];
end