function verifyHybridSolutionDomain(t, j, C, D, priority)
% verifyHybridSolutionDomain Check that the hybrid domain (t, j) is valid for the given flow and jump sets. 
% This method checks that t increases only if C=1, that j increases
% only if D=1, and that the priorty is respected in the intersection.
%
% WARNING: When using ode45, the solver automatically refines the solution
% by a factor of four. This can introduce entries in the solution vectors
% where t increases but x is not in C. 

if ~exist('priority', 'var')
    priority = HybridPriority.default();
end

ERR_ID = 'HybridSolution:InvalidDomain';

if any(diff(t) < 0)  
    error(ERR_ID, 't was not nondecreasing.')
end
if any(diff(j) < 0)
    error(ERR_ID, 'j was not nondecreasing.')
end
if length(t) ~= length(C)
    error(ERR_ID, 'length(t)=%d does not equal length(C)=%d.', length(t), length(C))
end
if length(t) ~= length(D)
   error(ERR_ID, 'length(t)=%d does not equal length(D)=%d.', length(t), length(D))
end
for k=1:(length(t)-1)
    % We check the change in t and j beween each entry and the next.
    % The last entry is omitted because there is no 'next' time to
    % check.
    t_increased = t(k+1) > t(k);
    j_increased = j(k+1) > j(k);
    if ~t_increased && ~j_increased
        error(ERR_ID, 'Neither t nor j increased at k=%d.', k)
    end
    if t_increased && j_increased 
        error(ERR_ID, 'Both t and j increased at k=%d.', k)
    end
    if t_increased
        if ~C(k)
            % WARNING: When using ode45, the solver automatically refines the solution
            % by a factor of four. This can cause this error a couple
            % entries of t in the solution to increase when x is not in C. 
            msg = {sprintf('Continuous time t increased outside C at k=%d. ', k)
                'This error can be (spuriously) caused if ''Refine'' option for the ODE '
                'solver is not equal to 1 (The default for ode45 is 4).'};
            error(ERR_ID, '%s', msg{:})
        end
        if D(k) && priority == HybridPriority.JUMP
            msg = {sprintf('Continuous time t increased when j should have increased at k=%d.' , k) 
                'This error can be (spuriously) caused if ''Refine'' option for the ODE ' 
                'solver is not equal to 1 (The default for ode45 is 4).'};
            error(ERR_ID, '%s', msg{:})
        end
    end
    if j_increased
        if ~D(k)
            error(ERR_ID, 'Discrete time j increased outside D at k=%d.', k)
        end
        if C(k) && priority == HybridPriority.FLOW
            error(ERR_ID, 'Discrete time j increased when t should have increased at k=%d.', k)
        end
    end
end
end