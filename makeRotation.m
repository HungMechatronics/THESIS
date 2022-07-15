function [beta] = makeRotation(x,y,angle,k,h)
    % x: center x of AGV. 
    % y: center y of AGV.    
    % angle : rotating angle.
    % k : the patch  
    
    t = 5 ; % rotation time   
    rot = angle/(t/0.1); % rot per 0.1s
    tem = 0;
    %global a b;
    while abs(tem)<abs(angle)    
        tem = tem +rot;
        rotate(k,[0 0 1],rot,[x,y,1]);
%         drawnow
%     pause(0.01);
%     set(gca, 'Layer', 'bottom');
    end        
    beta = angle;
end