
function rename() {
    if [ $# -ne 2 ]; then
        echo "Please <old name> and <new name>"
        return
    fi
    echo "Renaming $1 to $2"
    find . -type f -name "*.m*" -exec sed -i '' -e "s/$1/$2/g" {} +
}

# Build 3.0.0.6 to 3.0.0.11
#rename control_dimension input_dimension
#rename ControlledHybridSystem HybridSubsystem
#rename flow_map flowMap
#rename jump_map jumpMap
#rename flow_set_indicator flowSetIndicator
#rename jump_set_indicator jumpSetIndicator
#rename ControlledHybridSolution HybridSolutionWithInput

# 3.0.0.11 to 3.0.0.12
rename CompoundHybridSystem CompositeHybridSystem
rename CompoundHybridSolution CompositeHybridSolution