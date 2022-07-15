function [sta] = selectPosition(agvNum)

     % Output targetPosition
     % Input wsMAP
     % Output number in goals MAP 
     global wsMAP goalMAP;
     [maxY ,maxX] = find(wsMAP == max(max(wsMAP)));
     if size(maxY,1)==0 || size(maxX,1) ==0
        sta = 0;
     else 
        wsY = maxY(1); wsX = maxX(1);
        goalMAP(wsY,wsX) = agvNum;
        wsMAP(wsY,wsX) = wsMAP(wsY,wsX)-1;
     end
end