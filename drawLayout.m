function [podsort,rectCenter,stor,nodeArr] = drawLayout()
% line (x : horizontal , y: vertical )
clear
clc
l = 100000+8000; w = 48150+7000 ; % chieu dai , w chieu ron kho
ws_l = 4000 ;ws_w = 2000; % chieu dai , rong ws
lw = 1800 ; % be rong loi di
fp = 2500;
fp_y =ws_w+lw/2 ;
pw = 1000 ;
v_ais =15; h_ais=13; % so luong loi di
line_weight = 0.1;
axis([-1000 l+1000 -1000 w+1000]);

global verLine horLine;

%% Draw warehouse boundary & layout 
% draw horizonal 
line([1 l],[1 1],'color','k','LineWidth',2);
line([1 l],[w w],'color','k','LineWidth',2);
% Draw door and vertical
line([1 1],[1 (w/2-2500)],'color','k','LineWidth',2);
line([1 1],[(w/2+2500) w],'color','k','LineWidth',2);
line([l l],[1 w],'color','k','LineWidth',2);

% Entrance line
line( [0 fp], [w/2 w/2],'color','r','LineWidth',line_weight);
% Boundary of layout
line( [fp fp], [ws_w+lw/2 fp_y+(lw+2*pw)*h_ais],'color','b','LineWidth',line_weight); % left bound
line( [fp fp+v_ais*(lw+5*pw)],[ws_w+lw/2 ws_w+lw/2],'color','b','LineWidth',line_weight); % bot bound


%% Workstation properties
% Below
% old_length = 105000
step = (105000)/3; 
for i = 0:1
    a = step*(i+1)+(ws_l+200)*i-400;
    str = '#AD82D9';
    convertcolor = sscanf(str(2:end),'%2x%2x%2x',[1 3])/255;
    rectangle('Position',[a 0 ws_l ws_w],'FaceColor',convertcolor);
    line([ 4.5*lw+20.5*pw+fp+(5.5*lw+29.5*pw)*i  4.5*lw+20.5*pw+fp+(5.5*lw+29.5*pw)*i ],   [lw/2 fp_y],'color','b','LineWidth',line_weight);
    line([4.5*lw+20.5*pw+fp+(5.5*lw+29.5*pw)*i  4.5*lw+20.5*pw+fp+(6*lw+29*pw)*i+2*pw ],         [lw/2 lw/2],'color','b','LineWidth',line_weight);
    line( [4.5*lw+20.5*pw+fp+(6*lw+29*pw)*i+2*pw 4.5*lw+20.5*pw+fp+(6*lw+29*pw)*i+2*pw],         [lw/2 ws_w+lw/2],'color','b','LineWidth',line_weight);       
    nodeWS(i*2+1,:) = [4.5*lw+20.5*pw+fp+(5.5*lw+29.5*pw)*i , lw/2 ];
    nodeWS(i*2+2,:) = [4.5*lw+20.5*pw+fp+(6*lw+29*pw)*i+2*pw  , lw/2 ];
end  

% Upper 
step = (l-4500)/4;
%   line( [fp+3.5*lw+17.5*pw+(4*lw+19*pw)*2 , fp+3.5*lw+17.5*pw+(4*lw+19*pw)*2],  [w-lw/2 fp_y+(lw+2*pw)*h_ais],'color','r','LineWidth',1);
%   line( [fp+3.5*lw+17.5*pw+(4*lw+19*pw)*2 , fp+3.5*lw+17.5*pw+(4*lw+19*pw)*2+2*pw],     [w-lw/2 w-lw/2],'color','r','LineWidth',1);
%   line( [fp+3.5*lw+17.5*pw+(4*lw+19*pw)*2+2*pw , fp+3.5*lw+17.5*pw+(4*lw+19*pw)*2+2*pw],         [w-lw/2 fp_y+(lw+2*pw)*h_ais],'color','r','LineWidth',line_weight);
%   d = fp_y+(lw+2*pw)*h_ais
for i = 0:2     
    a = step*(i+1)+ws_l;
    str2 = '#FDCF76';
    convertcolor2 = sscanf(str2(2:end),'%2x%2x%2x',[1 3])/255;
    rectangle('Position',[a w-ws_w ws_l ws_w],'FaceColor',convertcolor2);
    line( [fp+3.5*lw+17.5*pw+(4*lw+19*pw)*i fp+3.5*lw+17.5*pw+(4*lw+19*pw)*i],  [w-lw/2 fp_y+(lw+2*pw)*h_ais],'color','b','LineWidth',line_weight);
    line( [fp+3.5*lw+17.5*pw+(4*lw+19*pw)*i fp+3.5*lw+17.5*pw+(4*lw+19*pw)*i+2*pw],     [w-lw/2 w-lw/2],'color','b','LineWidth',line_weight);
    line( [fp+3.5*lw+17.5*pw+(4*lw+19*pw)*i+2*pw , fp+3.5*lw+17.5*pw+(4*lw+19*pw)*i+2*pw],         [w-lw/2 fp_y+(lw+2*pw)*h_ais],'color','b','LineWidth',line_weight);
    nodeWS(i*2+1+4,:) = [fp+3.5*lw+17.5*pw+(4*lw+19*pw)*i , w-lw/2];
    nodeWS(i*2+2+4,:) = [fp+3.5*lw+17.5*pw+(4*lw+19*pw)*i+2*pw , w-lw/2 ];
end


%% Grid problem solving
% Vertical line 
verArr(1,:) = [fp ws_w+lw/2];
verArr(2,:) = [fp fp_y+(lw+2*pw)*h_ais];

for i = 1:v_ais
%       fp_y +(lw+2*pw)*(j)
%       line( [fp+i*(lw+5*pw) fp+i*(lw+5*pw)], [ws_w+lw/2 w-(ws_w+lw/2)],'color','b','LineWidth',line_weight);
      line( [fp+i*(lw+5*pw) fp+i*(lw+5*pw)], [ws_w+lw/2 fp_y+(lw+2*pw)*h_ais],'color','b','LineWidth',line_weight);
      if(mod(i,2)==0)
      verArr(i*2+1,:) = [fp+i*(lw+5*pw) ws_w+lw/2]  ;
      verArr(i*2+2,:) = [fp+i*(lw+5*pw) fp_y+(lw+2*pw)*h_ais] ;     
      else
      verArr(i*2+2,:) = [fp+i*(lw+5*pw) ws_w+lw/2]  ;
      verArr(i*2+1,:) = [fp+i*(lw+5*pw) fp_y+(lw+2*pw)*h_ais] ;             
      end
end

% Horizontal line aisle
horArr(1,:) = [fp ws_w+lw/2];
horArr(2,:) = [fp+v_ais*(lw+5*pw) ws_w+lw/2];
for i = 1:h_ais
    line( [fp fp+v_ais*(lw+5*pw)],[ws_w+lw/2+i*(lw+2*pw) ws_w+lw/2+i*(lw+2*pw)],'color','b','LineWidth',line_weight);
    if(mod(i,2)==0)
    horArr(i*2+1,:) = [fp ws_w+lw/2+i*(lw+2*pw)]  ;
    horArr(i*2+2,:) = [fp+v_ais*(lw+5*pw) ws_w+lw/2+i*(lw+2*pw)] ;  
    else
    horArr(i*2+2,:) = [fp ws_w+lw/2+i*(lw+2*pw)]  ;
    horArr(i*2+1,:) = [fp+v_ais*(lw+5*pw) ws_w+lw/2+i*(lw+2*pw)] ;         
    end
end
    
%% Arguments for node and pods
X(1,1) = 0;
Y(1,1) = 0;
k = 1 ;
countx= 0;
county = 0;

%% Pods drawing
for count_y = 1:h_ais
    if count_y == h_ais
       county = 0;
    end
    for count_x = 1:v_ais
        for i = 1:2
            for j = 1:5                
                l_conx = (fp + lw/2)+ (5*pw+lw)*(count_x-1) +(j-1)*pw;% x goc trai duoi
                l_cony = (ws_w + lw)+ (2*pw+lw)*(count_y-1) +(i-1)*pw;% y goc trai duoi
                %rectangle('Position',[l_conx l_cony pw pw],'FaceColor',[0.4 0.4 0.4],'EdgeColor','w');
                X(k,1) = double(l_conx);
                Y(k,1) = double(l_cony);
                % Coordinate of each pod.
                rectCenter(k,1) =l_conx+pw/2; % toa do tam x
                rectCenter(k,2) = l_cony+pw/2; % toa do tam y  
                % Storing 
               
 % Find pod entrance node horizontal
%                 if ( rectCenter(k,1) == 3650 )
                if ( rectCenter(k,1) == 3900 )                    
                    if i == 1
                    podStor(countx*4+1,:) = [ fp , rectCenter(k,2) ];
                    else
                    podStor(countx*4+4,:) = [ fp , rectCenter(k,2) ];
                    end
%                 elseif rectCenter(k,1) == 3650+v_ais*(lw+5*pw)-pw-lw
                elseif rectCenter(k,1) == 3900+v_ais*(lw+5*pw)-pw-lw                    
                    %102150 
                    if i == 1
                    podStor(countx*4+2,:) = [ fp+v_ais*(lw+5*pw), rectCenter(k,2)];
                    else
                    podStor(countx*4+3,:) = [ fp+v_ais*(lw+5*pw), rectCenter(k,2)];   
                    end
                end
                
                
                switch j                     
                    case 1
                       if count_y == 1
                           podStor1(county*11+1,:) = [ rectCenter(k,1) , ws_w+lw/2 ];                         
                       elseif count_y == h_ais
                           podStor1(county*11+2,:) = [ rectCenter(k,1) , ws_w+lw/2+h_ais*(lw+2*pw) ];
                       end
                    case 2 
                       if count_y == 1
                           podStor1(county*11+4,:) = [ rectCenter(k,1) , ws_w+lw/2 ];
                       elseif count_y == h_ais
                           podStor1(county*11+3,:) = [ rectCenter(k,1) , ws_w+lw/2+h_ais*(lw+2*pw) ];
                       end
                    case 3
                       if count_y == 1
                           podStor1(county*11+5,:) = [ rectCenter(k,1) , ws_w+lw/2 ];
                       elseif count_y == h_ais
                           podStor1(county*11+6,:) = [ rectCenter(k,1) , ws_w+lw/2+h_ais*(lw+2*pw) ];
                       end
                    case 4
                       if count_y == 1
                           podStor1(county*11+8,:) = [ rectCenter(k,1) , ws_w+lw/2 ];
                       elseif count_y == h_ais
                           podStor1(county*11+7,:) = [ rectCenter(k,1) , ws_w+lw/2+h_ais*(lw+2*pw) ];
                       end
                    case 5
                       if count_y == 1
                           podStor1(county*11+9,:) = [ rectCenter(k,1) , ws_w+lw/2 ];
                           podStor1(county*11+11,:) = [ rectCenter(k,1) , ws_w+lw/2 ];
                       elseif count_y == h_ais
                           podStor1(county*11+10,:) = [ rectCenter(k,1) , ws_w+lw/2+h_ais*(lw+2*pw) ];
                       end
                    otherwise 
                end

                k = k + 1;                                
            end
        end 
        county = county + 1 ; 
    end
    countx = countx + 1;
end  
    [x4,y4] = polyxpoly(verArr(:,1),verArr(:,2),horArr(:,1),horArr(:,2),'unique');
    [x5,y5] = polyxpoly(horArr(:,1),horArr(:,2),podStor1(:,1),podStor1(:,2),'unique');
    [x6,y6] = polyxpoly(verArr(:,1),verArr(:,2),podStor(:,1),podStor(:,2),'unique');
    % Draw vertical line
    verLine =line(podStor1(:,1),podStor1(:,2),"LineWidth",0.1,"color","b");
    horLine =line(podStor(:,1),podStor(:,2),"LineWidth",0.1,"color","b");
    
% Show pods
wid = ones(size(X))*pw; hei = ones(size(Y))*pw;
pos = [X ,Y ,wid,hei];
rect1 = rectangles(pos);

% Show nodes
nodeArr = cat(1,[x4,y4],[x5,y5],[x6,y6],rectCenter,nodeWS); % nodeWS % Xap xi 4200 node
% For recognition 
nodeArr = int64(nodeArr);
rectCenter = int64(rectCenter);
radi2 = ones(1,size(nodeArr,1))*100;
circles = viscircles(nodeArr,radi2,'Color','r');
circles.Visible = 'off';

%% Create a matrix that contains all the node. ( sorting matrix)
 % Store all node into a single matrix for A* search.
for j = 1:h_ais
    for i = 0:2
        % Sort aisle-line
        if i == 0
        a = find(nodeArr(:,2)== fp_y +(lw+2*pw)*(j-1));
        b = [a , nodeArr(a)];
        [b,I] = sort(b(:,2));
        a = a(I);
        stor((j-1)*3+i+1,:) = a;         
        if j == h_ais
            a = find(nodeArr(:,2)== fp_y +(lw+2*pw)*(j));
            b = [a , nodeArr(a)];
            [b,I] = sort(b(:,2));
            a = a(I);  
            stor(40,:) = a; 
        end
        % Sort pod-line
        else    
        a = find(nodeArr(:,2)== fp_y+((pw+lw)/2)+pw*(-1+i)+(lw+2*pw)*(j-1)); 
        b = [a , nodeArr(a)];
        [b,I] = sort(b(:,2));
        a = a(I);
        stor((j-1)*3+i+1,:) = a;
        
        % Sort pods only
        c = find(rectCenter(:,2) == fp_y+((pw+lw)/2)+pw*(-1+i)+(lw+2*pw)*(j-1)); 
        d = [c , rectCenter(c)];
        [d,S] = sort(d(:,2));
        c = c(S);
        podsort((j-1)*2+i,:) = c;        
        end
    end
end    

%% Sorting pods matrix 

end
