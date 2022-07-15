function [type,time] = chaseCorruptCheck(NodebY,NodebX,NodedY,NodedX,t_in,t_out,corruptWindow,t)
    % Check if current AGV is going behind any other AGV.
    type = 0;
    time = 0;
    time2turn = 0;
    for i = 1: size(corruptWindow,1)
        if corruptWindow(i,1)~= corruptWindow(i,8) && corruptWindow(i,2)~= corruptWindow(i,9)
            time2turn = 3;
        end
        if t_in >= corruptWindow(i,6) && t_out <= corruptWindow(i,7)+ time2turn
            type = 1;
        end
    end
end