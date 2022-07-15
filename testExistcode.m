%openExample('images/DrawLinesAroundBrightAndDarkCirclesInImageExample')
% openExample('map/FindIntersectionPointsBetweenRectangleAndPolylineExample')
% syms h r p x y u v ;

% s = @(u,v) 0.5-0.5/9.81*v;
% funx = @(u,v) s(u,v).*cos(u);
% funy = @(u,v) s(u,v).*sin(u);
% funz = @(u,v) v;
% fsurf(funx,funy,funz,[0 2*pi 0 1.4]) 

% xagv = [-0.4 -0.4  -0.4  ; 0.4  -0.4 0.4;  0.4  -0.4  0.4; -0.4   -0.4 -0.4];
% yagv = [-0.4 0.4 -0.4  ; -0.4    0.4 -0.4; -0.4 -0.4  0.4; -0.4   -0.4 0.4];
% zagv = [  0    0    0  ;  0     -0.4    0; -0.4 -0.4 0; -0.4     0   0];
% c = [2 2 2; 3 3 0; 2 2 2; 0 0 3];
% fill3(xagv,yagv,zagv,c)

% Eliminate the goods in WS
% str1 = 'ABCDABAAAA';
% storage = find(str1 == 'A');
% str1(storage) =['_']

% Random storage and dumming into WS - runs every 60s
% operators = 65:68; % ASCII character A B C D
% operators = [65,68];
% indexes = randi(length(operators), 1, size(storage,2));
% s = char(operators(indexes));
% d = cat(2,str1,s);
% a = find(str1 == '_');
% str1(a) = char(randi(operators,1,size(a,2)));


% Adding number for podst
% c = [];
% d = [];
% b = transpose(1:1:80);
% for i= 1:28
%     a = i*ones(80,1);
%     c = cat(1,c,a);
%     d = cat(1,d,b);
% end    

% Test continue function 
% a = [ 1 1 1 ; 3 4 5 ; 6 7 8 ];
% d(1,:) = find(a == 4);
% [b,c] = find(a == 4);
% e = [b,c];

% for i = 1:14
%    agvArray(1,i) = agvClass(1,1,0,i);
% end    

% a = [ 2 , 1 , 3 ,4 ; 1 , 2 , 4 ,3; 2 ,2 ,5 ,6 ; 3,4,2,1];
% b = [ 2, 1];
% c = [ 3 ,4 ];
% % check current road
% d = find(a(:,1)==b(1,1) & a(:,2)==b(1,2) & a(:,3)==c(1,1) & a(:,4)==c(1,2),10);
% e = find(a(:,1)==c(1,1) & a(:,2)==c(1,2) & a(:,3)==b(1,1) & a(:,4)==b(1,2),10);
% f = cat(1,d,e); % append into column matrix
% % take out the time_window frame.
% current_a = a(f,:);


% a= [5,5];
% neighbor = [ 0 -1; -1 0 ; 1 0 ;0 1 ];
% for i = 1:4
%     b(i,1) =  a(1,1) + neighbor(i,1);
%     b(i,2) =  a(1,2) + neighbor(i,2);
% end   


a = [ 10 12 8 6 9 ];
bar(a);
line([1 size(a,2)], [mean(a) mean(a)],'Color','r','LineWidth',2);


