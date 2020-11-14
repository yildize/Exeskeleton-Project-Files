clear all;
close all;
clc;

%MOTOR MODELÝ ÝÇÝN STATE SPACE ÖRNEÐÝ

%Real parameter values:
m = 1;                  % mass of the pendulum bob (kg)
l = 0.3;                % length of the pendulum rod (m)
b = 0.03;               % estimate of viscous friction coefficient (N-m-s)
g = 9.81;               % acceleration due to gravity (m/s^2)

N = 2.25;

Kt = 1.54;                % N.m/Amp

A = [0,     1;
    -4/(2*l*g),   -4*b/(m*l^2)];
 
B = [0;
    1000*4*Kt*N/(m*l^2)];

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



%% Yeni e_dot state i tanýmlandýktan sonra Anew Bnew ve yeni kökler tanýmlandý.
A_new = [A, zeros(2,1);
         1, 0, 0];
B_new = [B;
         0];
     
p = [-5,-10,-15];
%videoda p1 akým için p2 hýz için p3 error için denmiþ bu doðru mu? Aslýnda
%p1 p2 p3 birlikte her üç state için de CE yi tanýmlamýyor mu?

K = place(A_new,B_new,p)

eig(A_new - B_new*K)















% pretty(simplify(Wt)) %Time Domain Response