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

% Last Modified by GUIDE v2.5 30-Jan-2014 23:38:39

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
handles.xString = 'sin(t)';
handles.yString = 'cos(t)';
handles.zString = 't';
handles.divisions = 10;
handles.tStart = 0;
handles.tEnd = 1;

updateFunctionButton_Callback(handles.updateFunctionButton, eventdata, handles);

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


% --- Executes on slider movement.
function timeSlider_Callback(hObject, eventdata, handles)
% hObject    handle to timeSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function timeSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timeSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function timeBox_Callback(hObject, eventdata, handles)
% hObject    handle to timeBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of timeBox as text
%        str2double(get(hObject,'String')) returns contents of timeBox as a double


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



function xFunction_Callback(hObject, eventdata, handles)
% hObject    handle to xFunction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xFunction as text
%        str2double(get(hObject,'String')) returns contents of xFunction as a double


% --- Executes during object creation, after setting all properties.
function xFunction_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xFunction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yFunction_Callback(hObject, eventdata, handles)
% hObject    handle to yFunction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yFunction as text
%        str2double(get(hObject,'String')) returns contents of yFunction as a double


% --- Executes during object creation, after setting all properties.
function yFunction_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yFunction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zFunction_Callback(hObject, eventdata, handles)
% hObject    handle to zFunction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zFunction as text
%        str2double(get(hObject,'String')) returns contents of zFunction as a double


% --- Executes during object creation, after setting all properties.
function zFunction_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zFunction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in updateFunctionButton.
function updateFunctionButton_Callback(hObject, eventdata, handles)
% hObject    handle to updateFunctionButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


handles = checkDivisionNumber(handles);
handles = checkCurveDomain(handles);
handles = checkFunctionText(handles);
handles = setFunctions(handles);
handles = createCurve(handles);
drawCurve(handles);

guidata(handles.figure1, handles);

function handles = checkDivisionNumber(handles)
try
    boxString = get(handles.divisionBox, 'String');
    if ~(isa(eval([(boxString) ';']),'double'))
        error('Must be a valid numerical expression.');
    end
    testNum = eval([boxString ';']);
    
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
set(handles.tStartBox, 'String', handles.tStart);
set(handles.tEndBox, 'String', handles.tEnd);

guidata(handles.figure1, handles);

function handles = checkFunctionText(handles)

%dummy test variable
t = 1;
% t = handles.t(1);

%If corresponding text box has invalid code, reset to previous
try
    eval([get(handles.xFunction, 'String') ';'])
    eval(['@(t) ' get(handles.xFunction, 'String') ';']);
    handles.xString = get(handles.xFunction, 'String');
catch err
    set(handles.xFunction, 'String', handles.xString);
    disp(['FUNCTION ERROR: ' err.message])
end

try
    eval([get(handles.yFunction, 'String') ';'])
    eval(['@(t) ' get(handles.yFunction, 'String') ';']);
    handles.yString = get(handles.yFunction, 'String');
catch err
    set(handles.yFunction, 'String', handles.yString);
    disp(['FUNCTION ERROR: ' err.message])
end

try
    eval([get(handles.zFunction, 'String') ';'])
    eval(['@(t) ' get(handles.zFunction, 'String') ';']);
    handles.zString = get(handles.zFunction, 'String');
catch err
    disp(['FUNCTION ERROR: ' err.message])
    set(handles.zFunction, 'String', handles.zString);
end

guidata(handles.figure1, handles);

function handles = setFunctions(handles)
%Sets functions to text

handles.r = eval(['@(t) {' handles.xString ',' handles.yString ',' handles.zString '}']);

guidata(handles.figure1, handles);

function handles = createCurve(handles)
interval = (handles.tEnd-handles.tStart)/handles.divisions;
t = handles.tStart:interval:handles.tEnd;
handles.curve = handles.r(t);

handles.x = cell2mat(handles.curve(1));
handles.y = cell2mat(handles.curve(2));
handles.z = cell2mat(handles.curve(3));

guidata(handles.figure1, handles);

function drawCurve(handles)
plot3(handles.x, handles.y, handles.z);


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
