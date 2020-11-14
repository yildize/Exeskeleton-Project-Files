function varargout = MotorDriveGUI(varargin)
% MOTORDRIVEGUI MATLAB code for MotorDriveGUI.fig
%      MOTORDRIVEGUI, by itself, creates a new MOTORDRIVEGUI or raises the existing
%      singleton*.
%
%      H = MOTORDRIVEGUI returns the handle to a new MOTORDRIVEGUI or the handle to
%      the existing singleton*.
%
%      MOTORDRIVEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MOTORDRIVEGUI.M with the given input arguments.
%
%      MOTORDRIVEGUI('Property','Value',...) creates a new MOTORDRIVEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MotorDriveGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MotorDriveGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MotorDriveGUI

% Last Modified by GUIDE v2.5 01-Apr-2019 12:25:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MotorDriveGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @MotorDriveGUI_OutputFcn, ...
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


% --- Executes just before MotorDriveGUI is made visible.
function MotorDriveGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MotorDriveGUI (see VARARGIN)
clc 
countMyos = 1;
handles.mm = MyoMex(countMyos);
handles.m1 = handles.mm.myoData(1); 

%% MOTOR ILE ILGILI ILK KODLAR <



%% MOTOR ILE ILGILI ILK KODLAR >


% Choose default command line output for MotorDriveGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MotorDriveGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MotorDriveGUI_OutputFcn(hObject, eventdata, handles) 
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

% Load Libraries
if ~libisloaded('dxl_x64_c')
    [notfound, warnings] = loadlibrary('dxl_x64_c', 'dynamixel_sdk.h', 'addheader', 'port_handler.h', 'addheader', 'packet_handler.h', 'addheader', 'group_bulk_read.h', 'addheader', 'group_bulk_write.h');
end


hip = [33.0020599365234
32.9961166381835
32.9022865295410
32.7251701354980
32.4885025024414
32.2425765991210
31.9790401458740
31.6379680633544
31.1666221618652
30.5649471282958
29.8566493988037
29.0381107330322
28.1263275146484
27.1368141174316
26.1073455810546
25.0718631744384
24.0372943878173
22.9979515075683
21.9433460235595
20.8605537414550
19.7469654083251
18.5935440063476
17.4081439971923
16.1928977966308
14.9482555389404
13.6897535324096
12.4322538375854
11.1794776916503
9.9406013488770
8.7219266891479
7.5251364707947
6.3478674888611
5.1944661140442
4.0714416503906
2.9829537868500
1.9266539812088
0.9017928242683
-0.0949064493179
-1.0637298822403
-2.0000596046448
-2.8958532810211
-3.7348558902740
-4.5061912536621
-5.2052955627441
-5.8269972801208
-6.3732309341431
-6.8485932350159
-7.2627344131470
-7.6247291564941
-7.9376230239868
-8.1883201599121
-8.3246707916260
-8.3151283264160
-8.1381597518921
-7.8028392791748
-7.3256626129150
-6.6989431381226
-5.9068794250488
-4.9218425750732
-3.7272205352783
-2.3101551532745
-0.6890018582344
1.0933736562729
3.0001778602600
4.9658031463623
6.9535708427429
8.9540643692017
10.9481077194213
12.9302864074707
14.8752241134643
16.7498912811279
18.5277938842773
20.2187404632568
21.8537902832031
23.4282608032226
24.9365539550781
26.3409023284912
27.6500053405761
28.8645896911621
29.9674835205078
30.9468708038330
31.7855224609375
32.4818572998046
33.0246810913085
33.4131469726562
33.6506233215332
33.7299385070800
33.6605300903320
33.4512252807617
33.1463737487792
32.7834167480468
32.3931007385253
32.0288085937500
31.7320175170898
31.5344944000244
31.4407844543457
31.4482364654541
31.5487995147705
31.7119159698486
31.8889904022216
33.0020599365234];




knee = [7.94416189193725
9.32002353668212
10.26949787139890
10.98186588287350
11.85558986663810
13.14454650878900
14.72700881958000
16.23527526855460
17.43891143798820
18.32238578796380
18.95714569091790
19.32979011535640
19.43752479553220
19.28828430175780
18.95792388916010
18.54344940185540
18.09063529968260
17.63248443603510
17.16906547546380
16.69008636474600
16.19159889221190
15.66807746887200
15.12835025787350
14.57038879394530
13.99144840240470
13.39033794403070
12.76707172393790
12.13257217407220
11.49122142791740
10.85100078582760
10.22210502624510
9.61800193786621
9.05775928497314
8.56165218353271
8.14449882507324
7.80518579483032
7.54060602188110
7.34648084640502
7.22678184509277
7.19422483444213
7.25126838684082
7.41063356399536
7.68543815612792
8.08269500732421
8.61239624023437
9.26546382904052
10.02891159057610
10.89607238769530
11.86620330810540
12.93995189666740
14.12257194519040
15.45643901824950
16.96233558654780
18.68184471130370
20.63736152648920
22.82624435424800
25.24896430969230
27.89923286437980
30.77828598022460
33.87284469604490
37.15571212768550
40.54917144775390
43.95245742797850
47.25880813598630
50.36808776855460
53.21256256103510
55.74335098266600
57.93608856201170
59.77521896362300
61.25550079345700
62.35399627685540
63.05057907104490
63.37553024291990
63.34664916992180
62.99328994750970
62.32610702514640
61.31919479370110
59.99690628051750
58.36628341674800
56.44129562377920
54.23117065429680
51.71706008911130
48.91371536254880
45.81033325195310
42.43138122558590
38.80767440795890
34.95063018798820
30.93660163879390
26.82167816162100
22.72513198852530
18.74131774902340
15.00180816650390
11.63293838500970
8.74474143981933
6.46722602844238
4.84831571578979
3.97896361351013
3.80848383903503
4.36116695404052
5.50598049163818
7.94416189193725];


hip=round(hip*1.5); 
knee=round(knee*1.5);

hip = hip/(360/4096);
knee = knee/(360/4096);


% Control table address
ADDR_PRO_TORQUE_ENABLE          = 64;          % Control table address is different in Dynamixel model
ADDR_PRO_LED_RED                = 65;
ADDR_PRO_GOAL_POSITION          = 116;
ADDR_PRO_PRESENT_POSITION       = 132;
ADDR_PRO_OPERATING_MODE         = 11;

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


%% Relative Referans Deðerler Oluþturulsun
hip = dxl1_present_position - hip;
knee= dxl2_present_position + knee;

hip = round(hip);   
knee = round(knee);



%% Smoothen the first step by interpolation
increaseHip=hip(1)-dxl1_present_position;
hipAddVector=round((dxl1_present_position:(increaseHip/20):hip(1))');

increaseKnee=knee(1)-dxl2_present_position;
kneeAddVector=round((dxl2_present_position:(increaseKnee/20):knee(1))');

hip1stStep=ones(121,1);
knee1stStep=ones(121,1);

% ÝLK ADIM VECTORU OLUÞTURULUYOR
hip1stStep(1:20)=hipAddVector(1:20);
hip1stStep(21:121)=hip;
% ÝLK ADIM VECTORU OLUÞTURULUYOR
knee1stStep=kneeAddVector(1:20);
knee1stStep(21:121)=knee;

%%


T = str2num(get (handles.edit2,'String')); % seconds
handles.m1.clearLogs()
handles.m1.startStreaming();
pause(1);




IsFirstStepExecuted = false;
index = 1;
index_adim = 0;
StopAfterOngoingStep = false;
FX=0;
FS=0;
EX=0;
RX=0;
t = 0 ;
x = 0 ;
tstart=99; 
figurecount=0;

fullmoveindex=1;

%% t<T BOYUNCA      
while ( t < T )
            
            maxEMG2=max(handles.m1.emg_log(end-20:end,2)); %Son 100ms'de max emg2 verisi bulundu                        
            maxEMG7=max(handles.m1.emg_log(end-20:end,7)); %Son 100ms'de max emg7 verisi bulundu
                
             
            input1= [1; maxEMG2; maxEMG7];

            W =     [ 0.8836   -7.0693    6.6697
                      1.5403  -14.4231  -13.9882
                     -9.7691   10.6543   27.0664
                     -0.1365   16.2684  -13.0495];


            V =     [3.3316   10.5119  -27.4685   12.1715
                    -10.7406  -19.9309  -15.7503   25.9366];

            z=zeros(4,1);
 
            z(1) = 1/(1 + exp(-W(1,:)*input1));
            z(2) = 1/(1 + exp(-W(2,:)*input1));
            z(3) = 1/(1 + exp(-W(3,:)*input1));
            z(4) = 1/(1 + exp(-W(4,:)*input1));


             y(1) = 1/(1 + exp(-V(1,:)*z)); 
             y(2) = 1/(1 + exp(-V(2,:)*z));

             result=2*y(1) + 1*y(2);

         
                                                  
                                        
                                        
                                           
            
             
             if(abs(result-3)<0.0001) %EXTENSION
                EX=EX+1;
                if(EX>5)
                    %% EXTENSION TESPÝT EDÝLÝNCE MOTOR ADIM ATMAYA BAÞLASIN                   
                    tic; 
                    set (handles.text1,'String','YÜRÜYÜÞ MODU!');  
                    
                    
                           while(1)
                                    
                                                                                                                               
                                 % Add parameter storage for Dynamixel#1 goal position
                                 if(IsFirstStepExecuted)%Ýlk adým deðil ise
                                    dxl_addparam_result = groupBulkWriteAddParam(groupwrite_num, DXL1_ID, ADDR_PRO_GOAL_POSITION, LEN_PRO_GOAL_POSITION, typecast(int32(hip(index)), 'uint32'), LEN_PRO_GOAL_POSITION);
                                    if dxl_addparam_result ~= true
                                      fprintf(stderr, '[ID:%03d] groupBulkWrite addparam failed', DXL1_ID);
                                      return;
                                    end
                                    
                                 else %Ýlk adým ise
                                    dxl_addparam_result = groupBulkWriteAddParam(groupwrite_num, DXL1_ID, ADDR_PRO_GOAL_POSITION, LEN_PRO_GOAL_POSITION, typecast(int32(hip1stStep(index)), 'uint32'), LEN_PRO_GOAL_POSITION);
                                    if dxl_addparam_result ~= true
                                      fprintf(stderr, '[ID:%03d] groupBulkWrite addparam failed', DXL1_ID);
                                      return;
                                    end                                     
                                     
                                 end  
                                    
                                 if(IsFirstStepExecuted)%Ýlk adým deðil ise 
                                    % Add parameter storage for Dynamixel#2 
                                    dxl_addparam_result = groupBulkWriteAddParam(groupwrite_num, DXL2_ID, ADDR_PRO_GOAL_POSITION, LEN_PRO_GOAL_POSITION, typecast(int32(knee(index)), 'uint32'), LEN_PRO_GOAL_POSITION);
                                    if dxl_addparam_result ~= true
                                      fprintf(stderr, '[ID:%03d] groupBulkWrite addparam failed', DXL2_ID);
                                      return;
                                    end
                                    
                                 else %Ýlk adým ise
                                    dxl_addparam_result = groupBulkWriteAddParam(groupwrite_num, DXL2_ID, ADDR_PRO_GOAL_POSITION, LEN_PRO_GOAL_POSITION, typecast(int32(knee1stStep(index)), 'uint32'), LEN_PRO_GOAL_POSITION);
                                    if dxl_addparam_result ~= true
                                      fprintf(stderr, '[ID:%03d] groupBulkWrite addparam failed', DXL2_ID);
                                      return;
                                    end                                     
                                     
                                 end    
                                 
                                    
                                    % BURADA MOTORLARA GOAL POSITION BÝLGÝSÝ EÞ ZAMANLI OLARAK YOLLANDI VE MOTORLAR ILGILI INDEX ILE BELIRTILEN POZISYONA SÜRÜLDÜ                                                          
                                    groupBulkWriteTxPacket(groupwrite_num);
                                    if getLastTxRxResult(port_num, PROTOCOL_VERSION) ~= COMM_SUCCESS
                                        printTxRxResult(PROTOCOL_VERSION, getLastTxRxResult(port_num, PROTOCOL_VERSION));
                                    end
                                    
                                     % Clear bulkwrite parameter storage
                                     groupBulkWriteClearParam(groupwrite_num);
                                     
                                     
                                     %ÞÝMDÝ ANLIK OLARAK POZÝSYON ALALIM.
                                     
                                    % Bulkread present positions
                                    groupBulkReadTxRxPacket(groupread_num);
                                    if getLastTxRxResult(port_num, PROTOCOL_VERSION) ~= COMM_SUCCESS
                                        printTxRxResult(PROTOCOL_VERSION, getLastTxRxResult(port_num, PROTOCOL_VERSION));
                                    end
                                    
                                                                                                                                         
                                    % Check if groupbulkread data of Dynamixel#1 is available
                                    dxl_getdata_result = groupBulkReadIsAvailable(groupread_num, DXL1_ID, ADDR_PRO_PRESENT_POSITION, LEN_PRO_PRESENT_POSITION);
                                    if dxl_getdata_result ~= true
                                        fprintf('[ID:%03d] groupBulkRead getdata failed', DXL1_ID);
                                        return;
                                    end

                                    % Check if groupbulkread data of Dynamixel#2 is available
                                    dxl_getdata_result = groupBulkReadIsAvailable(groupread_num, DXL2_ID, ADDR_PRO_PRESENT_POSITION, LEN_PRO_PRESENT_POSITION);
                                    if dxl_getdata_result ~= true
                                        fprintf('[ID:%03d] groupBulkRead getdata failed', DXL2_ID);
                                        return;
                                    end

                                    % Get Dynamixel#1 present position value
                                    dxl1_present_position = groupBulkReadGetData(groupread_num, DXL1_ID, ADDR_PRO_PRESENT_POSITION, LEN_PRO_PRESENT_POSITION);
                                    % Get Dynamixel#2 present position value
                                    dxl2_present_position = groupBulkReadGetData(groupread_num, DXL2_ID, ADDR_PRO_PRESENT_POSITION, LEN_PRO_PRESENT_POSITION);

                                    %SON TUR HAREKETÝ KAYDEDÝLSÝN
                                    if(IsFirstStepExecuted)
                                        pos1(index) = typecast(uint32(dxl1_present_position), 'int32'); %her iterasyonda pozisyon bilgisini vektörlere atýyoruz.
                                        pos2(index) = typecast(uint32(dxl2_present_position), 'int32'); %her iterasyonda pozisyon bilgisini vektörlere atýyoruz.
                                        t1(index)=toc; %Son turun verisini tutatacaktýr.
                                    end
                                    
                                    
                                    %TÜM HAREKET KAYDEDÝLSÝN
                                    pos1full(fullmoveindex) = typecast(uint32(dxl1_present_position), 'int32'); %her iterasyonda pozisyon bilgisini vektörlere atýyoruz.
                                    pos2full(fullmoveindex) = typecast(uint32(dxl2_present_position), 'int32'); %her iterasyonda pozisyon bilgisini vektörlere atýyoruz.                                                                        
                                    t1full(fullmoveindex)=t;
                                                                        
                                                                                                                                                                                                                   
                                    %Loop zamaný emg ile tutuluyor.
                                    a=handles.m1.timeEMG_log;   
                                    b=ones(length(a),1);           
                                    timeemg = a-a(1).*b;
                                    t = timeemg(end)-1;            
                                    set(handles.edit2,'String',num2str(t));
                                    pause(0.0001);
                                    
                                    %Ýndex artýma
                                    index = index + 1 ;
                                    fullmoveindex = fullmoveindex+1;                                    
                                    
                                    
                                    
                                   %%  
                                   
                                   %Buraya sadece 1 kere girecek.
                                   if (index == 122 && ~IsFirstStepExecuted) %Ýlk tur ise ve adým tamamlanmýþ ise.
                                        IsFirstStepExecuted = true;
                                        if(StopAfterOngoingStep == true) % Adým bitince duracak!
                                            index=1;
                                            StopAfterOngoingStep = false;                                              
                                            set (handles.text1,'String','Yürüme sonlandý!');
                                            pause(0.3) % Yazý görülsün diye
                                            break;                                             
                                        end
                                        index = 1;
                                        index_adim = index_adim + 1; %Bu deðer 1 olunca 1 adým atýlmýþ demek.
                                        set (handles.text1,'String','Ýlk Adým Atýldý!'); 
                                        pause(0.3); %Tur tamamlanýnca 0.3 s dinlensin  
                                        set (handles.text1,'String','Yürüme modu'); 
                                    end 
                                    
                                                                                                          
                                    if (index == 102 && IsFirstStepExecuted) %Ýlk tur deðil ise. Bir adým tamamlanmýþsa.
                                        if(StopAfterOngoingStep == true) % Adým bitince duracak!
                                            index=1; 
                                            index_adim =0;
                                            StopAfterOngoingStep = false;                                             
                                            set (handles.text1,'String','Yürüme sonlandý!');
                                            pause(0.3) %Yazý görülsün diye
                                            break;                                             
                                        end
                                        index = 1;
                                        index_adim = index_adim + 1;
                                        pause(0.5); %Tur tamamlanýnca 0.3 s dinlensin
                                    end
                                    

                                    if(index_adim > 20 ) %% Durdurulmazsa Max 20 tur atýyor. Durdurulunca sýfýrlanýr. index_adim þu an çok þart deðil belki ilerde lazým olur.
                                       index = 1;
                                       index_adim = 0;                                                                             
                                       break;
                                    end
                                    %%
                                    
                                    
                                    
                                        maxEMG2=max(handles.m1.emg_log(end-20:end,2)); %Son 100ms'de max emg2 verisi bulundu                        
                                        maxEMG7=max(handles.m1.emg_log(end-20:end,7)); %Son 100ms'de max emg7 verisi bulundu

                                        input1= [1; maxEMG2; maxEMG7];

                                        W =     [ 0.8836   -7.0693    6.6697
                                                  1.5403  -14.4231  -13.9882
                                                 -9.7691   10.6543   27.0664
                                                 -0.1365   16.2684  -13.0495];


                                        V =     [3.3316   10.5119  -27.4685   12.1715
                                                -10.7406  -19.9309  -15.7503   25.9366];

                                        z=zeros(4,1);

                                        z(1) = 1/(1 + exp(-W(1,:)*input1));
                                        z(2) = 1/(1 + exp(-W(2,:)*input1));
                                        z(3) = 1/(1 + exp(-W(3,:)*input1));
                                        z(4) = 1/(1 + exp(-W(4,:)*input1));


                                         y(1) = 1/(1 + exp(-V(1,:)*z)); 
                                         y(2) = 1/(1 + exp(-V(2,:)*z));

                                         result=2*y(1) + 1*y(2);
                                         

                                     
                                     if(abs(result-1)<0.0001) %YUMRUK
                                        FS=FS+1;
                                        if(FS>5)
                                            set (handles.text1,'String','Sistem Yavaþladý');
                                            pause(0.05) % Bu sayede Yumruk yapýlýnca sistem slow motion olacak.
                                        end
                                        FX=0;
                                        RX=0;
                                        EX=0;
                                     end
                                     
                                     if(abs(result-2)<0.0001) %RAHAT
                                        RX=RX+1;
                                        if(RX>5)
                                            set (handles.text1,'String','Rahat');
                                        end
                                        FX=0;
                                        FS=0;
                                        EX=0;
                                     end
                                     
                                     
                                    if(abs(result-3)<0.0001) %EXTENSION
                                        EX=EX+1;
                                        if(EX>5)
                                            set (handles.text1,'String','Sistem zaten hareketli!');                    
                                        end
                                        FX=0;
                                        FS=0;
                                        RX=0;
                                     end
                                     
                                                                                                                                                                                                                                        
                                     if(abs(result-0)<0.0001) %FLEXION
                                        FX=FX+1;
                                        if(FX>5)
                                             set (handles.text1,'String','Durma Emri Alýndý!');
                                             StopAfterOngoingStep = true;  %% TUR BÝTÝNCE BU DEÐÝÞKEN KULLANILARAK DÖNGÜ KIRILACAK.
                                        end
                                        FS=0;
                                        RX=0;
                                        EX=0;                                          
                                     end                                         
                                                                                                                                                    
                            end  
                                                                              
                end
             FX=0;
             FS=0;
             RX=0;  
             end
             
             if(abs(result-1)<0.0001 && t>10) %FIST
                FS=FS+1;
                if(FS>5)
                    set (handles.text1,'String','FIST');                                                                                        
                end
                FX=0;
                RX=0;
                EX=0;
             end
             
             
             if(abs(result-2)<0.0001) %DO NOTHING
                RX=RX+1;
                if(RX>5)
                    set (handles.text1,'String','RELAX');                   
                end
                FX=0;
                FS=0;
                EX=0;
             end
             
             if(abs(result-0)<0.0001) %FLEXION
                FX=FX+1;
             if(FX>5)
                set (handles.text1,'String','Sistem zaten duruyor!');
             end
                FS=0;
                RX=0;
                EX=0;                                          
             end             
             

             
            %BURADA TIME EMG YARDIMI ÝLE ZAMAN TUTULUYOR. 
            a=handles.m1.timeEMG_log;   
            b=ones(length(a),1);           
            timeemg = a-a(1).*b;
            t = timeemg(end)-1;            
            set(handles.edit2,'String',num2str(t));
            pause(0.0001); %Bunu koymazsak gui de deðiþiklik alamýyoruz.
             
     
end

%% t<T OLAYI SONLANDI ARTIK SÝSTEM KENDÝNÝ KAPATSIN

handles.m1.stopStreaming();
handles.m1.timeEMG_log(end)
handles.mm.delete();
    
clear handles.mm;
    
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

set (handles.text1,'String','ENDED');  

%% PLOTLAR                               
%Son cycle indexe göre
figure                                        
plot(pos1)
hold on
plot(hip)                                                                                                                      
                                        
%Son cycle indexe göre
figure
plot(pos2)
hold on
plot(knee)
                                        
%Son cycle zamana göre
figure
plot(t1,pos1)
hold on 
plot(t1,hip)
                                        
%Son cycle zamana göre
figure
plot(t1,pos2)
hold on 
plot(t1,knee)
                                        
%Tüm hareket indexe göre yazdýr
figure
plot(pos1full)
hold on
plot(pos2full)
                                        
%Tüm hareket emgtime a göre yazdýr
figure
plot(t1full,pos1full)
hold on
plot(t1full,pos2full)
%%                                                                          
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
