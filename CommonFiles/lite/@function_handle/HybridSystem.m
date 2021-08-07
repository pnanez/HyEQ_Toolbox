function sys = HybridSystem(f, g, C, D, rule)
% HybridSystem Create a HybridSystem object from the give data. 

if ~exist("rule", "var")
    rule = HybridPriority.default();
end

sys = EZHybridSystem(f, g, C, D); 
sys.hybrid_priority = rule;

end