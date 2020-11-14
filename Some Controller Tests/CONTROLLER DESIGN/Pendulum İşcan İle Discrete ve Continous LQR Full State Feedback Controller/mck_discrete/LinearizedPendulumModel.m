clear all;
close all;
clc;

%PENDULUM MODEL� ���N STATE SPACE �RNE��

%Real parameter values:
I=0.078; %[kg*m^2]
m=1.394; %[kg]
r=0.484; %[m]
g=9.8;   %[m/s^2]
b=10;   %damping coefficient

alfa=I+m*r^2;
beta=-m*g*r;

%State space matrix (Bunu video 21'de ��kard�k)
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
rank_eval = rank(ctrb_motor)-rank(A); % Bu i�lem de defterde belirtildi iki rank birbirine e�itse rank_eval=0 olur bu da sistem controllable demektir.

%A matrisinin eigen value'su  bize sistemin karakteristik denkleminin
%k�klerini g�sterir
eig(A)

%place function
%Sistemin CE k�klerini istedi�imiz gibi manip�le edece�iz:
p=[-4,-5]; %desired CE roots
K=place(A,B,p);%required K values for desired CE roots

%Full state feedbackten sonra Closed Loop A a�a��daki halde:
A_cl = (A-B*K);

%Bakal�m bu sistemin CE'si istenilen k�klere sahip mi?
eig(A_cl) % Sonu� -4 ve -5 istenilen �ekilde ��kt�.