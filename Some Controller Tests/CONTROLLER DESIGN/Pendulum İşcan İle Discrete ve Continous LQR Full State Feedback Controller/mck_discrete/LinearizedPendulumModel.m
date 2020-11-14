clear all;
close all;
clc;

%PENDULUM MODELÝ ÝÇÝN STATE SPACE ÖRNEÐÝ

%Real parameter values:
I=0.078; %[kg*m^2]
m=1.394; %[kg]
r=0.484; %[m]
g=9.8;   %[m/s^2]
b=10;   %damping coefficient

alfa=I+m*r^2;
beta=-m*g*r;

%State space matrix (Bunu video 21'de çýkardýk)
a00=0;
a01=1;
a10= -beta/alfa;
a11= b/alfa;

b00=0;
b10=1/alfa;

A=[a00,a11;
   a10,a11];

B=[b00; 
    b10];

%Check system controllability

ctrb_motor = ctrb(A,B); %Defterde belirtilen Cm matrisi bu matris.
rank_eval = rank(ctrb_motor)-rank(A); % Bu iþlem de defterde belirtildi iki rank birbirine eþitse rank_eval=0 olur bu da sistem controllable demektir.

%A matrisinin eigen value'su  bize sistemin karakteristik denkleminin
%köklerini gösterir
eig(A)

%place function
%Sistemin CE köklerini istediðimiz gibi manipüle edeceðiz:
p=[-4,-5]; %desired CE roots
K=place(A,B,p);%required K values for desired CE roots

%Full state feedbackten sonra Closed Loop A aþaðýdaki halde:
A_cl = (A-B*K);

%Bakalým bu sistemin CE'si istenilen köklere sahip mi?
eig(A_cl) % Sonuç -4 ve -5 istenilen þekilde çýktý.