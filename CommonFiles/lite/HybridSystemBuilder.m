classdef HybridSystemBuilder
    % HybridSystemBuilder provides a clear and easy way for constructing an
    % instance of the HybridSystem class. 
    %
    % builder = HybridSystemBuilder() ...
    %                 .flowMap(@(x, t) t*sin(x)) ...
    %                 .jumpMap(@(x, t, j) -x) ...
    %                 .flowSetIndicator(@(x) x <= 0) ...
    %                 .jumpSetIndicator(@(x) x >= 0);
    % system = builder.build();

    properties(Access = private)
        flowMap_handle = @(x) 0;
        jumpMap_handle = @(x) 0;
        flowSetIndicator_handle = @(x) 0;
        jumpSetIndicator_handle = @(x) 0;
    end

    methods 
        function hybridSystem = build(this)
            hybridSystem = EZHybridSystem(this.flowMap_handle, ...
                                           this.jumpMap_handle, ...
                                           this.flowSetIndicator_handle, ...
                                           this.jumpSetIndicator_handle);
        end

        function this = flowMap(this, flowMap_handle)
            this.flowMap_handle = flowMap_handle;
        end

        function this = f(this, flowMap_handle)
            this.flowMap_handle = flowMap_handle;
        end

        function this = jumpMap(this, jumpMap_handle)
            this.jumpMap_handle = jumpMap_handle;
        end

        function this = g(this, jumpMap_handle)
            this.jumpMap_handle = jumpMap_handle;
        end

        function this = flowSetIndicator(this, flowSetIndicator_handle)
            this.flowSetIndicator_handle = flowSetIndicator_handle;
        end

        function this = C(this, flowSetIndicator_handle)
            this.flowSetIndicator_handle = flowSetIndicator_handle;
        end

        function this = jumpSetIndicator(this, jumpSetIndicator_handle)
            this.jumpSetIndicator_handle = jumpSetIndicator_handle;
        end

        function this = D(this, jumpSetIndicator_handle)
            this.jumpSetIndicator_handle = jumpSetIndicator_handle;
        end
    end
end