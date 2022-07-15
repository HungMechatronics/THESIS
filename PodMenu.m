function varargout = PodMenu(varargin)
% PODMENU MATLAB code for PodMenu.fig
%      PODMENU, by itself, creates a new PODMENU or raises the existing
%      singleton*.
%
%      H = PODMENU returns the handle to a new PODMENU or the handle to
%      the existing singleton*.
%
%      PODMENU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PODMENU.M with the given input arguments.
%
%      PODMENU('Property','Value',...) creates a new PODMENU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PodMenu_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PodMenu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PodMenu

% Last Modified by GUIDE v2.5 13-May-2022 01:08:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PodMenu_OpeningFcn, ...
                   'gui_OutputFcn',  @PodMenu_OutputFcn, ...
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


% --- Executes just before PodMenu is made visible.
function PodMenu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PodMenu (see VARARGIN)

% Choose default command line output for PodMenu
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PodMenu wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PodMenu_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
global podFlag;
podFlag = 0;


function podLine_Callback(hObject, eventdata, handles)
% hObject    handle to podLine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of podLine as text
%        str2double(get(hObject,'String')) returns contents of podLine as a double


% --- Executes during object creation, after setting all properties.
function podLine_CreateFcn(hObject, eventdata, handles)
% hObject    handle to podLine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function podPosition_Callback(hObject, eventdata, handles)
% hObject    handle to podPosition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of podPosition as text
%        str2double(get(hObject,'String')) returns contents of podPosition as a double


% --- Executes during object creation, after setting all properties.
function podPosition_CreateFcn(hObject, eventdata, handles)
% hObject    handle to podPosition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in randomBtn.
function randomBtn_Callback(hObject, eventdata, handles)
% hObject    handle to randomBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.storPercent,'Enable','on');
set(handles.podLine,'Enable','off');
set(handles.podPosition,'Enable','off');
set(handles.Agood,'Enable','off');
set(handles.Bgood,'Enable','off');
set(handles.Cgood,'Enable','off');
set(handles.Dgood,'Enable','off');
global podFlag;
podFlag = 0;

% --- Executes on button press in selectBtn.
function selectBtn_Callback(hObject, eventdata, handles)
% hObject    handle to selectBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.storPercent,'Enable','off');
set(handles.podLine,'Enable','on');
set(handles.podPosition,'Enable','on');
set(handles.Agood,'Enable','on');
set(handles.Bgood,'Enable','on');
set(handles.Cgood,'Enable','on');
set(handles.Dgood,'Enable','on');
global podFlag;
podFlag = 1;

function storPercent_Callback(hObject, eventdata, handles)
% hObject    handle to storPercent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of storPercent as text
%        str2double(get(hObject,'String')) returns contents of storPercent as a double


% --- Executes during object creation, after setting all properties.
function storPercent_CreateFcn(hObject, eventdata, handles)
% hObject    handle to storPercent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in setBtn.
function setBtn_Callback(hObject, eventdata, handles)
% hObject    handle to setBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global podStatus podFlag;
if podFlag == 1
    % Manual
    podrow = str2double(get(handles.podLine,'String'));
    podcol = str2double(get(handles.podPosition,'String'));
    temp = find(podStatus(:,1) == podrow & podStatus(:,2) == podcol);
    podStatus(temp,3) = str2double(get(handles.Agood,'String'));
    podStatus(temp,4) = str2double(get(handles.Bgood,'String'));
    podStatus(temp,5) = str2double(get(handles.Cgood,'String'));
    podStatus(temp,6) = str2double(get(handles.Dgood,'String'));
    
elseif podFlag == 2
    % Find flag
    podrow = str2double(get(handles.podLine,'String'));
    podcol = str2double(get(handles.podPosition,'String'));
    temp = find(podStatus(:,1) == podrow & podStatus(:,2) == podcol);
    set(handles.Agood,'String',int2str(int64(podStatus(temp,3))));
    set(handles.Bgood,'String',int2str(int64(podStatus(temp,4))));
    set(handles.Cgood,'String',int2str(int64(podStatus(temp,5))));
    set(handles.Dgood,'String',int2str(int64(podStatus(temp,6))));
else
    index = ceil(str2double(get(handles.storPercent,'String'))/10);
    for i = 1:size(podStatus,1)
       podStatus(i,3)= randi(index,1,1);
       podStatus(i,4)= randi(index,1,1);
       podStatus(i,5)= randi(index,1,1);
       podStatus(i,6)= randi(index,1,1);
    end    
end


function Agood_Callback(hObject, eventdata, handles)
% hObject    handle to Agood (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Agood as text
%        str2double(get(hObject,'String')) returns contents of Agood as a double


% --- Executes during object creation, after setting all properties.
function Agood_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Agood (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Bgood_Callback(hObject, eventdata, handles)
% hObject    handle to Bgood (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Bgood as text
%        str2double(get(hObject,'String')) returns contents of Bgood as a double


% --- Executes during object creation, after setting all properties.
function Bgood_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Bgood (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Cgood_Callback(hObject, eventdata, handles)
% hObject    handle to Cgood (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Cgood as text
%        str2double(get(hObject,'String')) returns contents of Cgood as a double


% --- Executes during object creation, after setting all properties.
function Cgood_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Cgood (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Dgood_Callback(hObject, eventdata, handles)
% hObject    handle to Dgood (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Dgood as text
%        str2double(get(hObject,'String')) returns contents of Dgood as a double


% --- Executes during object creation, after setting all properties.
function Dgood_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Dgood (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in findBtn.
function findBtn_Callback(hObject, eventdata, handles)
% hObject    handle to findBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.storPercent,'Enable','off');
set(handles.podLine,'Enable','on');
set(handles.podPosition,'Enable','on');
set(handles.Agood,'Enable','on');
set(handles.Bgood,'Enable','on');
set(handles.Cgood,'Enable','on');
set(handles.Dgood,'Enable','on');
global podFlag;
podFlag = 2;
