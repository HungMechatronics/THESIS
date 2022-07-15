function [rotation,direction,goalFinal] = getcurrentPath(agvName,startNode,endNode,agvMission)
    
    global agvPosition stor nodeArray goalLine;
    x = startNode(1,1);
    y = startNode(1,2);
    x1 = endNode(1,1); % col 
    y1 = endNode(1,2); % row
    [finalFscore,goal] = aStarSearch(x,y,x1,y1,stor,1,agvMission);

   % Convert from [col,row] to real [x,y] coordinate.
    for i = 1:size(goal,1)
       sGoal_ = stor(goal(i,1),goal(i,2));
       finalGoal(size(goal,1)-i+1,:) = [nodeArray(sGoal_,1),nodeArray(sGoal_,2)];
    end    

    goal = finalGoal;
    goalLine = line(goal(:,1),goal(:,2),'LineWidth',1.5,'Color','r'); 
    %radi = ones(1,size(goal,1))*200;

    % Mattanhen distance
%     for i = 1:size(goal,1)-1
%         dis(i)=abs((goal(i,1)-goal(i+1,1))+(goal(i,2)-goal(i+1,2)));
%     end    

    % Set first AGV Point
    agvPosition(agvName,1) = double(goal(1,1));
    agvPosition(agvName,2) = double(goal(1,2));

    
    % Tao ra ma tran huong
    char direc = []; % ma tran huong
    for i = 1:size(goal,1)-1
       if(goal(i+1,1) > goal(i,1))
           direc(i) ='W';
       elseif(goal(i+1,2)> goal(i,2))
           direc(i) ='N';
       elseif(goal(i+1,1) < goal(i,1))
           direc(i) ='E';
       elseif(goal(i+1,2)< goal(i,2))
           direc(i) ='S';
       end
    end    
    
    if direc(1)=='W' || direc(1) =='E'
        beta = 90;
    else
        beta = 0;    
    end
    agvPosition(agvName,3) = beta;
    
    rot(1,:) = [0 0];
    % Find rotation function 
    for i = 2: size(direc,2)
        if (direc(i-1)-direc(i)) == 9 || (direc(i-1)-direc(i)) == -4 || (direc(i-1)-direc(i)) == -14
            rot(i,:) = [1 90];
        elseif (direc(i-1)-direc(i)) == -9 || (direc(i-1)-direc(i)) == 4 || (direc(i-1)-direc(i)) == 14
            rot(i,:) = [1 -90];
        else
            rot(i,:) = [0 0];
        end
    end  
    
    direction = direc;
    rotation = rot;
    goalFinal = goal;
end