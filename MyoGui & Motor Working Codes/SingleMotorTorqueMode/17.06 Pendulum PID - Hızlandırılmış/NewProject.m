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



SamplingFreq = str2double(get (handles.edit4,'String')); % seconds
if(SamplingFreq>1000)
SamplingFreq=1000;
elseif(SamplingFreq<1)
SamplingFreq=1;
end

%Operating time al:
T = str2double(get (handles.edit2,'String')); % seconds

%% 


%% READ INITIAL POSITION
%READ POSITION                                            
dxl_present_position = read4ByteTxRx(port_num, PROTOCOL_VERSION, DXL_ID, ADDR_PRO_PRESENT_POSITION);
if getLastTxRxResult(port_num, PROTOCOL_VERSION) ~= COMM_SUCCESS
    printTxRxResult(PROTOCOL_VERSION, getLastTxRxResult(port_num, PROTOCOL_VERSION));
elseif getLastRxPacketError(port_num, PROTOCOL_VERSION) ~= 0
    printRxPacketError(PROTOCOL_VERSION, getLastRxPacketError(port_num, PROTOCOL_VERSION));
end



t = 0 ;    

error_int = 0;

error_der = 0;

initialMotorPosition=typecast(uint32(dxl_present_position), 'int32')  

SafetyLimitPosition=1500; %% INITIAL MOTOR POSIZYONUNDAN MAXIMUM UZAKLA�AB�L�NECEK DE�ER.

revised_current=0;



%% Kay�t yap�lacak vectorlerin boyutlar�n� ba�tan belirleyelim, b�ylece real-time performans� art�ral�m
%Ba�lang�� vekt�r boyutlar�n�, saniyede 2000 veri olacak �ekilde atad�m, bu
%daha az olacakt�r, daha sonra d�zenlenir.

posRadians = -99*ones(1,T*30);
ref = -99*ones(1,T*30);
PosError = -99*ones(1,T*30);
PosError_int = -99*ones(1,T*30);
PosError_der = -99*ones(1,T*30);
RevisedCurrent = -99*ones(1,T*30);
TimeVector = -99*ones(1,T*30);


%%         

%% PID Coefficients declared:
Kp=30;  
Kd=1;  
Ki=5.5;
%%

tic; %MOTOR HAREKET KODU BA�LAYINCA B�R T�MER SAYMAYA BA�LIYOR.
                    
                           %% READ AND WRITE                                                                                                                                                                                                                                                                                                                                    
                           while(t<T)
                               
                               
                                    %ASSIGN REFERENCE POSITION                                                                     
                                    reference_position = (pi/3)*sin(2*pi*0.2*t);
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
                                    %posValue = posValue/4;
                                    
                                    posValueSafety = typecast(uint32(dxl_present_position), 'int32') - initialMotorPosition; %Bunu sadece safety check i�in kullan�yorum. 
                                    
                                    dxl_present=double(posValue);                                                                       
                                    dxl_present=0.0174533*dxl_present*360/4096; % MOTOR POSITION TO RADIANS
                                    %Save position            
                                    posRadians(index) = dxl_present;    
                                    
                                    
                                    %OBTAIN POSITION ERROR (Reference - Actuated)                                    
                                    error = double(reference_position - dxl_present);
                                    % Save error into an array
                                    PosError(index)=error;
                                    
          
                                    %POSITION CHECK SAFETY
                                    if (abs(posValueSafety)>SafetyLimitPosition) %Error              
                                         disp('Position Limit Error')
                                         break;
                                     end                                    
                                      %POSITION CHECK SAFETY
                                    
                                    
                                    
                                                                                                                       
                                   
                                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                    %% YOUR CODE SHOULD BE HERE!
                                      
                                    t=toc;                               
                                    TimeVector(index)=t; 
                                    
                                    if(index>=2)
                                        %Error Integrali Belirlensin
                                        error_int_Vector = cumtrapz(TimeVector(1:index),PosError(1:index));
                                        error_int = error_int_Vector(end);
                                        %Save error integral into an array
                                        PosError_int(index)=error_int;
                                    end
                                    %Error Derivative Belirlensin
                                    error_der_Vector = gradient(PosError(1:index),TimeVector(1:index));
                                    error_der = error_der_Vector(end);
                                    PosError_der(index)= error_der;     
                                    
                                    %H�z'� Okumadan T�rev ile Belirleyelim 
                                    pos_der_Vector = gradient(posRadians(1:index),TimeVector(1:index));
                                    pos_der = pos_der_Vector(end);
                                    %   pos_der = pos_der/4;
                                    VelocityDerived(index)= pos_der; 
                                    

                                    
                                    %Assign revised current
%                                     if(abs(pos_der)<0.3 && pos_der>0)                                        
%                                         revised_current = ((2.5*error) + (1*error_int) + (0.2*error_der))*1000/3.36; %%+(0.34*1.54)*1000/3.36;  
%                                     elseif(abs(pos_der)<0.3 && pos_der<0)  
%                                         revised_current = ((2.5*error) + (1*error_int) + (0.2*error_der))*1000/3.36; %%-(0.34*1.54)*1000/3.36; 
%                                     else
%                                        revised_current = ((2.5*error) + (1*error_int) + (0.2*error_der))*1000/3.36 ; 
%                                     end

                                    %(0.0039*refDer2 + 0.1299*refDer + 0.5096*ref(index))
                                    
                                    refDerVector = gradient(ref(1:index),TimeVector(1:index));
                                    refDer = refDerVector(end);

                                    refDerVector2 = gradient(refDerVector(1:index),TimeVector(1:index));
                                    refDer2 = refDerVector2(end);
                                   
                                    
                                    
                                    revised_current = ((2.5*error) + (1*error_int) + (0.2*error_der))*1000/3.36;%+(0.002*refDer2 + 0.05*refDer + 0.15*ref(index))*1000/3.36 ;

                                    

                                    % Save goal current into an array
                                    RevisedCurrent(index) = revised_current;
                                                                                                                                                                             

                                   
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
                                                  
                                                                                                                                                                                                                                                                                                                                                                                                                                                 
                                                                                                         
                                            
                                    if(abs(t-T)<0.1)
                                    set(handles.edit2,'String',(num2str(round(t))));    
                                    else
                                    set(handles.edit2,'String',num2str(t));
                                    end

                                    
                                    index = index + 1 ;


                                    
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


%% Vekt�rler i�indeki kullan�lmam��, -99 de�erleri silinecek b�ylece sadece �nemli veriler kalacakt�r.
                      
posRadians(find(posRadians==-99))=[];
ref(find(ref==-99))=[];
PosError(find(PosError==-99))=[];
PosError_int(find(PosError_int==-99))=[];
PosError_der(find(PosError_der==-99))=[];
RevisedCurrent(find(RevisedCurrent==-99))=[];
TimeVector(find(TimeVector==-99))=[];

%%






%% PLOTLAR VE PORTLARI KAPATMA         
figure
plot(PosError)
hold on
plot(PosError_int)
hold on
plot(PosError_der)
legend('PosError','IntError','DerError')
                                                                         

figure
plot(TimeVector,posRadians)
hold on
plot(TimeVector,ref)
plot(TimeVector,VelocityDerived)
xlabel('Time[s]','FontSize',15)
ylabel('Position [0.088 Deg]','FontSize',15)
legend('actuated','reference','velocity');


figure
plot(TimeVector,RevisedCurrent)
title('RevisedCur')

figure
plot(TimeVector,ref)
hold on
plot(TimeVector,refDerVector)
plot(TimeVector,refDerVector2)
legend('ref','refder','refder2')




    
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
