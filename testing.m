% Init layout 
clear
[circles,stor,nodeArr] = drawLayout();
global nodeArray;
nodeArray = double(nodeArr);
% Init patch

k = patch;          
k.FaceColor = 'g'; 


% Fix parameters.
l=1000 ;w=800; h = sqrt(l^2+w^2)/2;
alp = acosd(w/sqrt(w^2+l^2));
% beta = 0; % global




%% findPath function : output direc[],rot[]
goal = aStarSearch(1,1,5,40,stor,1,1);

% Convert from [col,row] to real [x,y] coordinate.
for i = 1:size(goal,1)
   sGoal_ = stor(goal(i,1),goal(i,2));
   finalGoal(size(goal,1)-i+1,:) = [nodeArr(sGoal_,1),nodeArr(sGoal_,2)];
end    

goal = finalGoal;
line(goal(:,1),goal(:,2),'LineWidth',1.5,'Color','r');
radi = ones(1,size(goal,1))*200;
%circles1 = viscircles(goal,radi,'LineWidth',0.5);
v = 1000; % global

% Mattanhen distance
for i = 1:size(goal,1)-1
    dis(i)=abs((goal(i,1)-goal(i+1,1))+(goal(i,2)-goal(i+1,2)));
end    

% Set trung diem
global centX centY;
centX = double(goal(1,1));
centY = double(goal(1,2));

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
rot = [];
if direc(1)=='W' || direc(1) =='E'
    beta = 90;
else
    beta = 0;    
end
% Find rotation function 
for i = 1: size(direc,2)-1
    if (direc(i)-direc(i+1)) == 9 || (direc(i)-direc(i+1)) == -4 || (direc(i)-direc(i+1)) == -14
        rot(i,:) = [1 90];
    elseif (direc(i)-direc(i+1)) == -9 || (direc(i)-direc(i+1)) == 4 || (direc(i)-direc(i+1)) == 14
        rot(i,:) = [1 -90];
    else
        rot(i,:) = [0 0];
    end
end    
rot(end+1,:)=[0 0];
i = 1;
t_stamp = 0.1;
temp = 0;
t=0;
k.Visible = 'on';
circles.Visible = 'off';
nextNode = 0;

%% updateAGV output: agvPosition + agvNextMovement.
% Nhan dien vi tri node
while i<=size(direc,2)
    t= t + t_stamp; % Thoi gian th?c
    temp = temp + 0.1;
    
    % Display AGV
    x = [ (centX+h*cosd(alp+beta));centX+h*cosd(180-(alp+beta));
        centX+h*cosd(180+(alp+beta));centX+h*cosd(-(alp+beta))];
    y = [ (centY+h*sind(alp+beta));centY+h*sind(180-(alp+beta));
        centY+h*sind(180+(alp+beta));centY+h*sind(-(alp+beta))];
    vertex = [x(1,1) y(1,1);x(2,1) y(2,1);x(3,1) y(3,1);x(4,1) y(4,1)];
    face = [1 2 3 4];
    set(k,'faces',face,'vertices',vertex);   
    drawnow
    
    % check condition
    if( direc(i) == 'N')
        centY = centY + v*t_stamp;
        if centY >= goal(i+1,2)-20
            nextNode = 1;
        end
    elseif( direc(i) == 'S')
        centY = centY - v*t_stamp;
        if centY <= goal(i+1,2)-20
            nextNode = 1;
        end
    elseif( direc(i) == 'E')
        if centX <= goal(i+1,1)-20
            nextNode = 1;
        end
        centX = centX - v*t_stamp;
    elseif( direc(i) == 'W')    
        if centX >= goal(i+1,1)-20
            nextNode = 1;
        end
        centX = centX + v*t_stamp;
    end    
%     T = double(dis(i)/v); % constance

   % Changing state condition  
   if(nextNode == 1)
        if(rot(i,1)==1)
            beta1 = makeRotation(centX,centY,rot(i,2),k,h);
            beta = beta + beta1;
        end        
        i = i+1;
        temp = 0; 
        nextNode = 0;
    end
end

