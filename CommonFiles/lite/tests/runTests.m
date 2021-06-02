testFiles = what("tests");
testFiles = testFiles.m(endsWith(testFiles.m, "Test.m"));

runtests(testFiles);