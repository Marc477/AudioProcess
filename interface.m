function varargout = interface(varargin)
% INTER M-file for inter.fig
%      INTER, by itself, creates a new INTER or raises the existing
%      singleton*.
%
%      H = INTER returns the handle to a new INTER or the handle to
%      the existing singleton*.
%
%      INTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTER.M with the given input arguments.
%
%      INTER('Property','Value',...) creates a new INTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before inter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to inter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help inter

% Last Modified by GUIDE v2.5 25-Dec-2014 18:40:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @inter_OpeningFcn, ...
                   'gui_OutputFcn',  @inter_OutputFcn, ...
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


% --- Executes just before inter is made visible.
function inter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to inter (see VARARGIN)

% Choose default command line output for inter
handles.output = hObject;

handles.fs = 22050;
handles.fsRecord = 22050;
handles.nBit = 16;
handles.rSelect = 0;
handles.sound = 0;
handles.soundOutput = 0;
handles.isComputed = 0;
handles.recObj = audiorecorder(handles.fsRecord, handles.nBit,1);

%Notes
handles.notes = [65 69 73 78 82 87 92 98 104 110 117 123 131 139 147 156 165 175 185 196 208 220 233 247 262 277 294 311 330 349 370 392 415 440 466 494 523 554 587 622 659 698 740 784 830 880 932 988 1046];

%Darth vader load
[handles.vaderSound handles.vaderFs] = wavread('samples/darthvader.wav');
[handles.chewSound handles.chewFs] = wavread('samples/chewbacca.wav');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes inter wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function resetControl(hObject, handles)
set(handles.sTime,'Value', 0);
set(handles.sPitch, 'Value', 0);
set(handles.sDelay, 'Value', 0);
set(handles.sDelayTime, 'Value', 0);
set(handles.sReverb, 'Value', 0);
set(handles.sWahwah, 'Value', 0);
set(handles.cbTune, 'Value', 0);
set(handles.cbReverse, 'Value', 0);
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = inter_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in bRecord.
function bRecord_Callback(hObject, eventdata, handles)
% hObject    handle to bRecord (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isrecording(handles.recObj)
    stop(handles.recObj);
    handles.sound = getaudiodata(handles.recObj);
    handles.isComputed = 0;
    plot(handles.graphIn, handles.sound);
    ylim(handles.graphIn, [-1, 1]);
else
    handles.fs = handles.fsRecord;
    record(handles.recObj);
end
guidata(hObject, handles);

% --- Executes on button press in bStop.
function bStop_Callback(hObject, eventdata, handles)
% hObject    handle to bStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isrecording(handles.recObj)
    stop(handles.recObj);
    handles.sound = getaudiodata(handles.recObj);
    handles.isComputed = 0;
    plot(handles.graphIn, handles.sound);
    ylim(handles.graphIn, [-1, 1]);
end
clear playsnd; %Stop the sound being played
guidata(hObject, handles);

% --- Executes on button press in bPlay.
function bPlay_Callback(hObject, eventdata, handles)
% hObject    handle to bPlay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%player = audioplayer(handles.recObj);
%play(player);
clear playsnd;
sound(handles.sound,handles.fs,handles.nBit);

% --- Executes on button press in bSave.
function bSave_Callback(hObject, eventdata, handles)
% hObject    handle to bSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isrecording(handles.recObj)
else
    if length(handles.sound) > 1
        wavwrite(handles.sound,handles.fs,handles.nBit,'input.wav');
    else
        handles.sound = wavread('input.wav');
        plot(handles.graphIn, handles.sound);
        ylim(handles.graphIn, [-1, 1]);
        guidata(hObject, handles);
    end
end

% --- Executes on button press in bStopOut.
function bStopOut_Callback(hObject, eventdata, handles)
% hObject    handle to bStopOut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear playsnd; %Stop the sound being played

% --- Executes on button press in bPlayOut.
function bPlayOut_Callback(hObject, eventdata, handles)
% hObject    handle to bPlayOut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear playsnd;
if(handles.isComputed == 0)
    set(handles.bPlayOut,'Enable','off');
    set(handles.bSaveOut,'Enable','off');
    set(handles.bStopOut,'Enable','off');
    set(handles.tMessage,'String','Computing...');
    drawnow;
    handles.isComputed = 1;
    handles.soundOutput = analyse(handles.sound,handles);
    plot(handles.graphOut, handles.soundOutput);
    ylim(handles.graphOut, [-1, 1]);
    axes(handles.graphHisto);
    stft(handles.soundOutput, 1024, 1024, 256, handles.fs);
    set(handles.bPlayOut,'Enable','on');
    set(handles.bSaveOut,'Enable','on');
    set(handles.bStopOut,'Enable','on');
    set(handles.tMessage,'String','');
    guidata(hObject, handles);
end
sound(handles.soundOutput,handles.fs,handles.nBit);

% --- Executes on button press in bSaveOut.
function bSaveOut_Callback(hObject, eventdata, handles)
% hObject    handle to bSaveOut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isrecording(handles.recObj)
else
    wavwrite(handles.soundOutput,handles.fs,handles.nBit,'output.wav');
end

% --- Executes on slider movement.
function sTime_Callback(hObject, eventdata, handles)
% hObject    handle to sTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.isComputed = 0;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function sTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sPitch_Callback(hObject, eventdata, handles)
% hObject    handle to sPitch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.isComputed = 0;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function sPitch_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sPitch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sDelay_Callback(hObject, eventdata, handles)
% hObject    handle to sDelay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.isComputed = 0;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function sDelay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sDelay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function sDelayTime_Callback(hObject, eventdata, handles)
% hObject    handle to sDelayTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.isComputed = 0;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function sDelayTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sDelayTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sWahwah_Callback(hObject, eventdata, handles)
% hObject    handle to sWahwah (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.isComputed = 0;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function sWahwah_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sWahwah (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function sReverb_Callback(hObject, eventdata, handles)
% hObject    handle to sReverb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.isComputed = 0;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function sReverb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sReverb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes when selected object is changed in rButtonGroup.
function rButtonGroup_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in rButtonGroup 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

switch get(get(handles.rButtonGroup,'SelectedObject'),'Tag')
    case 'rDarth',  handles.rSelect = 1;
    case 'rChew',  handles.rSelect = 2;
    case 'rR2',  handles.rSelect = 3;
    otherwise, handles.rSelect = 0;
end

%Preset
resetControl(hObject,handles);
handles.isComputed = 0;

%Preset Darth Vader
if handles.rSelect == 1;
    set(handles.sPitch, 'Value', -0.4);
    set(handles.sReverb, 'Value', 0.3);
end

if handles.rSelect == 2;
    set(handles.sTime,'Value', -0.2);
end

if handles.rSelect == 3;
    set(handles.sPitch, 'Value', 0.1);
end
guidata(hObject, handles);
    


% --- Executes on slider movement.
function sTune_Callback(hObject, eventdata, handles)
% hObject    handle to sTune (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
tuneValue = get(handles.sTune, 'Value');
set(handles.tTune, 'String', handles.notes(floor(tuneValue*49)+1));
handles.isComputed = 0;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function sTune_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sTune (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in cbTune.
function cbTune_Callback(hObject, eventdata, handles)
% hObject    handle to cbTune (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbTune
handles.isComputed = 0;
guidata(hObject, handles);


function tLoad_Callback(hObject, eventdata, handles)
% hObject    handle to tLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tLoad as text
%        str2double(get(hObject,'String')) returns contents of tLoad as a double


% --- Executes during object creation, after setting all properties.
function tLoad_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bLoad.
function bLoad_Callback(hObject, eventdata, handles)
% hObject    handle to bLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear playsnd; %Stop the sound being played
handles.LoadFileName = get(handles.tLoad, 'String');

[loadSound, sr] = wavread( handles.LoadFileName );
if isrecording(handles.recObj)
    stop(handles.recObj);
end
handles.sound = loadSound(:,1);
handles.fs = sr;
handles.isComputed = 0;
plot(handles.graphIn, handles.sound);
ylim(handles.graphIn, [-1, 1]);
guidata(hObject, handles);

% --- Executes on slider movement.
function sMinMax_Callback(hObject, eventdata, handles)
% hObject    handle to sMinMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.isComputed = 0;
set(handles.tMinFreq,'String', floor(100-get(handles.sMinMax, 'Value')*100));
set(handles.tMaxFreq,'String', floor(get(handles.sMinMax, 'Value')*1000));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function sMinMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sMinMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in cbReverse.
function cbReverse_Callback(hObject, eventdata, handles)
% hObject    handle to cbReverse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbReverse
handles.isComputed = 0;
guidata(hObject, handles);
