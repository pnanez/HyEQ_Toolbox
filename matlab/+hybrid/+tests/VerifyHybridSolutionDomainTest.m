classdef VerifyHybridSolutionDomainTest < matlab.unittest.TestCase
    % This test class verifies that the function verifyHybridSolutionDomainTest
    % correctly verifies a given hybrid time domain along with C_vals and
    % D_vals.
    
    methods (Test)
               
        function testCorrectDomaInEmptyJumpSet(testCase)
            import hybrid.tests.internal.*
            n = 5;
            t = linspace(0, pi, n)';
            j = zeros(n, 1);
            C = ones(n, 1);
            D = zeros(n, 1);
            priority = hybrid.Priority.JUMP;
            verifyHybridSolutionDomain(t, j, C, D, priority)
            priority = hybrid.Priority.FLOW; % Priority doesn't matter.
            verifyHybridSolutionDomain(t, j, C, D, priority)
        end
        
        function testCorrectDomaInEmptyFlowSet(testCase)
            import hybrid.tests.internal.*
            n = 5;
            t = zeros(n,1);
            j = 1:n;
            C = zeros(n, 1);
            D = ones(n, 1);
            priority = hybrid.Priority.JUMP;
            verifyHybridSolutionDomain(t, j, C, D, priority)
            priority = hybrid.Priority.FLOW; % Priority doesn't matter.
            verifyHybridSolutionDomain(t, j, C, D, priority)
        end
        
        function testVerifyOneJump(testCase)
            import hybrid.tests.internal.*
            n1 = 5;
            n2 = 8;
            n = n1+n2;
            [t, j] = generateHybridDomainWithOneJump(n1, n2);
            C =  ones(n, 1);
            D = zeros(n, 1);
            
            % Check with default priority
            D(n1) = 1;
            verifyHybridSolutionDomain(t, j, C, D)
            
            % Check with explicit JUMP priority
            priority = hybrid.Priority.JUMP;
            D(n1) = 1;
            verifyHybridSolutionDomain(t, j, C, D, priority)
            
            % Now check that it fails with FLOW priority
            priority = hybrid.Priority.FLOW;
            f = @() verifyHybridSolutionDomain(t, j, C, D, priority);
            testCase.verifyError(f, 'HybridSolution:InvalidDomain')
            
            % Check if C is zero at the jump with FLOW priority 
            priority = hybrid.Priority.FLOW;
            C(n1) = 0;
            verifyHybridSolutionDomain(t, j, C, D, priority)
        end
                
        function testVerifyNoJumps(testCase)
            import hybrid.tests.internal.*
            n = 5;
            n1 = 2; % used for erroneous jumps.
            t = linspace(0, pi, 5)';
            j = zeros(n, 1);
            C = ones(n, 1);
            D = zeros(n, 1);
            
            % Check that it fails with default priority and D=1 at some point.
            D(n1) = 1;
            f = @() verifyHybridSolutionDomain(t, j, C, D);
            testCase.verifyError(f, 'HybridSolution:InvalidDomain')
            
            %  Check that it fails with  with explicit JUMP priority and D=1 at some point
            priority = hybrid.Priority.JUMP;
            D(n1) = 1; 
            f = @() verifyHybridSolutionDomain(t, j, C, D, priority);
            testCase.verifyError(f, 'HybridSolution:InvalidDomain')
            
            % Check that is OK with FLOW priority and D=1 at some point
            priority = hybrid.Priority.FLOW;
            D(n1) = 1; 
            verifyHybridSolutionDomain(t, j, C, D, priority);
            
            % Check that it fails if C=0 and D=0 at some point
            priority = hybrid.Priority.FLOW;
            C(n1) = 0;
            D(n1) = 0; 
            f = @() verifyHybridSolutionDomain(t, j, C, D, priority);
            testCase.verifyError(f, 'HybridSolution:InvalidDomain')
        end
        
        function testIncorrectFlowOutsideJumpAndFlowSet(testCase)
            import hybrid.tests.internal.*
            n = 5;
            t = linspace(0, pi, 5)';
            j = zeros(n, 1);
            C = ones(n, 1);
            D = zeros(n, 1);
            C(3) = 0;
            priority = hybrid.Priority.JUMP;
            
            f = @() verifyHybridSolutionDomain(t, j, C, D, priority);
            testCase.verifyError(f, 'HybridSolution:InvalidDomain')
        end
        
        function testIncorrectFlowWhenJumpPriority(testCase)
            import hybrid.tests.internal.*
            n = 5;
            t = linspace(0, pi, 5)';
            j = zeros(n, 1);
            C = ones(n, 1);
            D = zeros(n, 1);
            D(3) = 1;
            priority = hybrid.Priority.JUMP;
            
            f = @() verifyHybridSolutionDomain(t, j, C, D, priority);
            testCase.verifyError(f, 'HybridSolution:InvalidDomain')
        end
       
    end
    
end

function [t, j] = generateHybridDomainWithOneJump(n1, n2)
    t = [linspace(0, pi, 5), linspace(pi, 2*pi, 8)]'; 
    j = [ones(n1, 1); 2*ones(n2, 1)];
end
