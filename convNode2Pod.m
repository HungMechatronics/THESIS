function [b,a] = convNode2Pod(goalNode)
    % 42x97 
    % input row x col
    global podsort rectCenter stor nodeArray;
    
    x = goalNode(1,1);% row
    y = goalNode(1,2);% col
    c = nodeArray(stor(x,y),1); d = nodeArray(stor(x,y),2);
    e = find(rectCenter(:,1) == c & rectCenter(:,2) == d); 
    [b,a] = find(podsort == e);
     
end 