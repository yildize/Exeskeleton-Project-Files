%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pendulum

clear all;
close all;
clc;


m = 1;                  % mass of the pendulum bob (kg)
l = 0.3;               % length of the pendulum rod (m)
b = 0.003;              % estimate of viscous friction coefficient (N-m-s)
g = 9.81;               % acceleration due to gravity (m/s^2)

N = 2.25;

Kt = 1.54;                % N.m/Amp

A = [0,     1;
    -4/(2*l*g),   -4*b/(m*l^2)];
 
B = [0;
    1000*4*Kt*N/(m*l^2)];
    
C = [1 0;
     0 1];
 
D = [0;
     0];
 
Ts = 0.00001;
%% new A,B, Ref matrix 
A_new = [A,zeros(2,1);
         -1/Ts,zeros(1,2)];
     
B_new = [B;
         0];
     
C_new = [1 0 0;
         0 0 1];

     
D_new = [0;0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%


[A_new,B_new] = c2d(A_new,B_new,Ts)

Q = [10000,0,0;
     0,1000,0;
     0,0,1000000000];
 
R = 1e-20;
K = dlqr(A_new,B_new,Q,R)

Ac = [(A_new-B_new*K)];

E  = [0;
      0;
      1];

eig(Ac)

Init_condition = [0;
                  0;
                  0];

%% Pendulum
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%