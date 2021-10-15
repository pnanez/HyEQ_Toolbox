classdef HybridSystemBuilder < handle
% Construct, inline, a HybridSystem object. 
%
% builder = HybridSystemBuilder() ...
%                 .flowMap(@(x, t) t*sin(x)) ...
%                 .jumpMap(@(x, t, j) -x) ...
%                 .flowSetIndicator(@(x) x <= 0) ...
%                 .jumpSetIndicator(@(x) x >= 0);
% system = builder.build();
% 
% This approach is quick and easy to write, but results in slower
% computations and is harder to debug. We recommended that HybridSystemBuilder
% is only used for quick prototyping or demonstrations of simple systems. 
% Otherwise, create a subclass of HybridSystem. 
%
% The following abbreviations can also be used (sacrificing clarity):
%
% system = HybridSystemBuilder()...
%             .f(@(x, t) t*sin(x)) ...
%             .g(@(x, t, j) -x) ...
%             .C(@(x) x <= 0)...
%             .D(@(x) x >= 0)...
%             .build();
%
% See also: HybridSystem.
%
% Written by Paul K. Wintz, Hybrid Systems Laboratory, UC Santa Cruz. 
% © 2021. 

    properties(Access = private)
        flowMap_handle = @(x) 0;
        jumpMap_handle = @(x) 0;
        flowSetIndicator_handle = @(x) 0;
        jumpSetIndicator_handle = @(x) 0;
        state_dimension = [];
    end

    methods 
        function hybridSystem = build(this)
            % Create a HybridSystem object with the data (f, g, C, D) set by prior calls to the methods 'flowMap', 'jumpMap', 'flowSetIndicator', 'jumpSetIndicator'. 
            hybridSystem = hybrid.internal.EZHybridSystem(...
                                           this.flowMap_handle, ...
                                           this.jumpMap_handle, ...
                                           this.flowSetIndicator_handle, ...
                                           this.jumpSetIndicator_handle, ...
                                           this.state_dimension);
        end

        function this = flowMap(this, flowMap_handle)
            % Set the flow map for the hybrid system as a function handle with input arguments (x), (x, t), or (x, t, j).
            %
            % See also HybridSystemBuilder.f, HybridSystem.flowMap.
            check_handle_argument(flowMap_handle)
            this.flowMap_handle = flowMap_handle;
        end

        function this = jumpMap(this, jumpMap_handle)
            % Set the jump map for the hybrid system as a function handle with input arguments (x), (x, t), or (x, t, j).
            %
            % See also: HybridSystemBuilder.g, HybridSystem.jumpMap.
            check_handle_argument(jumpMap_handle)
            this.jumpMap_handle = jumpMap_handle;
        end

        function this = flowSetIndicator(this, flowSetIndicator_handle)
            % Set the flow set indicator for the hybrid system as a function handle with input arguments (x), (x, t), or (x, t, j).
            %
            % See also:  HybridSystemBuilder.C, HybridSystem.flowSetIndicator.
            check_handle_argument(flowSetIndicator_handle)
            this.flowSetIndicator_handle = flowSetIndicator_handle;
        end

        function this = jumpSetIndicator(this, jumpSetIndicator_handle)
            % Set the jump set indicator for the hybrid system as a function handle with input arguments (x), (x, t), or (x, t, j). 
            %
            % See also: HybridSystemBuilder.D, HybridSystem.jumpSetIndicator.
            check_handle_argument(jumpSetIndicator_handle)
            this.jumpSetIndicator_handle = jumpSetIndicator_handle;
        end

        function this = f(this, flowMap_handle)
            % Shortcut for 'flowMap' method.
            %
            % See also HybridSystemBuilder.flowMap
            this.flowMap(flowMap_handle);
        end

        function this = g(this, jumpMap_handle)
            % Shortcut for 'jumpMap' method.
            %
            % See also HybridSystemBuilder.jumpMap
            this.jumpMap(jumpMap_handle);
        end

        function this = C(this, flowSetIndicator_handle)
            % Shortcut for 'flowSetIndicator' method.
            %
            % See also HybridSystemBuilder.flowSetIndicator
            this.flowSetIndicator(flowSetIndicator_handle);
        end

        function this = D(this, jumpSetIndicator_handle)
            % Shortcut for 'jumpSetIndicator' method.
            %
            % See also HybridSystemBuilder.jumpSetIndicator
            this.jumpSetIndicator(jumpSetIndicator_handle);
        end

        function this = stateDimension(this, state_dim)
            % Set the state dimension.
            %
            % See also HybridSystem.state_dimension.
            check_dimension(state_dim);
            this.state_dimension = state_dim;
        end
    end

    methods(Hidden) % Hide methods from 'handle' superclass from documentation.
        function addlistener(varargin)
             addlistener@HybridSystemBuilder(varargin{:});
        end
        function delete(varargin)
             delete@HybridSystemBuilder(varargin{:});
        end
        function eq(varargin)
            error('Not supported')
        end
        function findobj(varargin)
             findobj@HybridSystemBuilder(varargin{:});
        end
        function findprop(varargin)
             findprop@HybridSystemBuilder(varargin{:});
        end
        % function isvalid(varargin)  Method is sealed.
        %      isvalid@HybridSystemBuilder(varargin);
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
            notify@HybridSystemBuilder(varargin{:});
        end
        function listener(varargin)
            listener@HybridSystemBuilder(varargin{:});
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
    if nargs < 1 || nargs > 3
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