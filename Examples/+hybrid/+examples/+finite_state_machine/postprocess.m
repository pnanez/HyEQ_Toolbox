% Initialization script for Finite State Machine example

sol = HybridArc(t, j, x); %#ok<IJCL>

figure(1)
hpb = HybridPlotBuilder();
hpb.subplots('on')...
   .labels('$q_{1}$', '$q_{2}$')...
   .legend('$q_{1}$', '$q_{2}$')...
   .plotFlows(sol)

figure(2)
hpb = HybridPlotBuilder();
hpb.subplots('on')...
    .labels('$q_{1}$', '$q_{2}$')...
    .legend('$q_{1}$', '$q_{2}$')...
    .plotJumps(sol)

figure(3)
hpb = HybridPlotBuilder();
hpb.subplots('on')...
    .legend('$q_{1}$')...
    .plotHybrid(sol.slice(1))     
grid on
view(37.5, 30) 


