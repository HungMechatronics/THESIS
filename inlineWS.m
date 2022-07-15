function [fPoint,midpoint,lastpoint,agvOutput] = inlineWS(wsName,agvName)
    global agvArray nodeArray stor;
    switch wsName
        case 1
            if(agvArray(agvName,1).direc(end)=='E')
               agvArray(agvName,1).rot = [1 90;1 -90;1 -90];
            elseif (agvArray(agvName,1).direc(end)=='W')
               agvArray(agvName,1).rot = [1 -90;1 -90;1 -90];
            elseif (agvArray(agvName,1).direc(end)=='N')
               agvArray(agvName,1).rot = [0 0;1 -90;1 -90];
            end    
                agvArray(agvName,1).direc = 'NES';
                agvArray(agvName,1).goal = [ nodeArray(stor(40,22),:);nodeArray(end-5,:);nodeArray(end-4,:);nodeArray(stor(40,24),:)]; 
                % extract the output
                agvArray(agvName,1).goalX = 24;
                agvArray(agvName,1).goalY = 40; 
                newgoal = [ [22,40]; nodeArray(end-5,:) ;nodeArray(end-4,:);[24,40] ];
                
        case 2
            if(agvArray(agvName,1).direc(end)=='E')
               agvArray(agvName,1).rot = [1 90;1 -90;1 -90];
            elseif (agvArray(agvName,1).direc(end)=='W')
               agvArray(agvName,1).rot = [1 -90;1 -90;1 -90];
            elseif (agvArray(agvName,1).direc(end)=='N')
               agvArray(agvName,1).rot = [0 0;1 -90;1 -90];               
            end    
                agvArray(agvName,1).direc = 'NES';
                agvArray(agvName,1).goal = [ nodeArray(stor(40,45),:);nodeArray(end-3,:);nodeArray(end-2,:);nodeArray(stor(40,47),:)]; 
                % extract the output
                agvArray(agvName,1).goalX = 47;
                agvArray(agvName,1).goalY = 40;  
                newgoal = [ [45,40]; nodeArray(end-3,:) ;nodeArray(end-2,:);[47,40] ];
        case 3
            if(agvArray(agvName,1).direc(end)=='E')
               agvArray(agvName,1).rot = [1 90;1 -90;1 -90];
            elseif (agvArray(agvName,1).direc(end)=='W')
               agvArray(agvName,1).rot = [1 -90;1 -90;1 -90];
            elseif (agvArray(agvName,1).direc(end)=='N')
               agvArray(agvName,1).rot = [0 0;1 -90;1 -90];               
            end    
                agvArray(agvName,1).direc = 'NES';
                agvArray(agvName,1).goal = [ nodeArray(stor(40,68),:);nodeArray(end-1,:);nodeArray(end,:);nodeArray(stor(40,70),:)]; 
                % extract the output
                agvArray(agvName,1).goalX = 70;
                agvArray(agvName,1).goalY = 40;  
                newgoal = [ [68,40] ; nodeArray(end-1,:);nodeArray(end,:);[70,40]];
                 
        case 4
            if(agvArray(agvName,1).direc(end)=='E')
               agvArray(agvName,1).rot = [1 -90;1 90;1 90];
            elseif (agvArray(agvName,1).direc(end)=='W')
               agvArray(agvName,1).rot = [1 90;1 90;1 90];
            elseif (agvArray(agvName,1).direc(end)=='S')
               agvArray(agvName,1).rot = [0 0;1 -90;1 -90];               
            end    
                agvArray(agvName,1).direc = 'SEN';
                agvArray(agvName,1).goal = [ nodeArray(stor(1,26),:);nodeArray(end-9,:);nodeArray(end-8,:);nodeArray(stor(1,28),:)]; 
                % extract the output
                agvArray(agvName,1).goalX = 28;
                agvArray(agvName,1).goalY = 1;  
                 newgoal = [ [26,1];nodeArray(end-9,:);nodeArray(end-8,:);[28,1]]; 
                 
        case 5
            if(agvArray(agvName,1).direc(end)=='E')
               agvArray(agvName,1).rot = [1 -90;1 90;1 90];
            elseif (agvArray(agvName,1).direc(end)=='W')
               agvArray(agvName,1).rot = [1 90;1 90;1 90];
            elseif (agvArray(agvName,1).direc(end)=='S')
               agvArray(agvName,1).rot = [0 0;1 -90;1 -90];                 
            end    
                agvArray(agvName,1).direc = 'SEN';
                agvArray(agvName,1).goal = [ nodeArray(stor(1,61),:);nodeArray(end-7,:);nodeArray(end-6,:);nodeArray(stor(1,63),:)]; 
                % extract the output
                agvArray(agvName,1).goalX = 63;
                agvArray(agvName,1).goalY = 1;  
                newgoal = [ [61,1];nodeArray(end-7,:);nodeArray(end-6,:);[63,1]];                  
    end 
    fPoint = newgoal(1,:);
    midpoint = newgoal(2,:);
    lastpoint = newgoal(4,:);
    agvArray(agvName,1).distanceCost = [0 0 0];
    agvArray(agvName,1).totalDistance =  agvArray(agvName,1).totalDistance + 5;
    agvArray(agvName,1).waitingFlag = 1;
    agvOutput = agvArray(agvName,1);
end    