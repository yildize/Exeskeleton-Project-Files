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

index = 1;
dxl_comm_result = COMM_TX_FAIL;           % Communication result


dxl_error = 0;                              % Dynamixel error
dxl_present_position = 0;                   % Present position
dxl_present_vel = 0;
dxl_present_cur = 0;

error_int = 0;



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
                                write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_OPERATING_MODE,0); %Current mode on.
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

T = str2double(get (handles.edit2,'String')); % seconds

%3.36 mA sensitivity var. Goal Current deðeri alýnýyor.
GOAL_CURRENT_VALUE = str2double(get (handles.edit3,'String'));
revised_current = 0;



if(GOAL_CURRENT_VALUE>2000)
   GOAL_CURRENT_VALUE = 2000 
elseif(GOAL_CURRENT_VALUE<0)
   GOAL_CURRENT_VALUE = 0 
end


t = 0 ;
x = 0 ;



op_mode=-99;
op_mode_counter=0;

                                                                          
%BURADA OPERATING MODE U ID 1 ÝÇÝN OKU
if (op_mode_counter==0)
    op_mode = read1ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_OPERATING_MODE)
    op_mode_counter=1;
end

%% 


%% READ INITIAL POSITION
%READ POSITION                                            
dxl_present_position = read4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_PRESENT_POSITION);
if getLastTxRxResult(port_num, PROTOCOL_VERSION) ~= COMM_SUCCESS
    printTxRxResult(PROTOCOL_VERSION, getLastTxRxResult(port_num, PROTOCOL_VERSION));
elseif getLastRxPacketError(port_num, PROTOCOL_VERSION) ~= 0
    printRxPacketError(PROTOCOL_VERSION, getLastRxPacketError(port_num, PROTOCOL_VERSION));
end

dxl_present_position
initialMotorPosition=typecast(uint32(dxl_present_position), 'int32')  %% MOTORUN POZÝSYON DEÐERÝ HEP POZÝTÝFTE OLSUN! NEGATÝF OLURSA BU YÝNE + ALACAK SIKINTI ÇIKAR.

SafetyLimitPosition=2000; %% INITIAL MOTOR POSIZYONUNDAN MAXIMUM UZAKLAÞABÝLÝNECEK DEÐER.

int_var_break=0;

revised_current=0;
         
error_before=0;
ta=0;
tb=0;

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
                                    
                                    realpos(index) = dxl_present_position; %Her iterasyonda pozisyon bilgisini vektörlere atýyoruz.
                                    
                                    
                                     %POSITION CHECK SAFETY
                                     if (abs(posValue)>SafetyLimitPosition) %Error
                                                    
                                          disp('Position Limit Error')
                                          break;

                                     end                                    
                                      %POSITION CHECK SAFETY
                                    
                                    
                                    %READ VELOCITY                                           
                                    dxl_present_vel = read4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_PRESENT_VELOCITY);
                                    if getLastTxRxResult(port_num, PROTOCOL_VERSION) ~= COMM_SUCCESS
                                        printTxRxResult(PROTOCOL_VERSION, getLastTxRxResult(port_num, PROTOCOL_VERSION));
                                    elseif getLastRxPacketError(port_num, PROTOCOL_VERSION) ~= 0
                                        printRxPacketError(PROTOCOL_VERSION, getLastRxPacketError(port_num, PROTOCOL_VERSION));
                                    end 
                                    
                                                                                                                                                                                   
                                    vel(index) = (2*pi/60)*0.229*double(typecast(uint32(dxl_present_vel), 'int32')); %her iterasyonda pozisyon bilgisini vektörlere atýyoruz.
                                   % vel(index) = (60/(2*pi))*0.229*typecast(uint32(dxl_present_vel), 'int32');
                                    
                                  
                                    
                                    
                                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                    %% YOUR CODE SHOULD BE HERE!

                                    % Assign reference position                                                                      
                                    reference_position = (pi/4)*sin(2*pi*0.2*t);
                                    %reference_position = pi/4;
                                    
                                    
                                                
                                    
                                    % Obtain normalized present position 
%                                     if(dxl_present_position<0)                                        
%                                     dxl_normalized_present = mod(dxl_present_position,4096)-4096; 
%                                     else
%                                     dxl_normalized_present = mod(dxl_present_position,4096);
%                                     end

                                    if(posValue<0)                                        
                                    dxl_normalized_present = mod(posValue,4096)-4096; 
                                    else
                                    dxl_normalized_present = mod(posValue,4096);
                                    end
                                    dxl_normalized_present1=double(dxl_normalized_present);
                                    
                                    vel1(index)=double(vel(index));
                                    % Save positions into arrays
                                    
                                    dxl_normalized_present1=0.0174533*dxl_normalized_present1*360/4096;
                                    posNormalized(index) = dxl_normalized_present1 
                                    
                                    ref(index)= reference_position;
                                    
                                    % Obtain error (reference-actuated)
                                    error = (reference_position - dxl_normalized_present1);
                                    ta = t;
                                    % Save error into an array
                                    er(index)=error;
                                    
                                    % Obtain error integral
                                    error_int = error_int +(error+error_before)/2*(ta-tb);
                                    tb=t;
                                    error_before = error;
                                    %Save error integral into an array
                                    er_int(index)=error_int;
                                    
                                    K=1e7*[1.2739    0.0036   -0.2182];
                                    
                               %%%  revised_current = (-(K(1)*dxl_normalized_present1 + K(2)*vel1(index) + K(3)*error_int))/3.36; 
                                    revised_current = 20;
                                    
%                                     if(vel(index)==0 && int_var_break==0)
%                                        revised_current=revised_current+5;
%                                    
%                                        revised_current = (-(K(1)*dxl_normalized_present1 + K(2)*vel1(index) + K(3)*error_int))/3.36; 
%                                        int_var_break=1;
%                                     end
                                   
                                    % SET CONTROLLER COEFFICIENTS (Assign goal current by using errors)                                  
                                    %revised_current = (100*error + 0*error_int);
                                                                       
                                    % Save goal current into an array
                                    rcur(index)=revised_current;

 %                                   K1 = -20.3036;
 %                                   K2 = -0.2795;
                                    
 %                                   revised_current =  (K1*dxl_present_position*(360/4096.0)*0.0174533 + K2* dxl_present_vel*(360/4096.0)*0.0174533);
                                    
                                    %Manual current limit                                   
                                    if revised_current > 2000
                                        revised_current = 2000;                                        
                                    end

                                    if revised_current < -2000
                                        revised_current = -2000;                                        
                                    end
                                        
                                    


                                    %% YOUR CODE SHOULD BE HERE!
                                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    % Write goal current
                                        write2ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_GOAL_CURRENT, typecast(int16(revised_current), 'uint16'));
                                        if getLastTxRxResult(port_num, PROTOCOL_VERSION) ~= COMM_SUCCESS
                                            printTxRxResult(PROTOCOL_VERSION, getLastTxRxResult(port_num, PROTOCOL_VERSION));
                                        elseif getLastRxPacketError(port_num, PROTOCOL_VERSION) ~= 0
                                            printRxPacketError(PROTOCOL_VERSION, getLastRxPacketError(port_num, PROTOCOL_VERSION));
                                        end
                                    %pause(1);                
                              
                                    
                                    %Read Current
                                    dxl_present_cur = read2ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_PRESENT_CURRENT);
                                    if getLastTxRxResult(port_num, PROTOCOL_VERSION) ~= COMM_SUCCESS
                                        printTxRxResult(PROTOCOL_VERSION, getLastTxRxResult(port_num, PROTOCOL_VERSION));
                                    elseif getLastRxPacketError(port_num, PROTOCOL_VERSION) ~= 0
                                        printRxPacketError(PROTOCOL_VERSION, getLastRxPacketError(port_num, PROTOCOL_VERSION));
                                    end 
                                    
                                    cur(index) = typecast(uint16(dxl_present_cur), 'int16'); %her iterasyonda pozisyon bilgisini vektörlere atýyoruz.                                                                                                                                                                                                                                                                                                                                                                                    
                                    
                                    t=toc;
                                    t1(index)=t;                                                                     
                                                                       
                                    index = index + 1 ;
                                                                        
                                        
                                    if(abs(t-T)<0.1)
                                    set(handles.edit2,'String',(num2str(round(t))));    
                                    else
                                    set(handles.edit2,'String',num2str(t));
                                    end
                                    %BU BÝZÝM SAMPLÝNG FREQUENCY MÝZ
                                    %pause(0.01)
                                    %pause(abs(1/SamplingFreq));
                                    


                                    
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
 

%% MOTORU DURDUR                              
                           
                           
                           
                           
                           

%% PLOTLAR VE PORTLARI KAPATMA                                                    
                                                                           
figure
plot(t1,vel)
xlim([0 t]);
ylim([0,300]);
hold on
xlabel('Time[s]','FontSize',15)
ylabel('Velocity [0.229RPM]','FontSize',15)

figure
plot(t1,posNormalized)
%xlim([0 t]);
%ylim([0,300]);
hold on
plot(t1,ref)
xlabel('Time[s]','FontSize',15)
ylabel('Position [0.088 Deg]','FontSize',15)
legend('actuated','reference');

% figure
% plot(t1,realpos)
% %xlim([0 t]);
% %ylim([0,300]);
% xlabel('Time[s]','FontSize',15)
% ylabel('Position [0.088 Deg]','FontSize',15)
% legend('actuated','reference');


figure
plot(t1,cur)
hold on
plot(t1,rcur)
legend('current','revisedcurrent')
xlim([0 t]);
%ylim([-50,50]);
xlabel('time[s]','FontSize',15)
ylabel('Current [3.36mA]','FontSize',15)
hold on
% 
% figure
% plot(t1,rcur)
% hold on
% plot(t1,posNormalized)
% hold on
% plot(t1,er)
% legend('rcur','pos','error');
% 
% 
% figure
% plot(t1,er)
% hold on
% plot(t1,er_int)
% legend('error','errorInt');



    
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
