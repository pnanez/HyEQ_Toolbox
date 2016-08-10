function blkStruct = slblocks
% Specify that the product should appear in the library browser
% and be cached in its repository
    Browser.Library = 'HyEQ_Library_R2012b';
    Browser.Name    = 'Hybrid Equations Toolbox';
    Browser(1).Choice = 0 ;
    blkStruct.Browser = Browser;
% Choice=0: Resave the library as SLX    
% Choice=1: Generate the required repository info in memory
% Choice=2: Skip. If the user chooses 2, their library won?t show up in the
% Library Browser at all since repository info is missing
