function varargout = AGVsystem(varargin)
% AGVSYSTEM MATLAB code for AGVsystem.fig
%      AGVSYSTEM, by itself, creates a new AGVSYSTEM or raises the existing
%      singleton*.
%
%      H = AGVSYSTEM returns the handle to a new AGVSYSTEM or the handle to
%      the existing singleton*.
%
%      AGVSYSTEM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AGVSYSTEM.M with the given input arguments.
%
%      AGVSYSTEM('Property','Value',...) creates a new AGVSYSTEM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AGVsystem_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AGVsystem_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AGVsystem

% Last Modified by GUIDE v2.5 13-May-2022 10:11:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AGVsystem_OpeningFcn, ...
                   'gui_OutputFcn',  @AGVsystem_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before AGVsystem is made visible.
function AGVsystem_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AGVsystem (see VARARGIN)

% Choose default command line output for AGVsystem
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AGVsystem wait for user response (see UIRESUME)
% uiwait(handles.gui1);


% --- Outputs from this function are returned to the command line.
function varargout = AGVsystem_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

global gui_xuatnhap table;

gui_xuatnhap = TrackingMenu;
gui_xuatnhap.Visible = 'off';
table = gui_xuatnhap.Children(4);


varargout{1} = handles.output;
% Khoi tao gui2

axes(handles.axes_wh);

global h alp t_stamp goalLine horLine verLine T;
l=900 ;w=760; h = sqrt(l^2+w^2)/2;
alp = acosd(w/sqrt(w^2+l^2));
t_stamp = 0.1;
T = 0;

global numberofAGV stopTime;
numberofAGV = 8;
numberofPod = 1950;
stopTime = 900;


global podsort rectCenter stor nodeArray nodeArr podStatic totalgood; 
        % Notice : stor(row,col - y,x) , nodeArray(i,1) = x ,
        % nodeArray(i,2) = y  !!!!
[podsort,rectCenter,stor,nodeArr] = drawLayout();  
nodeArray = double(nodeArr);
totalgood = 0;

% str = '#D8E1E7';
str = '#D7D7D9';
% str = '#FFFFFF';
convertcolor = sscanf(str(2:end),'%2x%2x%2x',[1 3])/255;

set(gca,'Color',convertcolor)
set(gca,'SortMethod','childorder');

for i = 1:numberofAGV
%    agvArr(i,1) = agvClass(i,1,0,i); %col,row - x,y
   patchArr(i,1) = patch;
   emptypod(i,1) = patch;
%    agvArr(i,1).agvName = i;
end    
% List of AGV
% agvArr(1,1) = agvClass(16,7,0,1);
% agvArr(2,1) = agvClass(19,10,0,2);
% agvArr(3,1) = agvClass(90,40,0,3);
% agvArr(4,1) = agvClass(1,40,0,4);
% agvArr(5,1) = agvClass(1,34,0,5);
% agvArr(6,1) = agvClass(7,22,0,6);
% agvArr(7,1) = agvClass(32,26,0,7);
% agvArr(8,1) = agvClass(8,15,0,8);

agvArr(1,1) = agvClass(1,4,0,1);
agvArr(2,1) = agvClass(1,8,0,2);
agvArr(3,1) = agvClass(1,12,0,3);
agvArr(4,1) = agvClass(1,16,0,4);
agvArr(5,1) = agvClass(1,24,0,5);
agvArr(6,1) = agvClass(1,28,0,6);
agvArr(7,1) = agvClass(1,32,0,7);
agvArr(8,1) = agvClass(1,36,0,8);

global patchArray emptyPod manualFrame manualFlag ;
patchArray = patchArr;
emptyPod = emptypod;
% patchArray(1,1).FaceColor ='r';
% patchArray(2,1).FaceColor ='g';
% patchArray(3,1).FaceColor ='y';
manualFlag = 0;
manualFrame = [];


global lineOfWS1 lineOfWS2 lineOfWS3 lineOfWS4 lineOfWS5
lineOfWS1 = [];
lineOfWS2 = [];
lineOfWS3 = [];
lineOfWS4 = [];
lineOfWS5 = [];


global agvArray;
agvArray = agvArr;
agvArray(1,1).colorface ='r';
agvArray(2,1).colorface ='g';
agvArray(3,1).colorface ='b';
agvArray(4,1).colorface ='c';
agvArray(5,1).colorface ='m';
agvArray(6,1).colorface ='k';
agvArray(7,1).colorface ='w';
agvArray(8,1).colorface =[0.9290 0.6940 0.1250];

% First display the AGV
for i = 1:size(agvArray,1)
    beta1 = 0;
    centX = nodeArray(stor(agvArray(i,1).positionY,agvArray(i,1).positionX),1);
    centY = nodeArray(stor(agvArray(i,1).positionY,agvArray(i,1).positionX),2);
    x = [ (centX+h*cosd(alp+beta1));centX+h*cosd(180-(alp+beta1));
    centX+h*cosd(180+(alp+beta1));centX+h*cosd(-(alp+beta1))];
    y = [ (centY+h*sind(alp+beta1));centY+h*sind(180-(alp+beta1));
    centY+h*sind(180+(alp+beta1));centY+h*sind(-(alp+beta1))];
    vertex = [x(1,1) y(1,1);x(2,1) y(2,1);x(3,1) y(3,1);x(4,1) y(4,1)];               
    face = [1 2 3 4];
    set(patchArray(i,1),'faces',face,'vertices',vertex,'FaceColor',agvArray(i,1).colorface); 
end



podStatic = zeros(size(stor,1),size(stor,2));
% Stor pod in ClosedList
for i = 1: size(rectCenter,1)
    temperary = find( nodeArr(:,1)==rectCenter(i,1) & nodeArr(:,2)==rectCenter(i,2) );
    [tem1,tem2] = find(stor == temperary);
    podStatic(tem1,tem2) = 1;
end

global agvPosition podStatus agvVel wsStatus wsOrdLine podShow;     % Array of AGV position
agvPosition = zeros(numberofAGV,7); % x,y,angle,type of mission,< coordinate of goal node >,wsMission
wsStatus = [22 40 0 0;45 40 0 0;68 40 0 0;26 1 0 0; 61 1 0 0 ];  % col ,row ,number of goods.
podShow = zeros(numberofAGV,3); % Patch for pod


agvVel = 1300;
wsOrdLine = char(wsOrdLine);
podStatus = zeros(size(rectCenter,1),8); % x of pod ,y of pod,A,B,C,D, isAtStorage? ,isPick ?
global temp
temp = 0; % for rotation only

global time_window
time_window = [ 0,0,0,0,0,0,0,0,0,0];% start_node , end_node , agvName , time_in , time_out , next node , previous node


operators = [65,68]; % ASCII character A B C D
for i = 1:5
    indexes = randi(operators, 1, 10);
    wsOrdLine(i,:) = char(indexes);          %ws Line of Order
end
    
% Generate  podStatus & random A-B-C-D
% Generate the number of good
c_ = [];
d_ = [];
b_ = transpose(1:1:75);
for i= 1:26
    a_ = i*ones(75,1); % change argument
    c_ = cat(1,c_,a_);
    d_ = cat(1,d_,b_);
end   
podStatus(:,1) = c_; % row
podStatus(:,2) = d_; % col
podStatus(:,7) = ones(size(podStatus,1),1);

% for i = 1:size(podStatus,1)
%    podStatus(i,3)= randi(8,1,1);
%    podStatus(i,4)= randi(8,1,1);
%    podStatus(i,5)= randi(8,1,1);
%    podStatus(i,6)= randi(8,1,1);
% end    

% disFlag = distributeMission2();

% --- Executes on button press in addBtn.
function addBtn_Callback(hObject, eventdata, handles)
% hObject    handle to addBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in removeBtn.
function removeBtn_Callback(hObject, eventdata, handles)
% hObject    handle to removeBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function addBox_Callback(hObject, eventdata, handles)
% hObject    handle to addBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of addBox as text
%        str2double(get(hObject,'String')) returns contents of addBox as a double


% --- Executes during object creation, after setting all properties.
function addBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to addBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in startBtn.
function startBtn_Callback(hObject, eventdata, handles)
% hObject    handle to startBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global agvArray patchArray t_stamp numberofAGV T podStatus podShow emptyPod totalgood trackingFlag trackingFrame table trackingName ;
global stopTime manualFrame manualFlag wsOrdLine;
global lineOfWS1 lineOfWS2 lineOfWS3 lineOfWS4 lineOfWS5

set(handles.stopBtn, 'userdata', 0);
global data
data = [];
data2 = [];
trackingFlag = 0;
trackingFrame = {};
trackingName = [];
% stopTime = 900;

% Auto mode
if manualFlag == 0
    while(1)
        if T >= stopTime
           break; 
        end
        T = T + t_stamp;  
        set(handles.timeShow,'String',num2str(T));
        % Display UI table
        if mod(int64(T),10) == 0
            wsdata = {};
            for countws = 1:5
                wstemp = {countws,wsOrdLine(countws,:)};
                wsdata = cat(1,wsdata,wstemp);
            end
            set(handles.uitable1,'Data',wsdata);
        end

        % Distribute mission
        if mod(int64(T),20) == 0
            refillOrder();
            disFlag =distributeMission2(); 
        end 
        
        % Update AGV
        for i = 1:numberofAGV
            if agvArray(i,1).currentMission~=0
                 agvArray(i,1) = updateAGV(agvArray(i,1),t_stamp,patchArray(i,1),handles.axes_wh);
            else
                agvArray(i,1).freeTime = agvArray(i,1).freeTime+t_stamp;
            end
        end
        drawnow ;

        
        % Extract AGV data 
%         if mod(int64(T),2) == 0
%             if get(handles.trackingGUI,'UserData')           
%                 trackingFrame = {};
%                 if ~isempty(trackingName)                
%                     for m = 1:size(trackingName)
%                     temp10 = trackingName(m);
%                     
%                     data = [{agvArray(temp10,1).agvName} {agvArray(temp10,1).wsName} {agvArray(temp10,1).coordinateX} {agvArray(temp10,1).coordinateY} {agvArray(temp10,1).goalY} {agvArray(temp10,1).goalX}  ];                    
%                     trackingFrame = cat(1,trackingFrame,data);
%                     end                
%                 end
%                 set(table,'Data',trackingFrame);           
%             end
%          end
        % Tracking AGV positions
        if get(handles.chooseAGV,'userData') ~= 0
            if get(handles.chooseAGV,'userData') == 15
                for i = 1:numberofAGV
                    patchArray(i,1).Visible = 'on';
                    agvArray(i,1).goalLine.Visible ='on';
                end
            else
                for i = 1:numberofAGV
                    patchArray(i,1).Visible = 'off';
                    agvArray(i,1).goalLine.Visible ='off';
                end
                patchArray(get(handles.chooseAGV,'userData'),1).Visible = 'on';                 
                agvArray(get(handles.chooseAGV,'userData'),1).goalLine.Visible ='on';
            end
            set(handles.chooseAGV,'userData',0);
        end
        
        % Stop button hold all AGV
        if get(handles.stopBtn, 'userdata') 
            break;
        end
    end 
% MANUAL CASE    
elseif manualFlag == 1
    deleteName = [];
    while(~isempty(manualFrame))
        for i = 1:size(manualFrame,1)
            manualAGV = manualFrame(i);
            % Delete out of frame
            if agvArray(manualAGV,1).manualFlag ==0
                deleteName = cat(2,deleteName,manualAGV); % store name to delete
            end
            %
            if agvArray(manualAGV,1).currentMission~=0
                 agvArray(manualAGV,1) = updateAGV(agvArray(manualAGV,1),t_stamp,patchArray(manualAGV,1),handles.axes_wh);
            end
            drawnow;
        end  
        % Take out the finish AGV
        if ~isempty(deleteName) ==1
            for j = 1:size(deleteName)
               deletemanual = find(manualFrame == deleteName(j));
               manualFrame(deletemanual) = []; 
            end
            deleteName = [];
        end
    end    
end    

    global a e;
    for i = 1:numberofAGV
        a(1,i) = agvArray(i,1).totalDistance;
        e(1,i) = T - agvArray(i,1).freeTime;
    end
    % After running an amount of time, plot RESULT   
    if T >= stopTime
        figure(2);
        % Distance
        subplot(2,2,1);
        bar(a);
        line([1 size(a,2)], [mean(a) mean(a)],'Color','r','LineWidth',2);
        title('Distance per AGV');
        % Operation Time
        subplot(2,2,2);
        bar(e);
        line([1 size(e,2)], [mean(e) mean(e)],'Color','r','LineWidth',2);
        title('Operational time per AGV');
        % Through put
        subplot(2,1,2);
        bar(totalgood);
        title('Total through put in 15 mins');
    end

% --- Executes on button press in stopBtn.
function stopBtn_Callback(hObject, eventdata, handles)
% hObject    handle to stopBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.stopBtn,'userdata',1);

      
% --- Executes on selection change in chooseAGV.
function chooseAGV_Callback(hObject, eventdata, handles)
% hObject    handle to chooseAGV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns chooseAGV contents as cell array
%        contents{get(hObject,'Value')} returns selected item from chooseAGV
type = get(handles.chooseAGV,'Value');
num = 0;
switch type
    case 1
        num = 15;
    case 2
        num = 1;
    case 3
        num = 2;
    case 4
        num = 3;
    case 5
        num = 4;
    case 6
        num = 5;
    case 7
        num = 6;
    case 8
        num = 7;
    case 9
        num = 8;
    case 10
        num = 9;
    case 11
        num = 10;
    case 12
        num = 11;
    case 13
        num = 12;
    case 14
        num = 13;
    case 15
        num = 14;
end        
set(handles.chooseAGV,'userData',num);


% --- Executes during object creation, after setting all properties.
function chooseAGV_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chooseAGV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in setBtn.
function setBtn_Callback(hObject, eventdata, handles)
% hObject    handle to setBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on agvTable and none of its controls.
function agvTable_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to agvTable (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in addAGVbtn.
function addAGVbtn_Callback(hObject, eventdata, handles)
% hObject    handle to addAGVbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in RemoveAGVbtn.
function RemoveAGVbtn_Callback(hObject, eventdata, handles)
% hObject    handle to RemoveAGVbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in trackingGUI.
function trackingGUI_Callback(hObject, eventdata, handles)
global gui_xuatnhap;
if get(handles.trackingGUI,'UserData')==0
    gui_xuatnhap.Visible = 'on';
    set(handles.trackingGUI,'UserData',1);
else
    gui_xuatnhap.Visible = 'off';
    set(handles.trackingGUI,'UserData',0);
end    
% hObject    handle to trackingGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in controlGUI.
function controlGUI_Callback(hObject, eventdata, handles)
global gui_tudong;
gui_tudong = ControlMenu;
% hObject    handle to controlGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function gui1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gui1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when user attempts to close gui1.
function gui1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to gui1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
global gui_xuatnhap gui_tudong gui_pod;
delete(hObject);
delete(gui_xuatnhap);
delete(gui_tudong);
delete(gui_pod);


% --- Executes on button press in podMenu.
function podMenu_Callback(hObject, eventdata, handles)
% hObject    handle to podMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gui_pod;
gui_pod = PodMenu;
