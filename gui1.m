function varargout = gui1(varargin)
% GUI1 MATLAB code for gui1.fig
%      GUI1, by itself, creates a new GUI1 or raises the existing
%      singleton*.
%
%      H = GUI1 returns the handle to a new GUI1 or the handle to
%      the existing singleton*.
%
%      GUI1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI1.M with the given input arguments.
%
%      GUI1('Property','Value',...) creates a new GUI1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui1

% Last Modified by GUIDE v2.5 20-Mar-2015 17:38:17

% Begin initialization code - DO NOT EDIT


gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @gui1_OpeningFcn, ...
    'gui_OutputFcn',  @gui1_OutputFcn, ...
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

% --- Executes just before gui1 is made visible.
function gui1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui1 (see VARARGIN)

%prompt = {'Enter name','Enter colormap name'};
%dlg_title = 'Person details';
%num_lines = 1;
%def = {'20','hsv'};
%answer = inputdlg(prompt,dlg_title,num_lines,def);

[nameSubject, choice, choiceIdx] = choosedialog;
    %disp(choice)
% Change these parameters for each person

start_count = 0;
max_count = 180;
switch(choiceIdx)
     case 1 
         start_count = 0; max_count = 180;
     case 2 
         start_count = 0; max_count = 90;
     case 3 
         start_count = 90; max_count = 180;
     case 4 
         start_count = 180; max_count = 360;
     case 5 
         start_count = 180; max_count = 270;
     case 6 
         start_count = 270; max_count = 360;  
end



% Choose default command line output for gui1
handles.output = hObject;
handles.count = start_count;
handles.max_count = max_count;
handles.name = [nameSubject '_' choice];
handles.logname = ['/home/karthikeyan/Research/rateVideosUbuntu/gui/logFiles/' handles.name '.log' ];
% Load the ratings file
if(exist(['/home/karthikeyan/Research/rateVideosUbuntu/gui/matFiles/' handles.name '.mat']))
    load(['/home/karthikeyan/Research/rateVideosUbuntu/gui/matFiles/' handles.name '.mat']) ;
    handles.ratings = saveRating;
    for check_zeros_ite = start_count+1:max_count
        if(saveRating(check_zeros_ite,:) == [0 0 0 0 0])
            break;
        end
    end
    handles.count = check_zeros_ite - 1;
else
    handles.ratings = zeros(max_count,5);
end
handles.start_log_count = handles.count+1;
handles.start_log_time = datetime('now');
% Load order of videos

load /home/karthikeyan/Research/rateVideosUbuntu/gui/randpermOrder;
handles.randpermOrder = randpermOrder;


% Load the tweets
load /home/karthikeyan/Research/rateVideosUbuntu/gui/tweetsPerson1;
load /home/karthikeyan/Research/rateVideosUbuntu/gui/tweetsPerson2;
handles.tweetsPerson1 = flipud(tweetsPerson1);
handles.tweetsPerson2 = flipud(tweetsPerson2);
% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using gui1.
if strcmp(get(hObject,'Visible'),'off')
    tempImg = imread('/home/karthikeyan/Research/rateVideosUbuntu/gui/openingScreen.png');
    imagesc(tempImg);
end

% UIWAIT makes gui1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


    
    
    % --- Outputs from this function are returned to the command line.
function varargout = gui1_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbuttonReplay.
function pushbuttonReplay_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonReplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(handles.count == 0)
   return; 
end
if(handles.count > handles.max_count)
    return;
end

axes(handles.Video);
cla;

%disp(['Handles.count = ' num2str(handles.count)]);
saveRating = handles.ratings;
save(['/home/karthikeyan/Research/rateVideosUbuntu/gui/matFiles/' handles.name],'saveRating');
%handles.count = handles.count + 1;
guidata(hObject,handles);

vid = VideoReader(['/home/karthikeyan/Research/rateVideosUbuntu/videos/overlayCrfResize/outputCrfRes' num2str(handles.randpermOrder(handles.count)) '.mp4']);
while(hasFrame(vid))
    a = readFrame(vid);
    imagesc(a);
    set(findobj(gcf, 'type','axes'), 'Visible','off');
    pause(0.0001);
end


% --- Executes on button press in pushbuttonReplay.
function pushbuttonNext_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonReplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%disp(handles.count);
if(handles.count >= handles.max_count)
    return;
end

axes(handles.Video);
cla;

%disp(['Handles.count = ' num2str(handles.count)]);
if(handles.count > 0)
    handles.ratings(handles.count,1)
    handles.ratings(handles.count,2)
    handles.ratings(handles.count,3)
    handles.ratings(handles.count,4)
    handles.ratings(handles.count,5)
end
saveRating = handles.ratings;
save(['/home/karthikeyan/Research/rateVideosUbuntu/gui/matFiles/' handles.name],'saveRating');

handles.count = handles.count + 1;
% Set the edits
set(handles.edit1,'string',num2str(handles.ratings(handles.count,1)));
set(handles.edit2,'string',num2str(handles.ratings(handles.count,2)));
set(handles.edit3,'string',num2str(handles.ratings(handles.count,5)));
set(handles.edit4,'string',num2str(handles.ratings(handles.count,3)));
set(handles.edit5,'string',num2str(handles.ratings(handles.count,4)));


guidata(hObject,handles);
set(handles.textTweet,'string',sprintf('%s\n%s',handles.tweetsPerson1{handles.randpermOrder(handles.count)},handles.tweetsPerson2{handles.randpermOrder(handles.count)}));
set(handles.textStatus,'string',sprintf('Viewing video %d out of %d',handles.count,handles.max_count));
vid = VideoReader(['/home/karthikeyan/Research/rateVideosUbuntu/videos/overlayCrfResize/outputCrfRes' num2str(handles.randpermOrder(handles.count)) '.mp4']);
while(hasFrame(vid))
    a = readFrame(vid);
    imagesc(a);
    set(findobj(gcf, 'type','axes'), 'Visible','off');
    pause(0.0001);
end

% --- Executes on button press in pushbuttonReplay.
function pushbuttonPrevious_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonReplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(handles.count <= 1)
   return; 
end

if(handles.count > handles.max_count)
    return;
end

axes(handles.Video);
cla;

%disp(['Handles.count = ' num2str(handles.count)]);
if(handles.count > 0)
    handles.ratings(handles.count,1)
    handles.ratings(handles.count,2)
    handles.ratings(handles.count,3)
    handles.ratings(handles.count,4)
    handles.ratings(handles.count,5)
end
saveRating = handles.ratings;
save(['/home/karthikeyan/Research/rateVideosUbuntu/gui/matFiles/' handles.name],'saveRating');
if(handles.count > 1)
    handles.count = handles.count - 1;
    set(handles.edit1,'string',num2str(handles.ratings(handles.count,1)));
    set(handles.edit2,'string',num2str(handles.ratings(handles.count,2)));
    set(handles.edit3,'string',num2str(handles.ratings(handles.count,5)));
    set(handles.edit4,'string',num2str(handles.ratings(handles.count,3)));
    set(handles.edit5,'string',num2str(handles.ratings(handles.count,4)));
    
    guidata(hObject,handles);
    set(handles.textTweet,'string',sprintf('%s\n%s',handles.tweetsPerson1{handles.randpermOrder(handles.count)},handles.tweetsPerson2{handles.randpermOrder(handles.count)}));
    set(handles.textStatus,'string',sprintf('Viewing video %d out of %d',handles.count,handles.max_count));
    vid = VideoReader(['/home/karthikeyan/Research/rateVideosUbuntu/videos/overlayCrfResize/outputCrfRes' num2str(handles.randpermOrder(handles.count)) '.mp4']);
    while(hasFrame(vid))
        a = readFrame(vid);
        imagesc(a);
        set(findobj(gcf, 'type','axes'), 'Visible','off');
        pause(0.0001);
    end
end








% --------------------------------------------------------------------
%function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
%function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%file = uigetfile('*.fig');
%if ~isequal(file, 0)
%    open(file);
%end

% --------------------------------------------------------------------
%function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
    ['Close ' get(handles.figure1,'Name') '...'],...
    'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
%function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
%function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
%if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%    set(hObject,'BackgroundColor','white');
%end

%set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))', 'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

handles.ratings(handles.count,1) = str2double(get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
handles.ratings(handles.count,2) = str2double(get(hObject,'String'));
guidata(hObject,handles);

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



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
handles.ratings(handles.count,5) = str2double(get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
handles.ratings(handles.count,3) = str2double(get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
handles.ratings(handles.count,4) = str2double(get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonNext.
%function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonNext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbuttonPrevious.
%function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonPrevious (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function text3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function textTweet_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textTweet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function textStatus_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textStatus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
handles.end_log_count = handles.count;
handles.end_log_time = datetime('now');
fid = fopen([handles.logname], 'a');
fprintf(fid, 'Start count = %d ; Start_time =%s  End count = %d End_time = %s Time elapsed = %s\n',... 
    handles.start_log_count, char(handles.start_log_time), handles.end_log_count, ... 
    char(handles.end_log_time), char(handles.end_log_time - handles.start_log_time));
fclose(fid);
delete(hObject);
