function []=SimFnc2tex(simsys,embfnc,mfilename)
%   SIMFCN2TEX   Generates and save a tex file (mfilename) from an embedded
%   simulink function (embfnc) of a simulink model (symsys).
%   simsys: path of simulink system.
%	embfnc: embedded function name e.g., simsys/subsys/embedded_function.
%	mfilename: name of the generated m and tex file.
%--------------------------------------------------------------------------
% Matlab M-file Project: HyEQ Toolbox @  Hybrid Systems Laboratory (HSL),
% https://hybrid.soe.ucsc.edu/software
% http://hybridsimulator.wordpress.com/
% Filename: SimFcn2tex.m
%--------------------------------------------------------------------------
%   See also PLOTARC, PLOTARC3, PLOTFLOWS, PLOTHARC, PLOTHARCCOLOR,
%   PLOTHARCCOLOR3D, PLOTHYBRIDARC, PLOTJUMPS.
%   Copyright @ Hybrid Systems Laboratory (HSL),
%   Revision: 0.0.0.1 Date: 04/18/2017 14:10:00
sf = sfroot();
load_system(simsys);
block = sf.find('Path',embfnc,'-isa','Stateflow.EMChart');
script = block.Script;
fid = fopen(mfilename, 'w');
fprintf(fid, '%s\r\n', script);
fclose(fid);
close_system(simsys);
m2tex(mfilename,'num')
delete(mfilename)
end