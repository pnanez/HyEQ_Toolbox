classdef HybridPriority < int32 
   enumeration
      JUMP(1) % Default
      FLOW(2)
   end
   
   methods(Static)
       function hp = default()
           hp = HybridPriority.JUMP;
       end
   end
end