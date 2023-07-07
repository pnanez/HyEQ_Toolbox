function [nFailed, nIncomplete] = run(filter)
% Run the tests in the HyEQ Toolbox. 
% 
% The tests that are run can be filtered by passing an optional string input
% argument. The options for the input are listed here: 
% *       'all': Run all tests (default).
% * 'essential': then several slow tests are skipped that are only important during development.
% *      'fast': then all slow tests are skipped. This includes tests of
%                HybridPlotBuilder, which is included in the 'essential' tests.
% 
% Some tests are skipped automatically on older versions of MATLAB.

if ~exist('filter', 'var') || strcmpi(filter, 'all')
    test_packages = {'hybrid.tests', 'hybrid.tests.slow_essential', 'hybrid.tests.slow_dev_only'};
elseif strcmpi(filter, 'essential')
    test_packages = {'hybrid.tests', 'hybrid.tests.slow_essential'};
elseif strcmpi(filter, 'fast')
    test_packages = {'hybrid.tests'};
end

is_simulink_installed = ~isempty(ver('SIMULINK'));
% Close all Simulink systems.
while is_simulink_installed && ~isempty(gcs())
    close_system(gcs());
end

if verLessThan('matlab', '9.2') 
    % I'm not sure when 'Strict' was introduced as a runtests option.
    % Please increase the version number as needed.
    results = runtests(test_packages);
else
    results = runtests(test_packages, 'Strict', true);
end

nPassed = 0;
nFailed = 0;
nIncomplete = 0;
for i = 1:length(results)
    nPassed = nPassed + results(i).Passed;
end
for i = 1:length(results)
    nFailed = nFailed + results(i).Failed;
end
nSkipped = length(results) - nPassed - nFailed;

if nFailed > 0
    error('Several HyEQ Tests Failed: %d passed, %d failed, %d skipped.\n', ...
       nPassed, nFailed, nSkipped)
end

if nargout == 0
   fprintf('\nFinished: %d passed, %d failed, %d skipped.\n', ...
       nPassed, nFailed, nSkipped)
   clear nFailed;
   clear nIncomplete;
end


end