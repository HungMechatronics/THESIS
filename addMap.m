function MAP = addMap(mapType,length,width)
% length : horizontal -  width : vertical
% 1: Static map , 2: wsMAP , 3:goalMAP, 4: dynMAP(agvMAP)
MAP=int8(zeros(width,length)); % MAP(Y,X)
   if mapType == 1       
        % Add pods
        for i = 0:11
            for j = 0 :12
            x = 4+3*i;
            y = 4+7*j;
            MAP(x:x+1,y:y+5)=1;
            end
        end
        
   elseif mapType == 2
        % Add workstations 
        MAP(10,1) = 1;
        MAP(22,1) = 2;
        MAP(34,1) = 3;
   elseif mapType == 3
       % goalMap        
   elseif mapType == 4
       % agvMAP
       MAP(1,5) = 1;
       MAP(1,6) = 2;
       MAP(1,7) = 3;
   end
end