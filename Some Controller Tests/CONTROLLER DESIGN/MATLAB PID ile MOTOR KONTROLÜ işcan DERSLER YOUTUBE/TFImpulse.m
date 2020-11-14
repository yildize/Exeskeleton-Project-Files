clear all;
close all;
clc;

syms s; %PARAMETERS

G=1/(s^2+4*s+3); %TF
Wd=1/(s); %INPUT
Ws=Wd*G; %OUTPUT

G2=s/(s^2+4*s+3); %TF

text1="Laplace Domain Impulse Response"
pretty(simplify(G)) %Laplace Domain Response
Wt=ilaplace(G);
text2="Time Domain Impulse Response"
pretty(simplify(Wt)) %Time Domain Response

text1="Laplace Domain Impulse Response"
pretty(simplify(G2)) %Laplace Domain Response
Wt2=ilaplace(G2);
text2="Time Domain Impulse Response"
pretty(simplify(Wt2)) %Time Domain Response

text1="Laplace Domain Step Response"
pretty(simplify(Ws)) %Laplace Domain Response
Wt=ilaplace(Ws);
text2="Time Domain Step Response"
pretty(simplify(Wt)) %Time Domain Response


sys1 = tf([1],[1 4 3])
impulse(sys1)
figure
sys2 = tf([1 0],[1 4 3])
impulse(sys2)