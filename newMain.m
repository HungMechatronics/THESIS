% new main funtion 
clear
clf
clc
%% Initial parameters
% Fix parameters.
global h alp t_stamp goalLine horLine verLine;
l=800 ;w=800; h = sqrt(l^2+w^2)/2;
alp = acosd(w/sqrt(w^2+l^2));
t_stamp = 0.1;
global numberofAGV totalgood;
numberofAGV = 8;
numberofPod = 1950;
totalgood = 0;
% GoodpPod = 40;
% fullPod = numberofPod * GoodpPod;
% percentofGood = 50; % 50%


% Node config
global podsort rectCenter stor nodeArray nodeArr podStatic; 
        % Notice : stor(row,col - y,x) , nodeArray(i,1) = x ,
        % nodeArray(i,2) = y  !!!!
newaxes = axes();
[podsort,rectCenter,stor,nodeArr] = drawLayout();  
nodeArray = double(nodeArr);

str = '#DAD870';
convertcolor = sscanf(str(2:end),'%2x%2x%2x',[1 3])/255;

set(gca,'Color',convertcolor)
set(gca,'SortMethod','childorder'); % keep the Rotate function in right order

% Create agvClass
for i = 1:numberofAGV
%    agvArr(i,1) = agvClass(i,1,0,i); %col,row - x,y
   patchArr(i,1) = patch;
   emptypod(i,1) = patch;
   
end

% All check
agvArr(1,1) = agvClass(16,7,0,1);
agvArr(2,1) = agvClass(19,10,0,2);
agvArr(3,1) = agvClass(90,40,0,3);
agvArr(4,1) = agvClass(1,40,0,4);
agvArr(5,1) = agvClass(8,40,0,5);
agvArr(6,1) = agvClass(7,22,0,6);
agvArr(7,1) = agvClass(32,26,0,7);
agvArr(8,1) = agvClass(8,15,0,8);
% agvArr(9,1) = agvClass(24,16,0,9);
% agvArr(10,1) = agvClass(7,28,0,10);



%% Test case
% Cross case (checked)
% agvArr(1,1) = agvClass(13,14,0,1);
% agvArr(2,1) = agvClass(13,7,0,2);

% Same side cross
% b d h 
% agvArr(1,1) = agvClass(10,13,0,1);
% agvArr(2,1) = agvClass(15,13,0,2);

% Dif side cross
% c g 
% agvArr(1,1) = agvClass(13,18,0,1);
% agvArr(2,1) = agvClass(13,9,0,2);
% f 
% agvArr(1,1) = agvClass(8,10,0,1);
% agvArr(2,1) = agvClass(13,16,0,2);

global agvArray ;
agvArray = agvArr;

% Cross case (checked)
% agvArray(2,1).goalX = 13;
% agvArray(2,1).goalY = 14;
% agvArray(1,1).goalX = 12;
% agvArray(1,1).goalY = 7;

% Same side check
% b d h
% agvArray(2,1).goalX = 13;
% agvArray(2,1).goalY = 20;
% agvArray(1,1).goalX = 13;
% agvArray(1,1).goalY = 20;

% Dif side check
% c g
% agvArray(2,1).goalX = 10;
% agvArray(2,1).goalY = 13;
% agvArray(1,1).goalX = 20;
% agvArray(1,1).goalY = 13;
% f
% agvArray(1,1).goalX = 13;
% agvArray(1,1).goalY = 15;
% agvArray(2,1).goalX = 13;
% agvArray(2,1).goalY = 6;



global patchArray emptyPod;
patchArray = patchArr;
emptyPod = emptypod;
% patchArray(1,1).FaceColor ='r';
% patchArray(2,1).FaceColor ='g';
% patchArray(3,1).FaceColor ='b';
% patchArray(4,1).FaceColor ='c';
% patchArray(5,1).FaceColor ='m';
% patchArray(6,1).FaceColor ='k';
% patchArray(7,1).FaceColor ='w';
% patchArray(8,1).FaceColor =[0.9290 0.6940 0.1250];
% patchArray(9,1).FaceColor =[0.4940 0.1840 0.5560];
% patchArray(10,1).FaceColor =[0.4660 0.6740 0.1880];

agvArray(1,1).colorface ='r';
agvArray(2,1).colorface ='g';
agvArray(3,1).colorface ='b';
agvArray(4,1).colorface ='c';
agvArray(5,1).colorface ='m';
agvArray(6,1).colorface ='k';
agvArray(7,1).colorface ='w';
agvArray(8,1).colorface =[0.9290 0.6940 0.1250];
% agvArray(9,1).colorface =[0.4940 0.1840 0.5560];
% agvArray(10,1).colorface =[0.4660 0.6740 0.1880];



%%
% Create static position for Pods.
podStatic = zeros(size(stor,1),size(stor,2));

for i = 1: size(rectCenter,1)
    temperary = find( nodeArr(:,1)==rectCenter(i,1) & nodeArr(:,2)==rectCenter(i,2) );
    [tem1,tem2] = find(stor == temperary);
    podStatic(tem1,tem2) = 1;
end
 
% AGV params
global agvPosition podStatus agvVel wsStatus wsOrdLine podShow;     % Array of AGV position
agvPosition = zeros(numberofAGV,7); % x,y,angle,type of mission,< coordinate of goal node >,wsMission
wsStatus = [22 40 0 0;45 40 0 0;68 40 0 0;26 1 0 0; 61 1 0 0 ];  % col ,row ,number of AGV in WS
podShow = zeros(numberofAGV,3); % row,col,status

%
%   ^
%  Y| (row)
%   |
%   |- - -> x(col)
% 
%

agvVel = 1000;
wsOrdLine = char(wsOrdLine);
podStatus = zeros(size(rectCenter,1),8); % x of pod ,y of pod,A,B,C,D, isAtStorage? ,isPick ?

% Rotation params
global temp
temp = 0; % for rotation only

global time_window
time_window = [ 0,0,0,0,0,0,0,0,0,0];% start_node , end_node , agvName , time_in , time_out , next node , previous node 



%% Start to generate params
% Generate first order line of 5 WS
operators = [65,68]; % ASCII character A B C D
for i = 1:5
    indexes = randi(operators, 1, 10);
    wsOrdLine(i,:) = char(indexes);          %ws Line of Order
end
    
% Generate  podStatus & random A-B-C-D
c_ = [];
d_ = [];
b_ = transpose(1:1:75);
for i= 1:26
    a_ = i*ones(75,1); % change argument
    c_ = cat(1,c_,a_);
    d_ = cat(1,d_,b_);
end   
podStatus(:,1) = c_;
podStatus(:,2) = d_;
podStatus(:,7) = ones(size(podStatus,1),1);

for i = 1:size(podStatus,1)
   podStatus(i,3)= randi(8,1,1);
   podStatus(i,4)= randi(8,1,1);
   podStatus(i,5)= randi(8,1,1);
   podStatus(i,6)= randi(8,1,1);
end    

% Check empty
% podStatus(2200,5)= 2; % C
% podStatus(2200,6)= 0;  % D
% podStatus(2200,3)= 0;  % A
% podStatus(2200,4)= 0;  % B

% Check demand
% podStatus(50,5)= randi(8,1,1); % C
% podStatus(50,6)= randi(8,1,1);  % D
% podStatus(50,3)= randi(8,1,1);  % A
% podStatus(50,4)= randi(8,1,1);  % B

% Test return Pod
% podStatus(700,7) = 0;
% podStatus(725,7) = 0;
% podStatus(50,7) = 0;
% podStatus(90,7) = 0;
% returnPod(1);

% Add mission => Output AGV mission.
disFlag = distributeMission2();


% agvArray(1,1).beta = 90;

agvArray(1,1).currentMission = 1;
% agvArray(2,1).goalX = 13;
% agvArray(2,1).goalY = 10;
agvArray(2,1).currentMission = 1;


%% Start 
% Find current path
% [rot,direc,goal]=getcurrentPath(1,[1 1],[agvPosition(1,5),agvPosition(1,6)],agvPosition(1,4)); % input agvName, startNode, endNode
% agvArray(1,1) = getcurrentPath(agvArray(1,1),agvArray(1,1).goalX ,agvArray(1,1).goalY);
% rot = agvArray(1,1).rot;
% direc = agvArray(1,1).direc;
% goal = agvArray(1,1).goal;
% goalLine = agvArray(1,1).goalLine;

% agvPosition(1,1) = agvArray(1,1).coordinateX;
% agvPosition(1,2) = agvArray(1,1).coordinateY;
global T;
T = 0;
% disFlag = 0;
% rotFlag = 0;
% rotAngle = 0;
% nextRoad = 1;

while(1)
    if T >= 900
       break; 
    end
    T = T + t_stamp;        
    if mod(int64(T),20) == 0
        refillOrder();
        disFlag =distributeMission2();    
    end
    
%     if astarFlag == 1 || disFlag == 1
%     for i = 1:numberofAGV
%         if agvArray(i,1).findPathFlag ==1     
%             agvArray(i,1) = getcurrentPath(agvArray(i,1),agvArray(i,1).goalX ,agvArray(i,1).goalY);
%             agvArray(i,1).findPathFlag = 0;    
%         end 
%     end    
    
    for i = 1:numberofAGV
        if agvArray(i,1).currentMission~=0
%             if agvArray(i,1).findPathFlag ==1  
%                 agvArray(i,1) = getcurrentPath(agvArray(i,1),agvArray(i,1).goalX ,agvArray(i,1).goalY);
%                 agvArray(i,1).findPathFlag = 0;        
%             end 
              agvArray(i,1) = updateAGV(agvArray(i,1),t_stamp,patchArray(i,1),newaxes);
        end
    end
    drawnow ;
%     pause(0.02);
end    
for i = 1:numberofAGV
    a(1,i) = agvArray(i,1).totalDistance;
end
bar(a);
line([1 size(a,2)], [mean(a) mean(a)],'Color','r','LineWidth',2);
bar(totalgood);





