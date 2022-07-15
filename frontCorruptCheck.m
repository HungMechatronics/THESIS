function type = frontCorruptCheck(corruptWindow,t_in,t_out,Y1,X1,Y2,X2,time2turn)
    % kiem tra va cham doi dau
    % Case 1 : front corrupt in straight line
    type = 0;
    for i = 1:size(corruptWindow,1)
       if (t_in >= corruptWindow(i,6) && t_in <= corruptWindow(i,7) && Y2 == corruptWindow(i,1) && X2 == corruptWindow(i,2)) || (t_out >= corruptWindow(i,6) && t_in <= corruptWindow(i,6) && Y1 == corruptWindow(i,3) && X1 == corruptWindow(i,4))
           type = 1;
           disp('Va cham doi dau 1');
       elseif (t_out >= corruptWindow(i,6) && t_out <= corruptWindow(i,7) && Y2 == corruptWindow(i,1) && X2 == corruptWindow(i,2)) || (corruptWindow(i,7) >= t_in && corruptWindow(i,7) <= t_out && Y1 == corruptWindow(i,3) && X1 == corruptWindow(i,4))
           type = 1;
           disp('Va cham doi dau 2');
       end
    end
end