% This code trains the BNN. Since an exhaustive search (brute-force) method is used, the training time will be very long.

clear
clc

numberPairs = nchoosek(0:9, 2); % Generate all pairwise combinations of digits from 0 to 9. Total number of digit pairs

% Number of Selected Pixels. Note: n3 corresponds to I1 in the main text, n4 corresponds to I2, n1 corresponds to I1 and I3, n2 corresponds to I2 and I4.
n1 = 8;
n2 = 8;
n3 = 4;
n4 = 4;

% Initialize the result matrix. The 1st and 2nd columns are the two numbers of the trained Number Pair, columns 3 to 6 are the trained weights b1~b4, and the 7th column is the accuracy.
numberPairs_b_and_accuracy = zeros(size(numberPairs,1),7); 

% Train the neural network
for i = 1:size(numberPairs,1)
    number1 = numberPairs(i,1);
    number2 = numberPairs(i,2);
    [b, accuracy] = trainBNN(number1,number2,n1,n2,n3,n4);
    numberPairs_b_and_accuracy(i,1:2) = numberPairs(i,:);
    numberPairs_b_and_accuracy(i,3:6) = b(1,:);
    numberPairs_b_and_accuracy(i,7) = accuracy(1,:);

end


% Function to train the neural network. Input: Number Pair and the number of Selected Pixels. Output: weights b1~b4 and accuracy.
function [b, accuracy] = trainBNN(number1,number2,n1,n2,n3,n4)
%% Read the MNIST dataset

% Read the MNIST dataset files
trainImagesFile = 'train-images-idx3-ubyte';
trainLabelsFile = 'train-labels-idx1-ubyte';
testImagesFile = 't10k-images-idx3-ubyte';
testLabelsFile = 't10k-labels-idx1-ubyte';

% Load the MNIST dataset
trainImages = loadMNISTImages(trainImagesFile);
trainLabels = loadMNISTLabels(trainLabelsFile);
testImages = loadMNISTImages(testImagesFile);
testLabels = loadMNISTLabels(testLabelsFile);


X_train = trainImages; % MNIST images (training)
y_train = trainLabels; % MNIST labels (training)
X_test = testImages; % MNIST images (testing)
y_test = testLabels; % MNIST labels (testing)


% Reshape X from 3D to 2D for easier processing (training)
X_train = reshape(X_train, [], size(X_train, 3))'; % Reshape so each row represents one image
% Reshape X from 3D to 2D for easier processing (testing)
X_test = reshape(X_test, [], size(X_test, 3))'; % Reshape so each row represents one image


% Binarize images: set pixel values > 0.5 to 1, and <= 0.5 to 0 (training)
X_binary = double(X_train > 0.5); % Binarize using 0.5 as the threshold
% Binarize images: set pixel values > 0.5 to 1, and <= 0.5 to 0 (testing)
X_test = double(X_test > 0.5); % Binarize using 0.5 as the threshold


% Filter images of the selected numbers (number1 and number2) (training)
X_0 = X_binary(y_train == number1, :);
X_non0 = X_binary(y_train == number2, :);
% Filter images of the selected numbers (number1 and number2) (testing) 
X_0_test = X_test(y_test == number1, :);
X_non0_test = X_test(y_test == number2, :);


% Augment data if necessary (commented out), combine datasets for the two digits
% X_0 = [X_0; X_0; X_0; X_0; X_0; X_0; X_0; X_0; X_0]; % Augment data for class 0
X_combined_train = [X_0; X_non0]; % Combine data for class number1 and number2
y_combined_train = [zeros(size(X_0, 1), 1) + number1; zeros(size(X_non0, 1), 1) + number2]; % Combine labels

% X_0_test = [X_0_test; X_0_test; X_0_test; X_0_test; X_0_test; X_0_test; X_0_test; X_0_test; X_0_test];
X_combined_test = [X_0_test; X_non0_test]; % Combine test data for class number1 and number2
y_combined_test = [zeros(size(X_0_test, 1), 1) + number1; zeros(size(X_non0_test, 1), 1) + number2]; % Combine test labels


%% Pixel Selection


% Calculate the mean value for each pixel across all samples
mean_X0 = mean(X_0,1);
mean_X_non0 = mean(X_non0,1);
difference = mean_X0 - mean_X_non0;
[~, sorted_indices] = sort(difference, 'descend');



% Find the indices of the feature pixels
n1_indices = sorted_indices(1:n1);
n2_indices = sorted_indices(end-n2+1:end);
n3_indices = sorted_indices(1:n3);
n4_indices = sorted_indices(end-n4+1:end);


% Visualize average pixel values and mark important feature points
figure;
subplot(1, 2, 1);
imshow(reshape(mean_X0, [28, 28])); 
% colorbar;
title('mean 0 value pixel');
hold on;




% Mark feature points on the image
for i = 1:n1
    [row, col] = ind2sub([28, 28], n1_indices(i));
    plot(col, row,'.', 'Color',[0.435294117647059	0.682352941176471	0.878431372549020], 'MarkerSize', 20); % Light blue
end
for i = 1:n2
    [row, col] = ind2sub([28, 28], n2_indices(i));
    plot(col, row, '.','Color',[0.792156862745098	0.584313725490196	0.764705882352941], 'MarkerSize', 20); % Light purple
end
for i = 1:n3
    [row, col] = ind2sub([28, 28], n3_indices(i));
    plot(col, row,'.', 'Color',[0.133333333333333	0.278431372549020	0.403921568627451],'MarkerSize', 20); % Blue
end
for i = 1:n4
    [row, col] = ind2sub([28, 28], n4_indices(i));
    plot(col, row, '.','Color',[0.556862745098039	0.200000000000000	0.541176470588235],'MarkerSize', 20); % Purple
end
hold off;


subplot(1, 2, 2);
imshow(reshape(mean_X_non0, [28, 28])); 
% colorbar;
title('mean non 0 value pixel');
hold on;

% Mark feature points on the image
for i = 1:n1
    [row, col] = ind2sub([28, 28], n1_indices(i));
    plot(col, row,'.', 'Color',[0.435294117647059	0.682352941176471	0.878431372549020], 'MarkerSize', 20); % Light blue
end
for i = 1:n2
    [row, col] = ind2sub([28, 28], n2_indices(i));
    plot(col, row, '.','Color',[0.792156862745098	0.584313725490196	0.764705882352941], 'MarkerSize', 20); % Light purple
end
for i = 1:n3
    [row, col] = ind2sub([28, 28], n3_indices(i));
    plot(col, row,'.', 'Color',[0.133333333333333	0.278431372549020	0.403921568627451],'MarkerSize', 20); % Blue
end
for i = 1:n4
    [row, col] = ind2sub([28, 28], n4_indices(i));
    plot(col, row, '.','Color',[0.556862745098039	0.200000000000000	0.541176470588235],'MarkerSize', 20); % Purple
end
hold off;



%% Organize Data



FeaturePixels_n1_train = X_combined_train(:,n1_indices);
FeaturePixels_n1_test = X_combined_test(:,n1_indices);
weights_n1 = zeros(1,n1)+1;
FeaturePixels_n2_train = X_combined_train(:,n2_indices);
FeaturePixels_n2_test = X_combined_test(:,n2_indices);
weights_n2 = zeros(1,n2);
FeaturePixels_n3n4_train = X_combined_train(:,[n3_indices,n4_indices]);
FeaturePixels_n3n4_test = X_combined_test(:,[n3_indices,n4_indices]);
weights_n3n4 = [zeros(1,n3)+1,zeros(1,n4)];







%% Train the Neural Network

threshold_n3n4 = 1:n3+n4;
threshold_n1 = 1:n1;
threshold_n2 = 1:n2;
threshold_output = 1:3;

accuracy_and_threshold = [];
for i = 1:length(threshold_n3n4)
    for j = 1:length(threshold_n1)
        for z = 1:length(threshold_n2)
            for k = 1:length(threshold_output)
                threshold = [threshold_n3n4(i),threshold_n1(j),threshold_n2(z),threshold_output(k)];
                [accuracy,~] = runBNN(y_combined_train, number1, FeaturePixels_n3n4_train, FeaturePixels_n1_train, FeaturePixels_n2_train, weights_n3n4, weights_n1, weights_n2, threshold);
                accuracy_and_threshold = [accuracy_and_threshold; [accuracy, threshold]];
            end
        end
    end
end

fprintf('Highest accuracy: %.2f%%\n', max(max(accuracy_and_threshold(:,1))) * 100);
temp = find(accuracy_and_threshold(:,1)==max(max(accuracy_and_threshold(:,1))));

temp=temp(1);

fprintf('Corresponding thresholds: %.2f  %.2f  %.2f  %.2f ', [accuracy_and_threshold(temp,2:5)]);

b = accuracy_and_threshold(temp,2:5);
acc = max(max(accuracy_and_threshold(:,1))) * 100;

% Calculate accuracy using the test set
[accuracy,y_pred]  = runBNN(y_combined_test, number1, FeaturePixels_n3n4_test, FeaturePixels_n1_test, FeaturePixels_n2_test, weights_n3n4, weights_n1, weights_n2, b);

end                     





















%% Functions

% Function to load MNIST image files
function images = loadMNISTImages(filename)
    fp = fopen(filename, 'rb');
    assert(fp ~= -1, ['Could not open ', filename]);

    magic = fread(fp, 1, 'int32', 0, 'ieee-be');
    assert(magic == 2051, 'Invalid magic number in MNIST image file');

    numImages = fread(fp, 1, 'int32', 0, 'ieee-be');
    numRows = fread(fp, 1, 'int32', 0, 'ieee-be');
    numCols = fread(fp, 1, 'int32', 0, 'ieee-be');

    images = fread(fp, inf, 'unsigned char');
    images = reshape(images, numCols, numRows, numImages);
    images = permute(images, [2 1 3]);
    images = double(images) / 255; % Normalize to [0,1]

    fclose(fp);
end

% Function to load MNIST label files
function labels = loadMNISTLabels(filename)
    fp = fopen(filename, 'rb');
    assert(fp ~= -1, ['Could not open ', filename]);

    magic = fread(fp, 1, 'int32', 0, 'ieee-be');
    assert(magic == 2049, 'Invalid magic number in MNIST label file');

    numLabels = fread(fp, 1, 'int32', 0, 'ieee-be');
    labels = fread(fp, inf, 'unsigned char');
    assert(numLabels == length(labels), 'Mismatch in label count');

    fclose(fp);
end


function output = xnorpopcount(x, w, threshold)
    % xnorpopcount - Simulates the function of a BNN neuron
    % Inputs:
    %   x - Input vector
    %   w - Weight vector
    %   threshold - Threshold value
    % Output:
    %   output - Simulated neuron output (0 or 1)

    % Ensure x and w have the same length
    assert(length(x) == length(w), 'Lengths of x and w vectors must be identical');

    % Perform XNOR operation: ~xor(x, w)
    xnor_result = ~xor(x, w);

    % Accumulate XNOR results (count identical bits)
    popcount = sum(sum(xnor_result));

    % Compare with threshold and output 0 or 1
    if popcount >= threshold
        output = 1;
    else
        output = 0;
    end
end



% Neural network execution function
function [accuracy,y_pred] = runBNN(y, number, x1, x2, x3, w1, w2, w3, threshold)

% Hidden layer thresholds
threshold_1 = threshold(1);
threshold_2 = threshold(2);
threshold_3 = threshold(3);

% Output layer threshold
threshold_4 = threshold(4);

y_pred = zeros(length(y),1);

for i = 1:size(y,1)
    % Three hidden layer nodes
    hiddenNodeOutput_1 = xnorpopcount(x1(i,:), w1, threshold_1);
    hiddenNodeOutput_2 = xnorpopcount(x2(i,:), w2, threshold_2);
    hiddenNodeOutput_3 = xnorpopcount(x3(i,:), w3, threshold_3);

    % One output layer node
    y_pred(i) = xnorpopcount([hiddenNodeOutput_1,hiddenNodeOutput_2,hiddenNodeOutput_3], [1 1 1], threshold_4);
end


% Calculate accuracy

y_acc = (y == number);

accuracy = mean(y_pred == y_acc);
fprintf('Accuracy: %.2f%%\n', accuracy * 100);

end