function returnPod(agvName)
    % do the Mission 3, return to the nearesrt empty slot.
   
    global podStatus nodeArray stor agvPosition; 
    emptyPosi = find(podStatus(:,7) == 0 );
    x = agvPosition(agvName,1);
    y = agvPosition(agvName,2);
    for i = 1: size(emptyPosi,1)
       pod = emptyPosi(i);
       podx = podStatus(pod,1);
       pody = podStatus(pod,2);
%        disp(podx);disp(pody);
       [pody,podx] = convPod2Node([podx pody]);% currently is node position
%        disp(podx);disp(pody);
       finalPod = stor(pody,podx);
       minDist(i) = abs(nodeArray(finalPod,1)-x) + abs(nodeArray(finalPod,1)-y);
       minPod(i,:) = [podx pody];
    end
    a = find(minDist==min(minDist),1); 
%     disp(a);
    agvPosition(agvName,5) = minPod(a,1);
    agvPosition(agvName,6) = minPod(a,2);
end