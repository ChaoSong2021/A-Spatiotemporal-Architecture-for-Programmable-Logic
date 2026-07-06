clear
clc
close all

load('numberPairs_b_and_accuracy.mat');

accuracy = zeros(10,10);


for i = 1:size(numberPairs_b_and_accuracy,1)
    number1 = numberPairs_b_and_accuracy(i,1);
    number2 = numberPairs_b_and_accuracy(i,2);
    accuracy_of_this_pair = numberPairs_b_and_accuracy(i,7)*100;
    accuracy(number2+1,number1+1) = accuracy_of_this_pair;
end



% Example data
actual = randi([0 9],1000,1); % Ground truth labels
predicted = randi([0 9],1000,1); % Predicted labels

% Generate confusion matrix
C = confusionmat(actual, predicted);





color_pink1 = [0.556862745098039	0.200000000000000	0.541176470588235]; % Purple 1
color_pink2 = [0.658823529411765	0.368627450980392	0.635294117647059]; % Purple 2
color_pink3 = [0.792156862745098	0.584313725490196	0.764705882352941]; % Purple 3
color_pink4 = [0.894117647058824	0.800000000000000	0.894117647058824]; % Purple 4


color_blue1 = [0.133333333333333	0.278431372549020	0.403921568627451]; % Blue 1
color_blue2 = [0.435294117647059	0.682352941176471	0.878431372549020]; % Blue 2
color_blue3 = [0.631372549019608	0.792156862745098	0.929411764705882]; % Blue 3
color_blue4 = [0.819607843137255	0.901960784313726	0.972549019607843]; % Blue 4



figure
h=heatmap(accuracy(2:end,1:end-1));

color0 = [0.75 0.75 0.75]; % 0~80% range
color =[];

for i = 1:16
    color = [color;color0]; % 0~80% range
end

color = [color;color_blue3]; % 85%
color = [color;color_pink4]; % 90%
color = [color;color_pink3]; % 95%
color = [color;color_pink2]; % 100%




color_steps = 100;
color_step1 = 80;
color_step2 = 20;

your_color0 = [0.75 0.75 0.75];
your_color1 = color_blue2;
your_color2 = color_pink3;

custom_colormap1 = [linspace(your_color0(1), your_color1(1), color_step1)',...
                   linspace(your_color0(2), your_color1(2), color_step1)',...
                   linspace(your_color0(3), your_color1(3), color_step1)'];

custom_colormap2 = [linspace(your_color1(1), your_color2(1), color_step2)',...
                   linspace(your_color1(2), your_color2(2), color_step2)',...
                   linspace(your_color1(3), your_color2(3), color_step2)'];

custom_colormap = [custom_colormap1;custom_colormap2];
% Apply custom colormap



h = gca;





colormap(custom_colormap);


h.CellLabelFormat = '%.1f';
h.XDisplayLabels = {'0','1','2','3','4','5','6','7','8'};
h.YDisplayLabels = {'1','2','3','4','5','6','7','8','9'};


xlabel('2nd Number')
ylabel('1st Number')
title('Accuracy [%]')
% Aesthetic formatting settings
% colormap(jet); % Set colormap
h.FontSize = 15;          % Set font size for data labels and axis tick labels
h.FontName = 'Times New Roman';
% h.FontWeight = 'bold';           % Font weight (optional: 'normal', 'bold')