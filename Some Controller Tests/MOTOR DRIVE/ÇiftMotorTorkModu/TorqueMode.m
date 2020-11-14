function varargout = TorqueMode(varargin)
% TORQUEMODE MATLAB code for TorqueMode.fig
%      TORQUEMODE, by itself, creates a new TORQUEMODE or raises the existing
%      singleton*.
%
%      H = TORQUEMODE returns the handle to a new TORQUEMODE or the handle to
%      the existing singleton*.
%
%      TORQUEMODE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TORQUEMODE.M with the given input arguments.
%
%      TORQUEMODE('Property','Value',...) creates a new TORQUEMODE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TorqueMode_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TorqueMode_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TorqueMode

% Last Modified by GUIDE v2.5 19-Apr-2019 16:59:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TorqueMode_OpeningFcn, ...
                   'gui_OutputFcn',  @TorqueMode_OutputFcn, ...
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


% --- Executes just before TorqueMode is made visible.
function TorqueMode_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TorqueMode (see VARARGIN)
handles.initialized=0;
% Choose default command line output for TorqueMode
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TorqueMode wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TorqueMode_OutputFcn(hObject, eventdata, handles) 
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

tic;
%% ÝLK MOTOR AYARLARI

% Load Libraries
if ~libisloaded('dxl_x64_c')
    [notfound, warnings] = loadlibrary('dxl_x64_c', 'dynamixel_sdk.h', 'addheader', 'port_handler.h', 'addheader', 'packet_handler.h', 'addheader', 'group_bulk_read.h', 'addheader', 'group_bulk_write.h');
end

GOAL_CURRENT_VALUE = 0; %BETWEEN 0-2047
% Control table address
ADDR_PRO_TORQUE_ENABLE          = 64;          % Control table address is different in Dynamixel model
ADDR_PRO_LED_RED                = 65;
ADDR_PRO_GOAL_POSITION          = 116;
ADDR_PRO_PRESENT_POSITION       = 132;
ADDR_PRO_OPERATING_MODE         = 11;
ADDR_PRO_GOAL_CURRENT           = 102;
ADDR_PRO_PRESENT_CURRENT        = 126;
ADDR_PRO_PRESENT_VELOCITY       = 128;



% Data Byte Length
LEN_PRO_LED_RED                 = 1;
LEN_PRO_GOAL_POSITION           = 4;
LEN_PRO_PRESENT_POSITION        = 4;
LEN_PRO_GOAL_CURRENT            = 2;
LEN_PRO_PRESENT_CURRENT         = 2;
LEN_PRO_PRESENT_VELOCITY        = 4;
% Protocol version
PROTOCOL_VERSION                = 2.0;          % See which protocol version is used in the Dynamixel

% Default setting
DXL1_ID                         = 1;            % Dynamixel#1 ID: 1
DXL2_ID                         = 2;            % Dynamixel#2 ID: 2
BAUDRATE                        = 56700;
DEVICENAME                      = 'COM5';       % Check which port is being used on your controller
                                                % ex) Windows: "COM1"   Linux: "/dev/ttyUSB0"

TORQUE_ENABLE                   = 1;            % Value for enabling the torque
TORQUE_DISABLE                  = 0;            % Value for disabling the torque
DXL_MINIMUM_POSITION_VALUE      = 0;            % Dynamixel will rotate between this value
DXL_MAXIMUM_POSITION_VALUE      = 4000;         % and this value (note that the Dynamixel would not move when the position value is out of movable range. Check e-manual about the range of the Dynamixel you use.)
DXL_MINIMUM_POSITION_VALUE_2    = 2000;
DXL_MAXIMUM_POSITION_VALUE_2    = 3000;

DXL_MOVING_STATUS_THRESHOLD     = 20;           % Dynamixel moving status threshold

ESC_CHARACTER                   = 'e';          % Key for escaping loop

COMM_SUCCESS                    = 0;            % Communication Success result value
COMM_TX_FAIL                    = -1001;        % Communication Tx Failed

% Initialize PortHandler Structs
% Set the port path
% Get methods and members of PortHandlerLinux or PortHandlerWindows
port_num = portHandler(DEVICENAME);

% Initialize PacketHandler Structs
packetHandler();

% Initialize groupBulkWrite Struct
groupwrite_num = groupBulkWrite(port_num, PROTOCOL_VERSION);

% Initialize Groupbulkread Structs
groupread_num = groupBulkRead(port_num, PROTOCOL_VERSION);

index = 1;

dxl_comm_result = COMM_TX_FAIL;                 % Communication result
dxl_addparam_result = false;                    % AddParam result
dxl_getdata_result = false;                     % GetParam result
dxl_goal_position = [DXL_MINIMUM_POSITION_VALUE DXL_MAXIMUM_POSITION_VALUE];         % Goal position
dxl_goal_position_2 = [DXL_MINIMUM_POSITION_VALUE_2 DXL_MAXIMUM_POSITION_VALUE_2];         % Goal position
dxl_error = 0;                                  % Dynamixel error
dxl_led_value = [0 1];                        % Dynamixel LED value for write
dxl1_present_position = 0;                      % Present position
dxl2_present_position = 0;
% dxl1_present_velocity = 0;
% dxl2_present_velocity = 0;
dxl2_led_value_read = 0;                        % Dynamixel moving status

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




                                %% MOTOR MODU DEÐÝÞTÝR
                                % DISABLE Dynamixel#1 Torque TO CHANGE MODE
                                write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL1_ID, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
                                if getLastTxRxResult(port_num, PROTOCOL_VERSION) ~= COMM_SUCCESS
                                    printTxRxResult(PROTOCOL_VERSION, getLastTxRxResult(port_num, PROTOCOL_VERSION));
                                elseif getLastRxPacketError(port_num, PROTOCOL_VERSION) ~= 0
                                    printRxPacketError(PROTOCOL_VERSION, getLastRxPacketError(port_num, PROTOCOL_VERSION));
                                else
                                    fprintf('Dynamixel has been successfully connected \n');
                                end
                                
                                % DISABLE Dynamixel#2 Torque TO CHANGE MODE
                                write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL2_ID, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
                                if getLastTxRxResult(port_num, PROTOCOL_VERSION) ~= COMM_SUCCESS
                                    printTxRxResult(PROTOCOL_VERSION, getLastTxRxResult(port_num, PROTOCOL_VERSION));
                                elseif getLastRxPacketError(port_num, PROTOCOL_VERSION) ~= 0
                                    printRxPacketError(PROTOCOL_VERSION, getLastRxPacketError(port_num, PROTOCOL_VERSION));
                                else
                                    fprintf('Dynamixel has been successfully connected \n');
                                end

                                % MODE CHANGE FOR ID1 
                                write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL1_ID, ADDR_PRO_OPERATING_MODE,0);
                                if getLastTxRxResult(port_num, PROTOCOL_VERSION) ~= COMM_SUCCESS
                                    printTxRxResult(PROTOCOL_VERSION, getLastTxRxResult(port_num, PROTOCOL_VERSION));
                                elseif getLastRxPacketError(port_num, PROTOCOL_VERSION) ~= 0
                                    printRxPacketError(PROTOCOL_VERSION, getLastRxPacketError(port_num, PROTOCOL_VERSION));
                                end
                                
                                % MODE CHANGE FOR ID2
                                write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL2_ID, ADDR_PRO_OPERATING_MODE,0);
                                if getLastTxRxResult(port_num, PROTOCOL_VERSION) ~= COMM_SUCCESS
                                    printTxRxResult(PROTOCOL_VERSION, getLastTxRxResult(port_num, PROTOCOL_VERSION));
                                elseif getLastRxPacketError(port_num, PROTOCOL_VERSION) ~= 0
                                    printRxPacketError(PROTOCOL_VERSION, getLastRxPacketError(port_num, PROTOCOL_VERSION));
                                end
                                %% MOTOR MODU DEÐÝÞTÝR



% Enable Dynamixel#1 Torque
write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL1_ID, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
if getLastTxRxResult(port_num, PROTOCOL_VERSION) ~= COMM_SUCCESS
    printTxRxResult(PROTOCOL_VERSION, getLastTxRxResult(port_num, PROTOCOL_VERSION));
elseif getLastRxPacketError(port_num, PROTOCOL_VERSION) ~= 0
    printRxPacketError(PROTOCOL_VERSION, getLastRxPacketError(port_num, PROTOCOL_VERSION));
else
    fprintf('Dynamixel has been successfully connected \n');
end

% Enable Dynamixel#2 Torque
write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL2_ID, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
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

T = str2double(get (handles.edit2,'String')); % seconds

%3.36 mA sensitivity var. Goal Current deðeri alýnýyor.
GOAL_CURRENT_VALUE = str2double(get (handles.edit3,'String'));
if(GOAL_CURRENT_VALUE>2047)
   GOAL_CURRENT_VALUE = 2047 
elseif(GOAL_CURRENT_VALUE<0)
   GOAL_CURRENT_VALUE = 0 
end


t = 0 ;
x = 0 ;



op_mode=-99;
op_mode_counter=0;

                                       

                    
                    
%BURADA OPERATING MODE U ID 1 VE ID2 ÝÇÝN OKU
if (op_mode_counter==0)
    op_mode = read1ByteTxRx(port_num, PROTOCOL_VERSION, DXL1_ID, ADDR_PRO_OPERATING_MODE)
    op_mode = read1ByteTxRx(port_num, PROTOCOL_VERSION, DXL2_ID, ADDR_PRO_OPERATING_MODE)
    op_mode_counter=1;
end

%% ÝLK MOTOR AYARLARI
initializetime=toc


%% MOTORLARI GOAL TORQUE DEÐERÝNE SÜRELÝM
% Add parameter storage for Dynamixel#1 goal c
dxl_addparam_result = groupBulkWriteAddParam(groupwrite_num, DXL1_ID, ADDR_PRO_GOAL_CURRENT, LEN_PRO_GOAL_CURRENT, typecast(int16(GOAL_CURRENT_VALUE), 'uint16'), LEN_PRO_GOAL_CURRENT);
if dxl_addparam_result ~= true
    fprintf(stderr, '[ID:%03d] groupBulkWrite addparam failed', DXL1_ID);
    return;
end

% Add parameter storage for Dynamixel#2 goal c
dxl_addparam_result = groupBulkWriteAddParam(groupwrite_num, DXL2_ID, ADDR_PRO_GOAL_CURRENT, LEN_PRO_GOAL_CURRENT, typecast(int16(GOAL_CURRENT_VALUE), 'uint16'), LEN_PRO_GOAL_CURRENT);
if dxl_addparam_result ~= true
   fprintf(stderr, '[ID:%03d] groupBulkWrite addparam failed', DXL2_ID);
   return;
end
                                                                       
% BURADA MOTORLARA GOAL CURRENT YOLLANDI                                                          
groupBulkWriteTxPacket(groupwrite_num);
if getLastTxRxResult(port_num, PROTOCOL_VERSION) ~= COMM_SUCCESS
   printTxRxResult(PROTOCOL_VERSION, getLastTxRxResult(port_num, PROTOCOL_VERSION));
end
                                    
% Clear bulkwrite parameter storage
groupBulkWriteClearParam(groupwrite_num); 

pause(1);

%% MOTORLARI GOAL TORQUE DEÐERÝNE SÜRELÝM                                     

tic; %MOTOR HAREKET KODU BAÞLAYINCA BÝR TÝMER SAYMAYA BAÞLIYOR.
                    
                           %% VELOCÝTY VE CURRENT OKUYALIM                                                                                                                                                                                                                                                                                                                                       
                           while(t<T)
                           
                               
                                     %ÖNCE VELOCÝTY OKUYALIM.
                                     
                                     % Add parameter storage for Dynamixel#1 present velocity value
                                    dxl_addparam_result = groupBulkReadAddParam(groupread_num, DXL1_ID, ADDR_PRO_PRESENT_VELOCITY, LEN_PRO_PRESENT_VELOCITY);
                                    if dxl_addparam_result ~= true
                                        fprintf('[ID:%03d] groupBulkRead addparam failed', DXL1_ID);
                                        return;
                                    end

                                    % Add parameter storage for Dynamixel#2 present velocity value
                                    dxl_addparam_result = groupBulkReadAddParam(groupread_num, DXL2_ID, ADDR_PRO_PRESENT_VELOCITY, LEN_PRO_PRESENT_VELOCITY);
                                    if dxl_addparam_result ~= true
                                        fprintf('[ID:%03d] groupBulkRead addparam failed', DXL2_ID);
                                        return;
                                    end
                                                                         
                                    % Bulkread related data
                                    groupBulkReadTxRxPacket(groupread_num);
                                    if getLastTxRxResult(port_num, PROTOCOL_VERSION) ~= COMM_SUCCESS
                                        printTxRxResult(PROTOCOL_VERSION, getLastTxRxResult(port_num, PROTOCOL_VERSION));
                                    end
                                    
                                    % Check if groupbulkread data of Dynamixel#1 is available
                                    dxl_getdata_result = groupBulkReadIsAvailable(groupread_num, DXL1_ID, ADDR_PRO_PRESENT_VELOCITY, LEN_PRO_PRESENT_VELOCITY);
                                    if dxl_getdata_result ~= true
                                        fprintf('[ID:%03d] groupBulkRead getdata failed', DXL1_ID);
                                        return;
                                    end

                                    % Check if groupbulkread data of Dynamixel#2 is available
                                    dxl_getdata_result = groupBulkReadIsAvailable(groupread_num, DXL2_ID, ADDR_PRO_PRESENT_VELOCITY, LEN_PRO_PRESENT_VELOCITY);
                                    if dxl_getdata_result ~= true
                                        fprintf('[ID:%03d] groupBulkRead getdata failed', DXL2_ID);
                                        return;
                                    end
                                    
                                    % Get Dynamixel#1 present velocity value
                                    dxl1_present_vel = groupBulkReadGetData(groupread_num, DXL1_ID, ADDR_PRO_PRESENT_VELOCITY, LEN_PRO_PRESENT_VELOCITY);

                                    % Get Dynamixel#2 present velocity value
                                    dxl2_present_vel = groupBulkReadGetData(groupread_num, DXL2_ID, ADDR_PRO_PRESENT_VELOCITY, LEN_PRO_PRESENT_VELOCITY);
                                    
                                    
                                    vel1(index) = typecast(uint32(dxl1_present_vel), 'int32'); %her iterasyonda pozisyon bilgisini vektörlere atýyoruz.
                                    vel2(index) = typecast(uint32(dxl2_present_vel), 'int32'); %her iterasyonda pozisyon bilgisini vektörlere atýyoruz.
                                    
                                    %TEMÝZLEME
                                    groupBulkReadClearParam(groupread_num); 

                                    
                                    
                                    
                                    
                                    
                                    % ÞÝMDÝ CURRENT OKUYALIM
                                    
                                    % Add parameter storage for Dynamixel#1 present current value
                                    dxl_addparam_result = groupBulkReadAddParam(groupread_num, DXL1_ID, ADDR_PRO_PRESENT_CURRENT, LEN_PRO_PRESENT_CURRENT);
                                    if dxl_addparam_result ~= true
                                        fprintf('[ID:%03d] groupBulkRead addparam failed', DXL1_ID);
                                        return;
                                    end

                                    % Add parameter storage for Dynamixel#2 present current value
                                    dxl_addparam_result = groupBulkReadAddParam(groupread_num, DXL2_ID, ADDR_PRO_PRESENT_CURRENT, LEN_PRO_PRESENT_CURRENT);
                                    if dxl_addparam_result ~= true
                                        fprintf('[ID:%03d] groupBulkRead addparam failed', DXL2_ID);
                                        return;
                                    end

                                    % Bulkread related data
                                    groupBulkReadTxRxPacket(groupread_num);
                                    if getLastTxRxResult(port_num, PROTOCOL_VERSION) ~= COMM_SUCCESS
                                        printTxRxResult(PROTOCOL_VERSION, getLastTxRxResult(port_num, PROTOCOL_VERSION));
                                    end
                                                                                                                                                                                                                                                                                   
                                   % Check if groupbulkread data of Dynamixel#1 is available
                                    dxl_getdata_result = groupBulkReadIsAvailable(groupread_num, DXL1_ID, ADDR_PRO_PRESENT_CURRENT, LEN_PRO_PRESENT_CURRENT);
                                    if dxl_getdata_result ~= true
                                        fprintf('[ID:%03d] groupBulkRead getdata failed', DXL1_ID);
                                        return;
                                    end
                                    
                                    % Check if groupbulkread data of Dynamixel#2 is available
                                    dxl_getdata_result = groupBulkReadIsAvailable(groupread_num, DXL2_ID, ADDR_PRO_PRESENT_CURRENT, LEN_PRO_PRESENT_CURRENT);
                                    if dxl_getdata_result ~= true
                                        fprintf('[ID:%03d] groupBulkRead getdata failed', DXL2_ID);
                                        return;
                                    end

                                    % Get Dynamixel#1 present current value
                                    dxl1_present_cur = groupBulkReadGetData(groupread_num, DXL1_ID, ADDR_PRO_PRESENT_CURRENT, LEN_PRO_PRESENT_CURRENT);

                                    % Get Dynamixel#2 present current value
                                    dxl2_present_cur = groupBulkReadGetData(groupread_num, DXL2_ID, ADDR_PRO_PRESENT_CURRENT, LEN_PRO_PRESENT_CURRENT);
 
                                    cur1(index) = typecast(uint16(dxl1_present_cur), 'int16'); %her iterasyonda pozisyon bilgisini vektörlere atýyoruz.
                                    cur2(index) = typecast(uint16(dxl2_present_cur), 'int16'); %her iterasyonda pozisyon bilgisini vektörlere atýyoruz.                                    

                                    groupBulkReadClearParam(groupread_num); 
                                    
                                                                                                                                                                                                                                                                                                                              
                                    
                                    t=toc
                                    t1(index)=t;                                                                     
                                                                       
                                    index = index + 1 ;
                                                                        
                                        
                                    if(abs(t-T)<0.1)
                                    set(handles.edit2,'String',(num2str(round(t))));    
                                    else
                                    set(handles.edit2,'String',num2str(t));
                                    end
                                    %BU BÝZÝM SAMPLÝNG FREQUENCY MÝZ
                                    pause(abs(1/SamplingFreq));
                                                                                                                                                                                                                                                                                          
                                    
                           end
                           %% VELOCÝTY VE CURRENT OKUYALIM  



GOAL_CURRENT_VALUE=0;   
%% MOTORLARI DURDUR                           
% Add parameter storage for Dynamixel#1 goal c
dxl_addparam_result = groupBulkWriteAddParam(groupwrite_num, DXL1_ID, ADDR_PRO_GOAL_CURRENT, LEN_PRO_GOAL_CURRENT, typecast(int16(GOAL_CURRENT_VALUE), 'uint16'), LEN_PRO_GOAL_CURRENT);
if dxl_addparam_result ~= true
    fprintf(stderr, '[ID:%03d] groupBulkWrite addparam failed', DXL1_ID);
    return;
end

% Add parameter storage for Dynamixel#2 goal c
dxl_addparam_result = groupBulkWriteAddParam(groupwrite_num, DXL2_ID, ADDR_PRO_GOAL_CURRENT, LEN_PRO_GOAL_CURRENT, typecast(int16(GOAL_CURRENT_VALUE), 'uint16'), LEN_PRO_GOAL_CURRENT);
if dxl_addparam_result ~= true
   fprintf(stderr, '[ID:%03d] groupBulkWrite addparam failed', DXL2_ID);
   return;
end
                                                                       
% BURADA MOTORLARA GOAL CURRENT YOLLANDI                                                          
groupBulkWriteTxPacket(groupwrite_num);
if getLastTxRxResult(port_num, PROTOCOL_VERSION) ~= COMM_SUCCESS
   printTxRxResult(PROTOCOL_VERSION, getLastTxRxResult(port_num, PROTOCOL_VERSION));
end                           
%% MOTORLARI DURDUR                              
                           
                           
                           
                           
                           
                                                     


%% PLOTLAR VE SONLANDIRMA                                                     
% plot(handles.axes1,t1,cur1);
% hold on
% plot(handles.axes1,t1,cur2);
% 
% plot(handles.axes2,t1,cur1);
% hold on
% plot(handles.axes2,t1,cur2);
% xlim(handles.axes1,[0 t]);
% ylim(handles.axes1,[0 300]);  
% xlim(handles.axes2,[0 t]);
% ylim(handles.axes2,[0 30]);  
% plot(handles.axes1,t1,cur2);
                                                                           
figure
plot(t1,vel1)
xlim([0 t]);
ylim([0,300]);
hold on
xlabel('Time[s]','FontSize',15)
ylabel('Velocity [0.229RPM]','FontSize',15)
plot(t1,vel2)
xlim([0 t]);
ylim([0,300]);
title('Velocity','FontSize',20)
xlabel('Time[s]','FontSize',15)
ylabel('Velocity [0.229RPM]','FontSize',15)

figure
plot(t1,cur1)
xlim([0 t]);
ylim([0,30]);
xlabel('time[s]','FontSize',15)
ylabel('Current [3.36mA]','FontSize',15)
hold on
plot(t1,cur2)
xlim([0 t]);
ylim([0,30]);
title('Current','FontSize',20)
xlabel('Time[s]','FontSize',15)
ylabel('Current [3.36mA]','FontSize',15)


    
% Disable Dynamixel#1 Torque
write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL1_ID, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
if getLastTxRxResult(port_num, PROTOCOL_VERSION) ~= COMM_SUCCESS
    printTxRxResult(PROTOCOL_VERSION, getLastTxRxResult(port_num, PROTOCOL_VERSION));
elseif getLastRxPacketError(port_num, PROTOCOL_VERSION) ~= 0
    printRxPacketError(PROTOCOL_VERSION, getLastRxPacketError(port_num, PROTOCOL_VERSION));
end

% Disable Dynamixel#2 Torque
write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL2_ID, ADDR_PRO_TORQUE_ENABLE, TORQUE_DISABLE);
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



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


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
