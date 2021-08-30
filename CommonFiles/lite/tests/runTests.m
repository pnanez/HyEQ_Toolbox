function nFailed = runTests()
testFiles = what("tests");
testFiles = testFiles.m(endsWith(testFiles.m, "Test.m"));

results = runtests(testFiles, "Strict", true);

nFailed = 0;
for i = 1:length(results)
    nFailed = nFailed + results(i).Failed;
end

if nargout == 0
   fprintf("Tests complete. %d tests failed.\n", nFailed)
   clear nFailed;
end

end