function varargout = ControlMenu(varargin)
% CONTROLMENU MATLAB code for ControlMenu.fig
%      CONTROLMENU, by itself, creates a new CONTROLMENU or raises the existing
%      singleton*.
%
%      H = CONTROLMENU returns the handle to a new CONTROLMENU or the handle to
%      the existing singleton*.
%
%      CONTROLMENU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONTROLMENU.M with the given input arguments.
%
%      CONTROLMENU('Property','Value',...) creates a new CONTROLMENU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ControlMenu_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ControlMenu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ControlMenu

% Last Modified by GUIDE v2.5 12-May-2022 21:48:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ControlMenu_OpeningFcn, ...
                   'gui_OutputFcn',  @ControlMenu_OutputFcn, ...
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


% --- Executes just before ControlMenu is made visible.
function ControlMenu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ControlMenu (see VARARGIN)

% Choose default command line output for ControlMenu
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ControlMenu wait for user response (see UIRESUME)
% uiwait(handles.gui3);


% --- Outputs from this function are returned to the command line.
function varargout = ControlMenu_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in autoBtn.
function autoBtn_Callback(hObject, eventdata, handles)
% hObject    handle to autoBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.agvMenu,'Enable','off');
set(handles.rowNode,'Enable','off');
set(handles.colNode,'Enable','off');
set(handles.timeInput,'Enable','on');
global manualFlag;
manualFlag = 0;

% --- Executes on button press in manualBtn.
function manualBtn_Callback(hObject, eventdata, handles)
% hObject    handle to manualBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.agvMenu,'Enable','on');
set(handles.rowNode,'Enable','on');
set(handles.colNode,'Enable','on');
set(handles.timeInput,'Enable','off');
global manualFlag;
manualFlag = 1;


% --- Executes on selection change in agvMenu.
function agvMenu_Callback(hObject, eventdata, handles)
% hObject    handle to agvMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns agvMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from agvMenu


% --- Executes during object creation, after setting all properties.
function agvMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to agvMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rowNode_Callback(hObject, eventdata, handles)
% hObject    handle to rowNode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rowNode as text
%        str2double(get(hObject,'String')) returns contents of rowNode as a double


% --- Executes during object creation, after setting all properties.
function rowNode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rowNode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function colNode_Callback(hObject, eventdata, handles)
% hObject    handle to colNode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of colNode as text
%        str2double(get(hObject,'String')) returns contents of colNode as a double


% --- Executes during object creation, after setting all properties.
function colNode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to colNode (see GCBO)
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
global stopTime manualFlag manualFrame agvArray;
if manualFlag == 0
    stopTime = str2double(get(handles.timeInput,'String'));
elseif manualFlag == 1
    agvName = get(handles.agvMenu,'Value');
    agvArray(agvName,1).goalY = str2double(get(handles.rowNode,'String'));
    agvArray(agvName,1).goalX = str2double(get(handles.colNode,'String'));
    agvArray(agvName,1).manualFlag = 1;
    agvArray(agvName,1).currentMission = 1;
    agvArray(agvName,1).findPathFlag = 1;
    if ~isempty(manualFrame) == 1
        manualFrame = cat(1,manualFrame,agvName);
    else 
        manualFrame = agvName;
    end
end

function timeInput_Callback(hObject, eventdata, handles)
% hObject    handle to timeInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of timeInput as text
%        str2double(get(hObject,'String')) returns contents of timeInput as a double


% --- Executes during object creation, after setting all properties.
function timeInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timeInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
