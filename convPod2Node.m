function [b,a]=convPod2Node(goalPod)
    % 28x80
    global podsort rectCenter stor nodeArray;
    
    x = goalPod(1,1); % row
    y = goalPod(1,2); % col
    c = rectCenter(podsort(x,y),1); d = rectCenter(podsort(x,y),2);
    e = find(nodeArray(:,1) == c & nodeArray(:,2) == d); 
    [b,a] = find(stor == e);
     
end 