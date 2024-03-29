function subsys = convertToSubsystem(hybrid_system)
% Convert a HybridSystem object into a HybridSubsystem object with no inputs (EXPERIMENTAL).
% 
% Added in HyEQ Toolbox version 3.0 

% Written by Paul K. Wintz, Hybrid Systems Laboratory, UC Santa Cruz (©2022). 
    assert(isa(hybrid_system, 'HybridSystem'), 'Input was not a HybridSystem.')
    assert(~isempty(hybrid_system.state_dimension), 'State dimension not set.')
    subsys = HybridSubsystemBuilder()...
        .flowMap(@(x, ~, t, j) hybrid_system.flowMap_3args(x, t, j))...
        .jumpMap(@(x, ~, t, j) hybrid_system.jumpMap_3args(x, t, j))...
        .flowSetIndicator(@(x, ~, t, j) hybrid_system.flowSetIndicator_3args(x, t, j))...
        .jumpSetIndicator(@(x, ~, t, j) hybrid_system.jumpSetIndicator_3args(x, t, j))...
        .stateDimension(hybrid_system.state_dimension)...
        .inputDimension(0)...
        .outputDimension(hybrid_system.state_dimension)...
        .build();

end