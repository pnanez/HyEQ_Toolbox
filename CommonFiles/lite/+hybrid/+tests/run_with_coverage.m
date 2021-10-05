import matlab.unittest.TestSuite
import matlab.unittest.TestRunner
import matlab.unittest.plugins.CodeCoveragePlugin

suite = TestSuite.fromPackage('hybrid.tests');

% Create a test runner.
runner = TestRunner.withTextOutput;

% Add CodeCoveragePlugin to the runner and run the tests. Specify that the
% source code folder is your current working folder. If you have other source
% code files in your current working folder, they show up in the coverage
% report. The folder that contains the source code (quadraticSolver.m) must be
% on the MATLAB search path.
runner.addPlugin(CodeCoveragePlugin.forFolder(pwd))
result = runner.run(suite);