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

% Last Modified by GUIDE v2.5 10-May-2014 00:33:11

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




%============== Setup Functions

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

% Initialize Timer
handles.tRate = 1;
handles.timer = timer('ExecutionMode', 'fixedRate', ...
    'Period', 1/5, ...
    'TimerFcn', @updateTimer);


% Initialize Cursor
handles.cursorObj = datacursormode(handles.figure1);
set(handles.cursorObj, 'UpdateFcn', @displayDataPoint);

% Check and add uibutton folder
if ~(exist('uibutton')==7 || exist('uibutton', 'dir'))
    error('Must have uibutton program added!');
else
    addpath('uibutton');
end

% Creating Integral Texts
handles.scalarIntLabel = uibutton(handles.scalarIntLabel, ...
    'Interpreter', 'LaTex', ...
    'String', '$$\int\limits_C \! f(x,y,z) \, dS = $$', ...
    'FontSize', 14);
handles.vectorIntLabel = uibutton(handles.vectorIntLabel, ...
    'Interpreter', 'LaTex', ...
    'String', '$$\int\limits_C \! \vec{F}(x,y,z) \cdot  \, d \vec{r} = $$', ...
    'FontSize', 14);

% Help text
set(handles.gridToggle, 'TooltipString', 'Toggle Grid Display');



handles = initialPlot(handles);

% Update handles structure
guidata(hObject, handles);


function handles = initialPlot(handles)
handles = checkDivisionNumber(handles);
handles = checkCurveDomain(handles);
handles = checkFunctionText(handles);
handles = setFunctions(handles);
handles = createCurve(handles);

% Plot Point Initially
handles.point = (handles.r(handles.tPoint));
handles.pointPlot = plot3(handles.bigGraph, handles.point(1), ...
    handles.point(2),  handles.point(3),'o','Color','red');

set(handles.bigGraph, 'NextPlot', 'add');

% Plot Curve Initially
t = getTimeVector;
curve = zeros(3,length(t));
for i = 1:length(t)
    curve(:,i) = handles.r(t(i));
end
x = curve(1,:);
y = curve(2,:);
z = curve(3,:);
handles.curvePlot = plot3(handles.bigGraph, x, y, z);


% Plot Vectors Initially (using dummy values)
handles.positionPlot = plot3(handles.bigGraph, ...
    0:0.5:1, 0:0.5:1, 0:0.5:1, '-.r');
handles.velocityPlot = plot3(handles.bigGraph, ...
    0:0.5:1, 0:0.5:1, 0:0.5:1, '-.r');
handles.accelerationPlot = plot3(handles.bigGraph, ...
    0:0.5:1, 0:0.5:1, 0:0.5:1, '-.r');

handles.tangentPlot = plot3(handles.bigGraph, ...
    0:0.5:1, 0:0.5:1, 0:0.5:1, '--g');
handles.normalPlot = plot3(handles.bigGraph, ...
    0:0.5:1, 0:0.5:1, 0:0.5:1, '--g');
handles.binormalPlot = plot3(handles.bigGraph, ...
    0:0.5:1, 0:0.5:1, 0:0.5:1, '--g');

set(handles.positionPlot, 'Visible', 'off');
set(handles.velocityPlot, 'Visible', 'off');
set(handles.accelerationPlot, 'Visible', 'off');
set(handles.tangentPlot, 'Visible', 'off');
set(handles.normalPlot, 'Visible', 'off');
set(handles.binormalPlot, 'Visible', 'off');

guidata(handles.figure1, handles);



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





%============== Component Callbacks

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



function xBox_Callback(hObject, eventdata, handles)
% hObject    handle to xBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xBox as text
%        str2double(get(hObject,'String')) returns contents of xBox as a double
if(isempty(get(hObject, 'String')))
    set(hObject, 'String', char(handles.xFunction));
end


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
if(isempty(get(hObject, 'String')))
    set(hObject, 'String', char(handles.yFunction));
end

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
if(isempty(get(hObject, 'String')))
    set(hObject, 'String', char(handles.zFunction));
end

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

calculateArcLength(handles);

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
    errordlg(['ERROR SETTING TIME VALUE: ' err.message], ...
        'Input Error', 'modal');
end

handles.tPoint = eval([get(handles.timeBox, 'String') ';']);
set(handles.timeBox, 'String', handles.tPoint);
set(handles.timeSlider, 'Value', handles.tPoint);

calculateArcLength(handles);

updateGraph(handles);

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
function gridToggle_OnCallback(hObject, eventdata, handles)
% hObject    handle to gridToggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
grid(handles.bigGraph, 'on');


% --------------------------------------------------------------------
function gridToggle_OffCallback(hObject, eventdata, handles)
% hObject    handle to gridToggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
grid(handles.bigGraph, 'off');


% --- Executes on button press in revertButton.
function revertButton_Callback(hObject, eventdata, handles)
% hObject    handle to revertButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.xBox, 'String', char(handles.xFunction));
set(handles.yBox, 'String', char(handles.yFunction));
set(handles.zBox, 'String', char(handles.zFunction));
set(handles.tStartBox, 'String', handles.tStart);
set(handles.tEndBox, 'String', handles.tEnd);
set(handles.divisionBox, 'String', handles.divisions);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes on button press in positionLabel.
function positionLabel_Callback(hObject, eventdata, handles)
% hObject    handle to positionLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of positionLabel
updateGraph(handles);
if(get(hObject, 'Value'))
    set(hObject, 'ForegroundColor', 'White');
    set(handles.positionPlot, 'Visible', 'on');
else
    set(hObject, 'ForegroundColor', 'Black');
    set(handles.positionPlot, 'Visible', 'off');
end

% --- Executes on button press in velocityLabel.
function velocityLabel_Callback(hObject, eventdata, handles)
% hObject    handle to velocityLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of velocityLabel
updateGraph(handles);
if(get(hObject, 'Value'))
    set(hObject, 'ForegroundColor', 'White');
    set(handles.velocityPlot, 'Visible', 'on');
else
    set(hObject, 'ForegroundColor', 'Black');
    set(handles.velocityPlot, 'Visible', 'off');
end


% --- Executes on button press in accelerationLabel.
function accelerationLabel_Callback(hObject, eventdata, handles)
% hObject    handle to accelerationLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of accelerationLabel
updateGraph(handles);
if(get(hObject, 'Value'))
    set(hObject, 'ForegroundColor', 'White');
    set(handles.accelerationPlot, 'Visible', 'on');
else
    set(hObject, 'ForegroundColor', 'Black');
    set(handles.accelerationPlot, 'Visible', 'off');
end


% --- Executes on button press in tangentLabel.
function tangentLabel_Callback(hObject, eventdata, handles)
% hObject    handle to tangentLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tangentLabel
updateGraph(handles);
if(get(hObject, 'Value'))
    set(hObject, 'ForegroundColor', 'White');
    set(handles.tangentPlot, 'Visible', 'on');
else
    set(hObject, 'ForegroundColor', 'Black');
    set(handles.tangentPlot, 'Visible', 'off');
end

% --- Executes on button press in normalLabel.
function normalLabel_Callback(hObject, eventdata, handles)
% hObject    handle to normalLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of normalLabel
updateGraph(handles);
if(get(hObject, 'Value'))
    set(hObject, 'ForegroundColor', 'White');
    set(handles.normalPlot, 'Visible', 'on');
else
    set(hObject, 'ForegroundColor', 'Black');
    set(handles.normalPlot, 'Visible', 'off');
end

% --- Executes on button press in binormalLabel.
function binormalLabel_Callback(hObject, eventdata, handles)
% hObject    handle to binormalLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of binormalLabel
updateGraph(handles);
if(get(hObject, 'Value'))
    set(hObject, 'ForegroundColor', 'White');
    set(handles.binormalPlot, 'Visible', 'on');
else
    set(hObject, 'ForegroundColor', 'Black');
    set(handles.binormalPlot, 'Visible', 'off');
end


% --- Executes on selection change in integralType.
function integralType_Callback(hObject, eventdata, handles)
% hObject    handle to integralType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns integralType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from integralType

% If first index, show scalar Function panel
if(get(hObject, 'Value') == 1)
    set(handles.scalarFunctionPanel, 'Visible', 'on');
    set(handles.vectorFieldPanel, 'Visible', 'off');
else
    set(handles.scalarFunctionPanel, 'Visible', 'off');
    set(handles.vectorFieldPanel, 'Visible', 'on');
end

% --- Executes during object creation, after setting all properties.
function integralType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to integralType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function scalarFuncText_Callback(hObject, eventdata, handles)
% hObject    handle to scalarFuncText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of scalarFuncText as text
%        str2double(get(hObject,'String')) returns contents of scalarFuncText as a double


% --- Executes during object creation, after setting all properties.
function scalarFuncText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scalarFuncText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in scalarIntSolve.
function scalarIntSolve_Callback(hObject, eventdata, handles)
% hObject    handle to scalarIntSolve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

t = sym('t');

%If corresponding text box has invalid code, reset to previous
funcText = get(handles.scalarFuncText, 'String');
if(isempty(funcText))
    set(handles.scalarFuncText, 'String', 0);
    set(handles.scalarIntAns, 'String', 0);
    return;
end

try
    
    variables = symvar(funcText);
    if ~isempty(variables)
        x = handles.xFunction;
        y = handles.yFunction;
        z = handles.zFunction;
        
        % Check for valid variables, if valid, replace with the function string
        for(i=1:length(variables))
            variable = variables{i};
            
            if ~strcmp(variable, 'x') ...
                    && ~strcmp(variable, 'y') ...
                    && ~strcmp(variable, 'z')
                
                error(['FUNCTION ERROR: ' ...
                    variable ' is not a valid variable. ' ...
                    'The formula can only have x, y, z or constants.'])
            end
        end
        
    end
    
    scalarFunction = eval(funcText) * norm(handles.velocity);
    
    if(scalarFunction ~= 0)
        % Solve line integral numerically
        value = integral(matlabFunction(scalarFunction, 'vars', 't'), ...
            handles.tStart, handles.tEnd, ...
            'ArrayValued', true);
        
        if(exactValuesActivated(handles))
            % Solving equation, set busy
            exactAnswer = int(scalarFunction, t, handles.tStart, handles.tEnd);
        end
        
    else
        value = 0;
        if(exactValuesActivated(handles))
            exactAnswer = 0;
        end
    end
    
    set(handles.scalarIntAns, 'String', value);
    if(exactValuesActivated(handles))
        set(handles.scalarIntAns, 'ToolTipString', ...
            ['Exact Answer: ' char(exactAnswer)]);
    else
        set(handles.scalarIntAns, 'ToolTipString', ...
            '');
    end
    
catch err
    errordlg(err.message, 'Solving Error', 'modal');
    set(handles.scalarIntAns, 'String', 'N/A');
end



guidata(handles.figure1, handles);



function iCompText_Callback(hObject, eventdata, handles)
% hObject    handle to iCompText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of iCompText as text
%        str2double(get(hObject,'String')) returns contents of iCompText as a double


% --- Executes during object creation, after setting all properties.
function iCompText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to iCompText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in vectorIntSolve.
function vectorIntSolve_Callback(hObject, eventdata, handles)
% hObject    handle to vectorIntSolve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

t = sym('t');
x = handles.xFunction;
y = handles.yFunction;
z = handles.zFunction;

componentHandles = {handles.iCompText; handles.jCompText; handles.kCompText};

try
    
    for i = 1:3
        %If corresponding text box has invalid code, reset to previous
        funcText = get(componentHandles{i}, 'String');
        
        if(isempty(funcText))
            set(componentHandles{i}, 'String', 0);
            continue;
        end
        
        variables = symvar(funcText);
        if ~isempty(variables)
            
            
            % Check for valid variables, if valid, replace with the function string
            for(i=1:length(variables))
                variable = variables{i};
                
                if ~strcmp(variable, 'x') ...
                        && ~strcmp(variable, 'y') ...
                        && ~strcmp(variable, 'z')
                    
                    errordlg(['FUNCTION ERROR: ' ...
                        variable ' is not a valid variable. ' ...
                        'The formula can only have x, y, z or constants.'], ...
                        'Input Error', 'modal');
                    return;
                end
            end
            
        end
        
    end
    
    vector = ['[ ' get(handles.iCompText, 'String') ';' ...
        get(handles.jCompText, 'String') ';' ...
        get(handles.kCompText, 'String') ']'];
    vectorFunction = dot(eval(vector),handles.velocity);
    
    if(vectorFunction ~= 0)
        % Solve line integral numerically
        value = integral(matlabFunction(vectorFunction, 'vars', 't'), ...
            handles.tStart, handles.tEnd, ...
            'ArrayValued', true);
        
        if(exactValuesActivated(handles))
            % Solving equation, set busy
            exactAnswer = int(vectorFunction, t, handles.tStart, handles.tEnd);
        end
    else
        value = 0;
        
        if(exactValuesActivated(handles))
            exactAnswer = 0;
        end
    end
    
    set(handles.vectorIntAns, 'String', value);
    
    if(exactValuesActivated(handles))
        set(handles.vectorIntAns, 'ToolTipString', ...
            ['Exact Answer: ' char(exactAnswer)]);
    else
        set(handles.vectorIntAns, 'ToolTipString', '');
    end
    
catch err
    errordlg(err.message, 'Solving Error', 'modal')
    set(handles.vectorIntAns, 'String', 'N/A');
end

guidata(handles.figure1, handles);


function jCompText_Callback(hObject, eventdata, handles)
% hObject    handle to jCompText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of jCompText as text
%        str2double(get(hObject,'String')) returns contents of jCompText as a double


% --- Executes during object creation, after setting all properties.
function jCompText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to jCompText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function kCompText_Callback(hObject, eventdata, handles)
% hObject    handle to kCompText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kCompText as text
%        str2double(get(hObject,'String')) returns contents of kCompText as a double


% --- Executes during object creation, after setting all properties.
function kCompText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kCompText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in toScaleButton.
function toScaleButton_Callback(hObject, eventdata, handles)
% hObject    handle to toScaleButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toScaleButton
if(get(hObject,'Value') == true)
    axis(handles.bigGraph, 'equal');
    set(hObject, 'ForegroundColor', 'White');
else
    axis(handles.bigGraph, 'normal');
    set(hObject, 'ForegroundColor', 'Black');
end

guidata(handles.figure1, handles);



function rateText_Callback(hObject, eventdata, handles)
% hObject    handle to rateText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rateText as text
%        str2double(get(hObject,'String')) returns contents of rateText as a double

try
    boxFunction = get(hObject, 'String');
    if ~(isa(eval([(boxFunction) ';']),'double'))
        error('Must be a valid numerical expression.');
    end
    testNum = eval([boxFunction ';']);
    
    %if number is within domain
    if(testNum <= 0)
        error('Value must be positive!');
    end
catch err
    set(hObject, 'String', handles.tRate);
    errordlg(['ERROR SETTING RATE VALUE: ' err.message], 'Input Error', 'modal');
end

handles.tRate = eval([get(hObject, 'String') ';']);
set(hObject, 'String', handles.tRate);
guidata(handles.figure1, handles);


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


% --- Executes on button press in playButton.
function playButton_Callback(hObject, eventdata, handles)
% hObject    handle to playButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(handles.timer, 'Running'), 'off')
    set(handles.playButton, 'String', 'Stop');
    start(handles.timer);
else
    stop(handles.timer);
    set(handles.playButton, 'String', 'Play');
end
guidata(handles.figure1, handles);

% --- Executes on button press in resetButton.
function resetButton_Callback(hObject, eventdata, handles)
% hObject    handle to resetButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.tPoint = handles.tStart;
handles = updateTPoint(handles);
drawPoint(handles);
drawMotionVectorsAt(handles.tPoint, handles);
drawUnitVectorsAt(handles.tPoint, handles);
stop(handles.timer);
set(handles.playButton, 'String', 'Play');
guidata(handles.figure1, handles);


% --- Executes on button press in exactValues.
function exactValues_Callback(hObject, eventdata, handles)
% hObject    handle to exactValues (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of exactValues
calculateArcLength(handles);
calculateCurveLength(handles);

if(get(hObject,'Value') == true)
    set(hObject, 'ForegroundColor', 'White');
else
    set(hObject, 'ForegroundColor', 'Black');
end

function answer = exactValuesActivated(handles)
answer = get(handles.exactValues, 'Value');






%============== Update Callbacks

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

calculateArcLength(handles);

guidata(handles.figure1, handles);


function updateGraph(handles)
% If position display is enabled
drawCurve(handles);

drawPoint(handles);
drawMotionVectorsAt(handles.tPoint, handles);
drawUnitVectorsAt(handles.tPoint, handles);

guidata(handles.figure1, handles);


function updateTimer(object, eventdata)
hfigure = getappdata(0, 'CurvePlotter3D');
handles = guidata(hfigure);
if(handles.tPoint + handles.tRate/5 <= handles.tEnd)
    handles.tPoint = handles.tPoint + handles.tRate/5;
    handles = updateTPoint(handles);
    drawPoint(handles);
    drawMotionVectorsAt(handles.tPoint, handles);
    drawUnitVectorsAt(handles.tPoint, handles);
    drawnow;
else
    stop(handles.timer);
    set(handles.playButton, 'String', 'Play');
end
guidata(handles.figure1, handles);






%============== Checking Functions

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
    errordlg(['ERROR SETTING NUMBER OF DIVISIONS: ' err.message], ...
        'Input Error', 'modal');
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
    errordlg(['INTERVAL ERROR: ' err.message], ...
        'Input Error', 'modal');
end

handles.tStart = eval([get(handles.tStartBox, 'String') ';']);
handles.tEnd = eval([get(handles.tEndBox, 'String') ';']);
handles.tPoint = handles.tStart;
set(handles.tStartBox, 'String', handles.tStart);
set(handles.tEndBox, 'String', handles.tEnd);

guidata(handles.figure1, handles);

function handles = checkFunctionText(handles)

syms('t');

xVars = symvar(get(handles.xBox, 'String'));
yVars = symvar(get(handles.yBox, 'String'));
zVars = symvar(get(handles.zBox, 'String'));

try
    
    if(isempty(xVars) && isempty(yVars) && isempty(zVars))
        set(handles.xBox, 'String', char(handles.xFunction));
        set(handles.yBox, 'String', char(handles.yFunction));
        set(handles.zBox, 'String', char(handles.zFunction));
        error(['Curve cannot be a constant point.']);
    end
    
    %If corresponding text box has invalid code, reset to previous
    
    if isempty(xVars) || (strcmp(xVars{1},'t') && length(xVars) == 1)
        handles.xFunction = sym(get(handles.xBox, 'String'));
    else
        set(handles.xBox, 'String', char(handles.xFunction));
        error(['The formula must only have t as the variable.']);
    end
    
    
    if isempty(yVars) || (strcmp(yVars{1},'t') && length(yVars) == 1)
        handles.yFunction = sym(get(handles.yBox, 'String'));
    else
        set(handles.yBox, 'String', char(handles.yFunction));
        error(['The formula must only have t as the variable.']);
    end
    
    
    if isempty(zVars) || (strcmp(zVars{1},'t') && length(zVars) == 1)
        handles.zFunction = sym(get(handles.zBox, 'String'));
    else
        set(handles.zBox, 'String', char(handles.zFunction));
        error(['The formula must only have t as the variable.']);
    end
    
catch err
    errordlg(['FUNCTION ERROR: ' err.message], ...
        'Input Error', 'modal');
end

guidata(handles.figure1, handles);






%============== Setting Functions

function handles = setFunctions(handles)

% Sets functions to text

handles.curve = [handles.xFunction; handles.yFunction; handles.zFunction];

% Motion Vectors' text

handles.velocity = diff(handles.curve);
handles.acceleration = diff(handles.velocity);

set(handles.positionText, 'String', ...
    ['< ' char(handles.xFunction) ', '...
    char(handles.yFunction) ', ' ...
    char(handles.zFunction) ' >']);
set(handles.velocityText, 'String', ...
    ['< ' char(handles.velocity(1)) ', '...
    char(handles.velocity(2)) ', ' ...
    char(handles.velocity(3)) ' >']);
set(handles.accelerationText, 'String', ...
    ['< ' char(handles.acceleration(1)) ', '...
    char(handles.acceleration(2)) ', ' ...
    char(handles.acceleration(3)) ' >']);

help = sprintf('i: %s\nj: %s\nk: %s', ...
    char(handles.xFunction), ...
    char(handles.yFunction), ...
    char(handles.zFunction));
set(handles.positionText, 'ToolTipString', help);
help = sprintf('i: %s\nj: %s\nk: %s', ...
    char(diff(handles.xFunction)), ...
    char(diff(handles.yFunction)), ...
    char(diff(handles.zFunction)));
set(handles.velocityText, 'ToolTipString', help);
help = sprintf('i: %s\nj: %s\nk: %s', ...
    char(diff(handles.xFunction, 2)), ...
    char(diff(handles.yFunction, 2)), ...
    char(diff(handles.zFunction, 2)));
set(handles.accelerationText, 'ToolTipString', help);

if(curveIsLine(handles))
    set(handles.accelerationLabel, 'Enable', 'off');
    set(handles.normalLabel, 'Enable', 'off');
    set(handles.binormalLabel, 'Enable', 'off');
else
    set(handles.accelerationLabel, 'Enable', 'on');
    set(handles.normalLabel, 'Enable', 'on');
    set(handles.binormalLabel, 'Enable', 'on');
end

guidata(handles.figure1, handles);

function handles = calculateCurveLength(handles)

% Calculate curve length
handles.speed = matlabFunction(norm(handles.velocity));

if(curveIsLine(handles))
    length = norm(handles.r(handles.tEnd) - handles.r(handles.tStart));
    
    if(exactValuesActivated(handles))
        position = symfun(handles.curve, sym('t'));
        exactAnswer = norm(position(handles.tEnd)-position(handles.tStart));
    end
else
    length = integral(handles.speed, handles.tStart, handles.tEnd);
    
    if(exactValuesActivated(handles))
        exactAnswer = int(norm(handles.velocity), handles.tStart, handles.tEnd);
    end
end

set(handles.lengthBox, 'String', length);

if(exactValuesActivated(handles))
    set(handles.lengthBox, 'ToolTipString', ...
        ['Exact Answer: ' char(exactAnswer)]);
else
    set(handles.lengthBox, 'ToolTipString', '');
end

function arcLength = calculateArcLength(handles)
if(curveIsLine(handles))
    arcLength = norm(handles.r(handles.tPoint) - handles.r(handles.tStart));
    
    if(exactValuesActivated(handles))
        position = symfun(handles.curve, sym('t'));
        exactAnswer = norm(position(handles.tPoint)-position(handles.tStart));
    end
else
    arcLength = integral(handles.speed, handles.tStart, handles.tPoint);
    
    if(exactValuesActivated(handles))
        exactAnswer = int(norm(handles.velocity), handles.tStart, handles.tPoint);
    end
end
set(handles.arcLengthText, 'String', arcLength);

if(exactValuesActivated(handles))
    set(handles.arcLengthText, 'ToolTipString', ...
        ['Exact Answer: ' char(exactAnswer)]);
else
    set(handles.arcLengthText, 'ToolTipString', '');
end


function handles = createCurve(handles)
t = linspace(handles.tStart, handles.tEnd, handles.divisions+1);
handles.r = matlabFunction(handles.curve);

setappdata(0, 'CurvePlotter3D', gcf);
setappdata(gcf, 'Time', t);

handles = calculateCurveLength(handles);

guidata(handles.figure1, handles);

function drawCurve(handles)
t = getTimeVector;
curve = zeros(3,length(t));
for i = 1:length(t)
    curve(:,i) = handles.r(t(i));
end
x = curve(1,:);
y = curve(2,:);
z = curve(3,:);

set(handles.curvePlot, 'XData', x, 'YData', y, 'ZData', z);


guidata(handles.figure1, handles);





%============== Drawing Functions

function drawPoint(handles)
handles.point = (handles.r(handles.tPoint));
x = handles.point(1);
y = handles.point(2);
z = handles.point(3);

set(handles.pointPlot, 'XData', x, 'YData', y, 'ZData', z);

guidata(handles.figure1, handles);

function drawMotionVectorsAt(time, handles)


if(get(handles.positionLabel, 'Value'))
    rVector = VectorExtendingFrom([0;0;0], handles.r(time));
    set(handles.positionPlot, 'XData', rVector(1,:), ...
        'YData', rVector(2,:), 'ZData', rVector(3,:));
end

if(curveIsLine(handles))
    handles.curvature = 0;
    
    v = matlabFunction(handles.velocity);
    vVector = VectorExtendingFrom(handles.r(time), v());
    if(get(handles.velocityLabel, 'Value'))
        set(handles.velocityPlot, 'XData', vVector(1,:), ...
            'YData', vVector(2,:), 'ZData', vVector(3,:));
    end
else
    v = matlabFunction(handles.velocity);
    vVector = VectorExtendingFrom(handles.r(time), v(time));
    if(get(handles.velocityLabel, 'Value'))
        set(handles.velocityPlot, 'XData', vVector(1,:), ...
            'YData', vVector(2,:), 'ZData', vVector(3,:));
    end
    
    a = matlabFunction(handles.acceleration);
    
    if(isempty(symvar(handles.acceleration)))
        aVector = VectorExtendingFrom(handles.r(time), a());
        
        % Curvature
        handles.curvature = norm(cross(v(time),a()))/(norm(v(time)))^3;
    else
        aVector = VectorExtendingFrom(handles.r(time), a(time));
        % Curvature
        handles.curvature = norm(cross(v(time),a(time)))/(norm(v(time)))^3;
    end
    if(get(handles.accelerationLabel, 'Value'))
        set(handles.accelerationPlot, 'XData', aVector(1,:), ...
            'YData', aVector(2,:), 'ZData', aVector(3,:));
    end
    
    
end

set(handles.curvatureText, 'String', (handles.curvature));


function drawUnitVectorsAt(time, handles)
v = matlabFunction(handles.velocity);
a = matlabFunction(handles.acceleration);

if(curveIsLine(handles))
    T = v();
    T = T/norm(T);
else
    T = v(time);
    T = T/norm(T);
    % perpendicular component of acceleration
    
    if(isempty(symvar(handles.acceleration)))
        N = a() - dot(a(),T);
    else
        N = a(time) - dot(a(time),T);
    end
    N = N/norm(N);
    B = cross(T, N);
    nVector = VectorExtendingFrom(handles.r(time), N);
    bVector = VectorExtendingFrom(handles.r(time), B);
    
    if(get(handles.normalLabel, 'Value'))
        set(handles.normalPlot, 'XData', nVector(1,:), ...
            'YData', nVector(2,:), 'ZData', nVector(3,:));
    end
    if(get(handles.binormalLabel, 'Value'))
        set(handles.binormalPlot, 'XData', bVector(1,:), ...
            'YData', bVector(2,:), 'ZData', bVector(3,:));
    end
end

tVector = VectorExtendingFrom(handles.r(time), T);


if(get(handles.tangentLabel, 'Value'))
    set(handles.tangentPlot, 'XData', tVector(1,:), ...
        'YData', tVector(2,:), 'ZData', tVector(3,:));
end


%============== Helper Functions

function points = VectorExtendingFrom(point, vector)
points = [point, point + vector];


% Checks to see if the curve is a line
function answer = curveIsLine(handles)
answer = all(handles.acceleration == 0);


% A curve is smooth if its second derivative is continuous and non-zero
function answer = curveIsSmooth(handles)
answer = ~(all(handles.velocity == 0) || any(handles.velocity == Inf));


function t = getTimeVector
CurvePlotter3D = getappdata(0, 'CurvePlotter3D');
t = getappdata(CurvePlotter3D, 'Time');


% Sets Datatip Text
function text = displayDataPoint(obj, event_obj)
% Customizes text of data tip
position = get(event_obj, 'Position');
dataIndex = get(event_obj, 'DataIndex');
time = getTimeVector;
text = sprintf('X: %f\nY: %f\nZ: %f\nTime: %f',...
    position(1),...
    position(2),...
    position(3),...
    time(dataIndex));
