function varargout = CurvePlotter3D(varargin)
% CURVEPLOTTER3D MATLAB code for CurvePlotter3D.fig
%      CURVEPLOTTER3D, by itself, creates a new CURVEPLOTTER3D or raises the existing
%      singleton*.
%
%      H = CURVEPLOTTER3D returns the handle to a new CURVEPLOTTER3D or the handle to
%      the existing singleton*.
%
%      CURVEPLOTTER3D('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CURVEPLOTTER3D.M with the given input arguments.
%
%      CURVEPLOTTER3D('Property','Value',...) creates a new CURVEPLOTTER3D or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CurvePlotter3D_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CurvePlotter3D_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CurvePlotter3D

% Last Modified by GUIDE v2.5 24-Feb-2014 21:34:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CurvePlotter3D_OpeningFcn, ...
                   'gui_OutputFcn',  @CurvePlotter3D_OutputFcn, ...
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


% --- Executes just before CurvePlotter3D is made visible.
function CurvePlotter3D_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CurvePlotter3D (see VARARGIN)

% Choose default command line output for CurvePlotter3D
handles.output = hObject;


% Default Initializations
handles.xFunction = 'sin(t)';
handles.yFunction = 'cos(t)';
handles.zFunction = 't';
handles.divisions = 50;
handles.tStart = 0;
handles.tEnd = 10;
handles.tPoint = 0;
handles.tRate = 1;
handles.timer = timer('ExecutionMode', 'fixedRate', ...
    'Period', 1/10, ...
    'TimerFcn', @updateTimer);


% Initialize Cursor
handles.cursorObj = datacursormode(handles.figure1);
set(handles.cursorObj, 'UpdateFcn', @displayDataPoint);

handles = updateFunctionButton_Callback(handles.updateFunctionButton, eventdata, handles);

% Update handles structure
guidata(hObject, handles);




% UIWAIT makes CurvePlotter3D wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = CurvePlotter3D_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function timeSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timeSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes during object creation, after setting all properties.
function timeBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timeBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function index = componentIndex(component)
% get the index for the specified component
switch(class(component))
    case 'double'
        if(component > 0 && component < 3)
            index = component;
            return;
        end
    case 'char'
        switch(component)
            case 'x'
                index = 1;
                return;
            case 'y'
                index = 2;
                return;
            case 'z'
                index = 3;
                return;
        end
end

%reached if no case is true
error('Invalid input! Component must be either x, y, z, or 0, 1, 2');

function name = getComponentName(component)
if(~strcmp(class(component),'double') || component < 1 || component > 3)
    error('Invalid input! Must be an integer of 1, 2, or 3.');
end
switch(component)
    case 1
        name = 'x';
    case 2
        name = 'y';
    case 3
        name = 'z';
end



function xBox_Callback(hObject, eventdata, handles)
% hObject    handle to xBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xBox as text
%        str2double(get(hObject,'String')) returns contents of xBox as a double



% --- Executes during object creation, after setting all properties.
function xBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yBox_Callback(hObject, eventdata, handles)
% hObject    handle to yBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yBox as text
%        str2double(get(hObject,'String')) returns contents of yBox as a double


% --- Executes during object creation, after setting all properties.
function yBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zBox_Callback(hObject, eventdata, handles)
% hObject    handle to zBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zBox as text
%        str2double(get(hObject,'String')) returns contents of zBox as a double


% --- Executes during object creation, after setting all properties.
function zBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on slider movement.
function timeSlider_Callback(hObject, eventdata, handles)
% hObject    handle to timeSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.tPoint = get(hObject, 'Value');
set(handles.timeBox, 'String', handles.tPoint);
updateGraph(handles);
guidata(handles.figure1, handles);



function timeBox_Callback(hObject, eventdata, handles)
% hObject    handle to timeBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of timeBox as text
%        str2double(get(hObject,'String')) returns contents of timeBox as a double

try
    boxFunction = get(handles.timeBox, 'String');
    if ~(isa(eval([(boxFunction) ';']),'double'))
        error('Must be a valid numerical expression.');
    end
    testNum = eval([boxFunction ';']);
    
    %if number is within domain
    if(testNum < get(handles.timeSlider, 'Min') || testNum > get(handles.timeSlider, 'Max'))
        error('Value must be in domain!');
    end
catch err
    set(handles.timeBox, 'String', handles.tPoint);
    disp(['ERROR SETTING TIME VALUE: ' err.message])
end

handles.tPoint = eval([get(handles.timeBox, 'String') ';']);
set(handles.timeBox, 'String', handles.tPoint);
set(handles.timeSlider, 'Value', handles.tPoint);
updateGraph(handles);

guidata(handles.figure1, handles);


% --- Executes on button press in updateFunctionButton.
function handles = updateFunctionButton_Callback(hObject, eventdata, handles)
% hObject    handle to updateFunctionButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


handles = checkDivisionNumber(handles);
handles = checkCurveDomain(handles);
handles = checkFunctionText(handles);
handles = setFunctions(handles);
handles = createCurve(handles);
handles = updateTPoint(handles);
updateGraph(handles);

guidata(handles.figure1, handles);

function handles = updateTPoint(handles)
set(handles.timeBox, 'String', handles.tPoint);
set(handles.timeSlider, 'Min', handles.tStart);
set(handles.timeSlider, 'Max', handles.tEnd);
set(handles.timeSlider, 'Value', handles.tPoint);

guidata(handles.figure1, handles);

function handles = checkDivisionNumber(handles)
try
    boxFunction = get(handles.divisionBox, 'String');
    if ~(isa(eval([(boxFunction) ';']),'double'))
        error('Must be a valid numerical expression.');
    end
    testNum = eval([boxFunction ';']);
    
    %if number is not a positive nonzero integer
    if(testNum <= 0 || mod(testNum, 1) ~= 0)
        error('Number of divisions must be a positive integer!');
    end
catch err
    set(handles.divisionBox, 'String', handles.divisions);
    disp(['ERROR SETTING NUMBER OF DIVISIONS: ' err.message])
end

handles.divisions = eval([get(handles.divisionBox, 'String') ';']);
set(handles.divisionBox, 'String', handles.divisions);

guidata(handles.figure1, handles);

function handles = checkCurveDomain(handles)

try
    startString = get(handles.tStartBox, 'String');
    endString = get(handles.tEndBox, 'String');
    if ~(isa(eval([(startString) ';']),'double') && isa(eval([(endString) ';']),'double'))
        error('Must be a valid numerical expression.');
    end
    testStart = eval([startString ';']);
    testEnd = eval([endString ';']);
    
    if ~(testStart <= testEnd)
        error('Invalid boundary conditions! Respect the comparison signs.');
    end
catch err
    set(handles.tStartBox, 'String', handles.tStart);
    set(handles.tEndBox, 'String', handles.tEnd);
    disp(['INTERVAL ERROR: ' err.message])
end

handles.tStart = eval([get(handles.tStartBox, 'String') ';']);
handles.tEnd = eval([get(handles.tEndBox, 'String') ';']);
handles.tPoint = handles.tStart;
set(handles.tStartBox, 'String', handles.tStart);
set(handles.tEndBox, 'String', handles.tEnd);

guidata(handles.figure1, handles);

function handles = checkFunctionText(handles)

%dummy test variable
t = handles.tStart;
% t = handles.t(1);

%If corresponding text box has invalid code, reset to previous
variables = symvar(get(handles.xBox, 'String'));
if isempty(variables) || (strcmp(variables{1},'t') && length(variables) == 1)
    handles.xFunction = sym(get(handles.xBox, 'String'));
else
    set(handles.xBox, 'String', char(handles.xFunction));
    error(['FUNCTION ERROR: The formula must only have t as the variable.']);
end

variables = symvar(get(handles.yBox, 'String'));
if isempty(variables) || (strcmp(variables{1},'t') && length(variables) == 1)
    handles.yFunction = sym(get(handles.yBox, 'String'));
else
    set(handles.yBox, 'String', char(handles.yFunction));
    error(['FUNCTION ERROR: The formula must only have t as the variable.']);
end

variables = symvar(get(handles.zBox, 'String'));
if isempty(variables) || (strcmp(variables{1},'t') && length(variables) == 1)
    handles.zFunction = sym(get(handles.zBox, 'String'));
else
    set(handles.zBox, 'String', char(handles.zFunction));
    error(['FUNCTION ERROR: The formula must only have t as the variable.']);
end

guidata(handles.figure1, handles);

function handles = setFunctions(handles)
%Sets functions to text

handles.curve = [handles.xFunction; handles.yFunction; handles.zFunction];

guidata(handles.figure1, handles);

function handles = createCurve(handles)
t = linspace(handles.tStart, handles.tEnd, handles.divisions+1);
handles.r = matlabFunction(handles.curve);

setappdata(0, 'CurvePlotter3D', gcf);
setappdata(gcf, 'Time', t);

guidata(handles.figure1, handles);

function drawCurve(handles)
t = getCurve;
curve = (handles.r(t));
x = curve(1,:);
y = curve(2,:);
z = curve(3,:);
disp(curve)
plot3(x,y,z);
guidata(handles.figure1, handles);

function drawPoint(handles)
point = (handles.r(handles.tPoint));
x = point(1);
y = point(2);
z = point(3);
plot3(x,y,z,'o','Color','red');
guidata(handles.figure1, handles);

function updateGraph(handles)
drawCurve(handles);
hold all;
drawPoint(handles);
hold off;
guidata(handles.figure1, handles);

function tStartBox_Callback(hObject, eventdata, handles)
% hObject    handle to tStartBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tStartBox as text
%        str2double(get(hObject,'String')) returns contents of tStartBox as a double


% --- Executes during object creation, after setting all properties.
function tStartBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tStartBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tEndBox_Callback(hObject, eventdata, handles)
% hObject    handle to tEndBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tEndBox as text
%        str2double(get(hObject,'String')) returns contents of tEndBox as a double


% --- Executes during object creation, after setting all properties.
function tEndBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tEndBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function divisionBox_Callback(hObject, eventdata, handles)
% hObject    handle to divisionBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of divisionBox as text
%        str2double(get(hObject,'String')) returns contents of divisionBox as a double


% --- Executes during object creation, after setting all properties.
function divisionBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to divisionBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function uitoggletool9_OnCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
grid(handles.bigGraph, 'on');


% --------------------------------------------------------------------
function uitoggletool9_OffCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
grid(handles.bigGraph, 'off');


% --- Executes on button press in revertButton.
function revertButton_Callback(hObject, eventdata, handles)
% hObject    handle to revertButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.xBox, 'String', handles.xFunction);
set(handles.yBox, 'String', handles.yFunction);
set(handles.zBox, 'String', handles.zFunction);
set(handles.tStartBox, 'String', handles.tStart);
set(handles.tEndBox, 'String', handles.tEnd);
set(handles.divisionBox, 'String', handles.divisions);


function text = displayDataPoint(obj, event_obj)
% Customizes text of data tip
position = get(event_obj, 'Position');
dataIndex = get(event_obj, 'DataIndex');
CurvePlotter3D = getappdata(0, 'CurvePlotter3D');
time = getappdata(CurvePlotter3D, 'Time');
disp(time(dataIndex));
text = sprintf('X: %f\nY: %f\nZ: %f\nTime: %f',...
    position(1),...
    position(2),...
    position(3),...
    time(dataIndex));


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

delete(handles.timer);

% Hint: delete(hObject) closes the figure
delete(hObject);



function rateText_Callback(hObject, eventdata, handles)
% hObject    handle to rateText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rateText as text
%        str2double(get(hObject,'String')) returns contents of rateText as a double


% --- Executes during object creation, after setting all properties.
function rateText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rateText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in playbackButton.
function playbackButton_Callback(hObject, eventdata, handles)
% hObject    handle to playbackButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(handles.timer, 'Running'), 'off')
    start(handles.timer);
    set(handles.playbackButton, 'String', 'Stop');
else
    stop(handles.timer);
    set(handles.playbackButton, 'String', 'Play');
end
guidata(handles.figure1, handles);

function updateTimer(object, eventdata)
hfigure = getappdata(0, 'CurvePlotter3D');
handles = guidata(hfigure);
if(handles.tPoint + handles.tRate/10 <= handles.tEnd);
    handles.tPoint = handles.tPoint + handles.tRate/10;
    guidata(hfigure, handles);
    handles = updateTPoint(handles);
    guidata(hfigure, handles);
    updateGraph(handles);
    guidata(hfigure, handles);
else
    stop(handles.timer);
end
guidata(hfigure, handles);

function t = getCurve
CurvePlotter3D = getappdata(0, 'CurvePlotter3D');
t = getappdata(CurvePlotter3D, 'Time');
