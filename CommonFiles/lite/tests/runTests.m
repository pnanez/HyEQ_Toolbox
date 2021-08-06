function nFailed = runTests()
testFiles = what("tests");
testFiles = testFiles.m(endsWith(testFiles.m, "Test.m"));

results = runtests(testFiles, "Strict", 1);

nFailed = 0;
for i = 1:length(results)
    nFailed = nFailed + results(i).Failed;
end
end