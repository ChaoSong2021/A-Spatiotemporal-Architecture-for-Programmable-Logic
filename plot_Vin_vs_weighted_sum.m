
% This code plots the relationship between the voltage Vin of the analog circuit and the total weighted sum n (presented in Extended Data Fig. 6)

clear
clc
close all

% Resistance and Vcc values
R = 10e3;
R1 = 2e3;
Vcc = 5.15967;

n = 0:0.5:4.5;

% Formula for calculating Vin
Vin = Vcc*R./(R+n.*R1);


% Experimental data measured using a multimeter (three separate trials)
Vin_exp = [5.15900000000000	5.16000000000000	5.16000000000000;
4.81600000000000	4.83000000000000	4.83100000000000;
4.50400000000000	4.51100000000000	4.51200000000000;
4.21400000000000	4.21500000000000	4.21700000000000;
3.94200000000000	3.94100000000000	3.94400000000000;
3.67400000000000	3.67500000000000	3.67500000000000;
3.43600000000000	3.43600000000000	3.43700000000000;
3.19200000000000	3.19200000000000	3.19300000000000;
2.98300000000000	2.98300000000000	2.98400000000000;
2.75900000000000	2.75900000000000	2.76000000000000];

% Calculate the average of the three experimental trials
Vin_ave = (Vin_exp(:,1) + Vin_exp(:,2) + Vin_exp(:,3))./3;




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





figure;
hold on
plot(n,Vin,'*','Color',color2,'LineWidth',2)
%plot(n,Vin_ave,'*-','Color',color1)
%errorbar(n, Vin_ave, Vin_ave-min(Vin_exp,[],2),max(Vin_exp,[],2)-Vin_ave, '-', 'LineWidth', 1.5,'Color',color1, 'MarkerSize', 6, 'CapSize', 10)
xlim([0 4.5])
% ylim([0 5])
xlabel('Total weighted sum n')
ylabel('V_i_n [V]')
% legend('Modeling')

ax = gca;
% Set font properties for axis tick labels
ax.FontName = 'Times New Roman'; % Font name (e.g., Arial, Helvetica)
ax.FontSize = 13;                % Font size (default is typically 10)
ax.FontWeight = 'bold';            % Font weight (optional: 'normal', 'bold')

box on



figure;
hold on
% plot(n,Vin,'*-','Color',color2)
plot(n,Vin_ave,'*','Color',color1,'LineWidth',2)
%errorbar(n, Vin_ave, Vin_ave-min(Vin_exp,[],2),max(Vin_exp,[],2)-Vin_ave, '-', 'LineWidth', 1.5,'Color',color1, 'MarkerSize', 6, 'CapSize', 10)
xlim([0 4.5])
% ylim([0 5])
xlabel('Total weighted sum n')
ylabel('V_i_n [V]')
% legend('Experiment')

ax = gca;
% Set font properties for axis tick labels
ax.FontName = 'Times New Roman'; % Font name (e.g., Arial, Helvetica)
ax.FontSize = 13;                % Font size (default is typically 10)
ax.FontWeight = 'bold';            % Font weight (optional: 'normal', 'bold')


box on