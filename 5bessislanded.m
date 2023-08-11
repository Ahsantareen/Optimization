clc 
close all
%% Input Data
InputData = [
0	169	90	70
0	175	90	70
0	179	90	70
0	171	90	70
0	181	90	70
0	172	90	70
0	270	110	90
10	264	110	90
15	273	110	90
20	281	110	90
23	193	110	90
28	158	125	105
33	161	125	105
35	162	125	105
34	250	125	105
31	260	125	105
28	267	125	105
10	271	125	105
0	284	110	90
0	167	110	90
0	128	110	90
0	137	110	90
0	144	110	90
0	150	110	90 ];


%% Parameters
Ppv=   InputData (:,1); % Interval-wise data
Pload= InputData (:,2)
PRbuy= InputData (:,3);
PRsell=InputData (:,4);
P_Dis=Pload/5

N=24; % Number of intervals

Cdg  = 85*ones(N,1); % DG cost
Cchp = 102*ones(N,1);

DG_Max =0; % Maximum generation limit of DG
CHP_Max=0;

%BESS parameters
Bcap=200;
SOC_init=500;
Eff_BESS=0.95;
SOC_min=0;
SOC_max=500;

%BESS2 parameters
Bcap1=200;
SOC_init1=500;
Eff_BESS1=0.95;
SOC_min1=0;
SOC_max1=500;

%BESS3 parameters
Bcap3=200;
SOC_init3=500;
Eff_BESS3=0.95;
SOC_min3=0;
SOC_max3=500;

%BESS4 parameters
Bcap4=200;
SOC_init4=500;
Eff_BESS4=0.95;
SOC_min4=0;
SOC_max4=500;

%BESS5 parameters
Bcap5=200;
SOC_init5=500;
Eff_BESS5=0.95;
SOC_min5=0;
SOC_max5=500;

%% Problem Formulation
% Objective Function
f = [zeros(N,1); zeros(N,1) ; zeros(N,1); zeros(N,1); zeros(N,1); zeros(N,1); zeros(N,1); zeros(N,1); zeros(N,1); zeros(N,1)];

% Inequality Constraints
%BESS 1
A1=[-(100/Bcap)*tril(ones(N))/Eff_BESS, (100/Bcap)*tril(ones(N))*Eff_BESS,zeros(N,N*8)];
b1=(-SOC_init + SOC_max).*ones(N,1); % soc max

A2=[ (100/Bcap)*tril(ones(N))/Eff_BESS, -(100/Bcap)*tril(ones(N))*Eff_BESS,zeros(N,N*8)];
b2=(SOC_init - SOC_min).*ones(N,1); % soc min

%BESS2

A3=[zeros(N,N*2), -(100/Bcap1)*tril(ones(N))/Eff_BESS1, (100/Bcap1)*tril(ones(N))*Eff_BESS1,zeros(N,N*6)];
b3=(-SOC_init1 + SOC_max1).*ones(N,1); % soc max2

A4=[zeros(N,N*2), (100/Bcap1)*tril(ones(N))/Eff_BESS1, -(100/Bcap1)*tril(ones(N))*Eff_BESS1,zeros(N,N*6)];
b4=(SOC_init1 - SOC_min1).*ones(N,1); % soc min2

%BESS3

A5=[zeros(N,N*4), -(100/Bcap3)*tril(ones(N))/Eff_BESS3, (100/Bcap3)*tril(ones(N))*Eff_BESS3,zeros(N,N*4)];
b5=(-SOC_init3 + SOC_max3).*ones(N,1); % soc max3

A6=[zeros(N,N*4), (100/Bcap3)*tril(ones(N))/Eff_BESS3, -(100/Bcap3)*tril(ones(N))*Eff_BESS3,zeros(N,N*4)];
b6=(SOC_init3 - SOC_min3).*ones(N,1); % soc min3

%BESS4

A7=[zeros(N,N*6), -(100/Bcap4)*tril(ones(N))/Eff_BESS4, (100/Bcap4)*tril(ones(N))*Eff_BESS4,zeros(N,N*2)];
b7=(-SOC_init4 + SOC_max4).*ones(N,1); % soc max4

A8=[zeros(N,N*6), (100/Bcap4)*tril(ones(N))/Eff_BESS4, -(100/Bcap4)*tril(ones(N))*Eff_BESS4,zeros(N,N*2)];
b8=(SOC_init4 - SOC_min4).*ones(N,1); % soc min4

%BESS5

A9=[zeros(N,N*8), -(100/Bcap5)*tril(ones(N))/Eff_BESS5, (100/Bcap5)*tril(ones(N))*Eff_BESS5];
b9=(-SOC_init5 + SOC_max5).*ones(N,1); % soc max5

A10=[zeros(N,N*8), (100/Bcap5)*tril(ones(N))/Eff_BESS5, -(100/Bcap5)*tril(ones(N))*Eff_BESS5];
b10=(SOC_init5 - SOC_min5).*ones(N,1); % soc min5


A = [A1; A2; A3; A4; A5; A6; A7; A8; A9; A10];
b = [b1; b2; b3; b4; b5; b6; b7; b8; b9; b10];

% Equality Constraints
Aeq = [eye(N), -eye(N), eye(N), -eye(N), eye(N), -eye(N), eye(N), -eye(N), eye(N), -eye(N)]; % 6>>chg a& 7>>dis
beq = Pload - Ppv;       

% Lower Bounds
lb5 = zeros(N,1);   % For chg
lb6 = zeros(N,1);   % For dis
lb7 = zeros(N,1);   % For chg2
lb8 = zeros(N,1);   % For dis2
lb9 = zeros(N,1);   % For chg3
lb10 = zeros(N,1);   % For dis3
lb11 = zeros(N,1);   % For chg4
lb12 = zeros(N,1);   % For dis4
lb13 = zeros(N,1);   % For chg5
lb14 = zeros(N,1);   % For dis5

lb = [lb5; lb6; lb7; lb8; lb9; lb10; lb11; lb12; lb13; lb14];

% Upper Bounds
ub5 = P_Dis.*ones(N,1);       % for chg1
ub6 = P_Dis.*ones(N,1);       % for dis1
ub7 = P_Dis.*ones(N,1);       % for chg2
ub8 = P_Dis.*ones(N,1);       % for dis2
ub9 = P_Dis.*ones(N,1);       % for chg3
ub10 = P_Dis.*ones(N,1);       % for dis3
ub11 = P_Dis.*ones(N,1);       % for chg4
ub12 = P_Dis.*ones(N,1);       % for dis4
ub13 = P_Dis.*ones(N,1);       % for chg5
ub14 = P_Dis.*ones(N,1);       % for dis5


ub = [ub5; ub6; ub7; ub8; ub9; ub10; ub11; ub12; ub13; ub14];

% Solve Mixed-integer Linear Programming
x = linprog(f,A,b,Aeq,beq,lb,ub);

%% For plotting
P_BD   = x(1 : N);
P_BC  = -x(N+1 : N*2);
P_BD2  = x(2*N+1 : N*3);
P_BC2 = -x(3*N+1 : N*4);
P_BD3  = x(4*N+1 : N*5);
P_BC3 = -x(5*N+1 : N*6);
P_BD4  = x(6*N+1 : N*7);
P_BC4 = -x(7*N+1 : N*8);
P_BD5  = x(8*N+1 : N*9);
P_BC5 = -x(9*N+1 : N*10);

subplot (2,1,1)


subplot (2,1,2)
y = [P_BD, P_BC, P_BD2, P_BC2, P_BD3, P_BC3, P_BD4, P_BC4, P_BD5, P_BC5];
bar(y,'stacked')
hold on
plot(Pload-Ppv, "-ko", 'LineWidth',1)
legend('BD','BC','BD2','BC2','BD3','BC3','BD4','BC4','BD5','BC5','NL')