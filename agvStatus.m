function [x,y,sta] = agvStatus(flag, nextX,nextY,num ,goalX ,goalY)
    % MAP : static map , current pods that are avaiable
    % flag : status of the AGV.
    % sizeX , sizeY : warehouse size
    % num : AGV number
    % flag 1 : get , 2 : go back , 0: stop
    
    %%% Create types of good which AGV is holding.
    global dynMAP staMAP;
    [currentY,currentX] = find(dynMAP == num);
    if currentX == goalX && currentY == goalY
       if flag == 1 
           staMAP(currentY,currentX) = 0;
           sta = 2;
       elseif flag == 2
           sta = 0;
       end
    else
        sta = flag;
    end    
    % Stop condition
    if flag == 1
        if dynMAP(nextY,nextX) ~= 0
           x = currentX;
           y = currentY;
        else  % moving on
           x = nextX;
           y = nextY;
        end
    elseif flag == 2
        if staMAP(nextY,nextX) == 1
           x = currentX;
           y = currentY;
        elseif dynMAP(nextY,nextX) ~= 0
           x = currentX;
           y = currentY;
        else % moving on
           x = nextX;
           y = nextY;
        end
    end 
    dynMAP(currentY,currentX) = 0;
    dynMAP(y,x) = num;        
end