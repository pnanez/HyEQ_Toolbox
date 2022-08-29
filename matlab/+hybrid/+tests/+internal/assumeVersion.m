function assumeVersion(testCase, version)
% Add an assumption to a test function that skips the test if the current version of MATLAB is too old.

if strcmp(version, 'R2016b')
    % Version R2016b or later is required for the 'string' class.
    version_num = '9.1';
elseif strcmp(version, 'R2021b')
    version_num = '9.11';
else
    error('Version year %s not recognized.', version)
end

if verLessThan('matlab', version_num)
    testCase.assumeFail(['This test does not work before version ', version, '.']);
end

end

