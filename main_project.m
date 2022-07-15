%% Information
 % Label for objects : 1: pods , 2: picking , 3: placing ,4 : obstacle
 % Some status of AGV : 1:empty loaded  2:loaded 

clear
    global dynMAP staMAP wsMAP goalMAP;
    %AGVs = 5; % Number of AGV
%% Generating a MAP manually 
   % init MAP
    staMAP = addMap(1,96,40);
    wsMAP = addMap(2,96,40);
    goalMAP = addMap(3,96,40);
    dynMAP = addMap(4,96,40);
    
%% Create an input type of good
   %goodList = [1 2 3];
   %goodType = input('Input type of good:')
   
   
%% A little UI
   startFlag = 1 ;
   
if startFlag == 1   
%% Init condition 
    %GoalX = input('Input X <=96 : '); GoalY = input('Input Y <=40 : ');          % X < 96 , Y < 40
    goalMAP(12,11) =1;
    %StartX1= 5; StartY1= 1;         % Cols < 96 , Rows < 40 .
    agvFlag = 1; % 1 : going to position

    [GoalX, GoalY] = find(goalMAP == 1);
    [y,x] = find(dynMAP == 1);
       
%% Serial of workload
% Start and End Positions
    while agvFlag ~= 0        
        %%% Create find destination           
        [OptimalPath] = aStarSearch(x,y,GoalX,GoalY,staMAP,1,agvFlag);
        % Cheat to reach path
        if size(OptimalPath,1) == 1
            OptimalPath(2,:) = OptimalPath(1,:);
        end        
        [x,y,agvFlag] = agvStatus(agvFlag,OptimalPath(end-1,2),OptimalPath(end-1,1),1,OptimalPath(1,2),OptimalPath(1,1)) ;          
        if agvFlag == 2
           [GoalY,GoalX] = find(wsMAP == 2);
        end  
        disPath(OptimalPath,staMAP); 
        drawnow;
    end
end


