classdef CompoundHybridSystemTest < matlab.unittest.TestCase
    
    methods (Test)
       
        function testTwo1x1Subsystems(testCase)
                                   % Size of: u, x, y
            sub1 = MockControlledHybridSystem(1, 1, 1);
            sub2 = MockControlledHybridSystem(1, 1, 1);
            sys = CompoundHybridSystem(sub1, sub2);
            sys.setContinuousFeedback(sub1, @(y1, y2, t, j) 4);
            sys.setContinuousFeedback(sub2, @(y1, y2, t, j) 4);
            tspan = [0, 10];
            jspan = [0, 10];
            sys.solve({1, 2}, tspan, jspan)
        end
       
        function testThreeSubsystemsOfDifferentSizes(testCase)
                                   % Size of: u, x, y
            sub1 = MockControlledHybridSystem(1, 1, 2);
            sub2 = MockControlledHybridSystem(2, 1, 3);
            sub3 = MockControlledHybridSystem(3, 1, 1);
            sys = CompoundHybridSystem(sub1, sub2, sub3);
            sys.setContinuousFeedback(sub1, @(y1, y2, y3, t, j) 4);
            sys.setContinuousFeedback(sub2, @(y1, y2, y3, t, j) ones(2, 1));
            sys.setContinuousFeedback(sub3, @(y1, y2, y3, t, j) 3*ones(3, 1));
            sys.setDiscreteFeedback(sub1, @(y1, y2, y3, t, j) 4);
            sys.setDiscreteFeedback(sub2, @(y1, y2, y3, t, j) ones(2, 1));
            sys.setDiscreteFeedback(sub3, @(y1, y2, y3, t, j) 3*ones(3, 1));
            tspan = [0, 10];
            jspan = [0, 10];
            sol = sys.solve({1, 2, 3}, tspan, jspan);
            testCase.assertLength(sol.subsys_sols, 3)
            testCase.assertLength(sol.x(1, :), ...
                sub1.state_dimension+sub2.state_dimension+sub3.state_dimension+3);
        end
       
        function testJumpsWhenAnySubsystemInJumpSet(testCase)
                                  % Size of: (u, x, y)
            sub1 = MockControlledHybridSystem(1, 1, 1);
            sub2 = MockControlledHybridSystem(1, 1, 1);
            sys = CompoundHybridSystem(sub1, sub2);
            sub1.D_indicator = @(x, u, t, j) t >= j + 1;
            sub2.D_indicator = @(x, u, t, j) 0;
            tspan = [0, 10];
            jspan = [0, 2];
            sol = sys.solve({0, 0}, tspan, jspan);
            testCase.assertEqual(sol.jump_times, [1; 2], 'AbsTol', 1e-6)
            testCase.assertEqual(sol.subsys_sols{1}.jump_times, [1; 2], 'AbsTol', 1e-6)
            testCase.assertEmpty(sol.subsys_sols{2}.jump_times)
        end
       
        function testAllSubsystemsJumpWhenAllInJumpSet(testCase)
                                  % Size of: (u, x, y)
            sub1 = MockControlledHybridSystem(1, 1, 1);
            sub2 = MockControlledHybridSystem(1, 1, 1);
            sys = CompoundHybridSystem(sub1, sub2);
            sub1.D_indicator = @(x, u, t, j) t >= j + 1;
            sub2.D_indicator = @(x, u, t, j) t >= j + 1;
            tspan = [0, 10];
            jspan = [0,  2];
            sol = sys.solve({0, 0}, tspan, jspan);
            
            expected_jumps = [1; 2];
            testCase.assertEqual(sol.jump_times, expected_jumps, 'AbsTol', 1e-6)
            testCase.assertEqual(sol.subsys_sols{1}.jump_times, expected_jumps, 'AbsTol', 1e-6)
            testCase.assertEqual(sol.subsys_sols{2}.jump_times, expected_jumps, 'AbsTol', 1e-6)
        end
        
        function testFlowPriorityWarning(testCase)
                                  % Size of: (u, x, y)
            sub = MockControlledHybridSystem(1, 1, 1);
            sys = CompoundHybridSystem(sub);
            tspan = [0, 10];
            jspan = [0,  2];
            config = HybridSolverConfig("silent").flowPriority();
            testCase.verifyWarning(@() sys.solve({0}, tspan, jspan, config), ...
                "CompoundHybridSystem:FlowPriorityNotSupported")
        end
        
        function testFlowsWhenAllSubsystemsInFlowSetAndFlowPriority(testCase)
                                  % Size of: (u, x, y)
            sub1 = MockControlledHybridSystem(1, 1, 1);
            sub2 = MockControlledHybridSystem(1, 1, 1);
            sys = CompoundHybridSystem(sub1, sub2);
            sub1.D_indicator = @(x, u, t, j) 1;
            sub2.D_indicator = @(x, u, t, j) 1;
            tspan = [0, 10];
            jspan = [0,  2];
            warning('off',"CompoundHybridSystem:FlowPriorityNotSupported")
            config = HybridSolverConfig("silent").flowPriority();
            sol = sys.solve({0, 0}, tspan, jspan, config);
            testCase.assertEmpty(sol.jump_times)
            testCase.assertEqual(sol.t(end), tspan(end), 'AbsTol', 1e-6)
            warning('on',"CompoundHybridSystem:FlowPriorityNotSupported")
        end
        
        function testJumpsWhenAnySubsystemsNotInFlowSetAndFlowPriority(testCase)
            % This test case fails because CompoundHybridSystem cannot
            % correctly handle flow priority when one subsystem is in C \ D
            % and another is in C \cap D.
            assumeFail(testCase)
                                  % Size of: (u, x, y)
            sub1 = MockControlledHybridSystem(1, 1, 1);
            sub2 = MockControlledHybridSystem(1, 1, 1);
            sys = CompoundHybridSystem(sub1, sub2);
            sub1.C_indicator = @(x, u, t, j) t <= 2.0 + 100*j;
            tspan = [0, 10];
            jspan = [0,  2];
            config = HybridSolverConfig("silent").flowPriority();
            sol = sys.solve({0, 0}, tspan, jspan, config);
            expected_jumps = 2.0;
            testCase.assertEqual(sol.jump_times, expected_jumps, 'AbsTol', 1e-6)
            testCase.assertEqual(sol.subsys_sols{1}.jump_times, expected_jumps, 'AbsTol', 1e-6)
            testCase.assertEmpty(sol.subsys_sols{2}.jump_times) % Fails
        end
        
        function testWrongNumberOfInitialStates(testCase)
                                  % Size of: (u, x, y)
            sub = MockControlledHybridSystem(1, 1, 1);
            sys = CompoundHybridSystem(sub);
            tspan = [0, 10];
            jspan = [0,  2];
            config = HybridSolverConfig("silent");
            testCase.verifyError(@() sys.solve({1, 2, 3}, tspan, jspan, config), ...
                "CompoundHybridSystem:WrongNumberOfInitialStates");
        end
        
        function testInitialStatesWrongSize(testCase)
                                  % Size of: (u, x, y)
            sub1 = MockControlledHybridSystem(1, 1, 1);
            sub2 = MockControlledHybridSystem(1, 1, 1);
            sys = CompoundHybridSystem(sub1, sub2);
            tspan = [0, 10];
            jspan = [0,  2];
            config = HybridSolverConfig("silent");
            testCase.verifyError(@() sys.solve({1, [1; 2]}, tspan, jspan, config), ...
                "CompoundHybridSystem:WrongNumberOfInitialStates");            
        end
        
        function testInitialStatesNotCellArray(testCase)
                                  % Size of: (u, x, y)
            sub = MockControlledHybridSystem(1, 1, 1);
            sys = CompoundHybridSystem(sub);
            tspan = [0, 10];
            jspan = [0,  2];
            config = HybridSolverConfig("silent");
            testCase.verifyError(@() sys.solve([1, 2, 3], tspan, jspan, config), ...
                "CompoundHybridSystem:InitialStateNotCell");    
        end
        
        function testWrongNumberOfContinuousFeedbackInputArguments(testCase)
            % i.e. @(y1, y2, t, j) instead of @(y1, y2, y3, t, j).
                                  % Size of: (u, x, y)
            sub1 = MockControlledHybridSystem(1, 1, 1);
            sub2 = MockControlledHybridSystem(1, 1, 1);
            sys = CompoundHybridSystem(sub1, sub2);
            testCase.verifyError(@() sys.setContinuousFeedback(1, @(y1, t, j) y1), ...
                "CompoundHybridSystem:WrongNumberFeedbackInputArgs")
        end
        
        function testFeedbackOutVectorWrongSize(testCase)
            % i.e. @(y1, y2, t, j) instead of @(y1, y2, y3, t, j).
            sub = MockControlledHybridSystem(1, 1, 1);
            sys = CompoundHybridSystem(sub);
            sys.setContinuousFeedback(1, @(x1, t, j) zeros(2, 1));
            testCase.verifyError(@() sys.solve({1}, [0, 10], [0, 10]), ...
               "CompoundHybridSystem:DoesNotMatchInputDimension");
        end
        
        function testWarningWhenSetFeedbackForSystemWithNoInputs(testCase)
            % i.e. @(y1, y2, t, j) instead of @(y1, y2, y3, t, j).
            sub = MockControlledHybridSystem(0, 1, 1);
            sys = CompoundHybridSystem(sub);
            testCase.verifyWarning(@() sys.setContinuousFeedback(1, @(x1, t, j) []), ...
               "CompoundHybridSystem:SystemHasNoInputs");
            testCase.verifyWarning(@() sys.setDiscreteFeedback(1, @(x1, t, j) []), ...
               "CompoundHybridSystem:SystemHasNoInputs");
            testCase.verifyWarning(@() sys.setFeedback(1, @(x1, t, j) []), ...
               "CompoundHybridSystem:SystemHasNoInputs");
        end
        
    end

end