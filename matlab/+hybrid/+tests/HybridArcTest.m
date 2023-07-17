classdef HybridArcTest < matlab.unittest.TestCase

    methods (Test)
        %%%%%%%%%%%%%%%% Test jump_times and flow_lengths %%%%%%%%%%%%%%%%%
        % Thorough testing of jump time and flow length calculations are in
        % jumpTimesTest.m and flowLengthTest.m. The tests here simply
        % verify that the HybridSolution class is wired up correctly.
        function testJumpTimes(testCase)
            t = linspace(0, 12, 5)'; % Not important
            j = [0; 1; 1; 1; 2]; % Jump at indices 1 and 4.
            x = NaN(5, 1); % Not important
            sol = HybridArc(t, j, x);
            testCase.assertEqual(sol.jump_times, hybrid.internal.jumpTimes(t, j))
            testCase.assertEqual(sol.is_jump_start, logical([1; 0; 0; 1; 0]))
        end

        function testFlowLengths(testCase)
            t = [0; 0.5; 0.5; 2; 3; 3; 4];
            j = [0;   0;   1; 1; 1; 2; 2];
            x = NaN(7, 1); % Not important
            sol = HybridArc(t, j, x);
            testCase.assertEqual(sol.flow_lengths, [0.5; 2.5; 1])
            testCase.assertEqual(sol.shortest_flow_length, 0.5)
        end

        function testJumpIndices(testCase)
            t = [0; 0.5; 0.5; 2; 3; 3; 4];
            j = [0;   0;   1; 1; 1; 2; 2];
            x = NaN(7, 1); % Not important
            sol = HybridArc(t, j, x);
            testCase.assertEqual(sol.jump_start_indices, [2; 5])
            testCase.assertEqual(sol.jump_end_indices, [3; 6])
        end

        function testInconsistentVectorLengths(testCase)
            % We define vectors that are all the same length...
            t = linspace(0, 12, 3)'; 
            j = zeros(3, 1); 
            x = zeros(3, 2);
            % ... then truncate them one at a time to make them not match.
            testCase.verifyError(@()HybridArc(t(1:2), j, x), 'HybridArc:WrongShape')
            testCase.verifyError(@()HybridArc(t, j(1:2), x), 'HybridArc:WrongShape')
            testCase.verifyError(@()HybridArc(t, j, x(1:2, :)), 'HybridArc:WrongShape')
        end

        function testTimeVectorsWrongShape(testCase)
            % Construct test data.
            t = linspace(0, 12, 3)';
            j = zeros(3, 1);
            x = zeros(3, 2);

            % Test with t transposed.
            testCase.verifyError(@() HybridArc(t', j, x), 'HybridArc:WrongShape')
            % Test with j transposed.
            testCase.verifyError(@() HybridArc(t, j', x), 'HybridArc:WrongShape')
            % Test with arguments out of order. (This won't throw an error if x
            % is not a column vector.)
            testCase.verifyError(@() HybridArc(x, t, j), 'HybridArc:WrongShape')
        end

        function testHybridArcArgumentsNotNumeric(testCase)
            % Construct test data.
            t = linspace(0, 12, 3)';
            j = zeros(3, 1);
            x = zeros(3, 2);

            testCase.verifyError(@() HybridArc('hello', j, x), 'HybridArc:NonNumericArgument')
            testCase.verifyError(@() HybridArc(t, 'hello', x), 'HybridArc:NonNumericArgument')
            testCase.verifyError(@() HybridArc(t, j, 'hello'), 'HybridArc:NonNumericArgument')
        end

        %%%%%%%%%%%% Test is_{jump_start,jump_end} %%%%%%%%%%%%%

        function testIsJumpStartJumpEnd_noJump(testCase)
            t = [0; 1; 2];
            j = [0; 0; 0];
            x = nan(numel(t), 1);
            harc = HybridArc(t, j, x);

            testCase.assertEqual(harc.is_jump_start, logical([0; 0; 0]))
            testCase.assertEqual(harc.is_jump_end, logical([0; 0; 0]))
        end

        function testIsJumpStartJumpEnd_jumpInMiddle(testCase)
            t = [0; 1; 1; 2];
            j = [0; 0; 1; 1];
            x = nan(numel(t), 1);
            harc = HybridArc(t, j, x);

            testCase.assertEqual(harc.is_jump_start, logical([0; 1; 0; 0]))
            testCase.assertEqual(harc.is_jump_end, logical([0; 0; 1; 0]))
        end

        function testIsJumpStartJumpEnd_jumpAtStart(testCase)
            t = [0; 0; 1; 2];
            j = [0; 1; 1; 1];
            x = nan(numel(t), 1);
            harc = HybridArc(t, j, x);

            testCase.assertEqual(harc.is_jump_start, logical([1; 0; 0; 0]))
            testCase.assertEqual(harc.is_jump_end, logical([0; 1; 0; 0]))
        end

        function testIsJumpStartJumpEnd_jumpAtEnd(testCase)
            t = [0; 1; 1];
            j = [0; 0; 1];
            x = nan(numel(t), 1);
            harc = HybridArc(t, j, x);

            testCase.assertEqual(harc.is_jump_start, logical([0; 1; 0]))
            testCase.assertEqual(harc.is_jump_end, logical([0; 0; 1]))
        end

        %%%%%%%%%%%% Test {jump_start,jump_end}_indices %%%%%%%%%%%%%

        function testJumpStartJumpEndIndices_noJump(testCase)
            t = [0; 1; 2];
            j = [0; 0; 0];
            x = nan(numel(t), 1);
            harc = HybridArc(t, j, x);

            testCase.assertEqual(harc.jump_start_indices, double.empty(0, 1))
            testCase.assertEqual(harc.jump_end_indices, double.empty(0, 1))
        end

        function testJumpStartJumpEndIndices_jumpInMiddle(testCase)
            t = [0; 1; 1; 2];
            j = [0; 0; 1; 1];
            x = nan(numel(t), 1);
            harc = HybridArc(t, j, x);

            testCase.assertEqual(harc.jump_start_indices, 2)
            testCase.assertEqual(harc.jump_end_indices, 3)
        end

        function testJumpStartJumpEndIndices_jumpAtStart(testCase)
            t = [0; 0; 1; 2];
            j = [0; 1; 1; 1];
            x = nan(numel(t), 1);
            harc = HybridArc(t, j, x);

            testCase.assertEqual(harc.jump_start_indices, 1)
            testCase.assertEqual(harc.jump_end_indices, 2)
        end

        function testJumpStartJumpEndIndices_twoJumps(testCase)
            t = [0; 1; 1; 2; 2];
            j = [0; 0; 1; 1; 2];
            x = nan(numel(t), 1);
            harc = HybridArc(t, j, x);

            testCase.assertEqual(harc.jump_start_indices, [2; 4])
            testCase.assertEqual(harc.jump_end_indices, [3; 5])
        end

        function testJumpStartJumpEndIndices_twoJumpsSequentially(testCase)
            t = [0; 1; 1; 2];
            j = [0; 0; 1; 2];
            x = nan(numel(t), 1);
            harc = HybridArc(t, j, x);

            testCase.assertEqual(harc.jump_start_indices, [2; 3])
            testCase.assertEqual(harc.jump_end_indices, [3; 4])
        end

        % Test Hybrid Arc Transformations.
        function testTransform(testCase)
            t = linspace(0, 10)';
            j = zeros(100, 1);
            x = rand(100, 3);

            sol = HybridArc(t, j, x);
            transformed_sol = sol.transform(@(x) [x(1); -x(2)]);
            testCase.assertEqual(transformed_sol.t, t)
            testCase.assertEqual(transformed_sol.j, j)
            testCase.assertEqual(transformed_sol.x, [x(:, 1), -x(:, 2)])
        end

        function testSelect(testCase)
            t = linspace(0, 10)';
            j = zeros(100, 1);
            x = rand(100, 3);

            sol = HybridArc(t, j, x);
            selected_sol = sol.select([1, 3]);
            testCase.assertEqual(selected_sol.t, t)
            testCase.assertEqual(selected_sol.j, j)
            testCase.assertEqual(selected_sol.x, [x(:, 1), x(:, 3)])
        end

        %%% Test interpolateToArray %%%        
        
        % Missing test cases for HybridArc/interpolateToArray:
        % 1. Test when multiple jumps happen at a single interpolation time.
        % 2. Test when a jump occurs at the first or final interpolation times.

        function testInterpolateToArray_ConstantX_NoJumps(testCase)
            x = ones(10, 1);
            t = linspace(0, 9, 10)';
            j = zeros(10, 1);
            sol = HybridArc(t, j, x);

            n_interp = 100;
            t_grid = linspace(0, 9, n_interp);
            interpolated_array = sol.interpolateToArray(t_grid);
            
            testCase.assertEqual(interpolated_array, ones(n_interp, 1))
        end

        function testInterpolateToArray_ConstantX_NoJumps2D(testCase)
            x = [ones(10, 1), 2*ones(10, 1)];
            t = linspace(0, 9, 10)';
            j = zeros(10, 1);
            sol = HybridArc(t, j, x);

            n_interp = 100;
            t_grid = linspace(0, 9, n_interp)'; % Test using column vector.
            interpolated_array = sol.interpolateToArray(t_grid);
            
            % Check values
            expected_array = [ones(n_interp, 1), 2*ones(n_interp, 1)];
            testCase.assertEqual(interpolated_array, expected_array)
        end

        function testInterpolateToArray_ConstantX_OneJump(testCase)
            x = ones(10,1);
            t = [0; 1; 2; 3; 4; 4; 5; 6; 7; 8]; % jump at t=4
            j = [0; 0; 0; 0; 0; 1; 1; 1; 1; 1];
            sol = HybridArc(t,j,x);

            t_grid = linspace(0,8);
            interpolated_sol = sol.interpolateToArray(t_grid);

            % Check values
            testCase.assertEqual(interpolated_sol, ones(size(interpolated_sol)))
        end

        function testInterpolateToArray_LinearX_NoJump_1D(testCase)
            t = linspace(0, 50, 51)';
            j = zeros(51, 1);
            x = 2*t;
            sol = HybridArc(t, j, x);
            
            t_grid = linspace(t(1), t(end), 123)';
            interpolated_sol = sol.interpolateToArray(t_grid);

            % Check values
            testCase.assertEqual(interpolated_sol, 2*t_grid) % slope of 2
        end

        function testInterpolateToArray_LinearX_OneJump_1D(testCase)
            t_jump = 12.56; t_end = 34; % Jump and end times.
            n_before = 26; n_after = 10; % Time steps before and after jump.
            t = [linspace(     0, t_jump, n_before)'; 
                 linspace(t_jump,  t_end, n_after)'];
            j = [zeros(n_before, 1); 
                  ones(n_after, 1)];
            x = [2*linspace(     0, t_jump, n_before)'; 
                  -linspace(t_jump,  t_end, n_after)'];
            sol = HybridArc(t, j, x);

            t_grid = linspace(0, t_end, 18)';
            interpolated_sol = sol.interpolateToArray(t_grid);
            ndxs_before_jump = t_grid < t_jump;
            ndxs_after_jump = t_grid > t_jump;

            % Check values
            testCase.assertEqual(interpolated_sol(ndxs_before_jump), 2*t_grid(ndxs_before_jump))
            testCase.assertEqual(interpolated_sol(ndxs_after_jump),   -t_grid(ndxs_after_jump))
        end
        
        function testInterpolateToArray_JumpAtInterpolationPoint_1D(testCase)
            % Jump time and end time.
            T_JUMP = 12.56; T_END = 34;

            % Time steps before and after jump.
            N_BEFORE = 26; N_AFTER = 10; 

            % (Constant) x-values before and after jump.
            X_BEFORE = 0; X_AFTER = 1;

            t = [linspace(     0, T_JUMP, N_BEFORE)'; 
                 linspace(T_JUMP,  T_END, N_AFTER)'];
            j = [zeros(N_BEFORE, 1); 
                  ones(N_AFTER, 1)];
            x = [X_BEFORE*ones(N_BEFORE, 1); 
                 X_AFTER*ones(N_AFTER, 1)];
            sol = HybridArc(t, j, x);

            t_grid = [0; T_JUMP; T_END];
            [x_interp, t_interp] = sol.interpolateToArray(t_grid);

            % Check sizes
            testCase.assertSize(x_interp, [3 1])
            testCase.assertSize(t_interp, [3 1])

            % Check values
            x_interp_expected = [X_BEFORE; mean([X_BEFORE, X_AFTER]); X_AFTER];
            testCase.assertEqual(x_interp, x_interp_expected)
        end
        
        function testInterpolateToArray_JumpAtInterpolationPoint_2D(testCase)
            % Jump and end times.
            T_JUMP = 12.56; T_END = 34;

            % Time steps before and after jump.
            N_BEFORE = 26; N_AFTER = 10; 

            % (Constant) x-values before and after jump.
            X_BEFORE = [-2 2]; X_AFTER = [0 10];
            
            t = [linspace(     0, T_JUMP, N_BEFORE)'; 
                 linspace(T_JUMP,  T_END, N_AFTER)'];
            j = [zeros(N_BEFORE, 1); 
                  ones(N_AFTER, 1)];
            x = [ones(N_BEFORE,1)*X_BEFORE; 
                 ones(N_AFTER,1)*X_AFTER];
            sol = HybridArc(t, j, x);

            t_grid = [0; T_JUMP; T_END];
            [x_interp, t_interp] = sol.interpolateToArray(t_grid);

            testCase.assertSize(x_interp, [3 2])
            testCase.assertSize(t_interp, [3 1])

            % Check values
            x_interp_expected = [X_BEFORE; mean([X_BEFORE; X_AFTER]); X_AFTER];
            testCase.assertEqual(x_interp, x_interp_expected)
        end
        
        function testInterpolateToArray_ScalarTGrid(testCase)
            % Jump and end times.
            T_JUMP = 12.56; T_END = 34;

            % Time steps before and after jump.
            N_BEFORE = 26; N_AFTER = 10; 
            
            t = [linspace(     0, T_JUMP, N_BEFORE)'; 
                 linspace(T_JUMP,  T_END, N_AFTER)'];
            j = [zeros(N_BEFORE, 1); 
                  ones(N_AFTER, 1)];
            x = [23*ones(N_BEFORE,1); 
                 12*ones(N_AFTER,1)];
            sol = HybridArc(t, j, x);

            n_t_interp = 123; % Number of interpolation points.
            [x_interp, t_interp] = sol.interpolateToArray(n_t_interp);

            % Check the shapes are correct.
            testCase.assertSize(x_interp, [n_t_interp 2])
            testCase.assertSize(t_interp, [n_t_interp 1])
        end
        
        function testInterpolateToArray_InterpMethod_Previous(testCase)
            % x-values
            x1=[-2 2]; x2=[0 10]; x3=[20, 0];
            
            t = [ 0;  1;  2];
            j = [ 0;  0;  0];
            x = [x1; x2; x3];
            sol = HybridArc(t, j, x);

            t_grid = [0; 0.5; 1; 1.5; 2];
            [x_interp, t_interp] = sol.interpolateToArray(t_grid, 'InterpMethod', 'previous');

            testCase.assertSize(x_interp, [numel(t_grid) 2])
            testCase.assertSize(t_interp, [numel(t_grid) 1])

            % Check values
            x_interp_expected = [x1; x1; x2; x2; x3];
            testCase.assertEqual(x_interp, x_interp_expected)
        end
        
        function testInterpolateToArray_ValueAtJumpFnc_NaN(testCase)
            % Jump and end times.
            T_JUMP = 12.56; T_END = 34;

            % Time steps before and after jump.
            N_BEFORE = 26; N_AFTER = 10; 

            % (Constant) x-values before and after jump.
            X_BEFORE = [-2 2]; X_AFTER = [0 10];
            
            t = [linspace(     0, T_JUMP, N_BEFORE)'; 
                 linspace(T_JUMP,  T_END, N_AFTER)'];
            j = [zeros(N_BEFORE, 1); 
                  ones(N_AFTER, 1)];
            x = [ones(N_BEFORE,1)*X_BEFORE; 
                 ones(N_AFTER,1)*X_AFTER];
            sol = HybridArc(t, j, x);

            t_grid = [0; T_JUMP; T_END];

            value_at_jump_fh = @(x_and_gx) NaN(size(x_and_gx, 1), 1);
            [x_interp, t_interp] = sol.interpolateToArray(t_grid, 'ValueAtJumpFnc', value_at_jump_fh);

            testCase.assertSize(x_interp, [3 2])
            testCase.assertSize(t_interp, [3 1])

            % Check values
            x_interp_expected = [X_BEFORE; [NaN NaN]; X_AFTER];
            testCase.assertEqual(x_interp, x_interp_expected)
        end

        function testInterpolateToArray_ValueAtJumpFnc_WrongSizeOutputFromFH(testCase)
            % Jump and end times.
            T_JUMP = 12.56; T_END = 34;

            % Time steps before and after jump.
            N_BEFORE = 26; N_AFTER = 10; 

            % (Constant) x-values before and after jump.
            X_BEFORE = [-2 2]; X_AFTER = [0 10];
            
            t = [linspace(     0, T_JUMP, N_BEFORE)'; 
                 linspace(T_JUMP,  T_END, N_AFTER)'];
            j = [zeros(N_BEFORE, 1); 
                  ones(N_AFTER, 1)];
            x = [ones(N_BEFORE,1)*X_BEFORE; 
                 ones(N_AFTER,1)*X_AFTER];
            sol = HybridArc(t, j, x);

            t_grid = [0 T_JUMP];
            value_at_jump_fh = @(x_and_gx) ones(1, 5);
            call_fh = @() sol.interpolateToArray(t_grid, 'ValueAtJumpFnc', value_at_jump_fh);
            testCase.assertError(call_fh, 'HybridArc:WrongFunctionHandleOutputSize');
        end

        %%% Test interpolateToHybridArc %%%

        function testInterpolateToHybridArc_ConstantX_NoJumps(testCase)
            x = ones(10, 1);
            t = linspace(0, 9, 10)';
            j = zeros(10, 1);
            sol = HybridArc(t, j, x);

            n_interp = 100;
            t_grid = linspace(0, 9, n_interp);
            interpolated_array = sol.interpolateToHybridArc(t_grid);
            
            % Check sizes
            testCase.assertSize(interpolated_array.x, [n_interp, 1])
            testCase.assertSize(interpolated_array.t, [n_interp, 1])
            testCase.assertSize(interpolated_array.j, [n_interp, 1])

            % Check values
            testCase.assertEqual(interpolated_array.x, ones(n_interp, 1))
        end

        %%% Test restrictT and restrictJ %%%

        function testRestrictT(testCase)
            t = [0; 1; 2; 2];
            j = [0; 0; 0; 1];
            x = [0.1, 0.2;
                 1.1, 1.2;
                 2.1, 2.2;
                 3.1, 3.2;];
            sol = HybridArc(t, j, x);
            restricted_sol = sol.restrictT([1, 2]);
            testCase.assertEqual(restricted_sol.t, [1; 2; 2])
            testCase.assertEqual(restricted_sol.j, [0; 0; 1])
            testCase.assertEqual(restricted_sol.x, [1.1, 1.2; ...
                                                    2.1, 2.2; ...
                                                    3.1, 3.2])
        end

        function testRestrictT_NoOverlap(testCase)
            t = [0; 1];
            j = [0; 0];
            x = [0.1, 0.2;
                 1.1, 1.2];
            sol = HybridArc(t, j, x);
            restricted_sol = sol.restrictT([10, 11]);
            testCase.assertEqual(restricted_sol.t, double.empty(0, 1))
            testCase.assertEqual(restricted_sol.j, double.empty(0, 1))
            testCase.assertEqual(restricted_sol.x, double.empty(0, 2))
        end

        function testRestrictJ_span(testCase)
            t = [0; 1; 1; 2; 2; 3; 3];
            j = [0; 0; 1; 1; 2; 2; 3];
            x = rand(length(t), 2);
            sol = HybridArc(t, j, x);
            restricted_sol = sol.restrictJ([1, 2]);
            testCase.assertEqual(restricted_sol.t, [1; 2; 2; 3])
            testCase.assertEqual(restricted_sol.j, [1; 1; 2; 2])
            testCase.assertEqual(restricted_sol.x, x(3:6, :))
        end

        function testRestrictJ_single(testCase)
            t = [0; 1; 1; 2; 2; 3; 3];
            j = [0; 0; 1; 1; 2; 2; 3];
            x = rand(length(t), 2);
            sol = HybridArc(t, j, x);
            restricted_sol = sol.restrictJ(2);
            testCase.assertEqual(restricted_sol.t, [2; 3])
            testCase.assertEqual(restricted_sol.j, [2; 2])
            testCase.assertEqual(restricted_sol.x, x(5:6, :))
        end

        function testRestrictTJ_errorNotNumeric(testCase)
            t = [0; 1; 1; 2; 2; 3; 3];
            j = [0; 0; 1; 1; 2; 2; 3];
            x = rand(length(t), 2);
            sol = HybridArc(t, j, x);
            testCase.verifyError(@() sol.restrictT('hello'), 'HybridArc:NonNumericArgument')
            testCase.verifyError(@() sol.restrictJ('hello'), 'HybridArc:NonNumericArgument')
        end

        function testRestrictTJ_errorWrongShape(testCase)
            t = [0; 1; 1; 2; 2; 3; 3];
            j = [0; 0; 1; 1; 2; 2; 3];
            x = rand(length(t), 2);
            sol = HybridArc(t, j, x);
            testCase.verifyError(@() sol.restrictT([1 2 3]), 'HybridArc:WrongShapeArgument')
            testCase.verifyError(@() sol.restrictJ([1 2 3]), 'HybridArc:WrongShapeArgument')
        end
    end

end