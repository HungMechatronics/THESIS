function [type,time] = stopCorruptCheck (t_in,corruptWindow)
    type = 0;
    time = 0;    
    for i = 1:size(corruptWindow,1)
        if t_in >= corruptWindow(i,6) && t_in <= corruptWindow(i,7)
           type = 3;
           time = corruptWindow(i,7) - t_in;
           disp('Va cham tai cho');
        end
    end
end