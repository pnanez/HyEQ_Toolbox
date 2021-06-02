classdef TerminationCause
   properties
      description
   end
   methods
       function this = TerminationCause(description)
         this.description = description;
      end
   end
   enumeration
      STATE_IS_INFINITE("Final state is infinite.")
      STATE_IS_NAN("Final state is NaN.")
      STATE_NOT_IN_C_UNION_D("Solution left the flow and jump sets")
      T_REACHED_END_OF_TSPAN("Continuous time t reached the end of tspan")
      J_REACHED_END_OF_JSPAN("Discrete time j reached the end of jspan")
        
      % Exceptional values:
      SYSTEM_NOT_PROVIDED("To determine termination cause, pass hybrid system to HybridSolution")
      NO_CAUSE("The cause of termination was not identified!")
   end

    methods(Static)
        function cause = getCause(hybrid_system, t, j, x, tspan, jspan)
            xf = x(end,:);

            if any(isinf(xf)) 
                cause = TerminationCause.STATE_IS_INFINITE; % sprintf("Final state x(t = %f) = %s is not finite.", t(end), mat2str(xf));
                return;
            elseif any(isnan(xf)) 
                cause = TerminationCause.STATE_IS_NAN;
                return;
            elseif t(end) >= tspan(end)
                cause = TerminationCause.T_REACHED_END_OF_TSPAN; % sprintf("Final continuous time t=%0.2f is at end of tspan=%s.", t(end), mat2str(tspan));
                return;
            elseif j(end) >= jspan(end)
                cause = TerminationCause.J_REACHED_END_OF_JSPAN; % sprintf("Final discrete time j=%d is past end of jspan=%s.", j(end), mat2str(jspan));
                return;
            end

            % At this point, we have tested as much as we can without the system.
            if isempty(hybrid_system)            
                cause = TerminationCause.SYSTEM_NOT_PROVIDED;
            else
                % If the hybrid system is given, then we determine what
                % caused the solution to terminate.
                is_xf_in_C = hybrid_system.flow_set_indicator_3args(xf, t(end), j(end));
                is_xf_in_D = hybrid_system.jump_set_indicator_3args(xf, t(end), j(end));
                if ~is_xf_in_C && ~is_xf_in_D
                    cause = TerminationCause.STATE_NOT_IN_C_UNION_D; % sprintf("Final state x(t = %f) = %s is not in (C union D).", t(end), mat2str(xf));
                else
                    % UNKNOWN REASON
                    % warning("The TerminationCause unexpectedly could not be identified.")
                    cause = TerminationCause.NO_CAUSE; 
                end
            end
        end
    end
end