function [distributeFlag] = distributeMission2()
    global agvPosition wsOrdLine wsStatus podStatus agvArray numberofAGV totalgood;
    global lineOfWS1 lineOfWS2 lineOfWS3 lineOfWS4 lineOfWS5;
    % Function
        % This function will give AGV mission of WS.
        % This function should be called every 20s.
    % Type of mission 
        % 0: have non-mission 
        % 1: pick mission. ( current position -> pod -> ws .)
        % 2: repl. mission. ( current position -> pod -> ws .)
        % 3: storage mission. ( ws -> pod.)
                
    % Check if AGV is currently available ?
%         avaiAGV = find(agvPosition(:,4)==0); 
        for i = 1:numberofAGV
            mission(i) = agvArray(i,1).currentMission;
        end
        avaiAGV = find(mission(1,:) == 0);        
        distributeFlag = 0;
        whatMission = randi([1,2],1,1);
    % Distribute WS task with 3 WS of pick ( Checked for correction )
    if whatMission == 1
%% Picking before Reple.
        for i = 1:3
            % Limit number of AGV
            sumWS = 0;
            for countAGV = 1:8
                if agvArray(countAGV,1).wsName == i
                    sumWS = sumWS +1;
                end
            end
            if sumWS >=2
               continue; 
            end
            
%             if(wsStatus(i,4)>2) || (wsStatus(i,3)>2)
            if (wsStatus(i,4) + wsStatus(i,3)) > 3
               continue; 
            end                        
            % Limits AGV enter
            lineOfws = [];
            switch i
                case 1
                        lineOfws = lineOfWS1;
                case 2
                        lineOfws = lineOfWS2;
                case 3
                        lineOfws = lineOfWS3;
            end
            
            if size(lineOfws >=2)
               continue; 
            end
            
            Agoods = find(wsOrdLine(i,:)=='A');
            numAgoods = size(Agoods,2);
            Bgoods = find(wsOrdLine(i,:)=='B');
            numBgoods = size(Bgoods,2);
            Cgoods = find(wsOrdLine(i,:)=='C');
            numCgoods = size(Cgoods,2);
            Dgoods = find(wsOrdLine(i,:)=='D');
            numDgoods = size(Dgoods,2);
            list = [ numAgoods numBgoods numCgoods numDgoods ];
            topgoods = find(list==max(list));


            % Choose 1 max good
            index = randi(length(topgoods),1,1);                        
            minCD =min(podStatus(:,topgoods(index)+2),list(topgoods(index)));
            % find Max min(C,D)
            if max(minCD) == 0
               continue; 
            end            
            argMax = find(minCD == max(max(minCD)));
            
           
%             disp('ArgMax before')
%             disp(argMax);
%             disp('ArgMax size')
%             disp(size(argMax));
%% Extended feature            
%             k = 0;
%             argMaxFilter = [];
%             nearPod = [];
%             for countIsPick = 1:size(argMax,1)
%                 if podStatus(argMax(countIsPick),8) == 0
%                     k = k+1;
%                     argMaxFilter(k) = argMax(countIsPick);
%                 end
%             end
%             
%             if ~isempty(argMaxFilter) == 1
%                 argMax = argMaxFilter;
%             end
% %             disp('ArgMax after')
% %             disp(argMax);
% %             disp('ArgMax size')
% %             disp(size(argMax));
%                                  
%             % find min Distance - advance
%             for count = 1:size(argMax,2)
%                 [pody,podx] = convPod2Node([podStatus(argMax(1,count),1),podStatus(argMax(1,count),2)]);
%                 nearPod(count) = abs(wsStatus(i,1)-podx) + abs(wsStatus(i,2)-pody);
%                 
% %                 disp('Size');
% %                 disp(size(argMax));                
% %                 disp('PodStatus');
% %                 disp(podStatus(argMax(count),1));
% %                 disp('Distance');
% %                 disp(abs(wsStatus(i,2)-podx));
% 
%             end
%             nearestPod = find(nearPod == min(nearPod),1);
%             index2 = nearestPod;
%% End extended feature     
%%
%              disp('index2');disp(index2);
%              disp('ArgMax after');
%              disp(argMax);

            % Random
            index2 = randi(length(argMax),1,1);            
            % get the Pod           
            goalPod_ = argMax(index2);
            if podStatus(goalPod_,8) == 0
                goalPod = [ podStatus(goalPod_,1) podStatus(goalPod_,2)];
                [goalNode(1,2),goalNode(1,1)] = convPod2Node(goalPod);
            else
                continue
            end
            % Find minAGV
            if(isempty(avaiAGV)~=1)               
                for j = 1: size(avaiAGV,2)
                  dist(j) = abs(wsStatus(i,1)-agvArray(j,1).positionX) + abs(wsStatus(i,2)-agvArray(j,1).positionY);
                end 
                minDist = find(dist == min(dist),1);
                goalAGV = avaiAGV(minDist);
                agvArray(goalAGV,1).currentMission = 1; % gain mission 
                agvArray(goalAGV,1).goalX = goalNode(1,1);
                agvArray(goalAGV,1).goalY = goalNode(1,2);
                agvArray(goalAGV,1).wsStaReturnX = wsStatus(i,1);
                agvArray(goalAGV,1).wsStaReturnY = wsStatus(i,2);                
                avaiAGV(minDist)=[];
                dist(minDist) = [];
                switch topgoods(index)
                    case 1
%                         wsOrdLine(i,Agoods) = '_';  
                        agvArray(goalAGV,1).deleteOrdLine = Agoods;
                    case 2
%                         wsOrdLine(i,Bgoods) = '_'; 
                        agvArray(goalAGV,1).deleteOrdLine = Bgoods;
                    case 3 
%                         wsOrdLine(i,Cgoods) = '_'; 
                        agvArray(goalAGV,1).deleteOrdLine = Cgoods;
                    case 4 
%                         wsOrdLine(i,Dgoods) = '_'; 
                        agvArray(goalAGV,1).deleteOrdLine = Dgoods;
                end
                agvArray(goalAGV,1).findPathFlag = 1; 
                agvArray(goalAGV,1).wsName = i; 
                % So luong hang dang nam giu~
                agvArray(goalAGV,1).goodHolding = list(topgoods(index)); 
%                 podStatus(goalPod_,topgoods(index)+2) = podStatus(goalPod_,topgoods(index)+2) - list(topgoods(index));
                podStatus(goalPod_,topgoods(index)+2) = podStatus(goalPod_,topgoods(index)+2) - max(minCD);
                podStatus(goalPod_,8) = 1; 
%                 totalgood = totalgood + list(topgoods(index));
                wsStatus(i,4) = wsStatus(i,4) +1;
                
                % Reorganized the pod
                agvArray(goalAGV,1).Agoods = podStatus(goalPod_,3) ;
                agvArray(goalAGV,1).Bgoods = podStatus(goalPod_,4) ;
                agvArray(goalAGV,1).Cgoods = podStatus(goalPod_,5) ;
                agvArray(goalAGV,1).Dgoods = podStatus(goalPod_,6) ;
                
                % return the thing ( can be deleted )
                podStatus(goalPod_,topgoods(index)+2) = podStatus(goalPod_,topgoods(index)+2) + max(minCD);
                
            end             
        end
        
%% Distribute WS task with 2 WS of reple. ( Checked for correction )
        for i = 4:5
%             if wsStatus(i,4)>2 || wsStatus(i,3)>2 
% Limit number of AGV
            sumWS = 0;
            for countAGV = 1:8
                if agvArray(countAGV,1).wsName == i
                    sumWS = sumWS +1;
                end
            end
            if sumWS >=2
               continue; 
            end

            if (wsStatus(i,4) + wsStatus(i,3)) > 3
               continue 
            end
            % Limits AGV enter
            lineOfws = [];
            switch i
                case 4
                        lineOfws = lineOfWS4;
                case 5
                        lineOfws = lineOfWS5;
            end
            
            if size(lineOfws >=2)
               continue; 
            end
            sum(:,1)=podStatus(:,3)+podStatus(:,4)+podStatus(:,5)+podStatus(:,6);
            leastPod = find(sum==min(min(sum)));
            
%% Extended feature for Replenishment         
%             k2 = 0;
%             argMaxFilter2 = [];
%             nearPod2 = [];
%             for countIsPick = 1:size(leastPod,1)
%                 if podStatus(leastPod(countIsPick),8) == 0
%                     k2 = k2+1;
%                     argMaxFilter2(k2) = leastPod(countIsPick);
%                 end
%             end
%             
%             if ~isempty(argMaxFilter2) == 1
%                 leastPod = argMaxFilter2;
%             end
% 
%                                  
%             % find min Distance - advance
%             for count2 = 1:size(leastPod,2)
%                 [pody2,podx2] = convPod2Node([podStatus(leastPod(1,count2),1),podStatus(leastPod(1,count2),2)]);
%                 nearPod2(count2) = abs(wsStatus(i,2)-pody2) + abs(wsStatus(i,1)-podx2);    
% %                 disp('podx2');
% %                 disp(podx2);
%             end
%             nearestPod2 = find(nearPod2 == min(nearPod2),1);
%             index3 = nearestPod2;
%% End extended feature  
%%                                    
            index3 = randi(length(leastPod),1,1);   % random the pods if equal
            leastPod_ = leastPod(index3);           % choose the target pod
            if podStatus(leastPod_,8) == 0
                targetPod = [podStatus(leastPod_,1) podStatus(leastPod_,2)];  % coordinate of the pod (r,c) < (27,76)
                [targetNode(1,2),targetNode(1,1)] = convPod2Node(targetPod);  % convert to Node coordinate
                % Fix later
            else
                continue;
            end            
            
            if 40 - sum(leastPod_,1) >=10 
                range = 10;
            else
                range = 40 - sum(leastPod_,1);
            end
            % Take out the number of each goods in reple. line
                Agoods2 = find(wsOrdLine(i,1:range)=='A');
                    numAgoods2 = size(Agoods2,2);
                Bgoods2 = find(wsOrdLine(i,1:range)=='B');
                    numBgoods2 = size(Bgoods2,2);
                Cgoods2 = find(wsOrdLine(i,1:range)=='C');
                    numCgoods2 = size(Cgoods2,2);
                Dgoods2 = find(wsOrdLine(i,1:range)=='D');
                    numDgoods2 = size(Dgoods2,2);
            % Gain mission to AGV
            if(isempty(avaiAGV)~=1)
                for j = 1: size(avaiAGV,1)
                  dist2(j) = abs(wsStatus(i,1)-agvArray(j,1).positionX) + abs(wsStatus(i,2)-agvArray(j,1).positionY);
%                   dist2(j) = abs(wsStatus(i,2)-agvPosition(avaiAGV(j),1)) + abs(wsStatus(i,1)-agvPosition(avaiAGV(j),2));
                end 
                minDist2 = find(dist2 == min(dist2),1);
                goalAGV2 = avaiAGV(minDist2);
                agvArray(goalAGV2,1).currentMission = 1; % gain mission 
                agvArray(goalAGV2,1).goalX = targetNode(1,1);
                agvArray(goalAGV2,1).goalY = targetNode(1,2);
                agvArray(goalAGV2,1).wsStaReturnX = wsStatus(i,1);
                agvArray(goalAGV2,1).wsStaReturnY = wsStatus(i,2);   
                avaiAGV(minDist2)=[];
                dist2(minDist2) = [];
%                 wsOrdLine(i,1:range) = '_'; 
                agvArray(goalAGV2,1).deleteOrdLine = [1:range];                
                agvArray(goalAGV2,1).findPathFlag = 1; 
                agvArray(goalAGV2,1).wsName = i; 
                agvArray(goalAGV2,1).goodHolding = numAgoods2 + numBgoods2 + numCgoods2 + numDgoods2;
                % fill in the pod
                podStatus(leastPod_,3) = podStatus(leastPod_,3) + numAgoods2;
                podStatus(leastPod_,4) = podStatus(leastPod_,4) + numBgoods2;
                podStatus(leastPod_,5) = podStatus(leastPod_,5) + numCgoods2;
                podStatus(leastPod_,6) = podStatus(leastPod_,6) + numDgoods2;
                % current pod is being taken
                podStatus(leastPod_,8) = 1;
%                 totalgood = totalgood + numAgoods2 + numBgoods2 + numCgoods2 + numDgoods2;
                wsStatus(i,4) = wsStatus(i,4) +1;
                
                % Reorganized the pod
                agvArray(goalAGV2,1).Agoods = podStatus(leastPod_,3) ;
                agvArray(goalAGV2,1).Bgoods = podStatus(leastPod_,4) ;
                agvArray(goalAGV2,1).Cgoods = podStatus(leastPod_,5) ;
                agvArray(goalAGV2,1).Dgoods = podStatus(leastPod_,6) ;
                                                
            end  
        end   

    else
%% Reple. before Picking        
        for i = 4:5
%             if wsStatus(i,4)>2 || wsStatus(i,3)>2 
% Limit number of AGV
            sumWS = 0;
            for countAGV = 1:8
                if agvArray(countAGV,1).wsName == i
                    sumWS = sumWS +1;
                end
            end
            if sumWS >=2
               continue; 
            end
            
            if (wsStatus(i,4) + wsStatus(i,3)) > 3
               continue 
            end
            % Limits AGV enter
            lineOfws = [];
            switch i
                case 4
                        lineOfws = lineOfWS4;
                case 5
                        lineOfws = lineOfWS5;
            end
            
            if size(lineOfws >=2)
               continue; 
            end
            
            
            sum(:,1)=podStatus(:,3)+podStatus(:,4)+podStatus(:,5)+podStatus(:,6);
            leastPod = find(sum==min(sum));
            
%% Extended feature for Replenishment         
%             k2 = 0;
%             argMaxFilter2 = [];
%             nearPod2 = [];
%             for countIsPick = 1:size(leastPod,1)
%                 if podStatus(leastPod(countIsPick),8) == 0
%                     k2 = k2+1;
%                     argMaxFilter2(k2) = leastPod(countIsPick);
%                 end
%             end
%             
%             if ~isempty(argMaxFilter2) == 1
%                 leastPod = argMaxFilter2;
%             end
%                                  
%             % find min Distance - advance
%             for count2 = 1:size(leastPod,2)
%                 [pody2,podx2] = convPod2Node([podStatus(leastPod(1,count2),1),podStatus(leastPod(1,count2),2)]);
%                 nearPod2(count2) = abs(wsStatus(i,2)-pody2) + abs(wsStatus(i,1)-podx2);              
% %                 disp('podx2');
% %                 disp(podx2);
%             end
%             nearestPod2 = find(nearPod2 == min(nearPod2),1);
%             index3 = nearestPod2;
% %             
%% End extended feature 
                                    
            index3 = randi(length(leastPod),1,1);   % random the pods if equal
            leastPod_ = leastPod(index3);           % choose the target pod
            if podStatus(leastPod_,8) == 0
                targetPod = [podStatus(leastPod_,1) podStatus(leastPod_,2)];  % coordinate of the pod (r,c) < (27,76)
                [targetNode(1,2),targetNode(1,1)] = convPod2Node(targetPod);  % convert to Node coordinate 
            else
                continue;
            end
            
            if 40 - sum(leastPod_,1) >=10 
                range = 10;
            else
                range = 40 - sum(leastPod_,1);
            end
            % Take out the number of each goods in reple. line
                Agoods2 = find(wsOrdLine(i,1:range)=='A');
                    numAgoods2 = size(Agoods2,2);
                Bgoods2 = find(wsOrdLine(i,1:range)=='B');
                    numBgoods2 = size(Bgoods2,2);
                Cgoods2 = find(wsOrdLine(i,1:range)=='C');
                    numCgoods2 = size(Cgoods2,2);
                Dgoods2 = find(wsOrdLine(i,1:range)=='D');
                    numDgoods2 = size(Dgoods2,2);
            % Gain mission to AGV
            if(isempty(avaiAGV)~=1)
                for j = 1: size(avaiAGV,1)
                  dist2(j) = abs(wsStatus(i,1)-agvArray(j,1).positionX) + abs(wsStatus(i,2)-agvArray(j,1).positionY);
%                   dist2(j) = abs(wsStatus(i,2)-agvPosition(avaiAGV(j),1)) + abs(wsStatus(i,1)-agvPosition(avaiAGV(j),2));
                end 
                minDist2 = find(dist2 == min(dist2),1);
                goalAGV2 = avaiAGV(minDist2);
                agvArray(goalAGV2,1).currentMission = 1; % gain mission 
                agvArray(goalAGV2,1).goalX = targetNode(1,1);
                agvArray(goalAGV2,1).goalY = targetNode(1,2);
                agvArray(goalAGV2,1).wsStaReturnX = wsStatus(i,1);
                agvArray(goalAGV2,1).wsStaReturnY = wsStatus(i,2);   
                avaiAGV(minDist2)=[];
                dist2(minDist2) = [];
%                 wsOrdLine(i,1:range) = '_'; 
                agvArray(goalAGV2,1).deleteOrdLine = [1:range];  
                agvArray(goalAGV2,1).findPathFlag = 1; 
                agvArray(goalAGV2,1).wsName = i; 
                agvArray(goalAGV2,1).goodHolding = numAgoods2 + numBgoods2 + numCgoods2 + numDgoods2;
                % fill in the pod
                podStatus(leastPod_,3) = podStatus(leastPod_,3) + numAgoods2;
                podStatus(leastPod_,4) = podStatus(leastPod_,4) + numBgoods2;
                podStatus(leastPod_,5) = podStatus(leastPod_,5) + numCgoods2;
                podStatus(leastPod_,6) = podStatus(leastPod_,6) + numDgoods2;
                % current pod is being taken
                podStatus(leastPod_,8) = 1;
%                 totalgood = totalgood + numAgoods2 + numBgoods2 + numCgoods2 + numDgoods2;
                wsStatus(i,4) = wsStatus(i,4) +1;
                
                % Reorganized the pod
                agvArray(goalAGV2,1).Agoods = podStatus(leastPod_,3) ;
                agvArray(goalAGV2,1).Bgoods = podStatus(leastPod_,4) ;
                agvArray(goalAGV2,1).Cgoods = podStatus(leastPod_,5) ;
                agvArray(goalAGV2,1).Dgoods = podStatus(leastPod_,6) ;
            end  
        end 
        
        for i = 1:3
%             if(wsStatus(i,4)>2) || wsStatus(i,3)>2
% Limit number of AGV
            sumWS = 0;
            for countAGV = 1:8
                if agvArray(countAGV,1).wsName == i
                    sumWS = sumWS +1;
                end
            end
            if sumWS >=2
               continue; 
            end
            
            if (wsStatus(i,4) + wsStatus(i,3)) > 3
               continue; 
            end
            
            lineOfws = [];
            switch i
                case 1
                        lineOfws = lineOfWS1;
                case 2
                        lineOfws = lineOfWS2;
                case 3
                        lineOfws = lineOfWS3;
            end
            
            if size(lineOfws >=2)
               continue; 
            end
                        
           
            Agoods = find(wsOrdLine(i,:)=='A');
            numAgoods = size(Agoods,2);
            Bgoods = find(wsOrdLine(i,:)=='B');
            numBgoods = size(Bgoods,2);
            Cgoods = find(wsOrdLine(i,:)=='C');
            numCgoods = size(Cgoods,2);
            Dgoods = find(wsOrdLine(i,:)=='D');
            numDgoods = size(Dgoods,2);
            list = [ numAgoods numBgoods numCgoods numDgoods ];
            topgoods = find(list==max(list));
            index = randi(length(topgoods),1,1);            
            minCD =min(podStatus(:,topgoods(index)+2),list(topgoods(index)));            
            if max(minCD) == 0
               continue; 
            end      
            
            argMax = find(minCD == max(max(minCD)));
            

%% Extended feature Picking     
%             k = 0;
%             argMaxFilter = [];
%             nearPod = [];
%             for countIsPick = 1:size(argMax,1)
%                 if podStatus(argMax(countIsPick),8) == 0
%                     k = k+1;
%                     argMaxFilter(k) = argMax(countIsPick);
%                 end
%             end
%             
%             if ~isempty(argMaxFilter) == 1                
%                 argMax = argMaxFilter;
%             end
% %             disp('ArgMax after')
% %             disp(argMax);
% %             disp('ArgMax size')
% %             disp(size(argMax));
%             
%             
%             % find min Distance 
%             for count = 1:size(argMax,2)
%                 [pody,podx] = convPod2Node([podStatus(argMax(1,count),1),podStatus(argMax(1,count),2)]);
%                 nearPod(count) = abs(wsStatus(i,1)-podx) + abs(wsStatus(i,2)-pody);
%             end
%             nearestPod = find(nearPod == min(nearPod),1);
%             index2 = nearestPod;
%% End extended feature  
%%

            % Random
            index2 = randi(length(argMax),1,1);
            
            % get the Pod
            goalPod_ = argMax(index2);
            if podStatus(goalPod_,8) == 0
                goalPod = [ podStatus(goalPod_,1) podStatus(goalPod_,2)];
                [goalNode(1,2),goalNode(1,1)] = convPod2Node(goalPod);
            else
                continue;
            end

            % Find minAGV
            if(isempty(avaiAGV)~=1)
                for j = 1: size(avaiAGV,2)
                  dist(j) = abs(wsStatus(i,1)-agvArray(j,1).positionX) + abs(wsStatus(i,2)-agvArray(j,1).positionY);
                end 
                minDist = find(dist == min(dist),1);
                goalAGV = avaiAGV(minDist);
                agvArray(goalAGV,1).currentMission = 1; % gain mission 
                agvArray(goalAGV,1).goalX = goalNode(1,1);
                agvArray(goalAGV,1).goalY = goalNode(1,2);
                agvArray(goalAGV,1).wsStaReturnX = wsStatus(i,1);
                agvArray(goalAGV,1).wsStaReturnY = wsStatus(i,2);                
                avaiAGV(minDist)=[];
                dist(minDist) = [];
                switch topgoods(index)
                    case 1
%                         wsOrdLine(i,Agoods) = '_';  
                        agvArray(goalAGV,1).deleteOrdLine = Agoods;
                    case 2
%                         wsOrdLine(i,Bgoods) = '_'; 
                        agvArray(goalAGV,1).deleteOrdLine = Bgoods;
                    case 3 
%                         wsOrdLine(i,Cgoods) = '_'; 
                        agvArray(goalAGV,1).deleteOrdLine = Cgoods;
                    case 4 
%                         wsOrdLine(i,Dgoods) = '_'; 
                        agvArray(goalAGV,1).deleteOrdLine = Dgoods;
                end
                agvArray(goalAGV,1).findPathFlag = 1; 
                agvArray(goalAGV,1).wsName = i; 
                agvArray(goalAGV,1).goodHolding = list(topgoods(index)); 
%                 podStatus(goalPod_,topgoods(index)+2) = podStatus(goalPod_,topgoods(index)+2) - list(topgoods(index));
                podStatus(goalPod_,topgoods(index)+2) = podStatus(goalPod_,topgoods(index)+2) - max(minCD);
                podStatus(goalPod_,8) = 1; 
%                 totalgood = totalgood + list(topgoods(index));
                wsStatus(i,4) = wsStatus(i,4) +1;
                
                % Reorganized the pod
                agvArray(goalAGV,1).Agoods = podStatus(goalPod_,3) ;
                agvArray(goalAGV,1).Bgoods = podStatus(goalPod_,4) ;
                agvArray(goalAGV,1).Cgoods = podStatus(goalPod_,5) ;
                agvArray(goalAGV,1).Dgoods = podStatus(goalPod_,6) ;
                
                % return the thing ( can be deleted )
                podStatus(goalPod_,topgoods(index)+2) = podStatus(goalPod_,topgoods(index)+2) + max(minCD);                
            end             
        end                               
    end
end