function disPath(OptimalPath,MAP)
    if size(OptimalPath,2)>1                % If exist path , plot it .
    global dynMAP staMAP wsMAP goalMAP;
   % figure(1);
    MAP = staMAP + wsMAP;
    imagesc((MAP)) 
    
    %grid on
    %axis equal
    colormap(flipud(gray));             % Show black-white image: 0 black , 1-white.
%    [Y,X]=meshgrid(1:96,1:40);
%    pcolor(Y,X,MAP);
   % colormap((gray));
   %h=msgbox('Path Found','warn');
   % uiwait(h,5);
    hold on
    plot(OptimalPath(1,2),OptimalPath(1,1),'X','color','g','LineWidth',2)     % Goal plot 
    plot(OptimalPath(end,2),OptimalPath(end,1),'X','color','b','LineWidth',2) % Start plot 
    plot(OptimalPath(:,2),OptimalPath(:,1),'r','LineWidth',2)                 % Path plot 
    legend('Goal','Start','Path')
    
    else 
    pause(1);
   % h=msgbox('Sorry, No path exists to the Target!','warn');
 %uiwait(h,5);        % Wait for the textbox in 5
end
end