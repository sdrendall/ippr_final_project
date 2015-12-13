function varargout = fan_filter_tool(varargin)
% FAN_FILTER_TOOL MATLAB code for fan_filter_tool.fig
%      FAN_FILTER_TOOL, by itself, creates a new FAN_FILTER_TOOL or raises the existing
%      singleton*.
%
%      H = FAN_FILTER_TOOL returns the handle to a new FAN_FILTER_TOOL or the handle to
%      the existing singleton*.
%
%      FAN_FILTER_TOOL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FAN_FILTER_TOOL.M with the given input arguments.
%
%      FAN_FILTER_TOOL('Property','Value',...) creates a new FAN_FILTER_TOOL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fan_filter_tool_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fan_filter_tool_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fan_filter_tool

% Last Modified by GUIDE v2.5 12-Dec-2015 21:45:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fan_filter_tool_OpeningFcn, ...
                   'gui_OutputFcn',  @fan_filter_tool_OutputFcn, ...
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


% --- Executes just before fan_filter_tool is made visible.
function fan_filter_tool_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to fan_filter_tool (see VARARGIN)

    % Choose default command line output for fan_filter_tool
    handles.output = hObject;

    % Create Orientation Analysis Object
    handles.orientation_analyzer = OrientationAnalysis();
    handles = set_defaults(handles);

    % Create Fan Filter Modes
    handles.filter_modes = struct( ...
        'ideal', 'Ideal Fan', ...
        'iterative', 'Iterative Fan' ...
    );
    
    set(handles.filter_select_menu, 'String', struct2cell(handles.filter_modes));

    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes fan_filter_tool wait for user response (see UIRESUME)
    % uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = fan_filter_tool_OutputFcn(hObject, eventdata, handles) 
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles.output;


% --- Executes on button press in load_image_button.
function load_image_button_Callback(hObject, eventdata, handles)
    % hObject    handle to load_image_button (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    handles = load_image(handles);
    handles = recompute_orientation(handles);
    handles = recompute_filter(handles);
    handles = recompute_filtered_image(handles);
    refresh_display(handles);

    guidata(hObject, handles);


% --- Executes on button press in save_filtered_image_button.
function save_filtered_image_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_filtered_image_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    [filename, directory] = uiputfile(fullfile(pwd, '*.*'), 'Save Filtered Image');
    save_path = fullfile(directory, filename);
    imwrite(handles.filtered_image, save_path);

% --- Executes on button press in save_filter_button.
function save_filter_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_filter_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    [filename, directory] = uiputfile(fullfile(pwd, '*.mat'), 'Save Filter');
    save_path = fullfile(directory, filename);
    fan_filter = handles.filter;
    save(save_path, 'fan_filter');


% --- Executes on button press in generate_filter_button.
function generate_filter_button_Callback(hObject, eventdata, handles)
    % hObject    handle to generate_filter_button (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    handles = recompute_filter(handles);
    handles = recompute_filtered_image(handles);
    refresh_display(handles);

    guidata(hObject, handles);


function r_low_text_Callback(hObject, eventdata, handles)
% hObject    handle to r_low_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of r_low_text as text
%        str2double(get(hObject,'String')) returns contents of r_low_text as a double


% --- Executes during object creation, after setting all properties.
function r_low_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to r_low_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function r_high_text_Callback(hObject, eventdata, handles)
% hObject    handle to r_high_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of r_high_text as text
%        str2double(get(hObject,'String')) returns contents of r_high_text as a double


% --- Executes during object creation, after setting all properties.
function r_high_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to r_high_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function theta_low_text_Callback(hObject, eventdata, handles)
% hObject    handle to theta_low_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of theta_low_text as text
%        str2double(get(hObject,'String')) returns contents of theta_low_text as a double


% --- Executes during object creation, after setting all properties.
function theta_low_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to theta_low_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function theta_high_text_Callback(hObject, eventdata, handles)
% hObject    handle to theta_high_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of theta_high_text as text
%        str2double(get(hObject,'String')) returns contents of theta_high_text as a double


% --- Executes during object creation, after setting all properties.
function theta_high_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to theta_high_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gauss_var1_text_Callback(hObject, eventdata, handles)
% hObject    handle to gauss_var1_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gauss_var1_text as text
%        str2double(get(hObject,'String')) returns contents of gauss_var1_text as a double


% --- Executes during object creation, after setting all properties.
function gauss_var1_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gauss_var1_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gauss_var2_text_Callback(hObject, eventdata, handles)
% hObject    handle to gauss_var2_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gauss_var2_text as text
%        str2double(get(hObject,'String')) returns contents of gauss_var2_text as a double


% --- Executes during object creation, after setting all properties.
function gauss_var2_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gauss_var2_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in compute_orientations_button.
function compute_orientations_button_Callback(hObject, eventdata, handles)
    % hObject    handle to compute_orientations_button (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    handles = recompute_orientation(handles);
    refresh_display(handles);

    guidata(hObject, handles);


% --- Executes when selected object is changed in filter_display_button_group.
function filter_display_button_group_SelectionChangedFcn(hObject, eventdata, handles)
    % hObject    handle to the selected object in filter_display_button_group 
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    refresh_filter_window(handles)


% --- Executes on selection change in filter_select_menu.
function filter_select_menu_Callback(hObject, eventdata, handles)
% hObject    handle to filter_select_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns filter_select_menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from filter_select_menu


% --- Executes during object creation, after setting all properties.
function filter_select_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filter_select_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% ---------------------------------------------------------------------- %%
%% ---------------------- User Defined Functions ------------------------ %%
%% ---------------------------------------------------------------------- %%
function handles = set_defaults(handles)
    %% handles = set_defaults(handles)
    %
    % Sets the default values for parameters used for filtering
    set(handles.gauss_var1_text, 'String', num2str(2*5^2));
    set(handles.gauss_var2_text, 'String', num2str(2*17.5^2));
    set(handles.r_low_text, 'String', num2str(0));
    set(handles.r_high_text, 'String', num2str(1));
    set(handles.theta_low_text, 'String', num2str(45));
    set(handles.theta_high_text, 'String', num2str(90));


function handles = load_image(handles)
    %% handles = load_image(handles)
    %
    % Prompts user for an image path then loads the specified image
    [filename, directory] = uigetfile(fullfile(pwd, '*.*'), 'Please Select an Image File');
    image_path = fullfile(directory, filename);

    im = imread(image_path);
    if (size(im, 3) == 3) 
        im = rgb2gray(im);
    end
    
    handles.image = mat2gray(im);
    

function handles = recompute_orientation(handles)
    %% handles = recompute_orientation(handles)
    %
    % Recomputes the orientation information in the stored image
    gauss_var1 = str2double(get(handles.gauss_var1_text, 'String'));
    gauss_var2 = str2double(get(handles.gauss_var2_text, 'String'));

    handles.orientation_analyzer.setImage(handles.image);
    handles.orientation_analyzer.setGaussianFilter(gauss_var1, gauss_var2);
    handles.orientation_vector = handles.orientation_analyzer.computeRadonPeaks();


function handles = recompute_filter(handles)
    %% handles = recompute_filter(handles)
    %
    % Recomputes the fan filter used to filter the input image
    theta_low = str2double(get(handles.theta_low_text, 'String'));
    theta_high = str2double(get(handles.theta_high_text, 'String'));

    filter_mode = get(handles.filter_select_menu, 'String')
    switch filter_mode
        case handles.filter_modes.ideal
            handles.filter = getFanFilter(size(handles.image), theta_low, theta_high);

        case handles.filter_modes.iterative
            B = 0.8 * pi;
            ripple = inf;
            transition_width = (pi - B)/2;
            max_iter = 1000;
            handles.filter = iterFirFan(theta_low, theta_high, B, size(handles.image), max_iter, ripple, transition_width);
        end


function handles = recompute_filtered_image(handles)
    %% handles = recompute_filtered_image(handles)
    %
    % Recomputes the filtered image using the current fan filter
    IM = fftshift(fft2(handles.image));
    IM = IM .* handles.filter;
    handles.filtered_image = real(ifft2(ifftshift(IM)));


function refresh_display(handles)
    %% refresh_display(handles)
    %
    % Refreshes the images and plots that are displayed on the GUI
    axes(handles.main_window);
    imshow(handles.image);

    refresh_filter_window(handles);

    axes(handles.orientation_window);
    plot(handles.orientation_vector);


function refresh_filter_window(handles)
    %% refresh_filter_window(handles)
    %
    % Displays the appropriate image on the filter display based on the chosen radio button
    axes(handles.filter_window);
    selected_button = get(handles.filter_display_button_group, 'SelectedObject');
    switch get(selected_button, 'Tag')
        case 'show_filtered_image_radio'
            imshow(handles.filtered_image);
        case 'show_filter_kernel_radio'
            imshow(real(fftshift(fft2(handles.filter))));
            colormap('parula')
        case 'show_filter_spectrum_radio'
            imshow(mat2gray(handles.filter));
            colormap('parula')
    end
