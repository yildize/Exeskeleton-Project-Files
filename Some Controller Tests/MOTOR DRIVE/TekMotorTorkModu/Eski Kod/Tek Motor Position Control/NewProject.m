function varargout = NewProject(varargin)
% NEWPROJECT MATLAB code for NewProject.fig
%      NEWPROJECT, by itself, creates a new NEWPROJECT or raises the existing
%      singleton*.
%
%      H = NEWPROJECT returns the handle to a new NEWPROJECT or the handle to
%      the existing singleton*.
%
%      NEWPROJECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NEWPROJECT.M with the given input arguments.
%
%      NEWPROJECT('Property','Value',...) creates a new NEWPROJECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before NewProject_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to NewProject_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help NewProject

% Last Modified by GUIDE v2.5 29-Apr-2019 08:51:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @NewProject_OpeningFcn, ...
                   'gui_OutputFcn',  @NewProject_OutputFcn, ...
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


% --- Executes just before NewProject is made visible.
function NewProject_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to NewProject (see VARARGIN)
handles.initialized=0;
% Choose default command line output for NewProject
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes NewProject wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = NewProject_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% ÝLK MOTOR AYARLARI

% Load Libraries
if ~libisloaded('dxl_x64_c')
    [notfound, warnings] = loadlibrary('dxl_x64_c', 'dynamixel_sdk.h', 'addheader', 'port_handler.h', 'addheader', 'packet_handler.h', 'addheader', 'group_bulk_read.h', 'addheader', 'group_bulk_write.h');
end

GOAL_CURRENT_VALUE = 0; %BETWEEN -2047 and  2047
% Control table address
ADDR_PRO_TORQUE_ENABLE          = 64;          % Control table address is different in Dynamixel model
ADDR_PRO_GOAL_POSITION          = 116;
ADDR_PRO_PRESENT_POSITION       = 132;
ADDR_PRO_OPERATING_MODE         = 11;
ADDR_PRO_GOAL_CURRENT           = 102;
ADDR_PRO_PRESENT_CURRENT        = 126;
ADDR_PRO_PRESENT_VELOCITY       = 128;


% Protocol version
PROTOCOL_VERSION                = 2.0;          % See which protocol version is used in the Dynamixel

% Default setting
DXL_ID                         = 2;            % Dynamixel#1 ID: 1
BAUDRATE                        = 56700;
DEVICENAME                      = 'COM7';       % Check which port is being used on your controller
                                                % ex) Windows: "COM1"   Linux: "/dev/ttyUSB0"

TORQUE_ENABLE                   = 1;            % Value for enabling the torque
TORQUE_DISABLE                  = 0;            % Value for disabling the torque


DXL_MOVING_STATUS_THRESHOLD     = 0;           % Dynamixel moving status threshold

ESC_CHARACTER                   = 'e';          % Key for escaping loop

COMM_SUCCESS                    = 0;            % Communication Success result value
COMM_TX_FAIL                    = -1001;        % Communication Tx Failed

% Initialize PortHandler Structs
% Set the port path
% Get methods and members of PortHandlerLinux or PortHandlerWindows
port_num = portHandler(DEVICENAME);

% Initialize PacketHandler Structs
packetHandler();


dxl_comm_result = COMM_TX_FAIL;           % Communication result



% Open port
if (openPort(port_num))
    fprintf('Succeeded to open the port!\n');
else
    unloadlibrary('dxl_x64_c');
    fprintf('Failed to open the port!\n');
    input('Press any key to terminate...\n');
    return;
end


% Set port baudrate
if (setBaudRate(port_num, BAUDRATE))
    fprintf('Succeeded to change the baudrate!\n');
else
    unloadlibrary('dxl_x86_c');
    fprintf('Failed to change the baudrate!\n');
    input('Press any key to terminate...\n');
    return;
end


                                %% Change Motor Mode
                                % DISABLE Dynamixel#1 Torque TO CHANGE MODE
                                write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
                                if getLastTxRxResult(port_num, PROTOCOL_VERSION) ~= COMM_SUCCESS
                                    printTxRxResult(PROTOCOL_VERSION, getLastTxRxResult(port_num, PROTOCOL_VERSION));
                                elseif getLastRxPacketError(port_num, PROTOCOL_VERSION) ~= 0
                                    printRxPacketError(PROTOCOL_VERSION, getLastRxPacketError(port_num, PROTOCOL_VERSION));
                                else
                                    fprintf('Dynamixel has been successfully connected \n');
                                end
                                

                                % MODE CHANGE FOR ID1 
                                write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_OPERATING_MODE,3); %Position mode on.
                                if getLastTxRxResult(port_num, PROTOCOL_VERSION) ~= COMM_SUCCESS
                                    printTxRxResult(PROTOCOL_VERSION, getLastTxRxResult(port_num, PROTOCOL_VERSION));
                                elseif getLastRxPacketError(port_num, PROTOCOL_VERSION) ~= 0
                                    printRxPacketError(PROTOCOL_VERSION, getLastRxPacketError(port_num, PROTOCOL_VERSION));
                                end
                                

                                %% 


% Enable Dynamixel#1 Torque
write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
if getLastTxRxResult(port_num, PROTOCOL_VERSION) ~= COMM_SUCCESS
    printTxRxResult(PROTOCOL_VERSION, getLastTxRxResult(port_num, PROTOCOL_VERSION));
elseif getLastRxPacketError(port_num, PROTOCOL_VERSION) ~= 0
    printRxPacketError(PROTOCOL_VERSION, getLastRxPacketError(port_num, PROTOCOL_VERSION));
else
    fprintf('Dynamixel has been successfully connected \n');
end



SamplingFreq = str2double(get (handles.edit4,'String')); % seconds
if(SamplingFreq>1000)
SamplingFreq=1000;
elseif(SamplingFreq<1)
SamplingFreq=1;
end

%Operating time al:
T = str2double(get (handles.edit2,'String')); % seconds

%Operating Mode Oku:
op_mode = read1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_OPERATING_MODE)

t = 0 ;                                       
error_int = 0;

index = 1;
GoalPositionIndex = 1;

%% 


%% READ INITIAL POSITION
%READ POSITION                                            
dxl_present_position = read4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_PRESENT_POSITION);
if getLastTxRxResult(port_num, PROTOCOL_VERSION) ~= COMM_SUCCESS
    printTxRxResult(PROTOCOL_VERSION, getLastTxRxResult(port_num, PROTOCOL_VERSION));
elseif getLastRxPacketError(port_num, PROTOCOL_VERSION) ~= 0
    printRxPacketError(PROTOCOL_VERSION, getLastRxPacketError(port_num, PROTOCOL_VERSION));
end


initialMotorPosition=typecast(uint32(dxl_present_position), 'int32')  %% MOTORUN POZÝSYON DEÐERÝ HEP POZÝTÝFTE OLSUN! NEGATÝF OLURSA BU YÝNE + ALACAK SIKINTI ÇIKAR.
initialMotorPosition=double(initialMotorPosition);

SafetyLimitPosition=800; %% INITIAL MOTOR POSIZYONUNDAN MAXIMUM UZAKLAÞABÝLÝNECEK DEÐER.

int_var_break=0;

revised_current=0;
         
dxl_goal_position = 500*[ 0    0.0998    0.1987    0.2955    0.3894    0.4794    0.5646  0.6442    0.7174    0.7833    0.8415    0.8912    0.9320    0.9636  0.9854    0.9975    0.9996    0.9917    0.9738    0.9463    0.9093 0.8632    0.8085    0.7457    0.6755    0.5985    0.5155    0.4274 0.3350    0.2392    0.1411    0.0416   -0.0584   -0.1577   -0.2555 -0.3508   -0.4425   -0.5298   -0.6119   -0.6878   -0.7568   -0.8183 -0.8716   -0.9162   -0.9516   -0.9775   -0.9937   -0.9999   -0.9962 -0.9825   -0.9589   -0.9258   -0.8835   -0.8323   -0.7728   -0.7055 -0.6313   -0.5507   -0.4646   -0.3739   -0.2794   -0.1822   -0.0831 0]; 
dxl_goal_position = dxl_goal_position + initialMotorPosition;                        
tic; %MOTOR HAREKET KODU BAÞLAYINCA BÝR TÝMER SAYMAYA BAÞLIYOR.
                    
                           %% READ AND WRITE                                                                                                                                                                                                                                                                                                                                    
                           while(t<T)
                                                     
                                                                             
                                    %READ POSITION                                            
                                    dxl_present_position = read4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_PRESENT_POSITION);
                                    if getLastTxRxResult(port_num, PROTOCOL_VERSION) ~= COMM_SUCCESS
                                        printTxRxResult(PROTOCOL_VERSION, getLastTxRxResult(port_num, PROTOCOL_VERSION));
                                    elseif getLastRxPacketError(port_num, PROTOCOL_VERSION) ~= 0
                                        printRxPacketError(PROTOCOL_VERSION, getLastRxPacketError(port_num, PROTOCOL_VERSION));
                                    end 
                                    
                                    posValue = typecast(uint32(dxl_present_position), 'int32') - initialMotorPosition; % MeasuredPos-InitialPos demiþ olduk.
                                    PresentPosition(index)= posValue;
                                    RealPosition(index)= typecast(uint32(dxl_present_position), 'int32');
                                                                                                          
                                     %POSITION CHECK SAFETY
                                     if (abs(posValue)>SafetyLimitPosition) %Error
                                                    
                                          disp('Position Limit Error')
                                          break;

                                     end                                    
                                   
                                    
                                    %READ CURRENT
                                    dxl_present_cur = read2ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_PRESENT_CURRENT);
                                    if getLastTxRxResult(port_num, PROTOCOL_VERSION) ~= COMM_SUCCESS
                                        printTxRxResult(PROTOCOL_VERSION, getLastTxRxResult(port_num, PROTOCOL_VERSION));
                                    elseif getLastRxPacketError(port_num, PROTOCOL_VERSION) ~= 0
                                        printRxPacketError(PROTOCOL_VERSION, getLastRxPacketError(port_num, PROTOCOL_VERSION));
                                    end 
                                    
                                    PresentCurrent(index) = typecast(uint16(dxl_present_cur), 'int16'); %her iterasyonda pozisyon bilgisini vektörlere atýyoruz. 
                                                                                                                                                            
                                    
                                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                    %% WRITE GOAL POSITION!

                                     % Write goal position
                                     write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_GOAL_POSITION, typecast(int32(dxl_goal_position(GoalPositionIndex)), 'uint32'));
                                     if getLastTxRxResult(port_num, PROTOCOL_VERSION) ~= COMM_SUCCESS
                                         printTxRxResult(PROTOCOL_VERSION, getLastTxRxResult(port_num, PROTOCOL_VERSION));
                                     elseif getLastRxPacketError(port_num, PROTOCOL_VERSION) ~= 0
                                         printRxPacketError(PROTOCOL_VERSION, getLastRxPacketError(port_num, PROTOCOL_VERSION));
                                     end
                                    
                                    %% WRITE GOAL POSITION!
                                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                    
                                    t=toc;
                                    
                                    TimeVector(index)=t;                                                                     
                                                                       
                                    index = index + 1 ;
                                    
                                    if(GoalPositionIndex>=64)
                                        GoalPositionIndex = 1;
                                    else
                                        GoalPositionIndex = GoalPositionIndex +1;                                    
                                    end    
                                    
                                    if(abs(t-T)<0.1)
                                    set(handles.edit2,'String',(num2str(round(t))));    
                                    else
                                    set(handles.edit2,'String',num2str(t));
                                    end
                                    
                                    %BU BÝZÝM SAMPLÝNG FREQUENCY MÝZ
                                    %pause(0.01)
                                    pause(abs(1/SamplingFreq));
                                                                      
                           end
                           %%  



  
%% MOTORU DURDUR      
GOAL_CURRENT_VALUE=0; 

   % Write goal current
    write2ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_GOAL_CURRENT, typecast(int16(GOAL_CURRENT_VALUE), 'uint16'));
    if getLastTxRxResult(port_num, PROTOCOL_VERSION) ~= COMM_SUCCESS
        printTxRxResult(PROTOCOL_VERSION, getLastTxRxResult(port_num, PROTOCOL_VERSION));
    elseif getLastRxPacketError(port_num, PROTOCOL_VERSION) ~= 0
        printRxPacketError(PROTOCOL_VERSION, getLastRxPacketError(port_num, PROTOCOL_VERSION));
    end
 
    
%%
       
PresentCurrent

%% PLOTLAR VE PORTLARI KAPATMA                                                    
                                                                           


figure
plot(TimeVector,PresentPosition)
xlabel('Time[s]','FontSize',15)
ylabel('Position [0.088 Deg]','FontSize',15)

figure
plot(TimeVector,RealPosition)
xlabel('Time[s]','FontSize',15)
ylabel('Position [0.088 Deg]','FontSize',15)


figure
plot(TimeVector,PresentCurrent)
xlabel('time[s]','FontSize',15)
ylabel('Current [3.36mA]','FontSize',15)


    
% Disable Dynamixel#1 Torque
write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
if getLastTxRxResult(port_num, PROTOCOL_VERSION) ~= COMM_SUCCESS
    printTxRxResult(PROTOCOL_VERSION, getLastTxRxResult(port_num, PROTOCOL_VERSION));
elseif getLastRxPacketError(port_num, PROTOCOL_VERSION) ~= 0
    printRxPacketError(PROTOCOL_VERSION, getLastRxPacketError(port_num, PROTOCOL_VERSION));
end



% Close port
closePort(port_num);

% Unload Library
unloadlibrary('dxl_x64_c');


%% PLOTLAR VE SONLANDIRMA











function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


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




function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


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
