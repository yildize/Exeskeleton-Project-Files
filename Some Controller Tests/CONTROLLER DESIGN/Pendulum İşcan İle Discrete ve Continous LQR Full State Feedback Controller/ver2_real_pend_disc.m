%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pendulum

clear all;
close all;
clc;


m = 1;                  % mass of the pendulum bob (kg)
l = 0.3;                % length of the pendulum rod (m)
b = 0.3;              % estimate of viscous friction coefficient (N-m-s)
g = 9.81;               % acceleration due to gravity (m/s^2)

N = 4;

Kt = 1.54;                % N.m/Amp

A = [0,     1;
    -4/(2*l*g),   -4*b/(m*l^2)];
 
B = [0;
    4*Kt*(1/N)/(m*l^2)];
    
C = [1 0;
     0 1];
 
D = [0;
     0];
 
Ts = 0.04;
%% new A,B, Ref matrix 
%Orjinal 1
A_new = [A,zeros(2,1);
         -1/Ts,zeros(1,2)];
     
B_new = [B;
         0];
     
C_new = [1 0 0;
         0 0 1];

     
D_new = [0;0];
%Orjinal 1

% % Revision 1
% A_new = [A,zeros(2,1);
%          -1,zeros(1,2)];
%      
% B_new = [B;
%          0];
%      
% C_new = [1 0 0;
%          0 0 1];
% 
%      
% D_new = [0;0];
% %Revision 1



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

%Revise comment'e alýndý
[A_ne,B_ne] = c2d(A_new,B_new,Ts)

Q = [10,0,0;
     0,10,0;
     0,0,100000 
   ];
 
R = 1e-3;

%Orjinal 2
K = dlqr(A_ne,B_ne,Q,R)
%Orjinal 2

% %Revise 2
% K = lqr(A_new,B_new,Q,R)
% %Revise 2

Ac = [(A_ne-B_ne*K)];

E  = [0;
      0;
      1];

eig(Ac)

Init_condition = [0;
                  0;
                  0];

%% Pendulum
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ý
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%