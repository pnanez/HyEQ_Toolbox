function [nFailed, nIncomplete] = run()

results = runtests("hybrid.tests", "Strict", true);

nPassed = 0;
nFailed = 0;
nIncomplete = 0;
for i = 1:length(results)
    nPassed = nPassed + results(i).Passed;
end
for i = 1:length(results)
    nFailed = nFailed + results(i).Failed;
end
for i = 1:length(results)
    nIncomplete = nIncomplete + results(i).Incomplete;
end

if nargout == 0
   fprintf("\nFinished: %d passed, %d failed, %d skipped.\n", ...
       nPassed, nFailed, nIncomplete - nFailed)
   clear nFailed;
   clear nIncomplete;
end

end