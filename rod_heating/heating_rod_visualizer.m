function varargout = heating_rod_visualizer(varargin)
% HEATING_ROD_VISUALIZER MATLAB code for heating_rod_visualizer.fig
%      HEATING_ROD_VISUALIZER, by itself, creates a new HEATING_ROD_VISUALIZER or raises the existing
%      singleton*.
%
%      H = HEATING_ROD_VISUALIZER returns the handle to a new HEATING_ROD_VISUALIZER or the handle to
%      the existing singleton*.
%
%      HEATING_ROD_VISUALIZER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HEATING_ROD_VISUALIZER.M with the given input arguments.
%
%      HEATING_ROD_VISUALIZER('Property','Value',...) creates a new HEATING_ROD_VISUALIZER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before heating_rod_visualizer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to heating_rod_visualizer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help heating_rod_visualizer

% Last Modified by GUIDE v2.5 17-May-2014 21:59:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @heating_rod_visualizer_OpeningFcn, ...
                   'gui_OutputFcn',  @heating_rod_visualizer_OutputFcn, ...
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


% --- Executes just before heating_rod_visualizer is made visible.
function heating_rod_visualizer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to heating_rod_visualizer (see VARARGIN)

% Choose default command line output for heating_rod_visualizer
handles.output = hObject;



handles = calculateTemperature(handles);
updateGraph(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes heating_rod_visualizer wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function handles = calculateTemperature(handles)
handles.totalTime = str2double(get(handles.totalTimeBox, 'String'));
handles.dt = str2double(get(handles.timeStepBox, 'String'));

handles.temperature = getTemperatureGradient(handles.totalTime, handles.dt);
handles.timeSamples = size(handles.temperature, 1);


% --- Outputs from this function are returned to the command line.
function varargout = heating_rod_visualizer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

updateGraph(handles);
guidata(handles.figure1, handles);

function index = getTimeIndex(handles)
index = floor((handles.timeSamples)*get(handles.slider1, 'Value')) + 1;
if index > handles.timeSamples
    index = handles.timeSamples;
end

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function updateGraph(handles)

data = handles.temperature(getTimeIndex(handles), :);
dt = handles.totalTime/handles.timeSamples;

timeElapsed = (getTimeIndex(handles)-1)*dt;
set(handles.elapsedTime, 'String', timeElapsed);
hold off;
plot(data, '--o');



function totalTimeBox_Callback(hObject, eventdata, handles)
% hObject    handle to totalTimeBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of totalTimeBox as text
%        str2double(get(hObject,'String')) returns contents of totalTimeBox as a double

handles = calculateTemperature(handles);
updateGraph(handles);
guidata(handles.figure1, handles);


% --- Executes during object creation, after setting all properties.
function totalTimeBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to totalTimeBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function timeStepBox_Callback(hObject, eventdata, handles)
% hObject    handle to timeStepBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of timeStepBox as text
%        str2double(get(hObject,'String')) returns contents of timeStepBox as a double

handles = calculateTemperature(handles);
updateGraph(handles);
guidata(handles.figure1, handles);


% --- Executes during object creation, after setting all properties.
function timeStepBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timeStepBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
