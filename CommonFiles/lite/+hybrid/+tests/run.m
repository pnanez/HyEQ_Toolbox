function [nFailed, nIncomplete] = run()

if verLessThan('matlab', '9.2') 
    % I'm not sure when 'Strict' was introduced as a runtests option.
    % Please increase the version number as needed.
    results = runtests('hybrid.tests');
else
    results = runtests('hybrid.tests', 'Strict', true);
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

if nargout == 0
   fprintf('\nFinished: %d passed, %d failed, %d skipped.\n', ...
       nPassed, nFailed, nSkipped)
   clear nFailed;
   clear nIncomplete;
end

end