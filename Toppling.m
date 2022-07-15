
clear;
% Pods and AGV specification
a = 1; % pods width
b = a/2;
h = 1.4 ;
w = 0.6;
as = 0.9389;


% Toppling range
syms s;
s = @(u,v) w/2-as/9.81*v;
funx = @(u,v) s(u,v).*cos(u);
funy = @(u,v) s(u,v).*sin(u);
funz = @(u,v) v;
graph = fsurf(funx,funy,funz,[0 2*pi 0 h]);
% graph.ShowContours = 'on';

% Graph limits
ax = gca;
ax.XLim = [-2 2 ];
ax.YLim = [-2 2 ];
ax.ZLim = [ -0.4 2 ];



% Pods and AGV draw
rectangle('Position',[-b -b a a],'EdgeColor','k','LineWidth',2);
line([-b -b],[-b -b],[-0.4 h],'Color','k','LineWidth',2);
line([b b],[b b],[-0.4 h],'Color','k','LineWidth',2);
line([b b],[-b -b],[-0.4 h],'Color','k','LineWidth',2);
line([-b -b],[b b],[-0.4 h],'Color','k','LineWidth',2);
line([-b b],[b b],[h h],'Color','k','LineWidth',2);
line([b b],[b -b],[h h],'Color','k','LineWidth',2);
line([b -b],[-b -b],[h h],'Color','k','LineWidth',2);
line([-b -b],[-b b],[h h],'Color','k','LineWidth',2);
viscircles([0 0],w/2,'Color','r','LineWidth',5);

for i = 1:3
line([-b b],[b b],[i*h/4 i*h/4],'Color','k','LineWidth',2);
line([b b],[b -b],[i*h/4 i*h/4],'Color','k','LineWidth',2);
line([b -b],[-b -b],[i*h/4 i*h/4],'Color','k','LineWidth',2);
line([-b -b],[-b b],[i*h/4 i*h/4],'Color','k','LineWidth',2);
end


% Draw AGV
xagv = [-0.4 -0.4  -0.4  ; 0.4  -0.4 0.4;  0.4  -0.4  0.4; -0.4   -0.4 -0.4];
yagv = [-0.4 0.4 -0.4  ; -0.4    0.4 -0.4; -0.4 -0.4  0.4; -0.4   -0.4 0.4];
zagv = [  0    0    0  ;  0     -0.4    0; -0.4 -0.4 0; -0.4     0   0];
% c = [2 2 2; 3 3 0; 2 2 2; 0 0 3];
c = [0.9290 0.6940 0.1250];
patch(xagv,yagv,zagv,c)

