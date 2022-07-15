function [finalFscore,OptimalPath,obj,road]=aStarSearch(StartX,StartY,GoalX,GoalY,MAP,Connecting_Distance,agvStatus,agvName)
%Version 2.0
% By Hardy on February , 2022

global nodeArray nodeArr podStatic time_window T agvArray;
agvArray(agvName,1).slowDownY = [];
agvArray(agvName,1).slowDownX = [];
agvArray(agvName,1).timeSlowDown = [];
slowDownStorage = [0 0 0];
exist = 0;
finalFscore = 0;
checkWindow = [];
dista = [];
clearWindow = find(time_window(:,5) == double(agvName));
if isempty(clearWindow) ~=1
    time_window(clearWindow,:) = [];
end

%% FINDING ASTAR PATH IN AN OCCUPANCY GRID
% Preallocation of Matrices
[Height,Width]=size(MAP); %Height and width of matrix

% Cost function : f = g + h
GScore=zeros(Height,Width);           %Matrix keeping track of G-scores 
FScore=double(inf(Height,Width));     %Matrix keeping track of F-scores (only open list) 
%31/3 -> turning single -> double

Hn=double(zeros(Height,Width));       %Heuristic matrix
%31/3 -> turning single -> double

% Open & Closed list     
OpenMAT=double(zeros(Height,Width));    %Matrix keeping of open grid cells
ClosedMAT=double(zeros(Height,Width));  %Matrix keeping track of closed grid cells
% 31/3/2022 -> Turn int8 -> Double

%%% Add a state code when AGV is loaded or unloaded.%%%
if agvStatus == 2 || agvStatus == 4 
    ClosedMAT(podStatic==1) = 1;                  %Adding object-cells to closed matrix                                      
end
% 

% Tracking parents , original code is int16.
ParentX=double(zeros(Height,Width));   %Matrix keeping track of X position of parent
ParentY=double(zeros(Height,Width));   %Matrix keeping track of Y position of parent
% 31/3/2022 -> Turn int8 -> Double


%% Setting up matrices representing neighboors to be investigated
    NeighboorCheck = [ 0 1 0; 1 0 1; 0 1 0];
% Find neighbors that can move 
    [row, col]=find(NeighboorCheck==1);
% Convert to normal x,y
    Neighboors=[row col]-(Connecting_Distance+1)  ; 
    N_Neighboors=size(col,1);
    

%% Creating Heuristic-matrix based on distance to nearest  goal node
    RegisteredGoals =[GoalX GoalY];
    Nodesfound=size(RegisteredGoals,1); % Numbers of Node need to find .

for k=1:size(MAP,1)
    for j=1:size(MAP,2)
        if MAP(k,j) ~= 0
        % Mat is [ x-xc , y-yc ] array 
        Mat=RegisteredGoals-(repmat([j k],(Nodesfound),1));
        % Manhattan distance .
            Distance= sum(abs(Mat));
            Hn(k,j)=Distance/(1.3); % t = s/v
        end
    end
end

%Note: If Hn values is set to zero the method will reduce to the Dijkstras method.

%Initializign start node with FValue and opening first node.
% f = g + h , h : the distance from current to goal.
% f(1) = h , g(1) = 0

FScore(StartY,StartX)=Hn(StartY,StartX);  
OpenMAT(StartY,StartX)=1;   
m = 1;
%% Create a loop for updating Open and Closed loop 
while 1==1 %Code will break when path found or when no path exist
    MINopenFSCORE=min(min(FScore)); % find the min F
    % Fail condition 
        if MINopenFSCORE==inf
        %Failuere!
            OptimalPath= inf ;
            RECONSTRUCTPATH=0;  
            % Add value so that it won't get error
            break
        end
        
    % Update current position 
    [CurrentY,CurrentX]=find(FScore==MINopenFSCORE);
    CurrentY=CurrentY(1);
    CurrentX=CurrentX(1);

    % Destination Check 
    if (CurrentY==GoalY) && (CurrentX==GoalX)
    %if GoalRegister(CurrentY,CurrentX)==1
        RECONSTRUCTPATH=1;
        break
    end
    
   % Removing node from OpenList to ClosedList  
    OpenMAT(CurrentY,CurrentX)= 0 ;
    FScore(CurrentY,CurrentX)=inf;
    ClosedMAT(CurrentY,CurrentX)=1;
    
    
    now =  MAP(CurrentY  ,CurrentX  ); % Node hien tai
    t = 0;
    
    % Check neighbors .
    checkWindow_3 = [];
    for p=1:N_Neighboors
        i=Neighboors(p,1); %Y
        j=Neighboors(p,2); %X
        
        corruptType = 0;
        % Boundary condition 
        if CurrentY+i<1||CurrentY+i>Height||CurrentX+j<1||CurrentX+j>Width
            continue
        end
        
        next = MAP(CurrentY+i,CurrentX+j); 
        % Time to complete every road.
        dist = (abs(nodeArray(now,1)-nodeArray(next,1))+ abs(nodeArray(now,2)-nodeArray(next,2)))/1300 ; % average speed 

        % Add rotation time in begin of the road. If rotate t + 3
        if m >= 2
            past = MAP(ParentY(CurrentY,CurrentX),ParentX(CurrentY,CurrentX));
            if( (nodeArr(now,1) == nodeArr(next,1) && nodeArr(next,1) == nodeArr(past,1)) || (nodeArr(now,2) == nodeArr(next,2) && nodeArr(next,2)==nodeArr(past,2)))
                t = 0;
            else                 
                t = 3;
            end 
            % Cross Corruption Check
            
            checkWindow_3 = find(time_window(:,3) == double(CurrentY) & time_window(:,4) == double(CurrentX) & ((time_window(:,1) ~= double(ParentY(CurrentY,CurrentX)) | time_window(:,2) ~= double(ParentX(CurrentY,CurrentX)))));
            checkWindow_9 = find(time_window(:,3) == double(CurrentY+i) & time_window(:,4) == double(CurrentX+j) & time_window(:,1) ~= double(CurrentY) | time_window(:,2) ~= double(CurrentX));
%             if isempty(checkWindow_3) == 0
%                 disp('Get go');
%             end
        end 
        
        % time in & out of currentAGV.        
        t_in  = T + GScore(CurrentY,CurrentX);
        t_out = T + GScore(CurrentY,CurrentX) + dist + t;
        
        % Find AGV that travels the same path.
        % Front Corruption Ability
        % Chase corruption cases
        checkWindow_1 = find(time_window(:,1) == double(CurrentY) & time_window(:,2) == double(CurrentX) & time_window(:,3) == double(CurrentY+i) & time_window(:,4) == double(CurrentX+j)); 
        % Frond corruption cases
        checkWindow_2 = find(time_window(:,3) == double(CurrentY) & time_window(:,4) == double(CurrentX) & time_window(:,1) == double(CurrentY+i) & time_window(:,2) == double(CurrentX+j)); 
%         checkWindow = cat(1,checkWindow_1,checkWindow_2); % all currently used road. 
        checkWindow = checkWindow_2;
        % Chase Corruption Check
        checkWindow_7  = find(time_window(:,1) == double(CurrentY) & time_window(:,2) == double(CurrentX) & time_window(:,3) == double(CurrentY) & time_window(:,4) == double(CurrentX)); 
        
%         disp(checkWindow_3);
    
        % Kiem tra truoc va cham doi dau
%         if ~isempty(checkWindow_7) == 1
%            stopWindow = time_window(checkWindow_7,:); 
%            disp('Hellooooooo');
%            [corruptType,time2turn] = stopCorruptCheck(t_in,stopWindow);
%         end
%         if ~isempty(checkWindow) == 1 
%             corruptWindow = time_window(checkWindow,:);
%             corruptType = frontCorruptCheck(corruptWindow,t_in,t_out,CurrentY,CurrentX,CurrentY+i,CurrentX+j,t);
%         end
%         % Neu khong phai va cham doi dau tiep tuc kiem tra 
%         if  corruptType ~= 1            
%             if ~isempty(checkWindow_3) == 1
%                 crossWindow = time_window(checkWindow_3,:);
%                 crossWindow_2 = time_window(checkWindow_9,:);
%                 crossWindow_2 = cat(1,crossWindow,crossWindow_2);
%                 [corruptType,time2turn] = crossCorruptCheck(ParentY(CurrentY,CurrentX),ParentX(CurrentY,CurrentX),CurrentY,CurrentX,CurrentY+i,CurrentX+j,t_in,t_out,crossWindow_2,t);
% %               disp(corruptType);
%             end 
%             if ~isempty(checkWindow_1) == 1
%                 if ~isempty(checkWindow_1) == 1
%                     chaseWindow = time_window(checkWindow_1,:);
%                     [corruptType,time2turn] = chaseCorruptCheck(CurrentY,CurrentX,CurrentY+i,CurrentX+j,t_in,t_out,chaseWindow,t);
%                 end
%             end
%         end        
% Evaluate the coruption        
        if corruptType ~= 0
            disp(corruptType);
        end
        if corruptType == 1
%             GScore(CurrentY,CurrentX) = 10000;
            tentative_gScore = 10000;
            ClosedMAT(CurrentY+i,CurrentX+j) = 1;
        elseif corruptType == 2
%             GScore(CurrentY,CurrentX) = 10000;
            tentative_gScore = 10000;
            ClosedMAT(CurrentY+i,CurrentX+j) = 1;
        elseif corruptType == 3
            tentative_gScore = GScore(CurrentY,CurrentX) + dist + time2turn + t;
        else
            tentative_gScore = GScore(CurrentY,CurrentX) + dist + t;             
        end
%         disp(corruptType);
        
        Flag=1;
        if(ClosedMAT(CurrentY+i,CurrentX+j)==0) %Neiboor is open             
            if Flag==1                                

                % Put free neighbors on the OpenList
                if OpenMAT(CurrentY+i,CurrentX+j)==0
                   OpenMAT(CurrentY+i,CurrentX+j)=1;  
                   
                % Check for the min gScore of neighbors 
                elseif tentative_gScore >= GScore(CurrentY+i,CurrentX+j)
                    continue                                    
                end
                if (corruptType == 3)
%                     agvArray(agvName,1).slowDownY = CurrentY;
%                     agvArray(agvName,1).slowDownX = CurrentX;
                    temp = [CurrentY,CurrentX,time2turn];
%                     slowDownStorage = cat(1,slowDownStorage,temp);
                    for count = 1:size(slowDownStorage,1)
                        exist = 0;
                        if( temp(1,1) == slowDownStorage(count,1) && temp(1,2) == slowDownStorage(count,2))
                            exist = 1;
                        end                    
                    end
                    if exist == 0
                        slowDownStorage = cat(1,slowDownStorage,temp);                        
                    end
                end    
                
%                 agvArray(agvName,1).totalDistance =  agvArray(agvName,1).totalDistance + dist;
                ParentX(CurrentY+i,CurrentX+j)=CurrentX;
                ParentY(CurrentY+i,CurrentX+j)=CurrentY;               
                tIN(CurrentY,CurrentX) = t_in;
                tOUT(CurrentY+i,CurrentX+j) = t_out;                                 
                GScore(CurrentY+i,CurrentX+j)=tentative_gScore;
                FScore(CurrentY+i,CurrentX+j)= tentative_gScore + Hn(CurrentY+i,CurrentX+j); % final fScore 
            end
        elseif (ClosedMAT(CurrentY+i,CurrentX+j)==1)
            if GScore(CurrentY+i,CurrentX+j) > tentative_gScore
               ClosedMAT(CurrentY+i,CurrentX+j) = 0;
               OpenMAT(CurrentY+i,CurrentX+j) = 1;
            end
        end        
    end         
    m = m +1;
end

%% Recreate the list of parent a.k.a shortest path
k=2;
if RECONSTRUCTPATH
    OptimalPath(1,:)=[CurrentY CurrentX];
    while RECONSTRUCTPATH    
        if (((CurrentX== StartX)) &&(CurrentY==StartY))
            break      
        else
    % Dummy value 
    CurrentY1 = CurrentY;
    CurrentX1 = CurrentX;
    CurrentXDummy=ParentX(CurrentY,CurrentX);
    CurrentY=ParentY(CurrentY,CurrentX);
    CurrentX=CurrentXDummy;
    OptimalPath(k,:)=[CurrentY CurrentX];
    if k == 2
        temp_window =[ OptimalPath(k,1),OptimalPath(k,2),OptimalPath(k-1,1),OptimalPath(k-1,2),agvName,tIN(CurrentY,CurrentX),tOUT(CurrentY1,CurrentX1)+3,OptimalPath(k-1,1),OptimalPath(k-1,2),agvStatus];
    else
        temp_window =[ OptimalPath(k,1),OptimalPath(k,2),OptimalPath(k-1,1),OptimalPath(k-1,2),agvName,tIN(CurrentY,CurrentX),tOUT(CurrentY1,CurrentX1),OptimalPath(k-2,1),OptimalPath(k-2,2),agvStatus];
    end
    time_window = cat(1,time_window,temp_window);
    now = MAP(OptimalPath(k,1),OptimalPath(k,2));
    next = MAP(OptimalPath(k-1,1),OptimalPath(k-1,2));
    % Add in first
%     dista = abs(nodeArray(now,1)-nodeArray(next,1)) + abs(nodeArray(now,2)-nodeArray(next,2));
%     agvArray(agvName,1).totalDistance =  agvArray(agvName,1).totalDistance + dista/1000;
    % Add in later
    dista(k-1) = (abs(nodeArray(now,1)-nodeArray(next,1)) + abs(nodeArray(now,2)-nodeArray(next,2)))/1000;
    % Update all the parent path.
        k=k+1;
        end 
    end
end
% slowDownStorage
% OptimalPath
% disp(OptimalPath);
if OptimalPath ~= double(inf(1,1))
    if ~isempty(slowDownStorage) == 1    
        for i = 1:size(slowDownStorage,1)
            temp2 = find(OptimalPath(:,1) == slowDownStorage(i,1) &  OptimalPath(:,2) == slowDownStorage(i,2));
        %         temp2
            if ~isempty(temp2) == 1
                agvArray(agvName,1).slowDownY = cat(1,agvArray(agvName,1).slowDownY,OptimalPath(temp2,1));
                agvArray(agvName,1).slowDownX = cat(1,agvArray(agvName,1).slowDownX,OptimalPath(temp2,2));
                agvArray(agvName,1).timeSlowDown = cat(1,agvArray(agvName,1).timeSlowDown,slowDownStorage(i,3));
        %             break;
            end
        end       
    end
end


obj = agvArray(agvName,1);
% finalFscore = FScore(OptimalPath(1,1),OptimalPath(1,2));
if ~isempty(checkWindow)
    finalFscore = checkWindow;
end
% disp(finalFscore);
road = dista ;
% dista
end
