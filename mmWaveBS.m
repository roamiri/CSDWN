classdef mmWaveBS
   properties
      X
      Y
      P
      dMUE
      dFUE
      FUEX
      FUEY
      M  % distance with MUE
      B  % distance with BS
      dM1 = 50; dM2 = 100; dM3 = 150;
      state = zeros(1,2)
      powerProfile = []
      C_FUE
      C_profile = []
      Q
      Xref
      Yref
   end
   methods
      function obj = mmWaveBS(xPos, yPos, dFUE, centerX, centerY)
        obj.X = xPos;
        obj.Y = yPos;
        obj.dFUE = dFUE;
        obj.FUEX = xPos;
        obj.FUEY = yPos+dFUE;
        obj.Xref = centerX;
        obj.Yref = centerY;
      end
      
      function obj = setQTable(obj,QTable)
          obj.Q = QTable;
      end
      
      function obj = setPower(obj,power)
%           obj.P = 10^((power-30)/10);
            obj.P = power;
%             obj.powerProfile = [obj.powerProfile power];
      end
      
      function obj = setCapacity(obj,c)
        obj.C_FUE = c;
%         obj.C_profile = [obj.C_profile c];
      end
      function obj = getDistanceStatus(obj)
          obj.dMUE = sqrt((obj.X-obj.Xref)^2+(obj.Y-obj.Yref)^2);
          if(obj.dMUE <= obj.dM1 )
              obj.state = 0;
          elseif(obj.dMUE <= obj.dM2 )
              obj.state = 1;
          elseif(obj.dMUE <= obj.dM3 )
              obj.state = 2;
          else
              obj.state = 3;
          end
      end
   end
end
