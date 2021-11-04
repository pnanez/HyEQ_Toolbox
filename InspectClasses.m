% This script prints out the names of public properties and methods in the
% most significant classes in the hybrid toolbox. This is useful for
% checking the consistency of naming conventions and that nothing is
% public that shouldn't be.

clc
inspectClass("HybridSystem")
inspectClass("CompositeHybridSystem")
inspectClass("HybridSubsystem")
inspectClass("PairHybridSystem")

inspectClass("HybridSolution")
inspectClass("HybridSubsystemSolution")
inspectClass("CompositeHybridSolution")

inspectClass("HybridPlotBuilder")
% inspectClass("HybridPriority")

inspectClass("HybridProgress")
inspectClass("PopupHybridProgress")
% inspectClass("SilentHybridProgress")

inspectClass("HybridSolverConfig")
inspectClass("HybridUtils")


function inspectClass(class_name)
    disp(" ============ " + class_name + " ============ " )

    properties(class_name)
    methods(class_name)

    if ~isempty(meta.abstractDetails(class_name))
        meta.abstractDetails(class_name)
    end
end