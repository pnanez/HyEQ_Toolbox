classdef (Abstract) HybridSubsystem < handle
% Class of hybrid subsystems with inputs and outputs, used in the construction of composite hybrid systems.
%
% See also: CompositeHybridSystem, HybridSystem, HybridSubsystemBuilder, hybrid.subsystems.
%
% Written by Paul K. Wintz, Hybrid Systems Laboratory, UC Santa Cruz. 
% © 2021. 

    properties(SetAccess = immutable)
        % Dimension of the state vector 'x'
        state_dimension
        % Dimension of the input 'u'
        input_dimension
        % Dimension of the output 'y'
        output_dimension
    end

    properties(GetAccess = {?CompositeHybridSystem, ?HybridSubsystemBuilder}, SetAccess = immutable)
        % Function that generates 'y' from 'x', and (optionally) 'u', 't', and 'j'.
        flows_output_fnc
        jumps_output_fnc
    end
    
    methods
        function this = HybridSubsystem(state_dim, input_dim, varargin)
            % Constructor
            % The varargin argument can take one of the following forms:
            %   * () -> full state output.
            %   * (output_dim) 
            %        -> Set the output dimension and set the output values to
            %           the first 'output_dim' entries of the state vector 'x'.
            %   * (output_dim, output_fnc) 
            %        -> Set the output dimension and a
            %           single output function for both
            %           flows and jumps.
            %   * (output_dim, flows_output_fnc, jumps_output_fnc) 
            %        -> Set the output dimension and the
            %           'flows_output_fnc' function for
            %           output during flows and the
            %           'jumps_output_fnc' function for
            %           output at jumps.
            if ~exist('input_dim', 'var')
                input_dim = 0;
            end
            if length(varargin) >= 1
                output_dim = varargin{1};
            else
                output_dim = state_dim;
            end
            if length(varargin) <= 1
                if output_dim > state_dim
                    error(['When the output function is not given explicitly, ' ...
                        'the output dimension must be less than or equal to the ' ...
                        'state dimension.'])
                end
                if output_dim < state_dim
                    output_fnc = @(x) x(1:output_dim);
                else 
                    output_fnc = @(x) x;
                end
                flows_output_fnc = output_fnc;
                jumps_output_fnc = output_fnc;
            end

            switch length(varargin)
                case 0 % Handled above.
                case 1 % Handled above.
                case 2
                    flows_output_fnc = varargin{2};
                    jumps_output_fnc = varargin{2};
                case 3
                    flows_output_fnc = varargin{2};
                    jumps_output_fnc = varargin{3};
            end

            % Check dimensions.
            if ~isscalar(state_dim)
                error('state_dim is not a scalar.')
            end
            if ~isscalar(input_dim)
                error('input_dim is not a scalar.')
            end
            if ~isscalar(output_dim)
                error('output_dim is not a scalar.')
            end

            % Set properties.
            this.state_dimension = state_dim;
            this.input_dimension = input_dim;
            this.output_dimension = output_dim;
            this.flows_output_fnc = flows_output_fnc;
            this.jumps_output_fnc = jumps_output_fnc;
        end
    end
    
    %%%%%% System Data %%%%%% 
    methods(Abstract) 

        % The flow map 'f' used to compute the evolution of the subsystem during intervals of flow.
        %
        % The flowMap function must be implemented in subclasses with the signature 
        %   xdot = flowMap(this, x, u, t, j).
        % The argument names can be changed, but u, t, and j cannot be ommited. 
        xdot = flowMap(this, x, u, t, j)  

        % The jump map 'g' used to compute the evolution of the subsystem at jumps.
        %
        % The jumpMap function must be implemented in subclasses with the signature  
        %   xplus = jumpMap(this, x, u, t, j).
        % The argument names can be changed, but u, t, and j cannot be ommited.
        xplus = jumpMap(this, x, u, t, j)  

        % Indicator function for flow set 'C'. Returns 1 inside 'C' and 0 outside.
        % 
        % The flowSetIndicator function must be implemented in subclasses with the signature 
        %   C = flowSetIndicator(this, x, u, t, j).
        % The argument names can be changed, but u, t, and j cannot be ommited. 
        C = flowSetIndicator(this, x, u, t, j) 

        % Indicator function for jump set 'D'. Returns 1 inside 'D' and 0 outside.
        % 
        % The jumpSetIndicator function must be implemented in subclasses with the signature 
        %   D = jumpSetIndicator(this, x, u, t, j).
        % The argument names can be changed, but u, t, and j cannot be ommited. 
        D = jumpSetIndicator(this, x, u, t, j)
    end
    
    methods
        function y = output(this, varargin)
            % Compute the output for the given values (x), (x, u), (x, u, t), or (x, u, t, j).
            % This function can only be used when the flow and jump output
            % functions are equal.
            % See also: flowOutput, jumpOutput.
            if isequal(this.flows_output_fnc, this.jumps_output_fnc)
                y = this.flows_output_fnc(varargin{:});
            else
                error('Unsupported')
            end
        end

        function y = flowOutput(this, varargin)
            % Compute the output during flows for the given values (x), (x, u), (x, u, t), or (x, u, t, j).
            % See also: output, jumpOutput.
            y = this.flows_output_fnc(varargin{:});
        end

        function y = jumpOutput(this, varargin)
            % Compute the output at jumps for the given values (x), (x, u), (x, u, t), or (x, u, t, j).
            % See also: output, flowOutput.
            y = this.flows_output_fnc(varargin{:});
        end
    end

    methods(Hidden)
        function sol = wrap_solution(this, t, j, x, u, y, tspan, jspan)
            % Override this method in subclasses to use other solution classes than
            % HybridSubsystemSolution.
            x_end = x(end, :)';
            u_end = u(end, :)';
            C_end = this.flowSetIndicator(x_end, u_end, t(end), j(end));
            D_end = this.jumpSetIndicator(x_end, u_end, t(end), j(end));
            
            sol = HybridSubsystemSolution(t, j, x, u, y, C_end, D_end, tspan, jspan);
        end
        
    end

    methods
        
        function [f_vals, g_vals, C_vals, D_vals] = generateFGCD(this, sol)
            % Compute the values of the data (f, g, C, D) at each point along a given hybrid solution.
            % 
            % The flow map 'f' and jump map 'g' are evaluated at each point, including
            % points not in the flow set or jump set, respectively. 
            % If the flow map 'f' (jump map 'g') throws an error and the
            % solution is not in the flow set (jump set), then the values are set to
            % NaN, but if the solution is in the flow set (jump set), then the
            % error is rethrown. 
            %
            % See also: HybridSubsystem.flowMap, HybridSubsystem.jumpMap,
            % HybridSubsystem.flowSetIndicator,
            % HybridSubsystem.jumpSetIndicator.
            assert(isa(sol, 'HybridSubsystemSolution'))
            t = sol.t;
            j = sol.j;
            x = sol.x;
            u = sol.u;
            f_vals = NaN(size(x));
            g_vals = NaN(size(x));
            C_vals = NaN(size(t));
            D_vals = NaN(size(t));
            for i=1:length(t)
                x_i = x(i, :)';
                u_i = u(i, :)';
                C_vals(i) = this.flowSetIndicator(x_i, u_i, t(i), j(i));
                D_vals(i) = this.jumpSetIndicator(x_i, u_i, t(i), j(i));

                try
                    f_vals(i, :) = this.flowMap(x_i, u_i, t(i), j(i))';
                catch e
                    if C_vals(i) % Only evaluate flow map in the flow set.
                        rethrow(e);
                    end
                end
                try
                    g_vals(i, :) = this.jumpMap(x_i, u_i, t(i), j(i))';
                catch e
                    if D_vals(i) % Only evaluate jump map in the jump set.
                        rethrow(e)
                    end
                end
            end
        end

        function checkFunctions(this, varargin)
            % Check the user-defined functions for this HybridSubsystem for the given arguments.
            %
            % Verify that the functions 'flowMap', 'flowSetIndicator',
            % 'flowOutput', 'jumpMap', 'jumpSetIndicator', and 'jumpOutput' can
            % be evaluated with the arguments 'x', 'x, u', 'x, u, t', 
            % or 'x, u, t, j' (any arguments not used by a particular
            % function are properly ignored). If varargin is empty, then 
            % zero vectors of the appropriate size. are used. The output values
            % of each function is checked to verify that they are the correct
            % shape. An error is thrown if any problems are identified.
            %
            % Example: 
            %
            %   x_test = [10;0]
            %   u_test = 1;
            %   t_test = 0;
            %   j_test = 0;
            %   sys.checkFunctions(x_test, u_test, t_test, j_test);
            %
            % If none of the functions use 'u', 't' or 'j', then they can be omitted: 
            %
            %   sys.checkFunctions(x_test);
            %
            this.checkPoint('flow', @this.flowMap, @this.flowSetIndicator,...
                                    this.flows_output_fnc, varargin{:});
            this.checkPoint('jump', @this.jumpMap, @this.jumpSetIndicator,...
                                    this.jumps_output_fnc, varargin{:});
        end

        function assertInC(this, varargin)
            % Check that a given point is in the flow set. An error is thrown otherwise.
            % See also: flowSetIndicator, assertNotInC, assertInD, assertNotInD.
            inC = this.checkPoint('flow', @this.flowMap, @this.flowSetIndicator,...
                                    this.flows_output_fnc, varargin{:});
            if ~inC
                error('HybridSubsystem:AssertInCFailed', ... 
                      'Point was expected to be inside C but was not.');
            end
        end

        function assertNotInC(this, varargin)
            % Check that a given point is in the flow set. An error is thrown otherwise.
            % See also: flowSetIndicator, assertInC, assertInD, assertNotInD.
            inC = this.checkPoint('flow', [], @this.flowSetIndicator, [], varargin{:});
            if inC
                error('HybridSubsystem:AssertNotInCFailed', ...
                    'Point was expected to not be inside C but actually was.');
            end
        end

        function assertInD(this, varargin)
            % Check that a given point is in the jump set. An error is thrown otherwise.
            % See also: jumpSetIndicator, assertInC, assertNotInC, assertNotInD.
            inD = this.checkPoint('jump', @this.jumpMap, @this.jumpSetIndicator,...
                                    this.jumps_output_fnc, varargin{:});
            if ~inD
                error('HybridSubsystem:AssertInDFailed', ... 
                      'Point was expected to be inside D but was not.');
            end
        end

        function assertNotInD(this, varargin)
            % Check that a given point is in the jump set. An error is thrown otherwise.
            % See also: jumpSetIndicator, assertInC, assertNotInC, assertInD.
            inD = this.checkPoint('jump', [], @this.jumpSetIndicator, [], varargin{:});
            if inD
                error('HybridSubsystem:AssertNotInDFailed', ...
                    'Point was expected to not be inside D but actually was.');
            end
        end
    end

    methods(Access = private)
        function is_inside = checkPoint(this, flow_or_jump_str, ...
                                f_or_g, C_or_D_indicator, output_fnc, varargin)
            % Check that the given functions can be evaluated with the arguments
            % given in varargin. Returns the output value of 'C_or_D_indicator'.
            % Input arguments: 
            %   * flow_or_jump_str: either 'flow' or 'jump'. Used in error
            %     messages.
            %   * f_or_g: function handle for the flow map or jump map, or an
            %       empty array (to skip checks).
            %   * C_or_D_indicator: function handle for the flow or jump set
            %     indicator (cannot be empty).
            %   * output_fnc: function handle for the flow or jump output
            %     function, or an empty array (to skip checks). 
            %   * varargin: arguments for each function in the form (x), (x, u),
            %     (x, u, t), or (x, u, t, j). If empty, then functions are
            %     tested with zero vectors of the appropriate sizes.

            switch flow_or_jump_str
                case 'flow'
                    err_id_base = 'HybridSubsystem:Flow';
                case 'jump'
                    err_id_base = 'HybridSubsystem:Jump';
            end
            assert(length(varargin) <= 4, 'Too many arguments. Must be at most (x, u, t, j).')

            % Get value for 'x'
            if ~isempty(varargin)
                test_point_x = varargin{1};
                assert(isnumeric(test_point_x), 'test_point_x is not numeric')
                assert(isempty(test_point_x) || iscolumn(test_point_x), ...
                                        'test_point_x is not a column vector')
            else % Use default value
                test_point_x = zeros(this.state_dimension, 1);
            end

            % Get value for 'u'
            if length(varargin) >= 2
                test_point_u = varargin{2};
                assert(isnumeric(test_point_u), 'test_point_u is not numeric')
                assert(isempty(test_point_u) || iscolumn(test_point_u), ...
                                        'test_point_u is not a column vector')
            else % Use default value
                test_point_u = zeros(this.input_dimension, 1);
            end

            % Get value for 't'
            if length(varargin) >= 3
                test_t = varargin{3};
                assert(isnumeric(test_t), 'test_t is not numeric')
                assert(isscalar(test_t), 'test_t is not a scalar')
            else % Use default value
                test_t = 0;
            end

            % Get value for 'j'
            if length(varargin) >= 4
                test_j = varargin{4};
                assert(isnumeric(test_j), 'test_j is not numeric')
                assert(isscalar(test_j), 'test_j is not a scalar')
            else % Use default value
                test_j = 0;
            end
            args = {test_point_x, test_point_u, test_t, test_j};

            if ~isempty(f_or_g)
                % Check flow or jump map.
                x_out = f_or_g(args{:});
                if ~isnumeric(x_out)
                    err_id = [err_id_base, 'MapNotNumeric'];
                    error(err_id, 'The %s map return a ''%s'' instead of a numeric value or array.',...
                        flow_or_jump_str, class(x_out));
                end
                if ~all(size(x_out) == [this.state_dimension, 1])
                    err_id = [err_id_base, 'MapWrongSizeOutput'];
                    error(err_id, 'The %s map return a %dx%d array, but the state dimension is %d.',...
                        flow_or_jump_str, this.state_dimension, ...
                        size(x_out, 1), size(x_out, 2));
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

            if ~isempty(output_fnc)
                % Check output function
                y = truncateInputArgs(output_fnc, args);
                if ~isnumeric(y)
                    err_id = [err_id_base, 'OutputNotNumeric'];
                    error(err_id, 'The %s output return a ''%s'' instead of a numeric value or array.',...
                        flow_or_jump_str, class(y));
                end
                if ~all(size(y) == [this.output_dimension, 1])
                    err_id = [err_id_base, 'OutputWrongSize'];
                    e = MException(err_id, ...
                        ['The output dimension is %d but the %s output function ' ...
                        'return a %dx%d array.'],...
                        this.output_dimension, flow_or_jump_str, ...
                        size(y, 1), size(y, 2));
                    throw(e);
                end
            end
        end
    end

    methods(Hidden) % Hide from documentation the following methods from 'handle' superclass .
        function addlistener(varargin)
             addlistener@HybridSubsystem(varargin{:});
        end
        function delete(varargin)
             delete@HybridSubsystem(varargin{:});
        end
%         function eq(varargin)
%             builtin('eq', varargin{:});
%         end
        function findobj(varargin)
             findobj@HybridSubsystem(varargin{:});
        end
        function findprop(varargin)
             findprop@HybridSubsystem(varargin{:});
        end
        % function isvalid(varargin)  Method is sealed.
        %      isvalid@HybridSubsystem(varargin);
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
            notify@HybridSubsystem(varargin{:});
        end
        function listener(varargin)
            listener@HybridSubsystem(varargin{:});
        end
    end
end

function out = truncateInputArgs(fh, input_args)
% Given a function handle 'fh' and a cell array of input arguments 'input_args',
% evaluate 'fh' with the first 'nargin(fh)' entries of 'input_args' used as
% input arguments.
nargs = nargin(fh);
assert(nargin >= 0, 'fh has variable input arguments.')
assert(iscell(input_args), 'input_args is not a cell array.')
assert(nargs <= numel(input_args), 'input_args has less entries ')
out = fh(input_args{1:nargs});
end