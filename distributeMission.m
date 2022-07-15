function [distributeFlag] = distributeMission()
    global agvPosition wsOrdLine wsStatus podStatus ;
    % Function
        % This function will give AGV mission of WS.
        % This function should be called every 20s.
    % Type of mission 
        % 0: have non-mission 
        % 1: pick mission. ( current position -> pod -> ws .)
        % 2: repl. mission. ( current position -> pod -> ws .)
        % 3: storage mission. ( ws -> pod.)
                
    % Check if AGV is currently available ?
        avaiAGV = find(agvPosition(:,4)==0);                
        distributeFlag = 0;
    % Distribute WS task with 3 WS of pick ( Checked for correction )
        for i = 1:3
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
            argMax = find(minCD == max(minCD));
            index2 = randi(length(argMax),1,1);
            
            % get the Pod
            goalPod_ = argMax(index2);
            goalPod = [ podStatus(goalPod_,1) podStatus(goalPod_,2)];
            [goalNode(1,2),goalNode(1,1)] = convPod2Node(goalPod);
            
            % Find minAGV
            if(isempty(avaiAGV)~=1)
                for j = 1: size(avaiAGV,1)
                  dist(j) = abs(wsStatus(i,1)-agvPosition(avaiAGV(j),1)) + abs(wsStatus(i,2)-agvPosition(avaiAGV(j),2));
                end 
                goalAGV = find(dist == min(dist),1);
                agvPosition(avaiAGV(goalAGV),4) = 1; % gain mission 
                agvPosition(avaiAGV(goalAGV),5) = goalNode(1,1);
                agvPosition(avaiAGV(goalAGV),6) = goalNode(1,2);
                agvPosition(avaiAGV(goalAGV),7) = i;
                avaiAGV(goalAGV)=[];
                switch topgoods(index)
                    case 1
                        wsOrdLine(i,Agoods) = '_';                    
                    case 2
                        wsOrdLine(i,Bgoods) = '_'; 
                    case 3 
                        wsOrdLine(i,Cgoods) = '_'; 
                    case 4 
                        wsOrdLine(i,Dgoods) = '_'; 
                end
                distributeFlag = 1;
            end             
            podStatus(goalPod_,topgoods(index)+2) = podStatus(goalPod_,topgoods(index)+2) - list(topgoods(index));
            
        end
        
    % Distribute WS task with 2 WS of reple. ( Checked for correction )
        for i = 4:5
            sum(:,1)=podStatus(:,3)+podStatus(:,4)+podStatus(:,5)+podStatus(:,6);
            leastPod = find(sum==min(sum));
            index3 = randi(length(leastPod),1,1);
            leastPod_ = leastPod(index3);
            targetPod = [podStatus(leastPod_,1) podStatus(leastPod_,2)];
            [targetNode(1,2),targetNode(1,1)] = convPod2Node(targetPod);
            
            if(isempty(avaiAGV)~=1)
                for j = 1: size(avaiAGV,1)
                  dist2(j) = abs(wsStatus(i,1)-agvPosition(avaiAGV(j),1)) + abs(wsStatus(i,2)-agvPosition(avaiAGV(j),2));
                end 
                goalAGV = find(dist2 == min(dist2),1);
                agvPosition(avaiAGV(goalAGV),4) = 2; % gain mission 
                agvPosition(avaiAGV(goalAGV),5) = targetNode(1,1);
                agvPosition(avaiAGV(goalAGV),6) = targetNode(1,2);
                avaiAGV(goalAGV)=[];
            end  
        end       
end