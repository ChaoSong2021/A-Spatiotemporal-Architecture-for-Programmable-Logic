
% This code displays the experimental data presented in the main text


clear
clc
close all


grid_1 = [1 3 5 7 9 11 13 15 17];
grid_2 = [6 8 10 12 14 16 18 20 22];
grid_3 = [11 13 15 17 19 21 23 25 27];
grid_4 = [16 18 20 22 24 26 28 30 32];



color_pink1 = [0.556862745098039	0.200000000000000	0.541176470588235]; % Purple 1
color_pink2 = [0.658823529411765	0.368627450980392	0.635294117647059]; % Purple 2
color_pink3 = [0.792156862745098	0.584313725490196	0.764705882352941]; % Purple 3
color_pink4 = [0.894117647058824	0.800000000000000	0.894117647058824]; % Purple 4


color_blue1 = [0.133333333333333	0.278431372549020	0.403921568627451]; % Blue 1
color_blue2 = [0.435294117647059	0.682352941176471	0.878431372549020]; % Blue 2
color_blue3 = [0.631372549019608	0.792156862745098	0.929411764705882]; % Blue 3
color_blue4 = [0.819607843137255	0.901960784313726	0.972549019607843]; % Blue 4

color1 = color_pink2;
color2 = color_blue2;


%% A = 1, B = 1, and C = 1


% Time alignment parameters for the data
n0 = 3.4251;
n1 = 3.2968;
n2 = 3.1548;
n3 = 3.2649;
n4 = 3.0421;
s1 = 2.5;
start_time = 8.5-s1;
lasting_time = 4;
next_step_time = 4;


% Load and plot T0
load('T0_111.mat')
t0=linspace(0,160,size(dataMatrix,1))-n0;
signal_0=dataMatrix(:,2).*1000;

figure;
% --- 新增：为整个组图添加总标题 (Super Title) ---
sgtitle('A = 1, B = 1, and C = 1', 'FontName', 'Times New Roman', 'FontSize', 14, 'FontWeight', 'bold');
% ---------------------------------------------

subplot(5,1,1)
hold on
plot(t0,signal_0,'Color', [0.75 0.75 0.75],'LineWidth', 0.2)
xlabel('Time [s]')
ylabel('Voltage [mV]')
axis([0 140 -50 50])

ax = gca;
% Set font properties for axis tick labels
ax.FontName = 'Times New Roman'; % Font name (e.g., Arial, Helvetica)
ax.FontSize = 12;                % Font size (default is typically 10)
ax.FontWeight = 'bold';            % Font weight (optional: 'normal', 'bold')
% ax.FontAngle = 'italic';         % Font angle/style (optional: 'normal', 'italic')




% Load and plot T1
load('T1_111.mat')
t1=linspace(0,160,size(dataMatrix,1))-n1;
signal_1=dataMatrix(:,2).*1000;
subplot(5,1,2)
hold on
plot(t1,signal_1,'Color', [0.75 0.75 0.75],'LineWidth', 0.2)
xlabel('Time [s]')
ylabel('Voltage [mV]')
axis([0 140 -50 50])

for i = 1:length(grid_1)
    interval_1 = start_time + next_step_time*(grid_1(i)-1);
    interval_2 = interval_1 + lasting_time;
    plot(t1(t1<=interval_2 & t1>=interval_1),signal_1(t1<=interval_2 & t1>=interval_1),'Color', color1,'LineWidth', 0.2)
end

ax = gca;
% Set font properties for axis tick labels
ax.FontName = 'Times New Roman'; % Font name (e.g., Arial, Helvetica)
ax.FontSize = 12;                % Font size (default is typically 10)
ax.FontWeight = 'bold';            % Font weight (optional: 'normal', 'bold')
% ax.FontAngle = 'italic';         % Font angle/style (optional: 'normal', 'italic')




% Load and plot T2
load('T2_111.mat')
t2=linspace(0,160,size(dataMatrix,1))-n2;
signal_2=dataMatrix(:,2).*1000;
subplot(5,1,3)
hold on
plot(t2,signal_2,'Color', [0.75 0.75 0.75],'LineWidth', 0.2)
xlabel('Time [s]')
ylabel('Voltage [mV]')
axis([0 140 -50 50])

for i = 1:length(grid_1)
    interval_1 = start_time + next_step_time*(grid_1(i)-1);
    interval_2 = interval_1 + lasting_time;
    plot(t2(t2<=interval_2 & t2>=interval_1),signal_2(t2<=interval_2 & t2>=interval_1),'Color', color1,'LineWidth', 0.2)
end

for i = 1:length(grid_2)
    interval_1 = start_time + next_step_time*(grid_2(i)-1);
    interval_2 = interval_1 + lasting_time;
    plot(t2(t2<=interval_2 & t2>=interval_1),signal_2(t2<=interval_2 & t2>=interval_1),'Color', color2,'LineWidth', 0.2)
end

ax = gca;
% Set font properties for axis tick labels
ax.FontName = 'Times New Roman'; % Font name (e.g., Arial, Helvetica)
ax.FontSize = 12;                % Font size (default is typically 10)
ax.FontWeight = 'bold';            % Font weight (optional: 'normal', 'bold')
% ax.FontAngle = 'italic';         % Font angle/style (optional: 'normal', 'italic')




% Load and plot T3
load('T3_111.mat')
t3=linspace(0,160,size(dataMatrix,1))-n3;
signal_3=dataMatrix(:,2).*1000;
subplot(5,1,4)
hold on
plot(t3,signal_3,'Color', [0.75 0.75 0.75],'LineWidth', 0.2)
xlabel('Time [s]')
ylabel('Voltage [mV]')
axis([0 140 -50 50])

for i = 1:length(grid_2)
    interval_1 = start_time + next_step_time*(grid_2(i)-1);
    interval_2 = interval_1 + lasting_time;
    plot(t3(t3<=interval_2 & t3>=interval_1),signal_3(t3<=interval_2 & t3>=interval_1),'Color', color2,'LineWidth', 0.2)
end

for i = 1:length(grid_3)
    interval_1 = start_time + next_step_time*(grid_3(i)-1);
    interval_2 = interval_1 + lasting_time;
    plot(t3(t3<=interval_2 & t3>=interval_1),signal_3(t3<=interval_2 & t3>=interval_1),'Color', color1,'LineWidth', 0.2)
end

ax = gca;
% Set font properties for axis tick labels
ax.FontName = 'Times New Roman'; % Font name (e.g., Arial, Helvetica)
ax.FontSize = 12;                % Font size (default is typically 10)
ax.FontWeight = 'bold';            % Font weight (optional: 'normal', 'bold')
% ax.FontAngle = 'italic';         % Font angle/style (optional: 'normal', 'italic')




% Load and plot T4
load('T4_111.mat')
t4=linspace(0,160,size(dataMatrix,1))-n4;
signal_4=dataMatrix(:,2).*1000;
subplot(5,1,5)
hold on
plot(t4,signal_4,'Color', [0.75 0.75 0.75],'LineWidth', 0.2)
xlabel('Time [s]')
ylabel('Voltage [mV]')
axis([0 140 -50 50])

for i = 1:length(grid_3)
    interval_1 = start_time + next_step_time*(grid_3(i)-1);
    interval_2 = interval_1 + lasting_time;
    plot(t4(t4<=interval_2 & t4>=interval_1),signal_4(t4<=interval_2 & t4>=interval_1),'Color', color1,'LineWidth', 0.2)
end

for i = 1:length(grid_4)
    interval_1 = start_time + next_step_time*(grid_4(i)-1);
    interval_2 = interval_1 + lasting_time;
    plot(t4(t4<=interval_2 & t4>=interval_1),signal_4(t4<=interval_2 & t4>=interval_1),'Color', color2,'LineWidth', 0.2)
end

ax = gca;
% Set font properties for axis tick labels
ax.FontName = 'Times New Roman'; % Font name (e.g., Arial, Helvetica)
ax.FontSize = 12;                % Font size (default is typically 10)
ax.FontWeight = 'bold';            % Font weight (optional: 'normal', 'bold')
% ax.FontAngle = 'italic';         % Font angle/style (optional: 'normal', 'italic')


%% A = 0, B = 0, and C = 0


% Time alignment parameters for the data
n0 = 3.4251;
n1 = 3.2968;
n2 = 3.1548;
n3 = 3.2649;
n4 = 3.0421;
s1 = 2.5;
start_time = 8.5-s1;
lasting_time = 4;
next_step_time = 4;


% Load and plot T0
load('T0_000.mat')
t0=linspace(0,160,size(dataMatrix,1))-n0;
signal_0=dataMatrix(:,2).*1000;

figure;
% --- 新增：为整个组图添加总标题 (Super Title) ---
sgtitle('A = 0, B = 0, and C = 0', 'FontName', 'Times New Roman', 'FontSize', 14, 'FontWeight', 'bold');
% ---------------------------------------------

subplot(5,1,1)
hold on
plot(t0,signal_0,'Color', [0.75 0.75 0.75],'LineWidth', 0.2)
xlabel('Time [s]')
ylabel('Voltage [mV]')
axis([0 140 -50 50])

ax = gca;
% Set font properties for axis tick labels
ax.FontName = 'Times New Roman'; % Font name (e.g., Arial, Helvetica)
ax.FontSize = 12;                % Font size (default is typically 10)
ax.FontWeight = 'bold';            % Font weight (optional: 'normal', 'bold')
% ax.FontAngle = 'italic';         % Font angle/style (optional: 'normal', 'italic')




% Load and plot T1
load('T1_000.mat')
t1=linspace(0,160,size(dataMatrix,1))-n1;
signal_1=dataMatrix(:,2).*1000;
subplot(5,1,2)
hold on
plot(t1,signal_1,'Color', [0.75 0.75 0.75],'LineWidth', 0.2)
xlabel('Time [s]')
ylabel('Voltage [mV]')
axis([0 140 -50 50])

for i = 1:length(grid_1)
    interval_1 = start_time + next_step_time*(grid_1(i)-1);
    interval_2 = interval_1 + lasting_time;
    plot(t1(t1<=interval_2 & t1>=interval_1),signal_1(t1<=interval_2 & t1>=interval_1),'Color', color1,'LineWidth', 0.2)
end

ax = gca;
% Set font properties for axis tick labels
ax.FontName = 'Times New Roman'; % Font name (e.g., Arial, Helvetica)
ax.FontSize = 12;                % Font size (default is typically 10)
ax.FontWeight = 'bold';            % Font weight (optional: 'normal', 'bold')
% ax.FontAngle = 'italic';         % Font angle/style (optional: 'normal', 'italic')




% Load and plot T2
load('T2_000.mat')
t2=linspace(0,160,size(dataMatrix,1))-n2;
signal_2=dataMatrix(:,2).*1000;
subplot(5,1,3)
hold on
plot(t2,signal_2,'Color', [0.75 0.75 0.75],'LineWidth', 0.2)
xlabel('Time [s]')
ylabel('Voltage [mV]')
axis([0 140 -50 50])

for i = 1:length(grid_1)
    interval_1 = start_time + next_step_time*(grid_1(i)-1);
    interval_2 = interval_1 + lasting_time;
    plot(t2(t2<=interval_2 & t2>=interval_1),signal_2(t2<=interval_2 & t2>=interval_1),'Color', color1,'LineWidth', 0.2)
end

for i = 1:length(grid_2)
    interval_1 = start_time + next_step_time*(grid_2(i)-1);
    interval_2 = interval_1 + lasting_time;
    plot(t2(t2<=interval_2 & t2>=interval_1),signal_2(t2<=interval_2 & t2>=interval_1),'Color', color2,'LineWidth', 0.2)
end

ax = gca;
% Set font properties for axis tick labels
ax.FontName = 'Times New Roman'; % Font name (e.g., Arial, Helvetica)
ax.FontSize = 12;                % Font size (default is typically 10)
ax.FontWeight = 'bold';            % Font weight (optional: 'normal', 'bold')
% ax.FontAngle = 'italic';         % Font angle/style (optional: 'normal', 'italic')




% Load and plot T3
load('T3_000.mat')
t3=linspace(0,160,size(dataMatrix,1))-n3;
signal_3=dataMatrix(:,2).*1000;
subplot(5,1,4)
hold on
plot(t3,signal_3,'Color', [0.75 0.75 0.75],'LineWidth', 0.2)
xlabel('Time [s]')
ylabel('Voltage [mV]')
axis([0 140 -50 50])

for i = 1:length(grid_2)
    interval_1 = start_time + next_step_time*(grid_2(i)-1);
    interval_2 = interval_1 + lasting_time;
    plot(t3(t3<=interval_2 & t3>=interval_1),signal_3(t3<=interval_2 & t3>=interval_1),'Color', color2,'LineWidth', 0.2)
end

for i = 1:length(grid_3)
    interval_1 = start_time + next_step_time*(grid_3(i)-1);
    interval_2 = interval_1 + lasting_time;
    plot(t3(t3<=interval_2 & t3>=interval_1),signal_3(t3<=interval_2 & t3>=interval_1),'Color', color1,'LineWidth', 0.2)
end

ax = gca;
% Set font properties for axis tick labels
ax.FontName = 'Times New Roman'; % Font name (e.g., Arial, Helvetica)
ax.FontSize = 12;                % Font size (default is typically 10)
ax.FontWeight = 'bold';            % Font weight (optional: 'normal', 'bold')
% ax.FontAngle = 'italic';         % Font angle/style (optional: 'normal', 'italic')




% Load and plot T4
load('T4_000.mat')
t4=linspace(0,160,size(dataMatrix,1))-n4;
signal_4=dataMatrix(:,2).*1000;
subplot(5,1,5)
hold on
plot(t4,signal_4,'Color', [0.75 0.75 0.75],'LineWidth', 0.2)
xlabel('Time [s]')
ylabel('Voltage [mV]')
axis([0 140 -50 50])

for i = 1:length(grid_3)
    interval_1 = start_time + next_step_time*(grid_3(i)-1);
    interval_2 = interval_1 + lasting_time;
    plot(t4(t4<=interval_2 & t4>=interval_1),signal_4(t4<=interval_2 & t4>=interval_1),'Color', color1,'LineWidth', 0.2)
end

for i = 1:length(grid_4)
    interval_1 = start_time + next_step_time*(grid_4(i)-1);
    interval_2 = interval_1 + lasting_time;
    plot(t4(t4<=interval_2 & t4>=interval_1),signal_4(t4<=interval_2 & t4>=interval_1),'Color', color2,'LineWidth', 0.2)
end

ax = gca;
% Set font properties for axis tick labels
ax.FontName = 'Times New Roman'; % Font name (e.g., Arial, Helvetica)
ax.FontSize = 12;                % Font size (default is typically 10)
ax.FontWeight = 'bold';            % Font weight (optional: 'normal', 'bold')
% ax.FontAngle = 'italic';         % Font angle/style (optional: 'normal', 'italic')







%% A = 1, B = 0, and C = 0


% Time alignment parameters for the data
n0 = 5.5;
n1 = 7.5;
n2 = 4.5;
n3 = 5;
n4 = 4;
s1 = 2.5;
start_time = 8.5-s1;
lasting_time = 4;
next_step_time = 4;


% Load and plot T0
load('T0_100.mat')
t0=linspace(0,160,size(dataMatrix,1))-n0;
signal_0=dataMatrix(:,2).*1000;

figure;
% --- 新增：为整个组图添加总标题 (Super Title) ---
sgtitle('A = 1, B = 0, and C = 0', 'FontName', 'Times New Roman', 'FontSize', 14, 'FontWeight', 'bold');
% ---------------------------------------------

subplot(5,1,1)
hold on
plot(t0,signal_0,'Color', [0.75 0.75 0.75],'LineWidth', 0.2)
xlabel('Time [s]')
ylabel('Voltage [mV]')
axis([0 140 -50 50])

ax = gca;
% Set font properties for axis tick labels
ax.FontName = 'Times New Roman'; % Font name (e.g., Arial, Helvetica)
ax.FontSize = 12;                % Font size (default is typically 10)
ax.FontWeight = 'bold';            % Font weight (optional: 'normal', 'bold')
% ax.FontAngle = 'italic';         % Font angle/style (optional: 'normal', 'italic')




% Load and plot T1
load('T1_100.mat')
t1=linspace(0,160,size(dataMatrix,1))-n1;
signal_1=dataMatrix(:,2).*1000;
subplot(5,1,2)
hold on
plot(t1,signal_1,'Color', [0.75 0.75 0.75],'LineWidth', 0.2)
xlabel('Time [s]')
ylabel('Voltage [mV]')
axis([0 140 -50 50])

for i = 1:length(grid_1)
    interval_1 = start_time + next_step_time*(grid_1(i)-1);
    interval_2 = interval_1 + lasting_time;
    plot(t1(t1<=interval_2 & t1>=interval_1),signal_1(t1<=interval_2 & t1>=interval_1),'Color', color1,'LineWidth', 0.2)
end

ax = gca;
% Set font properties for axis tick labels
ax.FontName = 'Times New Roman'; % Font name (e.g., Arial, Helvetica)
ax.FontSize = 12;                % Font size (default is typically 10)
ax.FontWeight = 'bold';            % Font weight (optional: 'normal', 'bold')
% ax.FontAngle = 'italic';         % Font angle/style (optional: 'normal', 'italic')




% Load and plot T2
load('T2_100.mat')
t2=linspace(0,160,size(dataMatrix,1))-n2;
signal_2=dataMatrix(:,2).*1000;
subplot(5,1,3)
hold on
plot(t2,signal_2,'Color', [0.75 0.75 0.75],'LineWidth', 0.2)
xlabel('Time [s]')
ylabel('Voltage [mV]')
axis([0 140 -50 50])

for i = 1:length(grid_1)
    interval_1 = start_time + next_step_time*(grid_1(i)-1);
    interval_2 = interval_1 + lasting_time;
    plot(t2(t2<=interval_2 & t2>=interval_1),signal_2(t2<=interval_2 & t2>=interval_1),'Color', color1,'LineWidth', 0.2)
end

for i = 1:length(grid_2)
    interval_1 = start_time + next_step_time*(grid_2(i)-1);
    interval_2 = interval_1 + lasting_time;
    plot(t2(t2<=interval_2 & t2>=interval_1),signal_2(t2<=interval_2 & t2>=interval_1),'Color', color2,'LineWidth', 0.2)
end

ax = gca;
% Set font properties for axis tick labels
ax.FontName = 'Times New Roman'; % Font name (e.g., Arial, Helvetica)
ax.FontSize = 12;                % Font size (default is typically 10)
ax.FontWeight = 'bold';            % Font weight (optional: 'normal', 'bold')
% ax.FontAngle = 'italic';         % Font angle/style (optional: 'normal', 'italic')




% Load and plot T3
load('T3_100.mat')
t3=linspace(0,160,size(dataMatrix,1))-n3;
signal_3=dataMatrix(:,2).*1000;
subplot(5,1,4)
hold on
plot(t3,signal_3,'Color', [0.75 0.75 0.75],'LineWidth', 0.2)
xlabel('Time [s]')
ylabel('Voltage [mV]')
axis([0 140 -50 50])

for i = 1:length(grid_2)
    interval_1 = start_time + next_step_time*(grid_2(i)-1);
    interval_2 = interval_1 + lasting_time;
    plot(t3(t3<=interval_2 & t3>=interval_1),signal_3(t3<=interval_2 & t3>=interval_1),'Color', color2,'LineWidth', 0.2)
end

for i = 1:length(grid_3)
    interval_1 = start_time + next_step_time*(grid_3(i)-1);
    interval_2 = interval_1 + lasting_time;
    plot(t3(t3<=interval_2 & t3>=interval_1),signal_3(t3<=interval_2 & t3>=interval_1),'Color', color1,'LineWidth', 0.2)
end

ax = gca;
% Set font properties for axis tick labels
ax.FontName = 'Times New Roman'; % Font name (e.g., Arial, Helvetica)
ax.FontSize = 12;                % Font size (default is typically 10)
ax.FontWeight = 'bold';            % Font weight (optional: 'normal', 'bold')
% ax.FontAngle = 'italic';         % Font angle/style (optional: 'normal', 'italic')




% Load and plot T4
load('T4_100.mat')
t4=linspace(0,160,size(dataMatrix,1))-n4;
signal_4=dataMatrix(:,2).*1000;
subplot(5,1,5)
hold on
plot(t4,signal_4,'Color', [0.75 0.75 0.75],'LineWidth', 0.2)
xlabel('Time [s]')
ylabel('Voltage [mV]')
axis([0 140 -50 50])

for i = 1:length(grid_3)
    interval_1 = start_time + next_step_time*(grid_3(i)-1);
    interval_2 = interval_1 + lasting_time;
    plot(t4(t4<=interval_2 & t4>=interval_1),signal_4(t4<=interval_2 & t4>=interval_1),'Color', color1,'LineWidth', 0.2)
end

for i = 1:length(grid_4)
    interval_1 = start_time + next_step_time*(grid_4(i)-1);
    interval_2 = interval_1 + lasting_time;
    plot(t4(t4<=interval_2 & t4>=interval_1),signal_4(t4<=interval_2 & t4>=interval_1),'Color', color2,'LineWidth', 0.2)
end

ax = gca;
% Set font properties for axis tick labels
ax.FontName = 'Times New Roman'; % Font name (e.g., Arial, Helvetica)
ax.FontSize = 12;                % Font size (default is typically 10)
ax.FontWeight = 'bold';            % Font weight (optional: 'normal', 'bold')
% ax.FontAngle = 'italic';         % Font angle/style (optional: 'normal', 'italic')




%% A = 1, B = 1, and C = 0


% Time alignment parameters for the data
n0 = 3.5;
n1 = 4.5;
n2 = 4;
n3 = 4;
n4 = 4;
s1 = 2.5;
start_time = 8.5-s1;
lasting_time = 4;
next_step_time = 4;


% Load and plot T0
load('T0_110.mat')
t0=linspace(0,160,size(dataMatrix,1))-n0;
signal_0=dataMatrix(:,2).*1000;

figure;
% --- 新增：为整个组图添加总标题 (Super Title) ---
sgtitle('A = 1, B = 1, and C = 0', 'FontName', 'Times New Roman', 'FontSize', 14, 'FontWeight', 'bold');
% ---------------------------------------------

subplot(5,1,1)
hold on
plot(t0,signal_0,'Color', [0.75 0.75 0.75],'LineWidth', 0.2)
xlabel('Time [s]')
ylabel('Voltage [mV]')
axis([0 140 -50 50])

ax = gca;
% Set font properties for axis tick labels
ax.FontName = 'Times New Roman'; % Font name (e.g., Arial, Helvetica)
ax.FontSize = 12;                % Font size (default is typically 10)
ax.FontWeight = 'bold';            % Font weight (optional: 'normal', 'bold')
% ax.FontAngle = 'italic';         % Font angle/style (optional: 'normal', 'italic')




% Load and plot T1
load('T1_110.mat')
t1=linspace(0,160,size(dataMatrix,1))-n1;
signal_1=dataMatrix(:,2).*1000;
subplot(5,1,2)
hold on
plot(t1,signal_1,'Color', [0.75 0.75 0.75],'LineWidth', 0.2)
xlabel('Time [s]')
ylabel('Voltage [mV]')
axis([0 140 -50 50])

for i = 1:length(grid_1)
    interval_1 = start_time + next_step_time*(grid_1(i)-1);
    interval_2 = interval_1 + lasting_time;
    plot(t1(t1<=interval_2 & t1>=interval_1),signal_1(t1<=interval_2 & t1>=interval_1),'Color', color1,'LineWidth', 0.2)
end

ax = gca;
% Set font properties for axis tick labels
ax.FontName = 'Times New Roman'; % Font name (e.g., Arial, Helvetica)
ax.FontSize = 12;                % Font size (default is typically 10)
ax.FontWeight = 'bold';            % Font weight (optional: 'normal', 'bold')
% ax.FontAngle = 'italic';         % Font angle/style (optional: 'normal', 'italic')




% Load and plot T2
load('T2_110.mat')
t2=linspace(0,160,size(dataMatrix,1))-n2;
signal_2=dataMatrix(:,2).*1000;
subplot(5,1,3)
hold on
plot(t2,signal_2,'Color', [0.75 0.75 0.75],'LineWidth', 0.2)
xlabel('Time [s]')
ylabel('Voltage [mV]')
axis([0 140 -50 50])

for i = 1:length(grid_1)
    interval_1 = start_time + next_step_time*(grid_1(i)-1);
    interval_2 = interval_1 + lasting_time;
    plot(t2(t2<=interval_2 & t2>=interval_1),signal_2(t2<=interval_2 & t2>=interval_1),'Color', color1,'LineWidth', 0.2)
end

for i = 1:length(grid_2)
    interval_1 = start_time + next_step_time*(grid_2(i)-1);
    interval_2 = interval_1 + lasting_time;
    plot(t2(t2<=interval_2 & t2>=interval_1),signal_2(t2<=interval_2 & t2>=interval_1),'Color', color2,'LineWidth', 0.2)
end

ax = gca;
% Set font properties for axis tick labels
ax.FontName = 'Times New Roman'; % Font name (e.g., Arial, Helvetica)
ax.FontSize = 12;                % Font size (default is typically 10)
ax.FontWeight = 'bold';            % Font weight (optional: 'normal', 'bold')
% ax.FontAngle = 'italic';         % Font angle/style (optional: 'normal', 'italic')




% Load and plot T3
load('T3_110.mat')
t3=linspace(0,160,size(dataMatrix,1))-n3;
signal_3=dataMatrix(:,2).*1000;
subplot(5,1,4)
hold on
plot(t3,signal_3,'Color', [0.75 0.75 0.75],'LineWidth', 0.2)
xlabel('Time [s]')
ylabel('Voltage [mV]')
axis([0 140 -50 50])

for i = 1:length(grid_2)
    interval_1 = start_time + next_step_time*(grid_2(i)-1);
    interval_2 = interval_1 + lasting_time;
    plot(t3(t3<=interval_2 & t3>=interval_1),signal_3(t3<=interval_2 & t3>=interval_1),'Color', color2,'LineWidth', 0.2)
end

for i = 1:length(grid_3)
    interval_1 = start_time + next_step_time*(grid_3(i)-1);
    interval_2 = interval_1 + lasting_time;
    plot(t3(t3<=interval_2 & t3>=interval_1),signal_3(t3<=interval_2 & t3>=interval_1),'Color', color1,'LineWidth', 0.2)
end

ax = gca;
% Set font properties for axis tick labels
ax.FontName = 'Times New Roman'; % Font name (e.g., Arial, Helvetica)
ax.FontSize = 12;                % Font size (default is typically 10)
ax.FontWeight = 'bold';            % Font weight (optional: 'normal', 'bold')
% ax.FontAngle = 'italic';         % Font angle/style (optional: 'normal', 'italic')




% Load and plot T4
load('T4_110.mat')
t4=linspace(0,160,size(dataMatrix,1))-n4;
signal_4=dataMatrix(:,2).*1000;
subplot(5,1,5)
hold on
plot(t4,signal_4,'Color', [0.75 0.75 0.75],'LineWidth', 0.2)
xlabel('Time [s]')
ylabel('Voltage [mV]')
axis([0 140 -50 50])

for i = 1:length(grid_3)
    interval_1 = start_time + next_step_time*(grid_3(i)-1);
    interval_2 = interval_1 + lasting_time;
    plot(t4(t4<=interval_2 & t4>=interval_1),signal_4(t4<=interval_2 & t4>=interval_1),'Color', color1,'LineWidth', 0.2)
end

for i = 1:length(grid_4)
    interval_1 = start_time + next_step_time*(grid_4(i)-1);
    interval_2 = interval_1 + lasting_time;
    plot(t4(t4<=interval_2 & t4>=interval_1),signal_4(t4<=interval_2 & t4>=interval_1),'Color', color2,'LineWidth', 0.2)
end

ax = gca;
% Set font properties for axis tick labels
ax.FontName = 'Times New Roman'; % Font name (e.g., Arial, Helvetica)
ax.FontSize = 12;                % Font size (default is typically 10)
ax.FontWeight = 'bold';            % Font weight (optional: 'normal', 'bold')
% ax.FontAngle = 'italic';         % Font angle/style (optional: 'normal', 'italic')