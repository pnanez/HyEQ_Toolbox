function assumeStringsSupported(testCase)
    if ~exist('string', 'class')
        testCase.assumeFail('strings are not supported on current version of Matlab')
    end
end