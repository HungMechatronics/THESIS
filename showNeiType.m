function showNeiType(flag)
% Show the neighbors that AGV use for A*
    if flag==1

    %2
    NeigboorCheck=[0 1 0 1 0;1 1 1 1 1;0 1 0 1 0;1 1 1 1 1;0 1 0 1 0]; %Heading has 16 possible allignments
    [row col]=find(NeigboorCheck==1);
    Neighboors=[row col]-(2+1);
    figure(2)

    for p=1:size(Neighboors,1)
      i=Neighboors(p,1);
           j=Neighboors(p,2);

         plot([0 i],[0 j],'k')
     hold on
     axis equal

    grid on
    title('Connecting distance=2')
    end

    %3
    NeigboorCheck=[0 1 1 0 1 1 0;1 0 1 0 1 0 1;1 1 1 1 1 1 1;0 0 1 0 1 0 0;1 1 1 1 1 1 1;1 0 1 0 1 0 1;0 1 1 0 1 1 0]; %Heading has 32 possible allignments
    figure(3)
    [row col]=find(NeigboorCheck==1);
    Neighboors=[row col]-(3+1);

    for p=1:size(Neighboors,1)
      i=Neighboors(p,1);
           j=Neighboors(p,2);

         plot([0 i],[0 j],'k')
     hold on
     axis equal
     grid on
    title('Connecting distance=3')

    end

    %4
    NeigboorCheck=[0 1 1 1 0 1 1 1 0;1 0 1 1 0 1 1 0 1;1 1 0 1 0 1 0 1 1;1 1 1 1 1 1 1 1 1;0 0 0 1 0 1 0 0 0;1 1 1 1 1 1 1 1 1;1 1 0 1 0 1 0 1 1 ;1 0 1 1 0 1 1 0 1 ;0 1 1 1 0 1 1 1 0];  %Heading has 56 possible allignments
    figure(4)
    [row col]=find(NeigboorCheck==1);
    Neighboors=[row col]-(4+1);

    for p=1:size(Neighboors,1)
      i=Neighboors(p,1);
           j=Neighboors(p,2);

         plot([0 i],[0 j],'k')
     hold on
     axis equal
    grid on
    title('Connecting distance=4')

    end

    %1
    NeigboorCheck=[0 1 0;1 0 1;0 1 0];
    figure(1)
    [row col]=find(NeigboorCheck==1);
    Neighboors=[row col]-(1+1);

    for p=1:size(Neighboors,1)
      i=Neighboors(p,1);
      j=Neighboors(p,2);

         plot([0 i],[0 j],'k')
     hold on
     axis equal
    grid on
    title('Connecting distance=1')

    end
    end
end