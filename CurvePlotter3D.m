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

% Last Modified by GUIDE v2.5 30-Jan-2014 08:49:12

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
