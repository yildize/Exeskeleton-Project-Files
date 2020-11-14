clear all;
close all;
clc;

%MOTOR MODEL� ���N STATE SPACE �RNE��

%Real parameter values:
R=0.55;
Kt=85*10^-3;
L=25*10^-3;
J=0.06+0.03;
b=0.05;

%State space matrix (Bunu video 21'de ��kard�k)
a00=-R/L;
a01=-Kt/L;
a10= Kt/J;
a11= -b/J;

b00=1/L;
b10=0;

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



%% Yeni e_dot state i tan�mland�ktan sonra Anew Bnew ve yeni k�kler tan�mland�.
A_new = [A, zeros(2,1);
         0, 1, 0];
B_new = [B;
         0];
     
p = [-10,-20,-22];
%videoda p1 ak�m i�in p2 h�z i�in p3 error i�in denmi� bu do�ru mu? Asl�nda
%p1 p2 p3 birlikte her �� state i�in de CE yi tan�mlam�yor mu?

K = place(A_new,B_new,p)

eig(A_new - B_new*K)















% pretty(simplify(Wt)) %Time Domain Response