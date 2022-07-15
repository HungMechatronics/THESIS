function [type,time] = crossCorruptCheck(NodeaY,NodeaX,NodebY,NodebX,NodedY,NodedX,t_in,t_out,corruptWindow,time2turn3)
    % Giai quyet va cham giao lo
    % Node a : past node , b : current Node , c : next node 
    % Case 1 : Va cham nguoc chieu
    % NodeD : nodeD la Current +i/j
    % NodeB : nodeB la Current
    global time_window;
    type = 0;
    time = 0;
    % Nhuong cho AGV co duong di quyen uu tien
    time2turn = 0;
    for i = 1:size(corruptWindow,1)
    nextRoad = find(time_window(:,1)==corruptWindow(i,3) & time_window(:,2)==corruptWindow(i,4) & time_window(:,3)== corruptWindow(i,8) & time_window(:,4)== corruptWindow(i,9) & time_window(:,5)== corruptWindow(i,5),1);
    timeOutprior = time_window(nextRoad,7);
%     if ~isempty(timeOutprior)==1
%         disp(timeOutprior);
%     end

    % Neu den dich thi set 1 vi khong tim duoc time
%     if corruptWindow(i,8) == corruptWindow(i,3) && corruptWindow(i,9) == corruptWindow(i,4)
%         % Neu AGV1 den dich
%         type = 1;
%         disp('Diem cuoi cung');
%         return;
%     end

    if corruptWindow(i,1)~= corruptWindow(i,8) && corruptWindow(i,2)~= corruptWindow(i,9)
        time2turn = 3;
    end
    % Truong hop di dau (+)
    if (corruptWindow(i,1) ~= NodedY || corruptWindow(i,2) ~= NodedX) && (NodeaY ~= corruptWindow(i,8) || NodeaX ~= corruptWindow(i,9))
        % d ~= a && a ~= d   
%% Case khac huong   
%         if (NodedY~= corruptWindow(i,8) || NodedX~= corruptWindow(i,9))  % d1 ~= d2            
%             disp('Khac huong')
            
        if NodedY == corruptWindow(i,3) && NodedX == corruptWindow(i,4) && ( NodebY ~= corruptWindow(i,1) || NodebX ~= corruptWindow(i,2))
            % Khac huong sau va cham 
%             if corruptWindow(i,8) == corruptWindow(i,3) && corruptWindow(i,9) == corruptWindow(i,4)
%                 % Neu AGV1 den dich
%                 type = 1;
%                 disp('Diem cuoi cung');
%                 return;
%             end
            if (t_in<=  corruptWindow(i,6) && corruptWindow(i,6)<= t_out) 
                % Neu AGV1 den sau
                type = 3;  
                time = corruptWindow(i,7) - t_in;
                
            elseif (corruptWindow(i,6) <= t_in) && (t_in<= corruptWindow(i,7))         
                % Neu AGV2 den sau
                type = 3; % slow down 
                time = corruptWindow(i,7) - t_in;
            end
            
%% Case cung huong            
        elseif NodedY == corruptWindow(i,1) && NodedX == corruptWindow(i,2) &&( NodebY ~= corruptWindow(i,3) ||  NodebX ~= corruptWindow(i,4))
            % d = d  
%            disp('Cung huong');
%            if corruptWindow(i,8) == corruptWindow(i,3) && corruptWindow(i,9) == corruptWindow(i,4)
%                % Neu la diem cuoi cung : b = d
%                type = 1;               
%                disp('Diem cuoi cung');
%                return;
%            end                 
               
            % Cung huong sau va cham
%             if (corruptWindow(i,7) <= t_in) && (t_in<= corruptWindow(i,7) + 1.5+ time2turn) || (t_in <= corruptWindow(i,7) && corruptWindow(i,7)<= t_in +1.5+time2turn)           
            if (t_in <= corruptWindow(i,6)) && (corruptWindow(i,6) <= t_out)
                % Neu AGV khong uu tien vao sau => wait                  
                type = 3; % slow down 
                time = corruptWindow(i,7) - t_in  ;
                  
            elseif ( corruptWindow(i,6) <= t_in && t_in <= corruptWindow(i,7))               
               % Neu AGV uu tien vao sau
                type = 3; % slow down 
                time = corruptWindow(i,7) - t_in  ;
            end
        end
%% Case va cham kieu f        
%     else
%         if corruptWindow(i,8) == corruptWindow(i,3) && corruptWindow(i,9) == corruptWindow(i,4)
%            % Neu la diem cuoi cung : b = d
%            type = 1;               
%            disp('Diem cuoi cung');
%            return;
%         end  
%         if NodeaY == corruptWindow(i,8) && NodeaX == corruptWindow(i,9) &&  corruptWindow(i,1) == NodedY && corruptWindow(i,2) == NodedX
%            % Truong hop 2 thg doi duong voi nhau
%             if( corruptWindow(i,7) <= t_in && t_in <= timeOutprior) || (t_in <= corruptWindow(i,7) && corruptWindow(i,7) <=t_out)
%                 % AGV uu tien vao truoc khi AGV sau ra khoi va cham
%                 type = 1;
%                 return;
%             end               
%         end
%         if NodeaY == corruptWindow(i,8) && NodeaX == corruptWindow(i,9) && ( corruptWindow(i,1) ~= NodedY || corruptWindow(i,2) ~= NodedX) 
%             % case a2 = d1 va a1 ~= d2  => AGV uu tien re~ vao huong AGV
%             % khong uu tien
%             if( corruptWindow(i,7) <= t_in && t_in <= timeOutprior) || (t_in <= corruptWindow(i,7) && corruptWindow(i,7) <=t_out)
%                 % AGV uu tien vao truoc khi AGV sau ra khoi va cham
%                 type = 1;
%             end
%         elseif NodedY == corruptWindow(i,1) && NodedX == corruptWindow(i,2) && ( corruptWindow(i,8) ~= NodeaY || corruptWindow(i,9) ~= NodeaX)            
%             disp('Va cham kieu f');
%             % Case a1 = d2 va a2~= d1 => AGV khong uu tien re~ vao
%             if( corruptWindow(i,7) <= t_in && t_in <= timeOutprior) || (t_in <= corruptWindow(i,7) && corruptWindow(i,7) <=t_out)
%                if t_out-corruptWindow(i,7)>= time2turn3
%                    % Neu AGV uu tien da gan toi
%                    type = 3; % slow down 
%                    time = timeOutprior - t_in + (corruptWindow(i,7) -corruptWindow(i,6)); 
%                    disp('AGV uu tien vao sau nhanh');
%                else
%                    % Neu AGV uu tien con xa khong cho duoc
%                    type =1;
%                    disp('AGV uu tien vao sau lau');
%                end
%             end
%         end
%     end        
    end
end