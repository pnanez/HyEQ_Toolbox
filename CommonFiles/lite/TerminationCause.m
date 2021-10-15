classdef TerminationCause
% Enumeration class of possible causes for why a hybrid solution terminiated.
%
% See also: HybridSolution, HybridSystem.
%
% Written by Paul K. Wintz, Hybrid Systems Laboratory, UC Santa Cruz. 
% © 2021. 

   properties
      description
   end
   methods
       function this = TerminationCause(description)
         this.description = description;
      end
   end
   enumeration
      % At least one state vector component is infinite.
      STATE_IS_INFINITE('Final state is infinite.')
      
      % At least one state vector component is NaN (not a number).
      STATE_IS_NAN('Final state is NaN.')
      
      % The final state value is not the flow set 'C' or the jump set 'D'.
      STATE_NOT_IN_C_UNION_D('Solution left the flow and jump sets.')
      
      % The continuous time 't' reached the end of the given range 'tspan'.
      T_REACHED_END_OF_TSPAN('Continuous time t reached the end of tspan.')
      
      % The discrete time 'j' reached the end of the given range 'jspan'.
      J_REACHED_END_OF_JSPAN('Discrete time j reached the end of jspan.')
      
      % The hybrid solver was cancelled before completing. 
      CANCELED('The solver was canceled.')

      % Insufficient information was provided to determine cause of termination.
      UNDETERMINED('Insufficient information provided to determine cause of termination.')
   end

    methods(Static, Hidden)
        function cause = getCause(t, j, x, C_vals, D_vals, tspan, jspan)
            % From the given data, compute the reason that the solution terminated. 
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