classdef SubsystemsListTest < matlab.unittest.TestCase

    methods (Test)

        function testGetByIndex(testCase)
            import hybrid.tests.internal.*
            sub1 = MockHybridSubsystem(1, 1, 1);
            sub2 = MockHybridSubsystem(1, 1, 1);
            subsystems = hybrid.internal.SubsystemList(sub1, sub2);
            testCase.assertEqual(subsystems.get(1), sub1);
            testCase.assertEqual(subsystems.get(2), sub2);
        end

        function testGetByReference(testCase)
            import hybrid.tests.internal.*
            sub1 = MockHybridSubsystem(1, 1, 1);
            sub2 = MockHybridSubsystem(1, 1, 1);
            subsystems = hybrid.internal.SubsystemList(sub1, sub2);
            testCase.assertEqual(subsystems.get(sub1), sub1);
            testCase.assertEqual(subsystems.get(sub2), sub2);
        end

        function testGetByName(testCase)
            import hybrid.tests.internal.*
            sub1 = MockHybridSubsystem(1, 1, 1);
            sub2 = MockHybridSubsystem(1, 1, 1);
            sub3 = MockHybridSubsystem(1, 1, 1);
            subsystems = hybrid.internal.SubsystemList("sub 1", sub1, ...
                                                       "sub 2", sub2, ...
                                                       'sub 3', sub3);
            testCase.assertEqual(subsystems.get("sub 1"), sub1);
            testCase.assertEqual(subsystems.get('sub 2'), sub2);
            testCase.assertEqual(subsystems.get("sub 3"), sub2);
            testCase.assertEqual(subsystems.getName(1),      "sub 1");
            testCase.assertEqual(subsystems.getName(sub2),   "sub 2");
            testCase.assertEqual(subsystems.getName('sub 3'),"sub 3");
        end

        function testGetName(testCase)
            import hybrid.tests.internal.*
            sub1 = MockHybridSubsystem(1, 1, 1);
            sub2 = MockHybridSubsystem(1, 1, 1);
            sub3 = MockHybridSubsystem(1, 1, 1);
            subsystems = hybrid.internal.SubsystemList("sub 1", sub1, ...
                                                       "sub 2", sub2, ...
                                                       'sub 3', sub3);
            testCase.assertEqual(subsystems.getName(1),      "sub 1");
            testCase.assertEqual(subsystems.getName(sub2),   "sub 2");
            testCase.assertEqual(subsystems.getName('sub 3'),"sub 3");
        end

        function testGetNameReturnsEmptyIfNoNames(testCase)
            import hybrid.tests.internal.*
            sub1 = MockHybridSubsystem(1, 1, 1);
            subsystems = hybrid.internal.SubsystemList(sub1);
            testCase.assertEqual(subsystems.getName(1), "");
        end
        
        function testErrorGetByNameWhenNoNames(testCase)
            import hybrid.tests.internal.*
            sub1 = MockHybridSubsystem(1, 1, 1);
            sub2 = MockHybridSubsystem(1, 1, 1);
            subsystems = hybrid.internal.SubsystemList(sub1, sub2);
            testCase.verifyError(@() subsystems.get("sub 1"), ...
                "CompoundHybridSystem:NoNamesProvided");
        end

        function testErrorNotNameOrSubsystemInConstructor(testCase)
            import hybrid.tests.internal.*
            sub1 = MockHybridSubsystem(1, 1, 1);
            testCase.verifyError(@() hybrid.internal.SubsystemList(1, sub1), ...
                "CompoundHybridSystem:UnexpectedType");
        end

        function testErrorNameWithoutSubsystemInConstructor(testCase)
            import hybrid.tests.internal.*
            sub1 = MockHybridSubsystem(1, 1, 1);
            fh = @() hybrid.internal.SubsystemList("sub 1", sub1, "sub 2");
            testCase.verifyError(fh, "CompoundArgument:InvalidConstructorArgs");
        end

        function testErrorNameWithNonSubsystemInConstructor(testCase)
            fh = @() hybrid.internal.SubsystemList("sub 1", "sub 2");
            testCase.verifyError(fh, "CompoundHybridSystem:UnexpectedType");
        end

        function testErrorNonuniqueName(testCase)
            import hybrid.tests.internal.*
            sub1 = MockHybridSubsystem(1, 1, 1);
            sub2 = MockHybridSubsystem(1, 1, 1);
            fh = @() hybrid.internal.SubsystemList("sub 1", sub1, ...
                                                   "sub 1", sub2);
            testCase.verifyError(fh, "CompoundHybridSystem:DuplicateName");
        end

    end

end