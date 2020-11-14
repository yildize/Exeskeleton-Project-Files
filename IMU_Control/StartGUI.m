function varargout = StartGUI(varargin)
% =$N1>0 EXCEL KODU
% STARTGUI MATLAB code for StartGUI.fig
%      STARTGUI, by itself, creates a new STARTGUI or raises the existing
%      singleton*.
%
%      H = STARTGUI returns the handle to a new STARTGUI or the handle to
%      the existing singleton*.
%
%      STARTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STARTGUI.M with the given input arguments.
%
%      STARTGUI('Property','Value',...) creates a new STARTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before StartGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to StartGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help StartGUI

% Last Modified by GUIDE v2.5 01-Apr-2019 01:07:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @StartGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @StartGUI_OutputFcn, ...
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


% --- Executes just before StartGUI is made visible.
function StartGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to StartGUI (see VARARGIN)
clc 
countMyos = 1;
handles.mm = MyoMex(countMyos);
handles.m1 = handles.mm.myoData(1); 
handles.marksemgtime=-99*ones(100,1);




% Choose default command line output,, for StartGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes StartGUI wait for user response (see UIRESUME)
% uiwait(handles.gui1);


% --- Outputs from this function are returned to the command line.
function varargout = StartGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
T = str2num(get (handles.edit1,'String')); % seconds

% Load Libraries
if ~libisloaded('dxl_x64_c')
    [notfound, warnings] = loadlibrary('dxl_x64_c', 'dynamixel_sdk.h', 'addheader', 'port_handler.h', 'addheader', 'packet_handler.h', 'addheader', 'group_bulk_read.h', 'addheader', 'group_bulk_write.h');
end

% Control table address
ADDR_PRO_TORQUE_ENABLE          = 64;          % Control table address is different in Dynamixel model
ADDR_PRO_LED_RED                = 65;
ADDR_PRO_GOAL_POSITION          = 116;
ADDR_PRO_PRESENT_POSITION       = 132;
ADDR_PRO_OPERATING_MODE         = 11;
ADDR_PRO_PRESENT_CURRENT        = 126;
LEN_PRO_PRESENT_CURRENT         = 2;

% Data Byte Length
LEN_PRO_LED_RED                 = 1;
LEN_PRO_GOAL_POSITION           = 4;
LEN_PRO_PRESENT_POSITION        = 4;

% Protocol version
PROTOCOL_VERSION                = 2.0;          % See which protocol version is used in the Dynamixel

% Default setting
DXL1_ID                         = 2;  %Hip           % Dynamixel#1 ID: 1
DXL2_ID                         = 1;  %Knee          % Dynamixel#2 ID: 2
BAUDRATE                        = 56700;
DEVICENAME                      = 'COM8';       % Check which port is being used on your controller
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


dxl_comm_result = COMM_TX_FAIL;                 % Communication result
dxl_addparam_result = false;                    % AddParam result
dxl_getdata_result = false;                     % GetParam result
dxl_goal_position = [DXL_MINIMUM_POSITION_VALUE DXL_MAXIMUM_POSITION_VALUE];         % Goal position
dxl_goal_position_2 = [DXL_MINIMUM_POSITION_VALUE_2 DXL_MAXIMUM_POSITION_VALUE_2];         % Goal position
dxl_error = 0;                                  % Dynamixel error
dxl_led_value = [0 1];                        % Dynamixel LED value for write
dxl1_present_position = 0;                      % Present position
dxl2_present_position = 0;
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



% Enable Dynamixel#1 Torque (Hip)
write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL1_ID, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
if getLastTxRxResult(port_num, PROTOCOL_VERSION) ~= COMM_SUCCESS
    printTxRxResult(PROTOCOL_VERSION, getLastTxRxResult(port_num, PROTOCOL_VERSION));
elseif getLastRxPacketError(port_num, PROTOCOL_VERSION) ~= 0
    printRxPacketError(PROTOCOL_VERSION, getLastRxPacketError(port_num, PROTOCOL_VERSION));
else
    fprintf('Dynamixel has been successfully connected \n');
end

% Enable Dynamixel#2 Torque (KNEE)
write1ByteTxRx(port_num, PROTOCOL_VERSION, DXL2_ID, ADDR_PRO_TORQUE_ENABLE, TORQUE_ENABLE);
if getLastTxRxResult(port_num, PROTOCOL_VERSION) ~= COMM_SUCCESS
    printTxRxResult(PROTOCOL_VERSION, getLastTxRxResult(port_num, PROTOCOL_VERSION));
elseif getLastRxPacketError(port_num, PROTOCOL_VERSION) ~= 0
    printRxPacketError(PROTOCOL_VERSION, getLastRxPacketError(port_num, PROTOCOL_VERSION));
else
    fprintf('Dynamixel has been successfully connected \n');
end


write2ByteTxRx(port_num, PROTOCOL_VERSION, DXL2_ID, 84, 500);% Set P gain to 150!

% Add parameter storage for Dynamixel#1 present position value
dxl_addparam_result = groupBulkReadAddParam(groupread_num, DXL1_ID, ADDR_PRO_PRESENT_POSITION, LEN_PRO_PRESENT_POSITION);
if dxl_addparam_result ~= true
    fprintf('[ID:%03d] groupBulkRead addparam failed', DXL1_ID);
    return;
end

% Add parameter storage for Dynamixel#2 present position value
dxl_addparam_result = groupBulkReadAddParam(groupread_num, DXL2_ID, ADDR_PRO_PRESENT_POSITION, LEN_PRO_PRESENT_POSITION);
if dxl_addparam_result ~= true
    fprintf('[ID:%03d] groupBulkRead addparam failed', DXL2_ID);
    return;
end


% Bulkread present positions
groupBulkReadTxRxPacket(groupread_num);
if getLastTxRxResult(port_num, PROTOCOL_VERSION) ~= COMM_SUCCESS
   printTxRxResult(PROTOCOL_VERSION, getLastTxRxResult(port_num, PROTOCOL_VERSION));
end


% Get Dynamixel#1 hip present position value
dxl1_present_position = groupBulkReadGetData(groupread_num, DXL1_ID, ADDR_PRO_PRESENT_POSITION, LEN_PRO_PRESENT_POSITION) %HÝP AÇISI
% Get Dynamixel#2 knee present position value
dxl2_present_position = groupBulkReadGetData(groupread_num, DXL2_ID, ADDR_PRO_PRESENT_POSITION, LEN_PRO_PRESENT_POSITION) %KNEE AÇISI

dxl1_initialPos = dxl1_present_position;
dxl2_initialPos = dxl2_present_position;




handles.m1.clearLogs()
handles.m1.startStreaming();



%VISIBILITYLERI KAPATALIM
set(handles.text2,'visible', 'off');
set(handles.text3,'visible', 'off');
set(handles.text4,'visible', 'off');
set(handles.text5,'visible', 'off');
set(handles.text6,'visible', 'off');
set(handles.text7,'visible', 'off');

set(handles.checkbox1,'visible', 'off');
set(handles.checkbox2,'visible', 'off');
set(handles.checkbox3,'visible', 'off');
set(handles.checkbox4,'visible', 'off');
set(handles.checkbox5,'visible', 'off');
set(handles.checkbox6,'visible', 'off');
set(handles.checkbox7,'visible', 'off');
set(handles.checkbox8,'visible', 'off');
set(handles.checkbox9,'visible', 'off');
set(handles.checkbox10,'visible', 'off');
set(handles.checkbox11,'visible', 'off');
set(handles.checkbox12,'visible', 'off');
set(handles.checkbox13,'visible', 'off');
set(handles.checkbox14,'visible', 'off');
set(handles.checkbox15,'visible', 'off');
set(handles.checkbox16,'visible', 'off');
set(handles.checkbox17,'visible', 'off');
set(handles.checkbox20,'visible', 'off');
set(handles.checkbox21,'visible', 'off');

set(handles.pushbutton1,'visible', 'off');

set(handles.edit1,'visible', 'off');
set(handles.edit5,'visible', 'off');
set(handles.edit7,'visible', 'off');

set(handles.pushbutton2,'visible', 'on');
set(handles.MarkText,'visible', 'on');
set(handles.MTV,'visible', 'on');
set(handles.text10,'visible', 'on');

set(handles.axes7,'visible', 'on');
set(handles.axes8,'visible', 'on');

%VISIBILITYLERI KAPATALIM



%BURADA YENÝ BÝR GUI EKRANINDA EMG DATALARINI ANLIK YAZDIRALIM
%instantPLOT

FX=0;
FS=0;
EX=0;
RX=0;
t = 0 ;
x = 0 ;
startSpot = 0;
%tic;
tstart=99; %while içinde ilk deðer atanacak þuan öylesine verdim!
index = 1;
while ( t < T )
     if (length(handles.m1.timeEMG_log)>300 && length(handles.m1.timeIMU_log)>75)   %%Yeterli data dolana kadar normal çiz! Sonra 300 ve 75 data yani yaklaþýk 1.5 saniye çizdiriyoruz.
            a=handles.m1.timeEMG_log;   
            b=ones(length(a),1);           
            timeemg = a-a(1).*b;
            
            emg = handles.m1.emg_log(1:length(timeemg),:);
            
            c=handles.m1.timeIMU_log;           
            d=ones(length(c),1);           
            timevectorimu=c-c(1).*d;
            
            
            gyromatrix=handles.m1.gyro_log();
            
            
            %% NN
            maxEMG2=max(handles.m1.emg_log(end-20:end,2)); %Son 100ms'de max emg2 verisi bulundu
            maxEMG7=max(handles.m1.emg_log(end-20:end,7)); %Son 100ms'de max emg7 verisi bulundu

            NNinput= [1; maxEMG2; maxEMG7];

            W =     [ 0.8836   -7.0693    6.6697
                      1.5403  -14.4231  -13.9882
                     -9.7691   10.6543   27.0664
                     -0.1365   16.2684  -13.0495];


            V =     [3.3316   10.5119  -27.4685   12.1715
                    -10.7406  -19.9309  -15.7503   25.9366];

            z=zeros(4,1);
 
            z(1) = 1/(1 + exp(-W(1,:)*NNinput));
            z(2) = 1/(1 + exp(-W(2,:)*NNinput));
            z(3) = 1/(1 + exp(-W(3,:)*NNinput));
            z(4) = 1/(1 + exp(-W(4,:)*NNinput));


             y(1) = 1/(1 + exp(-V(1,:)*z)); 
             y(2) = 1/(1 + exp(-V(2,:)*z));

             result=2*y(1) + 1*y(2);


             if(abs(result-0)<0.0001) %FLEXION
                FX=FX+1;
                if(FX>5)
                    set (handles.text10,'String','FLEXION');
                end
                FS=0;
                RX=0;
                EX=0;
             end
             if(abs(result-1)<0.0001) %FIST
                FS=FS+1;
                if(FS>5)
                    set (handles.text10,'String','FIST');
                end
                FX=0;
                RX=0;
                EX=0;
             end
             if(abs(result-2)<0.0001) %DO NOTHING
                RX=RX+1;
                if(RX>5)
                    set (handles.text10,'String','RELAX');
                end
                FX=0;
                FS=0;
                EX=0;
             end
             if(abs(result-3)<0.0001) %EXTENSION
                EX=EX+1;
                if(EX>5)
                    set (handles.text10,'String','EXTENSION');
                end
                FX=0;
                FS=0;
                RX=0;
             end
             

%% NN     
            
            


%{
                                                            anglex=cumtrapz(timevectorimu,gyromatrix(:,1));
                                                            angley=cumtrapz(timevectorimu,gyromatrix(:,2));
                                                            anglez=cumtrapz(timevectorimu,gyromatrix(:,3));
%}                                  
            
          if(length(timevectorimu)== length(gyromatrix)) 
            tvi=timevectorimu;
            gyro1=gyromatrix(:,1);
            gyro2=gyromatrix(:,2);
            gyro3=gyromatrix(:,3);
            anglex=cumtrapz(tvi,gyro1);
            angley=cumtrapz(tvi,gyro2);
            anglez=cumtrapz(tvi,gyro3);
          else                                           
              continue;                                  
          end                                            

            anglematrixgyros=[anglex,angley,anglez];
           
           % anglematrixdeg=rad2deg(quat2eul(  handles.m1.quat_log(1:length(timevectorimu),:),'XYZ'));
        %Hepsi için son 300 datasýndan bir matris oluþturuyoruz:
        
         timeemg=timeemg(end-299:end);
         emg=emg(end-299:end,:);
         timevectorimu=timevectorimu(end-74:end);
         anglematrixgyros=anglematrixgyros(end-74:end,:);
       
     else
        if (length(handles.m1.timeEMG_log)>0 && length(handles.m1.timeIMU_log)>0) %Data gelene kadar continue ile baþa dönüyoruz

            a=handles.m1.timeEMG_log;   
            b=ones(length(a),1);           
            timeemg = a-a(1).*b;
            
            emg = handles.m1.emg_log(1:length(timeemg),:);
            
            c=handles.m1.timeIMU_log;           
            d=ones(length(c),1);           
            timevectorimu=c-c(1).*d;
            
            gyromatrix=handles.m1.gyro_log();
            
            
            
            
            
          if(length(timevectorimu)== length(gyromatrix)) 
            tvi=timevectorimu;
            gyro1=gyromatrix(:,1);
            gyro2=gyromatrix(:,2);
            gyro3=gyromatrix(:,3);
            anglex=cumtrapz(tvi,gyro1);
            angley=cumtrapz(tvi,gyro2);
            anglez=cumtrapz(tvi,gyro3);
          else                                           
              continue;                                  
          end           
                      
 
            anglematrixgyros=[anglex,angley,anglez];
            
        else 
            continue;
        end
     end
     
  
    %subplot(2,1,1); 
     
     p1=plot(handles.axes7,timeemg,emg); title('EMG');
    %subplot(2,1,2); 
     timeVal = int2str(t);
     
     yVal = angley(end);
     if yVal>80
         yVal = 80;
     elseif yVal<0
         yVal = 0;
     else
         yVal = yVal;
     end  
     
     k=3;
     yValReductorCalculated = k*yVal;
     yValString = int2str(yVal);
     
                 
     set (handles.text11,'String',timeVal);
     set (handles.text12,'String',yValString);
     
     GoalAngle = round((dxl2_initialPos) + (yValReductorCalculated/(360/4096))); 
     
     % Write goal position
     write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL2_ID, ADDR_PRO_GOAL_POSITION, typecast(int32(GoalAngle), 'uint32'));
     if getLastTxRxResult(port_num, PROTOCOL_VERSION) ~= COMM_SUCCESS
         printTxRxResult(PROTOCOL_VERSION, getLastTxRxResult(port_num, PROTOCOL_VERSION));
     elseif getLastRxPacketError(port_num, PROTOCOL_VERSION) ~= 0
         printRxPacketError(PROTOCOL_VERSION, getLastRxPacketError(port_num, PROTOCOL_VERSION));
     end
     
     % Write goal position
     write4ByteTxRx(port_num, PROTOCOL_VERSION, DXL1_ID, ADDR_PRO_GOAL_POSITION, typecast(int32(dxl1_initialPos), 'uint32'));
     if getLastTxRxResult(port_num, PROTOCOL_VERSION) ~= COMM_SUCCESS
         printTxRxResult(PROTOCOL_VERSION, getLastTxRxResult(port_num, PROTOCOL_VERSION));
     elseif getLastRxPacketError(port_num, PROTOCOL_VERSION) ~= 0
         printRxPacketError(PROTOCOL_VERSION, getLastRxPacketError(port_num, PROTOCOL_VERSION));
     end
     
     % Read present position
     dxl2_present_position = read4ByteTxRx(port_num, PROTOCOL_VERSION, DXL2_ID, ADDR_PRO_PRESENT_POSITION);
     if getLastTxRxResult(port_num, PROTOCOL_VERSION) ~= COMM_SUCCESS
         printTxRxResult(PROTOCOL_VERSION, getLastTxRxResult(port_num, PROTOCOL_VERSION));
     elseif getLastRxPacketError(port_num, PROTOCOL_VERSION) ~= 0
         printRxPacketError(PROTOCOL_VERSION, getLastRxPacketError(port_num, PROTOCOL_VERSION));
     end     
     
                            %%
                             %Read Actual Current
                                    dxl_present_cur = read2ByteTxRx(port_num, PROTOCOL_VERSION, DXL2_ID, ADDR_PRO_PRESENT_CURRENT);
                                    if getLastTxRxResult(port_num, PROTOCOL_VERSION) ~= COMM_SUCCESS
                                        printTxRxResult(PROTOCOL_VERSION, getLastTxRxResult(port_num, PROTOCOL_VERSION));
                                    elseif getLastRxPacketError(port_num, PROTOCOL_VERSION) ~= 0
                                        printRxPacketError(PROTOCOL_VERSION, getLastRxPacketError(port_num, PROTOCOL_VERSION));
                                    end 
                                    
                                   %Save actuated current info to an array.
                                   
                              
     cur(index)  = typecast(uint16(dxl_present_cur), 'int16');
     %cur(index) = dxl_present_cur
     
     % Save pos. to vectors
     GoalPosVector(index ) =  yVal;
     KneePosVector(index) = typecast(uint32((dxl2_present_position-dxl2_initialPos)/k), 'int32');
     timeVectors(index) = t;
     index = index+1;
    
     p2=plot(handles.axes8,timevectorimu,anglematrixgyros); title('ABSOLUTE ANGLES [DEG]');
    
      if (t < 1.2)
          startSpot = 0;
      else
          startSpot = t-1.2;
      end
      
      xlim(handles.axes7,[startSpot (t+0.25)]);
      ylim(handles.axes7,[-1 1]);  
      
      xlim(handles.axes8,[startSpot (t+0.25)]);
      ylim(handles.axes8,[-180 180]);

      %axis([p1,p2],[startSpot (t+0.25)],[-1 1],[startSpot (t+0.25)],[-180 180])
      
    
      
    
      

      
      grid
      t = timeemg(end);
      drawnow;
      pause(0.001)
end
%toc 
%BURADA YENÝ BÝR GUI EKRANINDA EMG DATALARINI ANLIK YAZDIRALIM





handles.m1.stopStreaming();
set(handles.pushbutton2,'visible', 'off'); %Mark butonu invisible!

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

% figure
% plot(GoalPosVector)
% hold on
% plot(KneePosVector*(360/4096))
% legend('GoalPos','Actuated')

figure
plot(timeVectors,GoalPosVector)
hold on
plot(timeVectors,KneePosVector*(360/4096))
xlabel('time[s]')
ylabel('angle[deg]')
legend('GoalPos','Actuated')


figure
plot(timeVectors,cur)
title('current')
xlabel('time[s]','FontSize',15)
ylabel('Current [3.36mA]','FontSize',15)




timevectoremg=handles.m1.timeEMG_log - handles.m1.timeEMG_log(1)*ones(length(handles.m1.timeEMG_log),1);
timevectorimu=handles.m1.timeIMU_log - handles.m1.timeIMU_log(1)*ones(length(handles.m1.timeIMU_log),1);

checkEMGs=ones(1,8);
checkEMGs(1)= get(handles.checkbox1,'Value');
checkEMGs(2)= get(handles.checkbox2,'Value');
checkEMGs(3)= get(handles.checkbox3,'Value');
checkEMGs(4)= get(handles.checkbox4,'Value');
checkEMGs(5)= get(handles.checkbox5,'Value');
checkEMGs(6)= get(handles.checkbox6,'Value');
checkEMGs(7)= get(handles.checkbox7,'Value');
checkEMGs(8)= get(handles.checkbox8,'Value');
numberofchecksemg=sum(checkEMGs(:) == 1);


checkGYROs=ones(1,3);
checkGYROs(1)= get(handles.checkbox9,'Value');
checkGYROs(2)= get(handles.checkbox10,'Value');
checkGYROs(3)= get(handles.checkbox11,'Value');
numberofchecksgyro=sum(checkGYROs(:) == 1);

checkACCELs=ones(1,3);
checkACCELs(1)= get(handles.checkbox12,'Value');
checkACCELs(2)= get(handles.checkbox13,'Value');
checkACCELs(3)= get(handles.checkbox14,'Value');
numberofchecksaccel=sum(checkACCELs(:) == 1);

checkANGLEs=ones(1,3);
checkANGLEs(1)= get(handles.checkbox15,'Value');
checkANGLEs(2)= get(handles.checkbox16,'Value');
checkANGLEs(3)= get(handles.checkbox17,'Value');
numberofchecksangle=sum(checkANGLEs(:) == 1);




if(numberofchecksemg>0) %%Eðer hiç emg checkbox seçilmediyse skip!
    %plotGUI
    figure

    k=1;
    for i=1:1:8   
        if checkEMGs(i)
            subplot(numberofchecksemg,1,k); plot(timevectoremg,handles.m1.emg_log(:,i));   title(strcat('EMG Sensor ',num2str(i)));
            k=k+1;
        end   
        xlabel('time [s]')
        ylabel('%')
    end
end


if(numberofchecksgyro>0) %%Eðer hiç gyro checkbox seçilmediyse skip!
    plotGYRO

    l=1;
    for m=1:1:3   
        if checkGYROs(m)
            subplot(numberofchecksgyro,1,l); plot(timevectorimu,handles.m1.gyro_log(:,m));   title(strcat('GYRO  ',num2str(m)));
            l=l+1;
            xlabel('time [s]')
            ylabel('*/s')
        end   
    end
end


if(numberofchecksaccel>0) %%Eðer hiç acceleration checkbox seçilmediyse skip!
    plotACCEL
    
    n=1;
    for j=1:1:3   
        if checkACCELs(j)
            subplot(numberofchecksaccel,1,n); plot(timevectorimu,handles.m1.accel_log(:,j));   title(strcat('ACCEL  ',num2str(j)));
            n=n+1;
            xlabel('time [s]')
            ylabel('g')

        end   
    end
end


if(numberofchecksangle>0) %%Eðer hiç acceleration checkbox seçilmediyse skip!
    %plotANGLEs
    figure
  
    gyromatrix=handles.m1.gyro_log();
            
    anglex=cumtrapz(timevectorimu,gyromatrix(:,1));
    angley=cumtrapz(timevectorimu,gyromatrix(:,2));
    anglez=cumtrapz(timevectorimu,gyromatrix(:,3));
 
    anglematrixgyros=[anglex,angley,anglez];
   
    q=1;
    for u=1:1:3   
        if checkANGLEs(u)
            subplot(numberofchecksangle,1,q); plot(timevectorimu,anglematrixgyros(:,u));   title(strcat('Euler Angle  ',num2str(u)));
            q=q+1;
            xlabel('time [s]')
            ylabel('Angle[Degrees]')

        end   
    end
end

%% Interpolate and Save to file:



if(get(handles.checkbox20,'Value')==1) %interpolated data save
    

    %%marking
    handles.marksemgtime=getappdata(0,'marks');
    guidata(hObject, handles);
    
    
    
    cutindexes=find(handles.marksemgtime==-99);
    handles.marksemgtime(cutindexes)=[];
    guidata(hObject, handles);
    
  
    
    markindex=(-1*ones(1,length(handles.marksemgtime)))'; %%1 yapmamýz gereken indexler
    
    a=handles.m1.timeEMG_log;   
    b=ones(length(a),1);           
    timeemg = a-a(1).*b;
    
    if(handles.marksemgtime(end)~=-99) %Hiç mark yapýlmadý ise girme!
        for o=1:1:length(markindex)     
            markindex(o) = find(timeemg==handles.marksemgtime(o)) ;  
        end
    end
    
    timeemglength=length(timeemg);
    markvector=zeros(1,timeemglength)'; % emgtime ile ayný boyutta 0 vector.
    
    if(handles.marksemgtime(end)~=-99) %Hiç mark yapýlmadý ise girme!
    markvector(markindex)=[1];
    end
    
    
   %%marking
   
    
    timevectoremg=handles.m1.timeEMG_log - handles.m1.timeEMG_log(1)*ones(length(handles.m1.timeEMG_log),1); %200Hz time 0 dan baþlar.
    timevectorimu=handles.m1.timeIMU_log - handles.m1.timeIMU_log(1)*ones(length(handles.m1.timeIMU_log),1); %50Hz time 0 dan baþlar.
 
    emgmatrix=handles.m1.emg_log; %emg datasýný tutar 200Hz

    gyromatrix=handles.m1.gyro_log();
            
    anglex=cumtrapz(timevectorimu,gyromatrix(:,1));
    angley=cumtrapz(timevectorimu,gyromatrix(:,2));
    anglez=cumtrapz(timevectorimu,gyromatrix(:,3));
 
    anglematrixgyros=[anglex,angley,anglez]; %angle datasý 50Hz



    %% Expand anglematrix via interpolation. ( 50Hz ---> 200Hz )

    %Define the query points to be a finer sampling over the range of x.
    desiredtimeinterval = timevectoremg;
    %Interpolate the function at the query points and plot the result.
    imutimeinterp = interp1(timevectorimu,timevectorimu,desiredtimeinterval);

    anglesxinterp = interp1(timevectorimu, anglematrixgyros(:,1),desiredtimeinterval);
    anglesyinterp = interp1(timevectorimu, anglematrixgyros(:,2),desiredtimeinterval);
    angleszinterp = interp1(timevectorimu, anglematrixgyros(:,3),desiredtimeinterval);

    anglematrixdegrelativeinterp=[anglesxinterp, anglesyinterp, angleszinterp];

    % Save results to a file

    T = table(timevectoremg,emgmatrix,imutimeinterp,anglematrixdegrelativeinterp,markvector,'VariableNames',{'TimeEmg','Emg','TimeIMUInterpolated','InterpolatedAngles','IsMarked'});
    filename = strcat(get(handles.edit5,'String'),'.xlsx');
    % Write table to file 
    writetable(T,filename)
    % Print confirmation to command line
    fprintf('Results table with %g emg measurements saved to file %s\n',length(timevectoremg),filename)
end


    

%% Interpolate and Save to file



%% Cut and Save to file:
if(get(handles.checkbox21,'Value')==1)

    timevectoremg=handles.m1.timeEMG_log - handles.m1.timeEMG_log(1)*ones(length(handles.m1.timeEMG_log),1);
    timevectorimu=handles.m1.timeIMU_log - handles.m1.timeIMU_log(1)*ones(length(handles.m1.timeIMU_log),1);

    emgmatrix=handles.m1.emg_log;
    emg1vector=emgmatrix(:,1);
    gyromatrix=handles.m1.gyro_log();
    accelmatrix=handles.m1.accel_log();
    
    
    
    %% quat tan elde edlilen yanlýþ data
    anglematrixdeg=rad2deg(quat2eul(handles.m1.quat_log)); %quat_log matrisinden elde edilyor.
    difmatrix1s=ones(length(anglematrixdeg),3); %anglematrixdeg ile ayný boyutlarda her elamaný 1 olan bir matris.
    difmatrix1s(:,1)=difmatrix1s(:,1)*anglematrixdeg(1,1); %1. column ilk Qx deðeri ile çarpýldý
    difmatrix1s(:,2)=difmatrix1s(:,2)*anglematrixdeg(1,2);
    difmatrix1s(:,3)=difmatrix1s(:,3)*anglematrixdeg(1,3);
    anglematrixdegrelative=anglematrixdeg-difmatrix1s;
    %% quat tan elde edlilen yanlýþ data
    
    

    % CUT and save EMGTÝME AND EMGDATA in a matrix 50Hz instead of 200Hz

    i=1;
    k=1;

    emgtimevcut=-99.*ones(length(timevectorimu),1);
    emgmcut=-99.*ones(length(timevectorimu),8);


    while (i<=length(timevectorimu) && k<=length(timevectoremg))
    
        if (abs(timevectorimu(i)-timevectoremg(k))<0.000001)
        
            emgtimevcut(i)=timevectorimu(i);
            emgmcut(i,:)=emgmatrix(k,:); %Orjinal emg matrisinin k. satýrýný yeni emg matrisinin i. satýrýna taþýdým.
      
        else
            k=k+1;
            continue;
        end
    
        i=i+1;    
    end


    if(emgtimevcut(end)==-99) %%True ise silinmesi gereken en az 1 row var demek!
    indexes=find(emgtimevcut==-99) %%Silinmesi gereken rowlarýn indexlerini tuttuk

    %Silme iþlemini yapýyoruz
    emgtimevcut(indexes,:)=[];
    emgmcut(indexes,:)=[];
    timevectorimu(indexes,:)=[];
   %anglematrixdegrelative(indexes,:)=[];
    gyromatrix(indexes,:)=[];
    %Gerekirse burada yazýlacak diðer imu verilerinden de silme yapýlacak!
    
    anglex=cumtrapz(timevectorimu,gyromatrix(:,1));
    angley=cumtrapz(timevectorimu,gyromatrix(:,2));
    anglez=cumtrapz(timevectorimu,gyromatrix(:,3));
    anglematrixgyros=[anglex,angley,anglez];
    
    end
    % Save results to a file

    T = table(emgtimevcut,emgmcut,timevectorimu,anglematrixgyros,'VariableNames',{'TimeEmgCut','EmgCut','TimeIMU','Angles_Gyro'});
    filename = strcat(get(handles.edit7,'String'),'.xlsx');
    % Write table to file 
    writetable(T,filename)
    % Print confirmation to command line
    fprintf('Results table with %g emg measurements saved to file %s\n',length(timevectorimu),filename)
    
    end

    handles.mm.delete();
    clear handles.mm;
 

% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4


% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5


% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox6


% --- Executes on button press in checkbox7.
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox7


% --- Executes on button press in checkbox8.
function checkbox8_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox8



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


% --- Executes on button press in checkbox9.
function checkbox9_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox9


% --- Executes on button press in checkbox10.
function checkbox10_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox10


% --- Executes on button press in checkbox11.
function checkbox11_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox11


% --- Executes on button press in checkbox12.
function checkbox12_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox12


% --- Executes on button press in checkbox13.
function checkbox13_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox13


% --- Executes on button press in checkbox14.
function checkbox14_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox14


% --- Executes on button press in checkbox15.
function checkbox15_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox15


% --- Executes on button press in checkbox16.
function checkbox16_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox16


% --- Executes on button press in checkbox17.
function checkbox17_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox17



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


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


% --- Executes on button press in checkbox20.
function checkbox20_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox20


% --- Executes on button press in checkbox21.
function checkbox21_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox21



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


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


numberofmarks=str2num(get (handles.MarkText,'String'));

%Time vectorünü 0 dan baþlamýþ hale getiriyorum
a=handles.m1.timeEMG_log;   
b=ones(length(a),1);           
timeemg = a-a(1).*b;

%Marksemgtime vectoru içine butona basýldýðý andaki saniyeyi koyuyorum
handles.marksemgtime(numberofmarks+1)=timeemg(end);
%update handles
guidata(hObject, handles);

stringcounter=num2str(numberofmarks+1);
set (handles.MarkText,'String',stringcounter);
transfervector=handles.marksemgtime;
setappdata(0,'marks',transfervector);


set (handles.MTV,'String',strcat(get(handles.MTV,'String'),strcat(':',num2str(timeemg(end)))));



function MarkText_Callback(hObject, eventdata, handles)
% hObject    handle to MarkText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MarkText as text
%        str2double(get(hObject,'String')) returns contents of MarkText as a double


% --- Executes during object creation, after setting all properties.
function MarkText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MarkText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MTV_Callback(hObject, eventdata, handles)
% hObject    handle to MTV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MTV as text
%        str2double(get(hObject,'String')) returns contents of MTV as a double


% --- Executes during object creation, after setting all properties.
function MTV_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MTV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
