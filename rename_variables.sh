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
#rename CompoundHybridSystem CompositeHybridSystem
#rename CompoundHybridSolution CompositeHybridSolution
#rename ZOHController hybrid.subsystems.ZeroOrderHold

# 3.0.0.13 to 3.0.0.20
# rename HybridSolutionWithInput HybridSubsystemSolution

# 3.0.0.20 to 3.0.0.21
#rename HybridProgress hybrid.ProgressUpdater
#rename SilentHybridProgress hybrid.SilentProgressUpdater
#rename PopupHybridProgress hybrid.PopupProgressUpdater
#rename HybridPriority hybrid.Priority
#rename TerminationCause hybrid.TerminationCause

############# Rename 
rename zoh_feedback_control.slx zoh_feedback.slx
rename zero_order_hold.slx zoh.slx
rename vehicle_on_constrained_path.slx vehicle_on_path.slx
rename network_estimation_with_input.slx network_with_input.slx
rename network_estimation.slx network.slx
rename finite_state_machine.slx fsm.slx
rename bouncing_ball_with_input_alternative.slx ball_with_input2.slx
rename bouncing_ball_with_input.slx ball_with_input.slx
rename bouncing_ball_with_adc.slx ball_with_adc.slx
rename analog_to_digital_converter.slx adc.slx
rename behavior_in_C_intersection_D.slx hybrid_priority.slx
rename coupled_subsystems.slx coupled.slx

# Rename Paths
rename zero_order_hold.zero_order_hold -> zero_order_hold.zoh
rename zoh_feedback_control.zoh_feedback_control zoh_feedback_control.zoh_feedback
rename zoh_feedback_control.zoh_feedback_control zoh_feedback_control.zoh
rename vehicle_on_constrained_path.vehicle_on_constrained_path vehicle_on_constrained_path.vehicle_on_path
rename network_estimation_with_input.network_estimation_with_input network_estimation_with_input.network_with_input
rename network_estimation.network_estimation network_estimation.network
rename finite_state_machine.finite_state_machine finite_state_machine.fsm
rename bouncing_ball_with_input_alternative.bouncing_ball_with_input_alternative bouncing_ball_with_input_alternative.ball_with_input2
rename bouncing_ball_with_input.bouncing_ball_with_input bouncing_ball_with_input.ball_with_input
rename bouncing_ball_with_adc.bouncing_ball_with_adc bouncing_ball_with_adc.ball_with_adc
rename analog_to_digital_converter.analog_to_digital_converter analog_to_digital_converter.adc
rename behavior_in_C_intersection_D.behavior_in_C_intersection_D behavior_in_C_intersection_D.hybrid_priority
rename coupled_subsystems.coupled_subsystems coupled_subsystems.coupled