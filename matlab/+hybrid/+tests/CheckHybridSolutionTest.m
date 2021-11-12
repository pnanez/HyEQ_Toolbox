classdef CheckHybridSolutionTest < matlab.unittest.TestCase
    
    methods (Test)
       
        function testCorrectSolution(testCase)            
            import hybrid.tests.internal.*
            dt = 0.1;
            C_vals = [1, 1, 0, 0]';
            D_vals = [1, 0, 1, 0]';
            priority = hybrid.Priority.FLOW;
            [t, j] = generateHybridDomain(dt, C_vals, D_vals, priority);
            tspan = [t(1), t(2)];
            jspan = [j(1), j(2)];
            f = @(x) 1;
            g = @(x) -x;
            x0 = 1;
            [x, f_vals, g_vals] = generateEulerForwardSolution(t, j, x0, f, g);
            sol = HybridSolution(t, j, x, C_vals(end), D_vals(end), tspan, jspan);
            checkHybridSolution(sol, f_vals, g_vals, C_vals, D_vals, priority)
        end
        
        function testIncorrectFlow(testCase)    
            import hybrid.tests.internal.*        
            dt = 0.1;
            C_vals = [1, 1, 0, 0]';
            D_vals = [1, 0, 1, 0]';
            priority = hybrid.Priority.FLOW;
            [t, j] = generateHybridDomain(dt, C_vals, D_vals, priority);
            tspan = [t(1), t(2)];
            jspan = [j(1), j(2)];
            f = @(x) 1;
            g = @(x) -x;
            x0 = 1;
            [x, f_vals, g_vals] = generateEulerForwardSolution(t, j, x0, f, g);
            f_vals = f_vals + 4; % Change the flow map values so they don't match the change in x.
            sol = HybridSolution(t, j, x, C_vals, D_vals, tspan, jspan);
            
            testCase.verifyError(...
                @() checkHybridSolution(sol, f_vals, g_vals, C_vals, D_vals, priority),...
                'HybridSolution:IncorrectFlow')
        end
        
        function testIncorrectJumps(testCase) 
            import hybrid.tests.internal.*           
            dt = 0.1;
            C_vals = [1, 1, 0, 0]';
            D_vals = [1, 0, 1, 0]';
            priority = hybrid.Priority.FLOW;
            [t, j] = generateHybridDomain(dt, C_vals, D_vals, priority);
            tspan = [t(1), t(2)];
            jspan = [j(1), j(2)];
            f = @(x) 1;
            g = @(x) -x;
            x0 = 1;
            [x, f_vals, g_vals] = generateEulerForwardSolution(t, j, x0, f, g);
            g_vals = g_vals + 4; % Change the jump map values so they don't match the change in x.
            sol = HybridSolution(t, j, x, C_vals, D_vals, tspan, jspan);
            
            testCase.verifyError(...
                @() checkHybridSolution(sol, f_vals, g_vals, C_vals, D_vals, priority),...
                'HybridSolution:IncorrectJump')
        end
    end
    
end

function [t, j] = generateHybridDomain(dt, C, D, priority)
t = NaN(size(C));
j = NaN(size(C));
t(1) = 0;
j(1) = 0;
for k = 1:(length(t)-1)
    canFlow = C(k);
    canJump = D(k);
    if canFlow && canJump
        switch priority
            case hybrid.Priority.JUMP
                doFlow = false;
                doJump = true;
            case hybrid.Priority.FLOW
                doFlow = true;
                doJump = false;
        end
    elseif canFlow
        doFlow = true;
        doJump = false;
    elseif canJump
        doFlow = false;
        doJump = true;
    else
        doFlow = false;
        doJump = false;
    end
    assert(~(doFlow && doJump), 'Only one of doFlow and doJump can be true.')
    if doFlow
        t(k+1) = t(k) + dt;
        j(k+1) = j(k);
    end
    if doJump
        t(k+1) = t(k);
        j(k+1) = j(k) + 1;
    end
    if ~(doFlow || doJump)
        t = t(1:k);
        j = j(1:k);
        break;
    end
end

end

function [x, f_vals, g_vals] = generateEulerForwardSolution(t, j, x0, f, g)
nt = length(t);
x = NaN(nt, length(x0));
g_vals = NaN(size(x));
f_vals = NaN(size(x));
x(1,:) = x0';
for k = 1:(nt-1)
    isJump = j(k+1) > j(k);
    if isJump
        gk = g(x(k));
        x(k+1) = gk';
        g_vals(k,:) = gk';
    else
        fk = f(x(k));
        dt = t(k+1) - t(k);
        x(k+1) = x(k) + dt * fk';
        f_vals(k,:) = fk';
    end
end
end