function [nextRoad,clearRot,findPathFlag,currentGoal] =updateAGV(agvName,t_stamp,v,direc,road,rotFlag,rotAngle,k,nextNode)
    %% Input
        % agvName : name of the AGV.
        % direc : direction for future position.
        % road : current road due to A*.
        % rotFlag : during rotating. 1 : if rot , 0 : if not
        % v : velocity
        % k : agvPatch
        global temp podStatic;

    nextNodeFlag = 0;
    findPathFlag = 0;
    % Take current position of AGV.
    global agvPosition h alp stor nodeArray wsStatus goalLine podStatus;
    centX= agvPosition(agvName,1);
    centY= agvPosition(agvName,2);
    beta = agvPosition(agvName,3);   
    nextRoad = road;
    clearRot = 0;
    
%% Linear movement    
% nextNode = goal(i+1,:)
if rotFlag ~= 1
    % check direction
    if( direc == 'N')
        centY = centY + v*t_stamp;
        if centY >= nextNode(1,2)-20
            nextNodeFlag = 1;
            centY = nextNode(1,2); % added code
        end
    elseif( direc == 'S')
        centY = centY - v*t_stamp;
        if centY <= nextNode(1,2)-20
            nextNodeFlag = 1;
            centY = nextNode(1,2); 
        end
    elseif( direc == 'E')
        centX = centX - v*t_stamp;
        if centX <= nextNode(1,1) - 20
            nextNodeFlag = 1;
            centX = nextNode(1,1); % added code
        end        
    elseif( direc == 'W')   
        centX = centX + v*t_stamp;
        if centX >= nextNode(1,1) + 20
            nextNodeFlag = 1;
            centX = nextNode(1,1); % added code
        end        
    end
    %disp(nextNodeFlag);
    % nextNodeFlag 
    if nextNodeFlag == 1
       nextRoad = road+1;
    end
    
    
%% Rotating movement
elseif rotFlag == 1
%     beta1 = makeRotation(centX,centY,rot(i,2),k,h);
%     beta = beta + beta1;

    t = 5 ; % rotation time   
    rot = rotAngle/(t/t_stamp); % rot per 0.1s

    if abs(temp)<abs(rotAngle)    
%        rotate(k,[0 0 1],rot,[centX,centY,1]);        
        temp = temp + rot;
    else 
        clearRot = 1;
        beta = beta + rotAngle;
        temp = 0;
    end  
end
    
%% Display AGV
    x = [ (centX+h*cosd(alp+beta));centX+h*cosd(180-(alp+beta));
        centX+h*cosd(180+(alp+beta));centX+h*cosd(-(alp+beta))];
    y = [ (centY+h*sind(alp+beta));centY+h*sind(180-(alp+beta));
        centY+h*sind(180+(alp+beta));centY+h*sind(-(alp+beta))];
    vertex = [x(1,1) y(1,1);x(2,1) y(2,1);x(3,1) y(3,1);x(4,1) y(4,1)];
    face = [1 2 3 4];
    set(k,'faces',face,'vertices',vertex);   
%     if(clearRot == 0)
%         rotate(k,[0 0 1],temp,[centX,centY,1]);
%     end
    
    
%% Update new position    
    agvPosition(agvName,1)  = centX;
    agvPosition(agvName,2)  = centY;
    agvPosition(agvName,3)  = beta;
    
%% Changing status condition
    goalRow = agvPosition(agvName,5); % x = col
    goalCol = agvPosition(agvName,6); % y = row
    index = stor(goalCol,goalRow);
    finalGoal = nodeArray(index,:);
%     disp(finalGoal);
    if(centX == finalGoal(1,1) && centY == finalGoal(1,2))
        if agvPosition(agvName,4) == 1  
           podStatic(goalCol,goalRow) = 0;           
           [goalPod(1,2),goalPod(1,1)] = convNode2Pod([goalCol,goalRow]);
           a = find(podStatus(:,1) == goalPod(1,2) & podStatus(:,2) == goalPod(1,1),1);
           podStatus(a,7) = 0;             
           agvPosition(agvName,4) = 2;
           agvPosition(agvName,5) = wsStatus(agvPosition(agvName,7),1);
           agvPosition(agvName,6) = wsStatus(agvPosition(agvName,7),2);                                  
           findPathFlag = 1;
        elseif agvPosition(agvName,4) == 2
           agvPosition(agvName,4) = 3;                      
           returnPod(agvName);  
           findPathFlag = 1;
        elseif agvPosition(agvName,4) == 3
           agvPosition(agvName,4) = 0; 
           [goalPod(1,2),goalPod(1,1)] = convNode2Pod([goalCol,goalRow]);
           a = find(podStatus(:,1) == goalPod(1,2) & podStatus(:,2) == goalPod(1,1),1);
           podStatus(a,7) = 1; 
        end 
        goalLine.Visible = 'off';
        nextRoad = 1;
        pause(0.5);
    end
    currentGoal = [goalRow goalCol];

end