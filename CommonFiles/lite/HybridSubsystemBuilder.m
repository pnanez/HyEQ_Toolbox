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
% Using HybridSubsystemBuilder is quick and easy to write, but results in slower
% computations than writing a new HybridSubsystem subclass and is harder to
% debug. For this reason, HybridSubsystemBuilder is only  
% recommended for quick prototyping or demonstrations of simple systems. 
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
    output_handle = @(x) x;
    state_dim = 1;
    input_dim = 0;
    output_dim = 1;
end

methods 
    function hybridSystem = build(this)
        % Create a HybridSystem object with the data (f, g, C, D) set by prior calls to 'flowMap', 'jumpMap', 'flowSetIndicator', 'jumpSetIndicator'.
        hybridSystem = hybrid.internal.EZHybridSubsystem(...
                            this.flowMap_handle, ...
                            this.jumpMap_handle, ...
                            this.flowSetIndicator_handle, ...
                            this.jumpSetIndicator_handle, ...
                            this.state_dim, ...
                            this.input_dim, ...
                            this.output_dim, ...
                            this.output_handle);
    end

    function this = flowMap(this, flowMap_handle)
        % Set the flow map for the hybrid subsystem. 
        % 
        % The function handle must have input arguments (x), (x, u), (x, u, t),
        % or (x, u, t, j). 
        %
        % See also HybridSubsystemBuilder.f, HybridSubsystem.flowMap.
        check_handle_argument(flowMap_handle);
        this.flowMap_handle = flowMap_handle;
    end

    function this = f(this, flowMap_handle)
        this.flowMap(flowMap_handle);
    end

    function this = jumpMap(this, jumpMap_handle)
        % Set the jump map 'g' for the hybrid subsystem. 
        % 
        % The function handle must have input arguments (x), (x, u), (x, u, t),
        % or (x, u, t, j). 
        %
        % See also HybridSubsystemBuilder.g, HybridSubsystem.JumpMap.
        check_handle_argument(jumpMap_handle);
        this.jumpMap_handle = jumpMap_handle;
    end

    function this = g(this, jumpMap_handle)
        this.jumpMap(jumpMap_handle);
    end

    function this = flowSetIndicator(this, flowSetIndicator_handle)
        % Set the flow set indicator for the hybrid subsystem. 
        % 
        % The function handle must have input arguments (x), (x, u), (x, u, t),
        % or (x, u, t, j). 
        %
        % See also HybridSubsystemBuilder.C, HybridSubsystem.flowSetIndicator.
        check_handle_argument(flowSetIndicator_handle);
        this.flowSetIndicator_handle = flowSetIndicator_handle;
    end

    function this = C(this, flowSetIndicator_handle)
        this.flowSetIndicator(flowSetIndicator_handle);
    end

    function this = jumpSetIndicator(this, jumpSetIndicator_handle)
        % Set the jump set indicator for the hybrid subsystem. 
        % 
        % The function handle must have input arguments (x), (x, u), (x, u, t),
        % or (x, u, t, j). 
        %
        % See also HybridSubsystemBuilder.D, HybridSubsystem.jumpSetIndicator.
        check_handle_argument(jumpSetIndicator_handle);
        this.jumpSetIndicator_handle = jumpSetIndicator_handle;
    end

    function this = D(this, jumpSetIndicator_handle)
        this.jumpSetIndicator(jumpSetIndicator_handle);
    end
    
    function this = output(this, output_handle)
        check_handle_argument(output_handle);
        this.output_handle = output_handle;
    end
    
    function this = stateDimension(this, state_dim)
        check_dimension(state_dim)
        this.state_dim = state_dim;
    end
    
    function this = inputDimension(this, input_dim)
        check_dimension(input_dim)
        this.input_dim = input_dim;
    end
    
    function this = outputDimension(this, output_dim)
        check_dimension(output_dim)
        this.output_dim = output_dim;
    end
    
    function this = stateDim(this, state_dim)
       this.stateDimension(state_dim); 
    end
    
    function this = inputDim(this, input_dim)
       this.inputDimension(input_dim); 
    end
    
    function this = outputDim(this, output_dim)
       this.outputDimension(output_dim); 
    end
    
    function this = xDim(this, state_dim)
       this.stateDimension(state_dim); 
    end
    
    function this = uDim(this, input_dim)
       this.inputDimension(input_dim); 
    end
    
    function this = yDim(this, output_dim)
       this.outputDimension(output_dim); 
    end
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