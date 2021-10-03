classdef convert_varargin_to_solution_objTest < matlab.unittest.TestCase
   
    methods (Test)
       
        function test_Solution(testCase)
            sol_in = hybrid.examples.ExampleBouncingBallHybridSystem().solve([10, 0]);
            varagin_cell = {sol_in};       
            sol_out = hybrid.internal.convert_varargin_to_solution_obj(varagin_cell);
            testCase.assertEqual(sol_in, sol_out);
        end
        
        function test_inputs_sol_y(testCase)
            sol_in = hybrid.examples.ExampleBouncingBallHybridSystem().solve([10, 0]);
            y_in = ones(length(sol_in.t), 3);
            varagin_cell = {sol_in, y_in};       
            sol_out = hybrid.internal.convert_varargin_to_solution_obj(varagin_cell);
            testCase.assertEqual(sol_in.t, sol_out.t);
            testCase.assertEqual(sol_in.j, sol_out.j);
            testCase.assertEqual(y_in, sol_out.x);
        end
        
        function test_inputs_t_j_y(testCase)
            sol_in = hybrid.examples.ExampleBouncingBallHybridSystem().solve([10, 0]);
            y_in = rand(length(sol_in.t), 3);
            varagin_cell = {sol_in.t, sol_in.j, y_in};       
            sol_out = hybrid.internal.convert_varargin_to_solution_obj(varagin_cell);
            testCase.assertEqual(sol_in.t, sol_out.t);
            testCase.assertEqual(sol_in.j, sol_out.j);
            testCase.assertEqual(y_in, sol_out.x);
        end
        
        function test_inputs_sol_1arg(testCase)
            sol_in = hybrid.examples.ExampleBouncingBallHybridSystem().solve([10, 0]);
            y_func = @(x) -x;
            varagin_cell = {sol_in, y_func};       
            sol_out = hybrid.internal.convert_varargin_to_solution_obj(varagin_cell);
            testCase.assertEqual(sol_out.t,  sol_in.t);
            testCase.assertEqual(sol_out.j,  sol_in.j);
            testCase.assertEqual(sol_out.x, -sol_in.x);
        end
        
        function test_too_many_inputs(testCase)
            import hybrid.internal.convert_varargin_to_solution_obj
            varagin_cell = {1, 2, 3, 4};       
            testCase.verifyError(@() convert_varargin_to_solution_obj(varagin_cell), ...
                'Hybrid:InvalidArgument');
        end
        
        function test_1input_not_solution(testCase)
            import hybrid.internal.convert_varargin_to_solution_obj
            varagin_cell = {1};       
            testCase.verifyError(@() convert_varargin_to_solution_obj(varagin_cell), ...
                'Hybrid:InvalidArgument');
        end
        
        function test_2input_first_not_solution(testCase)
            import hybrid.internal.convert_varargin_to_solution_obj
            varagin_cell = {1, 4};       
            testCase.verifyError(@() convert_varargin_to_solution_obj(varagin_cell), ...
                'Hybrid:InvalidArgument');
        end

    end

end