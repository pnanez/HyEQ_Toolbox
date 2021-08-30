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
      STATE_NOT_IN_C_UNION_D("Solution left the flow and jump sets.")
      T_REACHED_END_OF_TSPAN("Continuous time t reached the end of tspan.")
      J_REACHED_END_OF_JSPAN("Discrete time j reached the end of jspan.")
      CANCELED("The solver was canceled.")
      UNDETERMINED("Insufficient information provided to determine cause of termination.")
   end

    methods(Static)
        function cause = getCause(t, j, x, C_vals, D_vals, tspan, jspan)
            %%% From the given data, compute the reason that the solution
            %%% terminated. 
            x_final = x(end,:);

            if any(isinf(x_final)) 
                cause = TerminationCause.STATE_IS_INFINITE;
                return;
            elseif any(isnan(x_final)) 
                cause = TerminationCause.STATE_IS_NAN;
                return;
            end
            if nargin == 7
                if t(end) >= tspan(end)
                    cause = TerminationCause.T_REACHED_END_OF_TSPAN;
                    return;
                elseif j(end) >= jspan(end)
                    cause = TerminationCause.J_REACHED_END_OF_JSPAN;
                    return;
                end
            end
            if nargin >= 5 && ~C_vals(end) && ~D_vals(end)
                cause = TerminationCause.STATE_NOT_IN_C_UNION_D;
                return
            end
            if nargin == 7
                % If there are no other reasons that the solution
                % terminated, then it must have been canceled (or there is
                % a defect).
                cause = TerminationCause.CANCELED;
                return
            else
                % Not enough arguments to determine cause of termination.
                cause = TerminationCause.UNDETERMINED;
                return
            end
        end
    end
end