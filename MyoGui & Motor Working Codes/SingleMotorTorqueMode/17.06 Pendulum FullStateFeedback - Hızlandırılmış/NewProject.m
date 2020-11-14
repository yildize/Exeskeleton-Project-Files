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


%% �LK MOTOR AYARLARI

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
DEVICENAME                      = 'COM8';       % Check which port is being used on your controller
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


%Operating time al:
T = str2double(get (handles.edit2,'String')); % seconds


t = 0 ;                                       
error_int = 0;

%% 


%% READ INITIAL POSITION
%READ POSITION                                            
dxl_present_position = read4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_PRESENT_POSITION);
if getLastTxRxResult(port_num, PROTOCOL_VERSION) ~= COMM_SUCCESS
    printTxRxResult(PROTOCOL_VERSION, getLastTxRxResult(port_num, PROTOCOL_VERSION));
elseif getLastRxPacketError(port_num, PROTOCOL_VERSION) ~= 0
    printRxPacketError(PROTOCOL_VERSION, getLastRxPacketError(port_num, PROTOCOL_VERSION));
end


initialMotorPosition=typecast(uint32(dxl_present_position), 'int32')  %% MOTORUN POZ�SYON DE�ER� HEP POZ�T�FTE OLSUN! NEGAT�F OLURSA BU Y�NE + ALACAK SIKINTI �IKAR.

SafetyLimitPosition=2000; %% INITIAL MOTOR POSIZYONUNDAN MAXIMUM UZAKLA�AB�L�NECEK DE�ER.

int_var_break=0;

revised_current=0;






tic; %MOTOR HAREKET KODU BA�LAYINCA B�R T�MER SAYMAYA BA�LIYOR.
                    
                           %% READ AND WRITE                                                                                                                                                                                                                                                                                                                                    
                           while(t<T)
                                                     
                                                                             
                                    %ASSIGN REFERENCE POSITION                                                                     
                                    reference_position = (pi/8)*sin(2*pi*0.2*t);
                                    %reference_position = pi/8;
                                    %reference_position = 300*0.088*pi/180*sin(2*pi*0.2*t);
                                    ref(index)= reference_position; %RADIANS
                                                     
                                                                             
                                    %READ POSITION                                            
                                    dxl_present_position = read4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_PRESENT_POSITION);
                                    if getLastTxRxResult(port_num, PROTOCOL_VERSION) ~= COMM_SUCCESS
                                        printTxRxResult(PROTOCOL_VERSION, getLastTxRxResult(port_num, PROTOCOL_VERSION));
                                    elseif getLastRxPacketError(port_num, PROTOCOL_VERSION) ~= 0
                                        printRxPacketError(PROTOCOL_VERSION, getLastRxPacketError(port_num, PROTOCOL_VERSION));
                                    end 
                                    
                                    posValue = double(typecast(uint32(dxl_present_position), 'int32') - initialMotorPosition); % MeasuredPos-InitialPos demi� olduk.
                                    %   posValue = posValue/4;
                                    
                                    posValueSafety = typecast(uint32(dxl_present_position), 'int32') - initialMotorPosition; %Bunu sadece safety check i�in kullan�yorum. 
                                    
                                    dxl_present=double(posValue);                                                                       
                                    dxl_present=0.0174533*dxl_present*360/4096; % MOTOR POSITION TO RADIANS
                                    %   Save position            
                                    posRadians(index) = dxl_present;    
                                    
                                    
                                    %OBTAIN POSITION ERROR (Reference - Actuated)                                    
                                    error = double(reference_position - dxl_present);
                                    % Save error into an array
                                    PosError(index)=error;
                                    
          
                                    %POSITION CHECK SAFETY
                                    if (abs(posValueSafety)>SafetyLimitPosition)              
                                         disp('Position Limit Error')
                                         break;
                                     end                                    
                                      %POSITION CHECK SAFETY
                                    
                                                                                                          
                                    
%                                     %READ VELOCITY                                           
%                                     dxl_present_vel = read4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_PRESENT_VELOCITY);
%                                     if getLastTxRxResult(port_num, PROTOCOL_VERSION) ~= COMM_SUCCESS
%                                         printTxRxResult(PROTOCOL_VERSION, getLastTxRxResult(port_num, PROTOCOL_VERSION));
%                                     elseif getLastRxPacketError(port_num, PROTOCOL_VERSION) ~= 0
%                                         printRxPacketError(PROTOCOL_VERSION, getLastRxPacketError(port_num, PROTOCOL_VERSION));
%                                     end 
%                                                                                                                                              
%                                     vel(index) = (2*pi/60)*0.229*double(typecast(uint32(dxl_present_vel), 'int32')); 
%                                     vel(index)=double(vel(index))/4;                                                      
                                    
                                  
                                    
                                    
                                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                    %% YOUR CODE SHOULD BE HERE!

                                    t=toc                              
                                    TimeVector(index)=t; 
                                    
                                    if(index>=2)
                                        %Error Integrali Belirlensin
                                        error_int_Vector = cumtrapz(TimeVector(1:index),PosError(1:index));
                                        error_int = error_int_Vector(end);
                                        %Save error integral into an array
                                        PosError_int(index)=error_int;
                                    end
                                    
                                    %H�z'� Okumadan T�rev ile Belirleyelim 
                                    pos_der_Vector = gradient(posRadians(1:index),TimeVector(1:index));
                                    pos_der = pos_der_Vector(end);
                                    %   pos_der = pos_der/4;
                                    VelocityDerived(index)= pos_der; 
                                    

                                                                        
                                    K = [90.6186    2.4645  -50.6660];
                                    
                                    u_lqr = double((-(K(1)*pos_der + K(2)*dxl_present + K(3)*error_int)));
                                    
                                    if(pos_der<0.2 && index>=2) 
                                        
                                        revised_current = double((-(K(1)*pos_der + K(2)*dxl_present + K(3)*error_int)) + (0.0265*uDer2 + 0.19*uDer + 1.114*u_lqr));    
                                    
                                    else
                                        revised_current = double((-(K(1)*pos_der + K(2)*dxl_present + K(3)*error_int)));
                                    end
                                    
                                    % Save goal current into an array
                                    RevisedCurrent(index)=revised_current
                                    
                                    u_lqrVector(index) = u_lqr;
                                                                      
                                    uDerVector = gradient(u_lqrVector(1:index),TimeVector(1:index));
                                    uDer = uDerVector(end);

                                    uDerVector2 = gradient(uDerVector(1:index),TimeVector(1:index));
                                    uDer2 = uDerVector2(end);

                                  
                                   

                                    
                                    %Manual current limit                                   
                                    if revised_current > 2046
                                        revised_current = 2046;                                        
                                    end

                                    if revised_current < -2046
                                        revised_current = -2046;                                        
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
                                                                                                                    
                                    index = index + 1 ;                                                                        
                                        
                                    if(abs(t-T)<0.1)
                                    set(handles.edit2,'String',(num2str(round(t))));    
                                    else
                                    set(handles.edit2,'String',num2str(t));
                                    end
                                    


                                    
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
plot(TimeVector,posRadians)
hold on
plot(TimeVector,ref*4)
xlabel('Time[s]','FontSize',15)
ylabel('Position [0.088 Deg]','FontSize',15)
legend('actuated','reference');


figure
plot(TimeVector,RevisedCurrent)
title('Revised Current')
xlabel('time[s]','FontSize',15)
ylabel('Current [3.36mA]','FontSize',15)
hold on

figure
plot(TimeVector,uDerVector)
hold on
plot(TimeVector,uDerVector2)

    
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
