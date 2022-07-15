function refillOrder()

    % This function runs every 20 seconds.
    global wsOrdLine
    wsOrdLine = char(wsOrdLine);
    operators = [65,68]; % ASCII character A B C D
    
% Generate first order line of 5 WS
%     for i = 1:5
%         indexes = randi(operators, 1, 10);
%         wsOrdLine(i,:) = char(indexes);
%     end

% Eliminate the goods in WS distributeMission
%     for i = 1:5
%         storage = find(wsOrdLine(i,:) ~= 'A');
%         wsOrdLine(i,storage) ='_';
%     end
    
% Random storage and dumming into WS - runs every 60s
    for i = 1:5
        a = find(wsOrdLine(i,:) == '_');
        wsOrdLine(i,a) = char(randi(operators,1,size(a,2)));
    end
    
    
end