classdef HybridSubsystemBuilder < handle
% Construct, inline, a HybridSubsystem object. 
%
% builder = HybridSubsystemBuilder() ...
%             .flowMap(@(x, u) u*sin(x)) ...
%             .jumpMap(@(x, u, t, j) -x) ...
%             .flowSetIndicator(@(x) x <= 0) ...
%             .jumpSetIndicator(@(x) x >= 0) ...
%             .output(@(x, u) [x; x - u]) ...
%             .stateDimension(1) ...
%             .inputDimension(1) ...
%             .outputDimension(2);
% system = builder.build();
% 
% The order of function calls prior to 'build()' do not matter.
% The following abbreviations can also be used (sacrificing clarity):
%
% system = HybridSubsystemBuilder() ...
%             .f(@(x, u) u*sin(x)) ...
%             .g(@(x, u, t, j) -x) ... 
%             .C(@(x) x <= 0) ...
%             .D(@(x) x >= 0) ...
%             .output(@(x, u) [x; x - u]) ...
%             .stateDim(1) ...
%             .inputDim(1) ...
%             .outputDim(2);
%             .build();
% 
% The 'output' function call can be replaced by 'flowOutput' and 'jumpOutput' to
% use different output functions during flows and at jumps. The dimension of the
% output must be the same during both, however. 
% 
% Using HybridSubsystemBuilder is quick and easy to write, but results in slower
% computations than writing a new HybridSubsystem subclass and is harder to
% debug. For this reason, HybridSubsystemBuilder is only  
% recommended for demonstrations or quick prototyping of simple systems. 
% Otherwise, it is better to create a subclass of HybridSubsystem in a separate file. 
%
% WARNING: For HybridSubsystem objects created by this class, the functions
% 'flowMap', 'jumpMap', 'flowSetIndicator', and 'jumpSetIndicator' will have the
% intput arguments '(x, u, t, j)' regardless of the particular input arguments
% in the function handle used to specify each function. The effect of this will
% be hidden when solving hybrid systems, but must be accounted
% for when evaluating the functions directly. On the other hand, input arguments
% for the 'output' function are preserved. 
%
% See also: HybridSubsystem, CompositeHybridSystem, HybridSystemBuilder.
%
% Written by Paul K. Wintz, Hybrid Systems Laboratory, UC Santa Cruz. 
% © 2021. 

properties(SetAccess = private)
    flowMap_handle = @(x, u, t, j) 0;
    jumpMap_handle = @(x, u, t, j) 0;
    flowSetIndicator_handle = @(x, u, t, j) 0;
    jumpSetIndicator_handle = @(x, u, t, j) 0;

    % Don't set 'flow_output_handle' and 'jump_output_handle' here. If unset,
    % explicitly, then we want the flow and jump outputs to be full state
    % feedback (or the first output_dim elements of x). However, the function
    % handle for 'flow_output_handle' and 
    % 'jump_output_handle' needs to be the same object for the
    % 'HybridSubsystem.output' function to work. 

    flow_output_handle
    jump_output_handle
    state_dim = 1;
    input_dim = 0;
    output_dim
end

methods 
    function hybridSubsystem = build(this)
        % Create a HybridSystem object with the data set by prior calls to builder functions.
        %
        % If the output dimension is not set, then it defaults to the state
        % dimension. If an output function is not set, then it defaults to a
        % truncation of the state 'x' to the first 'output_dim' entries.

        if isempty(this.output_dim)
            % Set the output dimension to the state dimension, if not defined.
            temp_output_dim = this.state_dim;
        else 
            temp_output_dim = this.output_dim;
        end
        
        if temp_output_dim == this.state_dim
            % Set the default output function to full state output if the output
            % dimension matches the state dimension...
            default_output = @(x) x;
        elseif temp_output_dim < this.state_dim
            % ...otherwise truncate its length to match the output dimension.
            default_output = @(x) x(1:temp_output_dim);
        else % output_dim > state_dim
            % default_output is not defined.
        end

        if isempty(this.flow_output_handle)
            % If the flow output function is not defined, we set it to the
            % default output function. 

            % We first check to make sure default output
            % is defined (which it won't be, if output_dim > state_dim).
            if ~exist('default_output', 'var')
                e = MException('HybridSubsystemBuilder:InvalidOutput', ...
                    ['If the flow output function is not given, then the ' ...
                    'output dimension must be less than or equal to the ' ...
                    'state dimension.']);
                throwAsCaller(e);
            end
            temp_flow_output_handle = default_output;
        else 
            temp_flow_output_handle = this.flow_output_handle;
        end
        if isempty(this.jump_output_handle)
            % If the jump output function is not defined, we set it to the
            % default output function. 

            % We first check to make sure default output
            % is defined (which it won't be, if output_dim > state_dim).
            if ~exist('default_output', 'var')
                e = MException('HybridSubsystemBuilder:InvalidOutput', ...
                    ['If the jump output function is not given, then the ' ...
                    'output dimension must be less than or equal to the ' ...
                    'state dimension.']);
                throwAsCaller(e);
            end
            temp_jump_output_handle = default_output;
        else 
            temp_jump_output_handle = this.jump_output_handle;
        end

        hybridSubsystem = hybrid.internal.EZHybridSubsystem(...
                            this.flowMap_handle, ...
                            this.jumpMap_handle, ...
                            this.flowSetIndicator_handle, ...
                            this.jumpSetIndicator_handle, ...
                            this.state_dim, ...
                            this.input_dim, ...
                            temp_output_dim, ...
                            temp_flow_output_handle, ...
                            temp_jump_output_handle);        
        % hybridSubsystem.checkFunctions();
    end

    function this = flowMap(this, flowMap_handle)
        % Set the flow map 'f'. 
        % 
        % The function handle must have input arguments (x), (x, u), (x, u, t),
        % or (x, u, t, j). 
        %
        % See also HybridSubsystemBuilder.f, HybridSubsystem.flowMap.
        check_handle_argument(flowMap_handle);
        this.flowMap_handle = flowMap_handle;
    end

    function this = f(this, flowMap_handle)
        % Abbreviation for 'flowMap'.
        % See also: flowMap.
        this.flowMap(flowMap_handle);
    end

    function this = jumpMap(this, jumpMap_handle)
        % Set the jump map 'g'. 
        % 
        % The function handle must have input arguments (x), (x, u), (x, u, t),
        % or (x, u, t, j). 
        %
        % See also HybridSubsystemBuilder.g, HybridSubsystem.JumpMap.
        check_handle_argument(jumpMap_handle);
        this.jumpMap_handle = jumpMap_handle;
    end

    function this = g(this, jumpMap_handle)
        % Abbreviation for 'jumpMap'.
        % See also: jumpMap.
        this.jumpMap(jumpMap_handle);
    end

    function this = flowSetIndicator(this, flowSetIndicator_handle)
        % Set the flow set indicator function. 
        %
        % A value of 1 indicates a point is in the flow set and a value of 0
        % indicates it is not.
        % The function handle must have input arguments (x), (x, u), (x, u, t),
        % or (x, u, t, j). 
        %
        % See also HybridSubsystemBuilder.C, HybridSubsystem.flowSetIndicator.
        check_handle_argument(flowSetIndicator_handle);
        this.flowSetIndicator_handle = flowSetIndicator_handle;
    end

    function this = C(this, flowSetIndicator_handle)
        % Abbreviation for 'flowSetIndicator'.
        % See also: flowSetIndicator.
        this.flowSetIndicator(flowSetIndicator_handle);
    end

    function this = jumpSetIndicator(this, jumpSetIndicator_handle)
        % Set the jump set indicator for the hybrid subsystem. 
        %
        % A value of 1 indicates a point is in the jump set and a value of 0
        % indicates it is not.
        % The function handle must have input arguments (x), (x, u), (x, u, t),
        % or (x, u, t, j). 
        %
        % See also HybridSubsystemBuilder.D, HybridSubsystem.jumpSetIndicator.
        check_handle_argument(jumpSetIndicator_handle);
        this.jumpSetIndicator_handle = jumpSetIndicator_handle;
    end

    function this = D(this, jumpSetIndicator_handle)
        % Abbreviation for 'jumpSetIndicator'.
        % See also: jumpSetIndicator.
        this.jumpSetIndicator(jumpSetIndicator_handle);
    end
    
    function this = output(this, output_handle)
        % Set the output function for flows and jumps.
        % 
        % The function must have input arguments (x), (x, u), (x, u, t) or 
        % (x, u, t, j). If 'u' is unused it must be replaced by '~' (or simply
        % omitted), so that dependencies can be evaluated.
        %   
        % See also: flowOutput, jumpOutput, outputDimension.
        this.flowOutput(output_handle);
        this.jumpOutput(output_handle);
    end

    function this = flowOutput(this, output_handle)
        % Set the output function for flows.
        % 
        % The function must have input arguments (x), (x, u), (x, u, t) or 
        % (x, u, t, j). If 'u' is unused it must be replaced by '~' (or simply
        % omitted), so that dependencies can be evaluated.
        %   
        % See also: output, jumpOutput, outputDimension.
        if ~isempty(output_handle)
            check_handle_argument(output_handle);
        end
        this.flow_output_handle = output_handle;
    end

    function this = jumpOutput(this, output_handle)
        % Set the output function for jumps.
        % 
        % The function must have input arguments (x), (x, u), (x, u, t) or 
        % (x, u, t, j). If 'u' is unused it must be replaced by '~' (or simply
        % omitted), so that dependencies can be evaluated.
        %   
        % See also: output, flowOutput, outputDimension.
        if ~isempty(output_handle)
            check_handle_argument(output_handle);
        end
        this.jump_output_handle = output_handle;
    end
    
    function this = stateDimension(this, state_dim)
        % Set the dimension of the subsystem state 'x'.
        check_dimension(state_dim)
        this.state_dim = state_dim;
    end
    
    function this = inputDimension(this, input_dim)
        % Set the dimension of the subsystem input 'u'.
        check_dimension(input_dim)
        this.input_dim = input_dim;
    end
    
    function this = outputDimension(this, output_dim)
        % Set the dimension of the subsystem output 'y'.
        check_dimension(output_dim)
        this.output_dim = output_dim;
    end
    
    function this = stateDim(this, state_dim)
        % Abbreviation for 'stateDimension'.
        % See also: stateDimension.
       this.stateDimension(state_dim); 
    end
    
    function this = inputDim(this, input_dim)
        % Abbreviation for 'inputDimension'.
        % See also: inputDimension.
       this.inputDimension(input_dim); 
    end
    
    function this = outputDim(this, output_dim)
        % Abbreviation for 'outputDimension'.
        % See also: outputDimension.
       this.outputDimension(output_dim); 
    end
    
%     function this = xDim(this, state_dim)
%         % Abbreviation for 'stateDimension'.
%         % See also: stateDimension.
%        this.stateDimension(state_dim); 
%     end
%     
%     function this = uDim(this, input_dim)
%         % Abbreviation for 'inputDimension'.
%         % See also: inputDimension.
%        this.inputDimension(input_dim); 
%     end
%     
%     function this = yDim(this, output_dim)
%         % Abbreviation for 'outputDimension'.
%         % See also: outputDimension.
%        this.outputDimension(output_dim); 
%     end
end

methods(Hidden) % Hide methods from 'handle' superclass from documentation.
    function addlistener(varargin)
         addlistener@HybridSubsystemBuilder(varargin{:});
    end
    function delete(varargin)
         delete@HybridSubsystemBuilder(varargin{:});
    end
    function eq(varargin)
        error('Not supported')
    end
    function findobj(varargin)
         findobj@HybridSubsystemBuilder(varargin{:});
    end
    function findprop(varargin)
         findprop@HybridSubsystemBuilder(varargin{:});
    end
    % function isvalid(varargin)  Method is sealed.
    %      isvalid@HybridSubsystemBuilder(varargin);
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
        notify@HybridSubsystemBuilder(varargin{:});
    end
    function listener(varargin)
        listener@HybridSubsystemBuilder(varargin{:});
    end
end
end

function check_handle_argument(fh)
    if ~isa(fh, 'function_handle')
        e = MException('Hybrid:InvalidArgument', ...
            'Expected as function handle, instead was a %s', class(fh));
        throwAsCaller(e)
    end
    nargs = nargin(fh);
    if nargs < 1 || nargs > 4
        e = MException('Hybrid:InvalidFunction', ...
            'Expected a function with 1, 2, or 3 input arguments, instead had %d', nargin);
        throwAsCaller(e)
    end
end

function check_dimension(dim)
    if ~isnumeric(dim)
        e = MException('Hybrid:InvalidArgument', ...
            'Expected a number, instead was a %s', class(dim));
        throwAsCaller(e)
    end
    if mod(dim,1) ~= 0 || dim < 0
        e = MException('Hybrid:InvalidArgument', ...
            'Expected a positive integer, value was a %g.', dim);
        throwAsCaller(e)
    end
end