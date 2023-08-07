classdef TerminationCause
% Enumeration class of possible causes for why a hybrid solution terminiated.
%
% See also: HybridSolution/termination_cause, HybridSystem.
% 
% Added in HyEQ Toolbox version 3.0 (©2022).

% Written by Paul K. Wintz, Hybrid Systems Laboratory, UC Santa Cruz. 

   enumeration
      % At least one state vector component is infinite.
      STATE_IS_INFINITE
      
      % At least one state vector component is NaN (not a number).
      STATE_IS_NAN
      
      % The final state value is not the flow set 'C' or the jump set 'D'.
      STATE_NOT_IN_C_UNION_D
      
      % The continuous time 't' reached the end of the given range 'tspan'.
      T_REACHED_END_OF_TSPAN
      
      % The discrete time 'j' reached the end of the given range 'jspan'.
      J_REACHED_END_OF_JSPAN
      
      % The hybrid solver was cancelled. 
      CANCELED
   end

    methods(Static, Hidden)
        function cause = getCause(t, j, x, C_vals, D_vals, tspan, jspan)
            % From the given data, compute the reason that the solution terminated. 
            narginchk(7, 7)
            x_final = x(end,:);

            if any(isinf(x_final)) 
                cause = hybrid.TerminationCause.STATE_IS_INFINITE;
                return;
            elseif any(isnan(x_final)) 
                cause = hybrid.TerminationCause.STATE_IS_NAN;
                return;
            end
            if t(end) >= tspan(end)
                cause = hybrid.TerminationCause.T_REACHED_END_OF_TSPAN;
                return;
            elseif j(end) >= jspan(end)
                cause = hybrid.TerminationCause.J_REACHED_END_OF_JSPAN;
                return;
            end
            if ~C_vals(end) && ~D_vals(end)
                cause = hybrid.TerminationCause.STATE_NOT_IN_C_UNION_D;
                return
            end
            % If there are no other reasons that the solution
            % terminated, then it must have been canceled (or there is
            % a defect).
            cause = hybrid.TerminationCause.CANCELED;
            return
        end
    end
end