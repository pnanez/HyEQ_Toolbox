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
        flow_map_handle = @(x) 0;
        jump_map_handle = @(x) 0;
        flow_set_indicator_handle = @(x) 0;
        jump_set_indicator_handle = @(x) 0;
    end

    methods 
        function hybridSystem = build(this)
            hybridSystem = EZHybridSystem(this.flow_map_handle, ...
                                           this.jump_map_handle, ...
                                           this.flow_set_indicator_handle, ...
                                           this.jump_set_indicator_handle);
        end

        function this = flowMap(this, flow_map_handle)
            this.flow_map_handle = flow_map_handle;
        end

        function this = f(this, flow_map_handle)
            this.flow_map_handle = flow_map_handle;
        end

        function this = jumpMap(this, jump_map_handle)
            this.jump_map_handle = jump_map_handle;
        end

        function this = g(this, jump_map_handle)
            this.jump_map_handle = jump_map_handle;
        end

        function this = flowSetIndicator(this, flow_set_indicator_handle)
            this.flow_set_indicator_handle = flow_set_indicator_handle;
        end

        function this = C(this, flow_set_indicator_handle)
            this.flow_set_indicator_handle = flow_set_indicator_handle;
        end

        function this = jumpSetIndicator(this, jump_set_indicator_handle)
            this.jump_set_indicator_handle = jump_set_indicator_handle;
        end

        function this = D(this, jump_set_indicator_handle)
            this.jump_set_indicator_handle = jump_set_indicator_handle;
        end
    end
end