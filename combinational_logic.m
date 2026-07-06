%% This code converts logic expressions into Lego-like circuit diagrams and implements them via dynamic evolution of cellular automata

clear
clc
close all



%% Combinational logic expression and variable assignment. Shown here is the neural network from Figure 3 in the text, which can be replaced by other logic expressions.
expression = '( X2 AND X3 AND ( X4 XOR 1 ) ) OR ( X AND X3 AND ( X4 XOR 1 ) ) OR ( X1 AND X2 AND X3 ) OR ( X1 AND X2 AND ( X4 XOR 1 ) )'; % Logic expression. Note: NOT(A) is implemented as A XOR 1
InputValue = {};
InputValue{end+1} = struct('Name', 'X2', 'Value', 1); % X2
InputValue{end+1} = struct('Name', 'X3', 'Value', 0); % X3
InputValue{end+1} = struct('Name', 'X4', 'Value', 0); % X4
InputValue{end+1} = struct('Name', '1', 'Value', 1);  % 1
InputValue{end+1} = struct('Name', 'X1', 'Value', 1); % X1




%% Convert logic expression to postfix expression
postfix = infixToPostfix(expression);     % Convert infix expression to postfix expression
disp('Reverse Polish notation')           % Display postfix expression
disp(strjoin(postfix));
root = buildExpressionTree(postfix);      % Build expression tree
plotTree(root);                           % Display binary tree (Figure 1)




% Build basic circuit diagram using postfix expression
stack = [];                               % Initialize an empty stack to store coordinates
stack_input = {};                         % Initialize operand stack
stack_operator = {};                      % Initialize operator stack
stack_wire = {};                          % Initialize wire stack
s = 1;                                    % Initialize horizontal coordinate position
% BasicBlockCircuit = strings(0, 0);      % Initialize a dynamically sized string array

for i = 1:length(postfix)                 % Iterate through each string in the postfix expression
    thispostfix = postfix{i};             % Current string
    if isOperator(thispostfix)            % If it is an operator
        rightPoint = stack(end,:);        % Right input of operator is the top point in the stack
        stack(end,:) = [];                % Pop the top point from the stack
        leftPoint = stack(end,:);         % Left input of operator is the new top point in the stack
        stack(end,:) = [];                % Pop the top point from the stack
        if leftPoint(1) == rightPoint(1)  % If y-coordinates of both inputs are equal, no wire is needed
            stack(end+1,:) = [leftPoint(1)+1,ceil((leftPoint(2)+rightPoint(2))/2)];
            temp_struct = struct('Name', thispostfix, 'InputLeft', leftPoint, 'InputRight', rightPoint, 'OutputPoint', [leftPoint(1)+1,ceil((leftPoint(2)+rightPoint(2))/2)]);
            stack_operator{end+1} = temp_struct;
        elseif leftPoint(1) > rightPoint(1) % If right input is higher than left, add wires to the right
            for e1 = rightPoint(1) : leftPoint(1)-1
            temp_struct = struct('Name', 'Wire', 'Input', [e1,rightPoint(2)], 'Output', [e1+1,rightPoint(2)]);
            stack_wire{end+1} = temp_struct;
            end
            stack(end+1,:) = [leftPoint(1)+1,ceil((leftPoint(2)+rightPoint(2))/2)];
            temp_struct = struct('Name', thispostfix, 'InputLeft', leftPoint, 'InputRight', [leftPoint(1), rightPoint(2)], 'OutputPoint', [leftPoint(1)+1,ceil((leftPoint(2)+rightPoint(2))/2)]);
            stack_operator{end+1} = temp_struct;
        else                              % If left input is higher than right, add wires to the left
            for e1 = leftPoint(1) : rightPoint(1)-1
            temp_struct = struct('Name', 'Wire', 'Input', [e1,leftPoint(2)], 'Output', [e1+1,leftPoint(2)]);
            stack_wire{end+1} = temp_struct;
            end
            stack(end+1,:) = [rightPoint(1)+1,ceil((leftPoint(2)+rightPoint(2))/2)];
            temp_struct = struct('Name', thispostfix, 'InputLeft', [rightPoint(1),leftPoint(2)], 'InputRight', rightPoint, 'OutputPoint', [rightPoint(1)+1,ceil((leftPoint(2)+rightPoint(2))/2)]);
            stack_operator{end+1} = temp_struct;
        end

    else                                  % If it is an operand
        stack(end+1,:) = [1,s];           % Record operand position as s
        temp_struct = struct('Name', thispostfix, 'Position', [1,s]);  %
        stack_input{end+1} = temp_struct;
        s=s+2;                            % Increment s by 2 to the right
    end
end


% input
% --- Figure 2: Basic block circuit diagram (Commented out) ---
% figure;
% hold on
% 
% Color_input = [204, 255, 204]./255;    % Variables in green
% Color_wire = [255, 255, 204]./255;     % Wires in yellow
% Color_operator = [173, 216, 230]./255; % Operators in light blue
% plot_the_logic_block(stack_input, stack_operator, stack_wire, Color_input, Color_wire, Color_operator)



% Construct standard circuit diagram from basic circuit diagram
operator_layer = zeros(1,length(stack_operator));         % Initialize layer numbers for operators
operator_length = zeros(1,length(stack_operator));        % Initialize lengths for operators
for i = 1 : length(stack_operator)
    operator_layer(i) = stack_operator{i}.InputLeft(1);   % Calculate layer number of operator
    operator_length(i) = stack_operator{i}.InputRight(2) - stack_operator{i}.InputLeft(2) + 1; % Calculate length of operator
end

max_length_operator_per_layer = zeros(1,max(max(operator_layer))); % Initialize variable representing maximum operator length per layer


for i = 1 : length(stack_operator)                        % Calculate the maximum operator length for each layer
    for j = 1 : max(max(operator_layer))
    if operator_layer(i) == j
        temp = max_length_operator_per_layer(j);
        max_length_operator_per_layer(j) = max(max([temp, operator_length(i)]));
    end
    end
end

for i = 1 : max(max(operator_layer))
    if operator_layer(i) == i
        temp = max_length_operator_per_layer(i);
        max_length_operator_per_layer(i) = max(max([temp, operator_length(i)]));
    end
end

vertical_block_add = 0.*max_length_operator_per_layer;       % Represents how many blocks downward the standard circuit shifts relative to the basic circuit
vertical_block_increment = 0.*max_length_operator_per_layer; % Represents thickness increment of standard circuit block

if max_length_operator_per_layer(1) < 4 % If basic circuit block length is < 4, no downward shift needed
    vertical_block_add(1)=0;
else
    vertical_block_add(1)=ceil(max_length_operator_per_layer(1)/2)-1; % If block length >= 4, shift downward: 4->1, 5->2, 6->2, 7->3, 8->3, 9->4, 10->4
end

if length(max_length_operator_per_layer)>1
    for i = 2 : length(max_length_operator_per_layer)
        if max_length_operator_per_layer(i) < 4
            vertical_block_add(i) = vertical_block_add(i-1);
        else
            vertical_block_add(i) = vertical_block_add(i-1) + ceil(max_length_operator_per_layer(i)/2)-1;
            vertical_block_increment(i) = ceil(max_length_operator_per_layer(i)/2)-1;
        end
    end
end


stack_operator_add_vertical_block = stack_operator;    % Shift all logic blocks downward
stack_wire_additional = {};
stack_shift_left = {};
stack_shift_right = {};

for i = 1 : length(stack_operator_add_vertical_block)
    temp_layer = stack_operator_add_vertical_block{1,i}.InputLeft(1);
    stack_operator_add_vertical_block{1,i}.InputLeft(1) = stack_operator_add_vertical_block{1,i}.InputLeft(1) + vertical_block_add(temp_layer);
    stack_operator_add_vertical_block{1,i}.InputRight(1) = stack_operator_add_vertical_block{1,i}.InputRight(1) + vertical_block_add(temp_layer);
    stack_operator_add_vertical_block{1,i}.OutputPoint(1) = stack_operator_add_vertical_block{1,i}.OutputPoint(1) + vertical_block_add(temp_layer);
    stack_operator_add_vertical_block{1,i}.InputLeft(2) = stack_operator_add_vertical_block{1,i}.OutputPoint(2)-1;
    stack_operator_add_vertical_block{1,i}.InputRight(2) = stack_operator_add_vertical_block{1,i}.OutputPoint(2)+1;
    if vertical_block_add(temp_layer)>0               % If shift blocks need to be added
        left_gap = stack_operator_add_vertical_block{1,i}.InputLeft(2) - stack_operator{1,i}.InputLeft(2);     % Left and right gap difference before and after simplification
        right_gap = -stack_operator_add_vertical_block{1,i}.InputRight(2) + stack_operator{1,i}.InputRight(2);
        temp_additional_layer = 0;
        left_shift_number = 0;                        % Initialize count of left shift blocks
        right_shift_number = 0;                       % Initialize count of right shift blocks
        for e1 = 1 : vertical_block_increment(temp_layer)    % Insert left/right shift blocks and wires
            if e1 == 1
                if left_gap>right_gap                 % Insert right-shift block on left, wire on right
                    temp_struct = struct('Name', 'RIGHT', 'Input',[stack_operator_add_vertical_block{1,i}.InputLeft(1)-e1,stack_operator_add_vertical_block{1,i}.InputLeft(2)-1-right_shift_number], 'Output', [stack_operator_add_vertical_block{1,i}.InputLeft(1)-e1+1,stack_operator_add_vertical_block{1,i}.InputLeft(2)-right_shift_number]);
                    stack_shift_right{end+1} = temp_struct;
                    temp_struct = struct('Name', 'Wire', 'Input', [stack_operator_add_vertical_block{1,i}.InputRight(1)-e1,stack_operator_add_vertical_block{1,i}.InputRight(2)+left_shift_number], 'Output', [stack_operator_add_vertical_block{1,i}.InputRight(1)-e1+1,stack_operator_add_vertical_block{1,i}.InputRight(2)+left_shift_number]);
                    stack_wire_additional{end+1} = temp_struct;
                    right_shift_number = right_shift_number + 1;
                    left_gap=left_gap-1;
                else                                  % Insert left-shift block on right, wire on left
                    temp_struct = struct('Name', 'LEFT', 'Input',[stack_operator_add_vertical_block{1,i}.InputRight(1)-e1,stack_operator_add_vertical_block{1,i}.InputRight(2)+1+left_shift_number], 'Output', [stack_operator_add_vertical_block{1,i}.InputRight(1)-e1+1,stack_operator_add_vertical_block{1,i}.InputRight(2)+left_shift_number]);
                    stack_shift_left{end+1} = temp_struct;
                    temp_struct = struct('Name', 'Wire', 'Input', [stack_operator_add_vertical_block{1,i}.InputLeft(1)-e1,stack_operator_add_vertical_block{1,i}.InputLeft(2)-right_shift_number], 'Output', [stack_operator_add_vertical_block{1,i}.InputLeft(1)-e1+1,stack_operator_add_vertical_block{1,i}.InputLeft(2)-right_shift_number]);
                    stack_wire_additional{end+1} = temp_struct;
                    left_shift_number = left_shift_number + 1;
                    right_gap=right_gap-1;
                end
            else
                if left_gap > 0 && right_gap > 0
                    % Insert right-shift block on left, left-shift block on right
                    temp_struct = struct('Name', 'RIGHT', 'Input',[stack_operator_add_vertical_block{1,i}.InputLeft(1)-e1,stack_operator_add_vertical_block{1,i}.InputLeft(2)-1-right_shift_number], 'Output', [stack_operator_add_vertical_block{1,i}.InputLeft(1)-e1+1,stack_operator_add_vertical_block{1,i}.InputLeft(2)-right_shift_number]);
                    stack_shift_right{end+1} = temp_struct;
                    temp_struct = struct('Name', 'LEFT', 'Input',[stack_operator_add_vertical_block{1,i}.InputRight(1)-e1,stack_operator_add_vertical_block{1,i}.InputRight(2)+1+left_shift_number], 'Output', [stack_operator_add_vertical_block{1,i}.InputRight(1)-e1+1,stack_operator_add_vertical_block{1,i}.InputRight(2)+left_shift_number]);
                    stack_shift_left{end+1} = temp_struct;
                    right_shift_number = right_shift_number + 1;
                    left_shift_number = left_shift_number + 1;
                    left_gap=left_gap-1;
                    right_gap=right_gap-1;
                elseif left_gap > 0 && right_gap == 0
                    % Insert right-shift block on left, wire on right
                    temp_struct = struct('Name', 'RIGHT', 'Input',[stack_operator_add_vertical_block{1,i}.InputLeft(1)-e1,stack_operator_add_vertical_block{1,i}.InputLeft(2)-1-right_shift_number], 'Output', [stack_operator_add_vertical_block{1,i}.InputLeft(1)-e1+1,stack_operator_add_vertical_block{1,i}.InputLeft(2)-right_shift_number]);
                    stack_shift_right{end+1} = temp_struct;
                    temp_struct = struct('Name', 'Wire', 'Input', [stack_operator_add_vertical_block{1,i}.InputRight(1)-e1,stack_operator_add_vertical_block{1,i}.InputRight(2)+left_shift_number], 'Output', [stack_operator_add_vertical_block{1,i}.InputRight(1)-e1+1,stack_operator_add_vertical_block{1,i}.InputRight(2)+left_shift_number]);
                    stack_wire_additional{end+1} = temp_struct;
                    right_shift_number = right_shift_number + 1;
                    left_gap=left_gap-1;
                elseif left_gap == 0 && right_gap > 0
                    % Insert left-shift block on right, wire on left
                    temp_struct = struct('Name', 'LEFT', 'Input',[stack_operator_add_vertical_block{1,i}.InputRight(1)-e1,stack_operator_add_vertical_block{1,i}.InputRight(2)+1+left_shift_number], 'Output', [stack_operator_add_vertical_block{1,i}.InputRight(1)-e1+1,stack_operator_add_vertical_block{1,i}.InputRight(2)+left_shift_number]);
                    stack_shift_left{end+1} = temp_struct;
                    temp_struct = struct('Name', 'Wire', 'Input', [stack_operator_add_vertical_block{1,i}.InputLeft(1)-e1,stack_operator_add_vertical_block{1,i}.InputLeft(2)-right_shift_number], 'Output', [stack_operator_add_vertical_block{1,i}.InputLeft(1)-e1+1,stack_operator_add_vertical_block{1,i}.InputLeft(2)-right_shift_number]);
                    stack_wire_additional{end+1} = temp_struct;
                    left_shift_number = left_shift_number + 1;
                    right_gap=right_gap-1;
                elseif left_gap == 0 && right_gap == 0
                    % Insert wire on both right and left
                    temp_struct = struct('Name', 'Wire', 'Input', [stack_operator_add_vertical_block{1,i}.InputRight(1)-e1,stack_operator_add_vertical_block{1,i}.InputRight(2)+left_shift_number], 'Output', [stack_operator_add_vertical_block{1,i}.InputRight(1)-e1+1,stack_operator_add_vertical_block{1,i}.InputRight(2)+left_shift_number]);
                    stack_wire_additional{end+1} = temp_struct;
                    temp_struct = struct('Name', 'Wire', 'Input', [stack_operator_add_vertical_block{1,i}.InputLeft(1)-e1,stack_operator_add_vertical_block{1,i}.InputLeft(2)-right_shift_number], 'Output', [stack_operator_add_vertical_block{1,i}.InputLeft(1)-e1+1,stack_operator_add_vertical_block{1,i}.InputLeft(2)-right_shift_number]);
                    stack_wire_additional{end+1} = temp_struct;
                end
            end
        end
    end
end

stack_wire_add_vertical_block = stack_wire;            % Shift all wires downward and insert additional wires
for i = 1 : length(stack_wire_add_vertical_block)
    temp_layer = stack_wire_add_vertical_block{1,i}.Input(1);
    stack_wire_add_vertical_block{1,i}.Input(1) = stack_wire_add_vertical_block{1,i}.Input(1) + vertical_block_add(temp_layer);
    stack_wire_add_vertical_block{1,i}.Output(1) = stack_wire_add_vertical_block{1,i}.Output(1) + vertical_block_add(temp_layer);
    if vertical_block_add(temp_layer) > 0
        for e1 = 1 : vertical_block_increment(temp_layer) % Insert wire
            temp_struct = struct('Name', 'Wire', 'Input', [stack_wire_add_vertical_block{1,i}.Input(1)-e1,stack_wire_add_vertical_block{1,i}.Input(2)], 'Output', [stack_wire_add_vertical_block{1,i}.Output(1)-e1,stack_wire_add_vertical_block{1,i}.Output(2)]);
            stack_wire_additional{end+1}=temp_struct;
        end
    end
end

    


% --- Figure 3: Standard circuit diagram with shift blocks (Commented out) ---
% figure;
% hold on

Color_input = [0.435294117647059	0.682352941176471	0.878431372549020];     % Variables in blue
Color_wire = [0.658823529411765	0.368627450980392	0.635294117647059];      % Wires in purple
Color_operator = [0.894117647058824	0.800000000000000	0.894117647058824];  % Operators in light purple
Color_shift = [0.819607843137255	0.901960784313726	0.972549019607843];     % Shift blocks in light blue

stack_input_standard = stack_input;
stack_operator_standard = stack_operator_add_vertical_block;
stack_wire_standard = [stack_wire_add_vertical_block,stack_wire_additional];
stack_shift_left_standard = stack_shift_left;
stack_shift_right_standard = stack_shift_right;



% plot_the_logic_block_standard(stack_input, stack_operator_standard, stack_wire_standard, stack_shift_left_standard, stack_shift_right_standard, Color_input, Color_wire, Color_operator, Color_shift)





% Transform basic circuit to 1x5 layout

stack_input1x5 = stack_input;
stack_operator1x5 = stack_operator;
stack_wire1x5 = stack_wire;




for i = 1 : length(stack_input1x5)                                         % Shift all input positions: 1 -> 1, 3 -> 5, 5 -> 7, N -> 2N-1
    stack_input1x5{1, i}.Position(2) = stack_input{1, i}.Position(2)*2 - 1;
end



for i = 1 : length(stack_operator1x5)                                      % Shift all operator positions: 1 -> 1, 3 -> 5, 5 -> 7, N -> 2N-1
    stack_operator1x5{1, i}.InputLeft(2) = stack_operator{1, i}.InputLeft(2)*2 - 1;
    stack_operator1x5{1, i}.InputRight(2) = stack_operator{1, i}.InputRight(2)*2 - 1;
    stack_operator1x5{1, i}.OutputPoint(2) = stack_operator{1, i}.OutputPoint(2)*2 - 1;
end



for i = 1 : length(stack_wire1x5)                                          % Shift all wire positions: 1 -> 1, 3 -> 5, 5 -> 7, N -> 2N-1
    stack_wire1x5{1, i}.Input(2) = stack_wire{1, i}.Input(2)*2 - 1;
    stack_wire1x5{1, i}.Output(2) = stack_wire{1, i}.Output(2)*2 - 1;
end

% --- Figure 4: Basic 1x5 circuit (Commented out) ---
% figure;
% hold on
% plot_the_logic_block1x5(stack_input1x5, stack_operator1x5, stack_wire1x5, Color_input, Color_wire, Color_operator)

% --- Figure 5: Colored Basic 1x5 circuit (Commented out) ---
% figure;
% hold on
% plot_the_logic_block1x5_colored(stack_input1x5, stack_operator1x5, stack_wire1x5, Color_input, Color_wire, Color_operator)




% Transform standard circuit to 1x5 layout

stack_input_standard1x5 = stack_input_standard;
stack_operator_standard1x5 = stack_operator_standard;
stack_wire_standard1x5 = stack_wire_standard;
stack_shift_left_standard1x5 = stack_shift_left_standard;
stack_shift_right_standard1x5 = stack_shift_right_standard;



for i = 1 : length(stack_input_standard1x5)                                         % Shift all input positions: 1 -> 1, 3 -> 5, 5 -> 7, N -> 2N-1
    stack_input_standard1x5{1, i}.Position(2) = stack_input_standard{1, i}.Position(2)*2 - 1;
end



for i = 1 : length(stack_operator_standard1x5)                                      % Shift all operator positions: 1 -> 1, 3 -> 5, 5 -> 7, N -> 2N-1
    stack_operator_standard1x5{1, i}.InputLeft(2) = stack_operator_standard{1, i}.InputLeft(2)*2 - 1;
    stack_operator_standard1x5{1, i}.InputRight(2) = stack_operator_standard{1, i}.InputRight(2)*2 - 1;
    stack_operator_standard1x5{1, i}.OutputPoint(2) = stack_operator_standard{1, i}.OutputPoint(2)*2 - 1;
end



for i = 1 : length(stack_wire_standard1x5)                                          % Shift all wire positions: 1 -> 1, 3 -> 5, 5 -> 7, N -> 2N-1
    stack_wire_standard1x5{1, i}.Input(2) = stack_wire_standard{1, i}.Input(2)*2 - 1;
    stack_wire_standard1x5{1, i}.Output(2) = stack_wire_standard{1, i}.Output(2)*2 - 1;
end



for i = 1 : length(stack_shift_left_standard1x5)                                    % Shift all left-shift operator positions: 1 -> 1, 3 -> 5, 5 -> 7, N -> 2N-1
    stack_shift_left_standard1x5{1, i}.Input(2) = stack_shift_left_standard{1, i}.Input(2)*2 - 1;
    stack_shift_left_standard1x5{1, i}.Output(2) = stack_shift_left_standard{1, i}.Output(2)*2 - 1;
end



for i = 1 : length(stack_shift_right_standard1x5)                                   % Shift all right-shift operator positions: 1 -> 1, 3 -> 5, 5 -> 7, N -> 2N-1
    stack_shift_right_standard1x5{1, i}.Input(2) = stack_shift_right_standard{1, i}.Input(2)*2 - 1;
    stack_shift_right_standard1x5{1, i}.Output(2) = stack_shift_right_standard{1, i}.Output(2)*2 - 1;
end


blackColor = [0 0 0];
redColor = [1	0.450980392156863	0.635294117647059];
yellowColor = [0.976470588235294	1	0.419607843137255];
blueColor = [0.298039215686275	0.611764705882353	0.984313725490196];
greenColor = [0.309803921568627	0.854901960784314	0.600000000000000];
purpleColor = [0.694117647058824	0.517647058823530	0.839215686274510];

% Replace blue with orange, purple with cyan
blueColor = [0.956862745098039	0.694117647058824	0.513725490196078];
purpleColor = [0.694117647058824	1	1];

% Replace blue with purple
blueColor = [0.694117647058824	0.517647058823530	0.839215686274510];


% --- Figure 6: Standard 1x5 circuit ---
figure;
hold on
plot_the_logic_block_standard1x5(stack_input_standard1x5, stack_operator_standard1x5, stack_wire_standard1x5, stack_shift_left_standard1x5, stack_shift_right_standard1x5, blackColor, redColor, yellowColor, blueColor, greenColor, purpleColor)


% --- Figure 7: Colored Standard 1x5 circuit (Commented out) ---
% figure;
% hold on
% plot_the_logic_block_standard1x5_colored(stack_input_standard1x5, stack_operator_standard1x5, stack_wire_standard1x5, stack_shift_left_standard1x5, stack_shift_right_standard1x5, blackColor, redColor, yellowColor, blueColor, greenColor,purpleColor)









% Convert circuit diagram to Cellular Automaton (CA)

% Convert circuit diagram to ModeMatrix; each cell represents the operational mode for each step
% Initialize ModeMatrix: width depends on last variable position, height depends on last operator position
ModeMatrix = zeros(stack_operator_standard1x5{end}.OutputPoint(1),stack_input_standard1x5{end}.Position(2)); 

ModeMatrix=ModeMatrix+2; % Default all cells to Mode 2 for every step


% Step 1: Process variables
if exist('InputValue','var')==1 % If InputValue exists, assign accordingly; otherwise default all to 1
    for i=1:length(stack_input_standard1x5) % Iterate through all variables
        for j=1:length(InputValue)
            if stack_input_standard1x5{i}.Name == InputValue{j}.Name % Find variable name and value in InputValue
                if InputValue{j}.Value == 0  % If variable is 0, assign Mode 3
                    ModeMatrix(stack_input_standard1x5{i}.Position(1),stack_input_standard1x5{i}.Position(2))=3;
                elseif InputValue{j}.Value == 1 % If variable is 1, assign Mode 4
                    ModeMatrix(stack_input_standard1x5{i}.Position(1),stack_input_standard1x5{i}.Position(2))=4;
                end
            end
        end
    end
else % Otherwise, assign 1 to all
    for i=1:length(stack_input_standard1x5)
         ModeMatrix(stack_input_standard1x5{i}.Position(1),stack_input_standard1x5{i}.Position(2))=4;
    end
end

% Step 2: Process logic gates
for i = 1:length(stack_operator_standard1x5)
    if strcmp(stack_operator_standard1x5{i}.Name, 'OR') % If OR gate, write "010"
        ModeMatrix(stack_operator_standard1x5{i}.InputLeft(1),stack_operator_standard1x5{i}.InputLeft(2)+1)=3;
        ModeMatrix(stack_operator_standard1x5{i}.InputLeft(1),stack_operator_standard1x5{i}.InputLeft(2)+2)=4;
        ModeMatrix(stack_operator_standard1x5{i}.InputLeft(1),stack_operator_standard1x5{i}.InputLeft(2)+3)=3;
    elseif strcmp(stack_operator_standard1x5{i}.Name, 'AND') % If AND gate, write "000"
        ModeMatrix(stack_operator_standard1x5{i}.InputLeft(1),stack_operator_standard1x5{i}.InputLeft(2)+1)=3;
        ModeMatrix(stack_operator_standard1x5{i}.InputLeft(1),stack_operator_standard1x5{i}.InputLeft(2)+2)=3;
        ModeMatrix(stack_operator_standard1x5{i}.InputLeft(1),stack_operator_standard1x5{i}.InputLeft(2)+3)=3;
    elseif strcmp(stack_operator_standard1x5{i}.Name, 'XOR') % If XOR gate, write "100"
        ModeMatrix(stack_operator_standard1x5{i}.InputLeft(1),stack_operator_standard1x5{i}.InputLeft(2)+1)=4;
        ModeMatrix(stack_operator_standard1x5{i}.InputLeft(1),stack_operator_standard1x5{i}.InputLeft(2)+2)=3;
        ModeMatrix(stack_operator_standard1x5{i}.InputLeft(1),stack_operator_standard1x5{i}.InputLeft(2)+3)=3;
    elseif strcmp(stack_operator_standard1x5{i}.Name, 'NAND') % If NAND gate, write "110"
        ModeMatrix(stack_operator_standard1x5{i}.InputLeft(1),stack_operator_standard1x5{i}.InputLeft(2)+1)=4;
        ModeMatrix(stack_operator_standard1x5{i}.InputLeft(1),stack_operator_standard1x5{i}.InputLeft(2)+2)=4;
        ModeMatrix(stack_operator_standard1x5{i}.InputLeft(1),stack_operator_standard1x5{i}.InputLeft(2)+3)=3;
    elseif strcmp(stack_operator_standard1x5{i}.Name, 'NOR') % If NOR gate, write "101"
        ModeMatrix(stack_operator_standard1x5{i}.InputLeft(1),stack_operator_standard1x5{i}.InputLeft(2)+1)=4;
        ModeMatrix(stack_operator_standard1x5{i}.InputLeft(1),stack_operator_standard1x5{i}.InputLeft(2)+2)=3;
        ModeMatrix(stack_operator_standard1x5{i}.InputLeft(1),stack_operator_standard1x5{i}.InputLeft(2)+3)=4;
    end
    ModeMatrix(stack_operator_standard1x5{i}.OutputPoint(1),stack_operator_standard1x5{i}.OutputPoint(2))=1;
end

% Step 3: Process left shifts
for i = 1:length(stack_shift_left_standard1x5) % Left shift operation, write "0100"
    ModeMatrix(stack_shift_left_standard1x5{i}.Input(1),stack_shift_left_standard1x5{i}.Input(2)-4)=3;
    ModeMatrix(stack_shift_left_standard1x5{i}.Input(1),stack_shift_left_standard1x5{i}.Input(2)-3)=4;
    ModeMatrix(stack_shift_left_standard1x5{i}.Input(1),stack_shift_left_standard1x5{i}.Input(2)-2)=3;
    ModeMatrix(stack_shift_left_standard1x5{i}.Input(1),stack_shift_left_standard1x5{i}.Input(2)-1)=3;

    ModeMatrix(stack_shift_left_standard1x5{i}.Output(1),stack_shift_left_standard1x5{i}.Output(2))=1;
end

% Step 4: Process right shifts
for i = 1:length(stack_shift_right_standard1x5) % Right shift operation, write "1000"
    ModeMatrix(stack_shift_right_standard1x5{i}.Input(1),stack_shift_right_standard1x5{i}.Input(2)+1)=4;
    ModeMatrix(stack_shift_right_standard1x5{i}.Input(1),stack_shift_right_standard1x5{i}.Input(2)+2)=3;
    ModeMatrix(stack_shift_right_standard1x5{i}.Input(1),stack_shift_right_standard1x5{i}.Input(2)+3)=3;
    ModeMatrix(stack_shift_right_standard1x5{i}.Input(1),stack_shift_right_standard1x5{i}.Input(2)+4)=3;

    ModeMatrix(stack_shift_right_standard1x5{i}.Output(1),stack_shift_right_standard1x5{i}.Output(2))=1;
end



% Convert ModeMatrix to Cellular Automaton CellMatrix

CellMatrix = zeros(size(ModeMatrix,1)+1,size(ModeMatrix,2)); % CellMatrix has one more row than ModeMatrix

for i = 2:size(CellMatrix,1)
    for j = 1:size(CellMatrix,2)

        if ModeMatrix(i-1,j) == 1 % If Mode 1
            if CellMatrix(i-1,j) == 0 % If previous state is 0, cell becomes 1 if and only if exactly two neighbors are 1
                if CellMatrix(i-1,j-2)+CellMatrix(i-1,j-1)+CellMatrix(i-1,j+1)+CellMatrix(i-1,j+2)==2
                    CellMatrix(i,j)=1;
                else
                    CellMatrix(i,j)=0;
                end
            elseif CellMatrix(i-1,j) == 1 % If previous state is 1, cell becomes 1 if one or two neighbors are 1
                if CellMatrix(i-1,j-2)+CellMatrix(i-1,j-1)+CellMatrix(i-1,j+1)+CellMatrix(i-1,j+2)==2
                    CellMatrix(i,j)=1;
                elseif CellMatrix(i-1,j-2)+CellMatrix(i-1,j-1)+CellMatrix(i-1,j+1)+CellMatrix(i-1,j+2)==1
                    CellMatrix(i,j)=1;
                else
                    CellMatrix(i,j)=0;
                end
            end
                    
        elseif ModeMatrix(i-1,j) == 2 % If Mode 2
            CellMatrix(i,j) = CellMatrix(i-1,j);

        elseif ModeMatrix(i-1,j) == 3 % If Mode 3
            CellMatrix(i,j) = 0;

        elseif ModeMatrix(i-1,j) == 4 % If Mode 4
            CellMatrix(i,j) = 1;

        end
    end
end

% Calculation result of the Cellular Automaton
CellResult = CellMatrix(stack_operator_standard1x5{end}.OutputPoint(1)+1,stack_operator_standard1x5{end}.OutputPoint(2))

% --- Figure 8: Boolean matrix heatmap ---
figure;
% Create heatmap
h = heatmap(CellMatrix, 'Colormap', [0.85 0.85 0.85; 0 0 0]); % Binary color map: White (0) / Black (1) [3,5](@ref)
h.CellLabelColor = 'none';   % Hide cell numerical labels [1,10](@ref)
h.GridVisible = 'on';       % Enable grid lines [4](@ref)

for i = 1:length(h.XDisplayLabels)
    h.XDisplayLabels{i}=' ';
end

for i = 1:length(h.YDisplayLabels)
    h.YDisplayLabels{i}=' ';
end

% h.XDisplayLabels = '';  % Hide column labels
% h.YDisplayLabels = '';  % Hide row labels

% grid on;        % Ensure grid lines are visible
% h.GridColor = 'white';

% Mark specific point (e.g., row 3, column 5)
targetRow = stack_operator_standard1x5{end}.OutputPoint(1)+1;
targetCol = stack_operator_standard1x5{end}.OutputPoint(2);
% hold on;
% rectangle('Position', [targetCol-0.5, targetRow-0.5, 1, 1], ...
%           'EdgeColor', 'r', 'LineWidth', 2, 'Curvature', [1 1]); % Red circle annotation [7,8](@ref)
% hold off;

% Optimize display (Updated to English as requested)
h.Title = 'Boolean Matrix Heatmap';
h.XLabel = 'Column Index';
h.YLabel = 'Row Index';
set(gca, 'FontSize', 12);    % Set uniform font size


% --- Figure 9: Subplot Heatmaps (Commented out) ---
% figure;
% % Create heatmap
% hold on
% for i = 1:size(CellMatrix,1)
%     subplot(size(CellMatrix,1),1,i)
%     if i == 1
%         h = heatmap(CellMatrix(i,:), 'Colormap', [0.85 0.85 0.85; 0.85 0.85 0.85]); % Binary color map: White (0) / Black (1) [3,5](@ref)
%     else
%         h = heatmap(CellMatrix(i,:), 'Colormap', [0.85 0.85 0.85; 0 0 0]); % Binary color map: White (0) / Black (1) [3,5](@ref)
%     end
%     h.CellLabelColor = 'none';   % Hide cell numerical labels [1,10](@ref)
%     h.GridVisible = 'on';       % Disable grid lines [4](@ref)
%     % grid on;        % Ensure grid lines are visible
%     % h.GridColor = 'white';
%     for j = 1:length(h.XDisplayLabels)
%         h.XDisplayLabels{j}=' ';
%     end
% 
%     for j = 1:length(h.YDisplayLabels)
%         h.YDisplayLabels{j}=' ';
%     end
% end
% 
% % Mark specific point (e.g., row 3, column 5)
% targetRow = stack_operator_standard1x5{end}.OutputPoint(1)+1;
% targetCol = stack_operator_standard1x5{end}.OutputPoint(2);
% % hold on;
% % rectangle('Position', [targetCol-0.5, targetRow-0.5, 1, 1], ...
% %           'EdgeColor', 'r', 'LineWidth', 2, 'Curvature', [1 1]); % Red circle annotation [7,8](@ref)
% % hold off;
% 
% % % Optimize display
% % h.Title = 'Boolean Matrix Heatmap';
% % h.XLabel = 'Column Index';
% % h.YLabel = 'Row Index';
% set(gca, 'FontSize', 12);    % Set uniform font size


% --- Figure 10: Tiledlayout Heatmaps (Commented out) ---
% figure;
% Tl = tiledlayout(size(CellMatrix,1), 1); % 5 rows, 1 column
% Tl.Padding = 'compact'; % Set compact padding
% Tl.TileSpacing = 'compact'; % Set compact tile spacing
% 
% 
% for i = 1:size(CellMatrix,1)
%     nexttile
%     if i == 1
%         h = heatmap(CellMatrix(i,:), 'Colormap', [0.85 0.85 0.85; 0.85 0.85 0.85]); % Binary color map: White (0) / Black (1) [3,5](@ref)
%     else
%         h = heatmap(CellMatrix(i,:), 'Colormap', [0.85 0.85 0.85; 0 0 0]); % Binary color map: White (0) / Black (1) [3,5](@ref)
%     end
%     h.CellLabelColor = 'none';   % Hide cell numerical labels [1,10](@ref)
%     h.GridVisible = 'on';       % Disable grid lines [4](@ref)
%     % grid on;        % Ensure grid lines are visible
%     % h.GridColor = 'white';
%     for j = 1:length(h.XDisplayLabels)
%         h.XDisplayLabels{j}=' ';
%     end
% 
%     for j = 1:length(h.YDisplayLabels)
%         h.YDisplayLabels{j}=' ';
%     end
% end
































%% Functions


function root = buildExpressionTree(tokens)
    % Function to build expression tree from postfix expression
    stack = {};  % Initialize an empty stack
    for i = 1:length(tokens)  % Iterate through each token
        token = tokens{i};  % Current token
        if isOperator(token)  % If it is an operator
            rightNode = stack{end};  % Pop top of stack as right child
            stack(end) = [];  % Remove from stack
            leftNode = stack{end};  % Pop new top of stack as left child
            stack(end) = [];  % Remove from stack
            newNode = struct('value', token, 'left', leftNode, 'right', rightNode);  % Create new node
            stack{end+1} = newNode;  % Push new node onto stack
        else  % If it is an operand
            newNode = struct('value', token, 'left', [], 'right', []);  % Create leaf node
            stack{end+1} = newNode;  % Push leaf node onto stack
        end
    end
    root = stack{end};  % Top element of stack is the root of the expression tree
end



function postfix = infixToPostfix(expression)
    % Function to convert infix expression to postfix expression
    output = {};  % Initialize output list
    operators = {};  % Initialize operator stack
    tokens = strsplit(expression);  % Split expression into individual tokens
    for i = 1:length(tokens)  % Iterate through each token
        token = tokens{i};  % Current token
        if isOperator(token)  % If it is an operator
            while ~isempty(operators) && precedence(operators{end}) >= precedence(token)
                % Pop operators with greater or equal precedence from stack to output
                output{end+1} = operators{end};
                operators(end) = [];
            end
            operators{end+1} = token;  % Push current operator onto stack
        elseif strcmp(token, '(')  % If left parenthesis
            operators{end+1} = token;  % Push onto stack
        elseif strcmp(token, ')')  % If right parenthesis
            while ~strcmp(operators{end}, '(')  % Pop stack to output until left parenthesis is found
                output{end+1} = operators{end};
                operators(end) = [];
            end
            operators(end) = [];  % Pop left parenthesis without adding to output
        else  % If it is an operand
            output{end+1} = token;  % Add directly to output list
        end
    end
    while ~isempty(operators)  % Pop all remaining operators from stack to output
        output{end+1} = operators{end};
        operators(end) = [];
    end
    postfix = output;  % Return postfix expression
end



function prec = precedence(token)
    % Return operator precedence; higher number means higher priority
    switch token
        case 'OR'
            prec = 1;  % Precedence of OR is 1
        case 'XOR'
            prec = 2;  % Precedence of XOR is 2
        case 'AND'
            prec = 3;  % Precedence of AND is 3
        otherwise
            prec = 0;  % Default precedence is 0
    end
end



function flag = isOperator(token)
    % Determine if a token is an operator
    flag = any(strcmp(token, {'AND', 'OR', 'XOR', 'NAND', 'NOR'}));
end



function displayTree(node, indent)
    % Function to recursively display binary tree in command window
    if isempty(node)  % If node is empty, return immediately
        return;
    end
    if nargin < 2  % If indent parameter is not provided, initialize as empty string
        indent = '';
    end
    displayTree(node.right, [indent, '   ']);  % Display right subtree first
    fprintf('%s%s\n', indent, node.value);  % Display current node
    displayTree(node.left, [indent, '   ']);  % Display left subtree last
end


% Function to plot the tree
function plotTree(node)
    % Initialize the figure
    figure;
    hold on;
    axis off;
    % Start plotting from the root node at (0, 0)
    plotNode(node, 0, 0, 1);
    hold off;
end



% Recursive function to plot each node
function [x, y] = plotNode(node, x, y, level)
    if isempty(node) || isempty(node.value) % If the node is empty, return current coordinates
        return;
    end
    
    % Compute the horizontal distance based on the level of the node
    hDist = 2^(-level);
    
    % Plot the right subtree
    [xr, yr] = plotNode(node.right, x + hDist, y - 1, level + 1);
    
    % Plot the current node
    plot(x, y, 'ko', 'MarkerFaceColor', 'k'); % Plot node
    text(x, y, sprintf('%s', node.value), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    
    % If there's a right child, draw a line to it
    if ~isempty(node.right) && ~isempty(node.right.value)
        plot([x xr], [y yr], 'k-'); % Draw line to the right child
    end
    
    % Plot the left subtree
    [xl, yl] = plotNode(node.left, x - hDist, y - 1, level + 1);
    
    % If there's a left child, draw a line to it
    if ~isempty(node.left) && ~isempty(node.left.value)
        plot([x xl], [y yl], 'k-'); % Draw line to the left child
    end
end




function plot_the_logic_block(stack_input, stack_operator, stack_wire, Color_input, Color_wire, Color_operator)
    % This function plots logic blocks, including input blocks, operator blocks, and wires.
    % Parameters:
    %   stack_input - Structure array of input blocks containing positions and names.
    %   stack_operator - Structure array of operator blocks containing input positions and names.
    %   stack_wire - Structure array of wires containing input positions and names.
    %   Color_input - Color of input blocks.
    %   Color_wire - Color of wires.
    %   Color_operator - Color of operator blocks.

    % Plot input blocks
    for i = 1 : length(stack_input)
        % Call add_pixel_with_text for each input block at specified position
        add_pixel_with_text(stack_input{i}.Position, stack_input{i}.Name, Color_input);
    end

    % Plot operator blocks
    for i = 1 : length(stack_operator)
        % Plot name on left side of operator block
        add_pixel_with_text(stack_operator{i}.InputLeft + [1, 0], stack_operator{i}.Name, Color_operator);
        
        % Plot tilde '~' in middle of operator block to indicate connection
        for j = stack_operator{i}.InputLeft(2) + 1 : stack_operator{i}.InputRight(2) - 1
            add_pixel_with_text([stack_operator{i}.InputLeft(1) + 1, j], '~', Color_operator);
        end
        
        % Plot name on right side of operator block
        add_pixel_with_text(stack_operator{i}.InputRight + [1, 0], stack_operator{i}.Name, Color_operator);
    end

    % Plot output block
    add_pixel_with_text(stack_operator{end}.OutputPoint + [1, 0], 'Output', Color_input);

    % Plot wires
    for i = 1 : length(stack_wire)
        % Call add_pixel_with_text for each wire at specified position
        add_pixel_with_text(stack_wire{i}.Input + [1, 0], stack_wire{i}.Name, Color_wire);
    end
end



function add_pixel_with_text(point, textLabel, color)
    % Create a dynamically resizable matrix, initially empty
    % textData stores text label for each coordinate
    % colorData stores RGB color for each coordinate
    % maxRow and maxCol track current maximum dimensions
    persistent textData;
    persistent colorData;
    persistent maxRow;
    persistent maxCol;
    
    % Initialize if textData is empty
    if isempty(textData)
        textData = cell(1, 1); % Initialize as 1x1 cell array
        colorData = ones(1, 1, 3); % Initialize as 1x1x3 white color matrix
        maxRow = 1; % Initialize max rows
        maxCol = 1; % Initialize max cols
    end
    
    % Resize matrices dynamically if input point exceeds current boundaries
    if point(1) > maxRow
        maxRow = point(1);
    end
    if point(2) > maxCol
        maxCol = point(2);
    end
    if size(textData, 1) < maxRow || size(textData, 2) < maxCol
        % Create new, larger cell and color arrays
        newTextData = cell(maxRow, maxCol);
        newColorData = ones(maxRow, maxCol, 3);
        
        % Copy old data into new arrays
        newTextData(1:size(textData, 1), 1:size(textData, 2)) = textData;
        newColorData(1:size(colorData, 1), 1:size(colorData, 2), :) = colorData;
        
        % Update persistent variables
        textData = newTextData;
        colorData = newColorData;
    end
    
    % Add new text label and color to data arrays
    textData{point(1), point(2)} = textLabel;
    colorData(point(1), point(2), :) = color;
    
    % Render plot
    % figure(2); % Keep rendering in the current figure window
    clf; % Clear current figure
    hold on; % Hold plot
    
    % Loop through all cells to plot colored polygons and labels
    for row = 1:maxRow
        for col = 1:maxCol
            if ~isempty(textData{row, col})
                % Draw colored polygon block
                fill([col-1 col col col-1], [row-1 row-1 row row], reshape(colorData(row, col, :), 1, 3), 'EdgeColor', 'none');
                
                % Add text label at the center of the block
                text(col-0.5, row-0.5, textData{row, col}, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
                    'Color', 'k', 'FontSize', 14, 'FontWeight', 'bold');
            end
        end
    end
    
    % Set axes properties
    set(gca, 'YDir', 'reverse'); % Reverse Y-axis so (1,1) is at top-left
    axis equal; % Equal aspect ratio
    xlim([0 maxCol]); % Set x-axis limits
    ylim([0 maxRow]); % Set y-axis limits
    axis off; % Hide axes
    box on; % Enable box outline
    hold off; % Release hold
end


function plot_the_logic_block_standard(stack_input, stack_operator, stack_wire, stack_shift_left, stack_shift_right, Color_input, Color_wire, Color_operator, Color_shift)
    % This function plots logic blocks, including input blocks, operator blocks, and wires.
    % Parameters:
    %   stack_input - Structure array of input blocks containing positions and names.
    %   stack_operator - Structure array of operator blocks containing input positions and names.
    %   stack_wire - Structure array of wires containing input positions and names.
    %   Color_input - Color of input blocks.
    %   Color_wire - Color of wires.
    %   Color_operator - Color of operator blocks.
    % Plot input blocks
    for i = 1 : length(stack_input)
        % Call add_pixel_with_text for each input block at specified position
        add_pixel_with_text_standard(stack_input{i}.Position, stack_input{i}.Name, Color_input);
    end

    % Plot operator blocks
    for i = 1 : length(stack_operator)
        % Plot name on left side of operator block
        add_pixel_with_text_standard(stack_operator{i}.InputLeft + [1, 0], stack_operator{i}.Name(1), Color_operator);
        
        if length(stack_operator{i}.Name) > 2
        add_pixel_with_text_standard(stack_operator{i}.InputLeft + [1, 1], stack_operator{i}.Name(2), Color_operator);
        
        % Plot name on right side of operator block
        add_pixel_with_text_standard(stack_operator{i}.InputRight + [1, 0], stack_operator{i}.Name(3), Color_operator);
        else
        add_pixel_with_text_standard(stack_operator{i}.InputLeft + [1, 1], ' ', Color_operator);
        
        % Plot name on right side of operator block
        add_pixel_with_text_standard(stack_operator{i}.InputRight + [1, 0], stack_operator{i}.Name(2), Color_operator); 
        end
    end

    % Plot left-shift blocks
    for i = 1 : length(stack_shift_left)
        % Plot label on left side of operator block
        add_pixel_with_text_standard(stack_shift_left{i}.Input + [1, 0], 'T', Color_shift);
        
        % Plot label in middle of operator block
        add_pixel_with_text_standard(stack_shift_left{i}.Output + [0, 0], 'F', Color_shift);
        
        % Plot label on right side of operator block
        add_pixel_with_text_standard(stack_shift_left{i}.Output + [0, -1], 'L', Color_shift);
    end    

    % Plot right-shift blocks
    for i = 1 : length(stack_shift_right)
        % Plot label on right side of operator block
        add_pixel_with_text_standard(stack_shift_right{i}.Input + [1, 0], 'R', Color_shift);
        
        % Plot label in middle of operator block
        add_pixel_with_text_standard(stack_shift_right{i}.Output + [0, 0], 'G', Color_shift);
        
        % Plot label on left side of operator block
        add_pixel_with_text_standard(stack_shift_right{i}.Output + [0, +1], 'T', Color_shift);
    end 

    % Plot output block
    add_pixel_with_text_standard(stack_operator{end}.OutputPoint + [1, 0], 'Output', Color_input);

    % Plot wires
    for i = 1 : length(stack_wire)
        % Call add_pixel_with_text for each wire at specified position
        add_pixel_with_text_standard(stack_wire{i}.Input + [1, 0], stack_wire{i}.Name, Color_wire);
    end
end            












function add_pixel_with_text_standard(point, textLabel, color)
    % Create a dynamically resizable matrix, initially empty
    % textData stores text label for each coordinate
    % colorData stores RGB color for each coordinate
    % maxRow and maxCol track current maximum dimensions
    persistent textData_standard;
    persistent colorData_standard;
    persistent maxRow_standard;
    persistent maxCol_standard;
    
    % Initialize if textData is empty
    if isempty(textData_standard)
        textData_standard = cell(1, 1); % Initialize as 1x1 cell array
        colorData_standard = ones(1, 1, 3); % Initialize as 1x1x3 white color matrix
        maxRow_standard = 1; % Initialize max rows
        maxCol_standard = 1; % Initialize max cols
    end
    
    % Resize matrices dynamically if input point exceeds current boundaries
    if point(1) > maxRow_standard
        maxRow_standard = point(1);
    end
    if point(2) > maxCol_standard
        maxCol_standard = point(2);
    end
    if size(textData_standard, 1) < maxRow_standard || size(textData_standard, 2) < maxCol_standard
        % Create new, larger cell and color arrays
        newTextData = cell(maxRow_standard, maxCol_standard);
        newColorData = ones(maxRow_standard, maxCol_standard, 3);
        
        % Copy old data into new arrays
        newTextData(1:size(textData_standard, 1), 1:size(textData_standard, 2)) = textData_standard;
        newColorData(1:size(colorData_standard, 1), 1:size(colorData_standard, 2), :) = colorData_standard;
        
        % Update persistent variables
        textData_standard = newTextData;
        colorData_standard = newColorData;
    end
    
    % Add new text label and color to data arrays
    textData_standard{point(1), point(2)} = textLabel;
    colorData_standard(point(1), point(2), :) = color;
    
    % Render plot
    % figure; % Keep rendering in the current figure window
    clf; % Clear current figure
    hold on; % Hold plot
    
    % Loop through all cells to plot colored polygons and labels
    for row = 1:maxRow_standard
        for col = 1:maxCol_standard
            if ~isempty(textData_standard{row, col})
                % Draw colored polygon block
                fill([col-1 col col col-1], [row-1 row-1 row row], reshape(colorData_standard(row, col, :), 1, 3), 'EdgeColor', 'none');
                
                % Add text label at the center of the block
                text(col-0.5, row-0.5, textData_standard{row, col}, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
                    'Color', 'k', 'FontSize', 14, 'FontWeight', 'bold');
            end
        end
    end
    
    % Set axes properties
    set(gca, 'YDir', 'reverse'); % Reverse Y-axis so (1,1) is at top-left
    axis equal; % Equal aspect ratio
    xlim([0 maxCol_standard]); % Set x-axis limits
    ylim([0 maxRow_standard]); % Set y-axis limits
    axis off; % Hide axes
    box on; % Enable box outline
    hold off; % Release hold
end





function plot_the_logic_block1x5(stack_input, stack_operator, stack_wire, Color_input, Color_wire, Color_operator)
    % This function plots logic blocks, including input blocks, operator blocks, and wires.
    % Parameters:
    %   stack_input - Structure array of input blocks containing positions and names.
    %   stack_operator - Structure array of operator blocks containing input positions and names.
    %   stack_wire - Structure array of wires containing input positions and names.
    %   Color_input - Color of input blocks.
    %   Color_wire - Color of wires.
    %   Color_operator - Color of operator blocks.

    % Plot input blocks
    for i = 1 : length(stack_input)
        % Call add_pixel_with_text for each input block at specified position
        add_pixel_with_text1x5(stack_input{i}.Position, stack_input{i}.Name, Color_input);
    end

    % Plot operator blocks
    for i = 1 : length(stack_operator)
        % Plot name on left side of operator block
        add_pixel_with_text1x5(stack_operator{i}.InputLeft + [0, 1], stack_operator{i}.Name, Color_operator);
        
        % Plot tilde '~' in middle of operator block to indicate connection
        for j = stack_operator{i}.InputLeft(2) + 2 : stack_operator{i}.InputRight(2) - 2
            add_pixel_with_text1x5([stack_operator{i}.InputLeft(1) , j], '~', Color_operator);
        end
        
        % Plot name on right side of operator block
        add_pixel_with_text1x5(stack_operator{i}.InputRight + [0, -1], stack_operator{i}.Name, Color_operator);

        % Plot output of operator block
        add_pixel_with_text1x5(stack_operator{i}.OutputPoint, 'Output', Color_operator);
    end

    % Plot output block
    add_pixel_with_text1x5(stack_operator{end}.OutputPoint, 'Output', Color_input);

    % Plot wires
    for i = 1 : length(stack_wire)
        % Call add_pixel_with_text for each wire at specified position
        add_pixel_with_text1x5(stack_wire{i}.Input + [1, 0], stack_wire{i}.Name, Color_wire);
    end



end



function add_pixel_with_text1x5(point, textLabel, color)
    % Create a dynamically resizable matrix, initially empty
    % textData stores text label for each coordinate
    % colorData stores RGB color for each coordinate
    % maxRow and maxCol track current maximum dimensions
    persistent textData;
    persistent colorData;
    persistent maxRow;
    persistent maxCol;
    
    % Initialize if textData is empty
    if isempty(textData)
        textData = cell(1, 1); % Initialize as 1x1 cell array
        colorData = ones(1, 1, 3); % Initialize as 1x1x3 white color matrix
        maxRow = 1; % Initialize max rows
        maxCol = 1; % Initialize max cols
    end
    
    % Resize matrices dynamically if input point exceeds current boundaries
    if point(1) > maxRow
        maxRow = point(1);
    end
    if point(2) > maxCol
        maxCol = point(2);
    end
    if size(textData, 1) < maxRow || size(textData, 2) < maxCol
        % Create new, larger cell and color arrays
        newTextData = cell(maxRow, maxCol);
        newColorData = ones(maxRow, maxCol, 3);
        
        % Copy old data into new arrays
        newTextData(1:size(textData, 1), 1:size(textData, 2)) = textData;
        newColorData(1:size(colorData, 1), 1:size(colorData, 2), :) = colorData;
        
        % Update persistent variables
        textData = newTextData;
        colorData = newColorData;
    end
    
    % Add new text label and color to data arrays
    textData{point(1), point(2)} = textLabel;
    colorData(point(1), point(2), :) = color;
    
    % Render plot
    % figure(2); % Keep rendering in the current figure window
    clf; % Clear current figure
    hold on; % Hold plot
    
    % Loop through all cells to plot colored polygons and labels
    for row = 1:maxRow
        for col = 1:maxCol
            if ~isempty(textData{row, col})
                % Draw colored polygon block
                fill([col-1 col col col-1], [row-1 row-1 row row], reshape(colorData(row, col, :), 1, 3), 'EdgeColor', 'none');
                
                % Add text label at the center of the block
                text(col-0.5, row-0.5, textData{row, col}, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
                    'Color', 'k', 'FontSize', 14, 'FontWeight', 'bold');
            end
        end
    end
    
    % Set axes properties
    set(gca, 'YDir', 'reverse'); % Reverse Y-axis so (1,1) is at top-left
    axis equal; % Equal aspect ratio
    xlim([0 maxCol]); % Set x-axis limits
    ylim([0 maxRow]); % Set y-axis limits
    axis off; % Hide axes
    box on; % Enable box outline
    hold off; % Release hold
end





function plot_the_logic_block1x5_colored(stack_input, stack_operator, stack_wire, Color_input, Color_wire, Color_operator)
    % This function plots logic blocks, including input blocks, operator blocks, and wires.
    % Parameters:
    %   stack_input - Structure array of input blocks containing positions and names.
    %   stack_operator - Structure array of operator blocks containing input positions and names.
    %   stack_wire - Structure array of wires containing input positions and names.
    %   Color_input - Color of input blocks.
    %   Color_wire - Color of wires.
    %   Color_operator - Color of operator blocks.

    % Plot input blocks
    for i = 1 : length(stack_input)
        % Call add_pixel_with_text for each input block at specified position
        add_pixel_with_text1x5_colored(stack_input{i}.Position, ' ', Color_input);
    end

    % Plot operator blocks
    for i = 1 : length(stack_operator)
        % Plot name on left side of operator block
        add_pixel_with_text1x5_colored(stack_operator{i}.InputLeft + [0, 1], ' ', Color_operator);
        
        % Plot tilde '~' in middle of operator block to indicate connection
        for j = stack_operator{i}.InputLeft(2) + 2 : stack_operator{i}.InputRight(2) - 2
            add_pixel_with_text1x5_colored([stack_operator{i}.InputLeft(1) , j], ' ', Color_operator);
        end
        
        % Plot name on right side of operator block
        add_pixel_with_text1x5_colored(stack_operator{i}.InputRight + [0, -1], ' ', Color_operator);

        % Plot output of operator block
        add_pixel_with_text1x5_colored(stack_operator{i}.OutputPoint, ' ', Color_operator);
    end

%     % Plot output block
%     add_pixel_with_text1x5_colored(stack_operator{end}.OutputPoint, ' ', Color_input);

    % Plot wires
    for i = 1 : length(stack_wire)
        % Call add_pixel_with_text for each wire at specified position
        add_pixel_with_text1x5_colored(stack_wire{i}.Input + [1, 0], ' ', Color_wire);
    end



end



function add_pixel_with_text1x5_colored(point, textLabel, color)
    % Create a dynamically resizable matrix, initially empty
    % textData stores text label for each coordinate
    % colorData stores RGB color for each coordinate
    % maxRow and maxCol track current maximum dimensions
    persistent textData;
    persistent colorData;
    persistent maxRow;
    persistent maxCol;
    
    % Initialize if textData is empty
    if isempty(textData)
        textData = cell(1, 1); % Initialize as 1x1 cell array
        colorData = ones(1, 1, 3); % Initialize as 1x1x3 white color matrix
        maxRow = 1; % Initialize max rows
        maxCol = 1; % Initialize max cols
    end
    
    % Resize matrices dynamically if input point exceeds current boundaries
    if point(1) > maxRow
        maxRow = point(1);
    end
    if point(2) > maxCol
        maxCol = point(2);
    end
    if size(textData, 1) < maxRow || size(textData, 2) < maxCol
        % Create new, larger cell and color arrays
        newTextData = cell(maxRow, maxCol);
        newColorData = ones(maxRow, maxCol, 3);
        
        % Copy old data into new arrays
        newTextData(1:size(textData, 1), 1:size(textData, 2)) = textData;
        newColorData(1:size(colorData, 1), 1:size(colorData, 2), :) = colorData;
        
        % Update persistent variables
        textData = newTextData;
        colorData = newColorData;
    end
    
    % Add new text label and color to data arrays
    textData{point(1), point(2)} = textLabel;
    colorData(point(1), point(2), :) = color;
    
    % Render plot
    % figure(2); % Keep rendering in the current figure window
    clf; % Clear current figure
    hold on; % Hold plot
    
    % Loop through all cells to plot colored polygons and labels
    for row = 1:maxRow
        for col = 1:maxCol
            if ~isempty(textData{row, col})
                % Draw colored polygon block
                fill([col-1 col col col-1], [row-1 row-1 row row], reshape(colorData(row, col, :), 1, 3), 'EdgeColor', 'none');
                
                % Add text label at the center of the block
                text(col-0.5, row-0.5, textData{row, col}, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
                    'Color', 'k', 'FontSize', 14, 'FontWeight', 'bold');
            end
        end
    end
    
    % Set axes properties
    set(gca, 'YDir', 'reverse'); % Reverse Y-axis so (1,1) is at top-left
    axis equal; % Equal aspect ratio
    xlim([0 maxCol]); % Set x-axis limits
    ylim([0 maxRow]); % Set y-axis limits
    axis off; % Hide axes
    box on; % Enable box outline
    hold off; % Release hold
end






function plot_the_logic_block_standard1x5(stack_input, stack_operator, stack_wire, stack_shift_left, stack_shift_right, blackColor, redColor, yellowColor, blueColor, greenColor, purpleColor)
    % This function plots logic blocks, including input blocks, operator blocks, and wires.
    % Parameters:
    %   stack_input - Structure array of input blocks containing positions and names.
    %   stack_operator - Structure array of operator blocks containing input positions and names.
    %   stack_wire - Structure array of wires containing input positions and names.
    %   Color_input - Color of input blocks.
    %   Color_wire - Color of wires.
    %   Color_operator - Color of operator blocks.
    % Plot input blocks
    for i = 1 : length(stack_input)
        % Call add_pixel_with_text for each input block at specified position
        if stack_input{i}.Name ~= '1'
            add_pixel_with_text_standard1x5(stack_input{i}.Position, stack_input{i}.Name, blueColor);
        else
            add_pixel_with_text_standard1x5(stack_input{i}.Position, stack_input{i}.Name, blackColor);
        end
    end

    % Plot operator blocks
    for i = 1 : length(stack_operator)
        % Plot name on left side of operator block
        add_pixel_with_text_standard1x5(stack_operator{i}.InputLeft + [0, 1], stack_operator{i}.Name(1), yellowColor);
        % Plot output label below operator block
        add_pixel_with_text_standard1x5(stack_operator{i}.OutputPoint + [0, 0], 'Output', redColor);


        if length(stack_operator{i}.Name) > 2    % Multi-character operators like AND, XOR
        add_pixel_with_text_standard1x5(stack_operator{i}.InputLeft + [0, 2], stack_operator{i}.Name(2), yellowColor);
        
        % Plot name on right side of operator block
        add_pixel_with_text_standard1x5(stack_operator{i}.InputRight + [0, -1], stack_operator{i}.Name(3), yellowColor);
        else                                     % Short operators like OR
        add_pixel_with_text_standard1x5(stack_operator{i}.InputLeft + [0, 2], ' ', yellowColor);
        
        % Plot name on right side of operator block
        add_pixel_with_text_standard1x5(stack_operator{i}.InputRight + [0, -1], stack_operator{i}.Name(2), yellowColor); 
        end
    end

    % Plot left-shift blocks
    for i = 1 : length(stack_shift_left)
        % Plot label on right side of operator block
        add_pixel_with_text_standard1x5(stack_shift_left{i}.Input + [0, -1], 'T', greenColor);
        
        % Plot label in middle of operator block
        add_pixel_with_text_standard1x5(stack_shift_left{i}.Output + [-1, 0], 'F', greenColor);
        
        % Plot label on left side of operator block
        add_pixel_with_text_standard1x5(stack_shift_left{i}.Output + [-1, -1], 'E', greenColor);

        % 
        add_pixel_with_text_standard1x5(stack_shift_left{i}.Output + [-1, -2], 'L', greenColor);

        % Plot output label below operator block
        add_pixel_with_text_standard1x5(stack_shift_left{i}.Output + [0, 0], 'Output', redColor);
    end    

    % Plot right-shift blocks
    for i = 1 : length(stack_shift_right)
        % Plot label on right side of operator block
        add_pixel_with_text_standard1x5(stack_shift_right{i}.Input + [0, 1], 'R', greenColor);
        
        % Plot label in middle of operator block
        add_pixel_with_text_standard1x5(stack_shift_right{i}.Output + [-1, 0], 'G', greenColor);
        
        % Plot label on left side of operator block
        add_pixel_with_text_standard1x5(stack_shift_right{i}.Output + [-1, +1], 'H', greenColor);

        % 
        add_pixel_with_text_standard1x5(stack_shift_right{i}.Output + [-1, +2], 'T', greenColor);

        % Plot output label below operator block
        add_pixel_with_text_standard1x5(stack_shift_right{i}.Output + [0, 0], 'Output', redColor);
    end 

    % Plot output block
    add_pixel_with_text_standard1x5(stack_operator{end}.OutputPoint + [0, 0], 'Output', redColor);

    % Plot wires
    for i = 1 : length(stack_wire)
        % Call add_pixel_with_text for each wire at specified position
        add_pixel_with_text_standard1x5(stack_wire{i}.Input + [1, 0], stack_wire{i}.Name, purpleColor);
    end
end            












function add_pixel_with_text_standard1x5(point, textLabel, color)
    % Create a dynamically resizable matrix, initially empty
    % textData stores text label for each coordinate
    % colorData stores RGB color for each coordinate
    % maxRow and maxCol track current maximum dimensions
    persistent textData_standard;
    persistent colorData_standard;
    persistent maxRow_standard;
    persistent maxCol_standard;
    
    % Initialize if textData is empty
    if isempty(textData_standard)
        textData_standard = cell(1, 1); % Initialize as 1x1 cell array
        colorData_standard = ones(1, 1, 3); % Initialize as 1x1x3 white color matrix
        maxRow_standard = 1; % Initialize max rows
        maxCol_standard = 1; % Initialize max cols
    end
    
    % Resize matrices dynamically if input point exceeds current boundaries
    if point(1) > maxRow_standard
        maxRow_standard = point(1);
    end
    if point(2) > maxCol_standard
        maxCol_standard = point(2);
    end
    if size(textData_standard, 1) < maxRow_standard || size(textData_standard, 2) < maxCol_standard
        % Create new, larger cell and color arrays
        newTextData = cell(maxRow_standard, maxCol_standard);
        newColorData = ones(maxRow_standard, maxCol_standard, 3);
        
        % Copy old data into new arrays
        newTextData(1:size(textData_standard, 1), 1:size(textData_standard, 2)) = textData_standard;
        newColorData(1:size(colorData_standard, 1), 1:size(colorData_standard, 2), :) = colorData_standard;
        
        % Update persistent variables
        textData_standard = newTextData;
        colorData_standard = newColorData;
    end
    
    % Add new text label and color to data arrays
    textData_standard{point(1), point(2)} = textLabel;
    colorData_standard(point(1), point(2), :) = color;
    
    % Render plot
    % figure; % Keep rendering in the current figure window
    clf; % Clear current figure
    hold on; % Hold plot
    
    % Loop through all cells to plot colored polygons and labels
    for row = 1:maxRow_standard
        for col = 1:maxCol_standard
            if ~isempty(textData_standard{row, col})
                % Draw colored polygon block
                fill([col-1 col col col-1], [row-1 row-1 row row], reshape(colorData_standard(row, col, :), 1, 3), 'EdgeColor', 'k');
                
                % Add text label at the center of the block
                text(col-0.5, row-0.5, textData_standard{row, col}, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
                    'Color', 'k', 'FontSize', 14, 'FontWeight', 'bold');
            end
        end
    end
    
    % Set axes properties
    set(gca, 'YDir', 'reverse'); % Reverse Y-axis so (1,1) is at top-left
    axis equal; % Equal aspect ratio
    xlim([0 maxCol_standard]); % Set x-axis limits
    ylim([0 maxRow_standard]); % Set y-axis limits
    axis off; % Hide axes
    box on; % Enable box outline
    hold off; % Release hold
end       







function plot_the_logic_block_standard1x5_colored(stack_input, stack_operator, stack_wire, stack_shift_left, stack_shift_right, blackColor, redColor, yellowColor, blueColor, greenColor, purpleColor)
    % This function plots logic blocks, including input blocks, operator blocks, and wires.
    % Parameters:
    %   stack_input - Structure array of input blocks containing positions and names.
    %   stack_operator - Structure array of operator blocks containing input positions and names.
    %   stack_wire - Structure array of wires containing input positions and names.
    %   Color_input - Color of input blocks.
    %   Color_wire - Color of wires.
    %   Color_operator - Color of operator blocks.
    % Plot input blocks
    for i = 1 : length(stack_input)
        % Call add_pixel_with_text for each input block at specified position
        if stack_input{i}.Name ~= '1'
            add_pixel_with_text_standard1x5_colored(stack_input{i}.Position, ' ', blueColor);
        else
            add_pixel_with_text_standard1x5_colored(stack_input{i}.Position, ' ', blackColor);
        end
    end

    % Plot operator blocks
    for i = 1 : length(stack_operator)
        % Plot name on left side of operator block
        add_pixel_with_text_standard1x5_colored(stack_operator{i}.InputLeft + [0, 1], ' ', yellowColor);
        % Plot output label below operator block
        add_pixel_with_text_standard1x5_colored(stack_operator{i}.OutputPoint + [0, 0], ' ', redColor);


        if length(stack_operator{i}.Name) > 2    % Multi-character operators like AND, XOR
        add_pixel_with_text_standard1x5_colored(stack_operator{i}.InputLeft + [0, 2], ' ', yellowColor);
        
        % Plot name on right side of operator block
        add_pixel_with_text_standard1x5_colored(stack_operator{i}.InputRight + [0, -1], ' ', yellowColor);
        else                                     % Short operators like OR
        add_pixel_with_text_standard1x5_colored(stack_operator{i}.InputLeft + [0, 2], ' ', yellowColor);
        
        % Plot name on right side of operator block
        add_pixel_with_text_standard1x5_colored(stack_operator{i}.InputRight + [0, -1], ' ', yellowColor); 
        end
    end

    % Plot left-shift blocks
    for i = 1 : length(stack_shift_left)
        % Plot label on right side of operator block
        add_pixel_with_text_standard1x5_colored(stack_shift_left{i}.Input + [0, -1], ' ', greenColor);
        
        % Plot label in middle of operator block
        add_pixel_with_text_standard1x5_colored(stack_shift_left{i}.Output + [-1, 0], ' ', greenColor);
        
        % Plot label on left side of operator block
        add_pixel_with_text_standard1x5_colored(stack_shift_left{i}.Output + [-1, -1], ' ', greenColor);

        % 
        add_pixel_with_text_standard1x5_colored(stack_shift_left{i}.Output + [-1, -2], ' ', greenColor);

        % Plot output label below operator block
        add_pixel_with_text_standard1x5_colored(stack_shift_left{i}.Output + [0, 0], ' ', redColor);
    end    

    % Plot right-shift blocks
    for i = 1 : length(stack_shift_right)
        % Plot label on right side of operator block
        add_pixel_with_text_standard1x5_colored(stack_shift_right{i}.Input + [0, 1], ' ', greenColor);
        
        % Plot label in middle of operator block
        add_pixel_with_text_standard1x5_colored(stack_shift_right{i}.Output + [-1, 0], ' ', greenColor);
        
        % Plot label on left side of operator block
        add_pixel_with_text_standard1x5_colored(stack_shift_right{i}.Output + [-1, +1], ' ', greenColor);

        % 
        add_pixel_with_text_standard1x5_colored(stack_shift_right{i}.Output + [-1, +2], ' ', greenColor);

        % Plot output label below operator block
        add_pixel_with_text_standard1x5_colored(stack_shift_right{i}.Output + [0, 0], ' ', redColor);
    end 

    % Plot output block
   % add_pixel_with_text_standard1x5_colored(stack_operator{end}.OutputPoint + [0, 0], 'Output', Color_input);

    % Plot wires
    for i = 1 : length(stack_wire)
        % Call add_pixel_with_text for each wire at specified position
        add_pixel_with_text_standard1x5_colored(stack_wire{i}.Input + [1, 0], ' ', purpleColor);
    end
end                        












function add_pixel_with_text_standard1x5_colored(point, textLabel, color)
    % Create a dynamically resizable matrix, initially empty
    % textData stores text label for each coordinate
    % colorData stores RGB color for each coordinate
    % maxRow and maxCol track current maximum dimensions
    persistent textData_standard;
    persistent colorData_standard;
    persistent maxRow_standard;
    persistent maxCol_standard;
    
    % Initialize if textData is empty
    if isempty(textData_standard)
        textData_standard = cell(1, 1); % Initialize as 1x1 cell array
        colorData_standard = ones(1, 1, 3); % Initialize as 1x1x3 white color matrix
        maxRow_standard = 1; % Initialize max rows
        maxCol_standard = 1; % Initialize max cols
    end
    
    % Resize matrices dynamically if input point exceeds current boundaries
    if point(1) > maxRow_standard
        maxRow_standard = point(1);
    end
    if point(2) > maxCol_standard
        maxCol_standard = point(2);
    end
    if size(textData_standard, 1) < maxRow_standard || size(textData_standard, 2) < maxCol_standard
        % Create new, larger cell and color arrays
        newTextData = cell(maxRow_standard, maxCol_standard);
        newColorData = ones(maxRow_standard, maxCol_standard, 3);
        
        % Copy old data into new arrays
        newTextData(1:size(textData_standard, 1), 1:size(textData_standard, 2)) = textData_standard;
        newColorData(1:size(colorData_standard, 1), 1:size(colorData_standard, 2), :) = colorData_standard;
        
        % Update persistent variables
        textData_standard = newTextData;
        colorData_standard = newColorData;
    end
    
    % Add new text label and color to data arrays
    textData_standard{point(1), point(2)} = textLabel;
    colorData_standard(point(1), point(2), :) = color;
    
    % Render plot
    % figure; % Keep rendering in the current figure window
    clf; % Clear current figure
    hold on; % Hold plot
    
    % Loop through all cells to plot colored polygons and labels
    for row = 1:maxRow_standard
        for col = 1:maxCol_standard
            if ~isempty(textData_standard{row, col})
                % Draw colored polygon block
                fill([col-1 col col col-1], [row-1 row-1 row row], reshape(colorData_standard(row, col, :), 1, 3), 'EdgeColor', 'k');
                
                % Add text label at the center of the block
                text(col-0.5, row-0.5, textData_standard{row, col}, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
                    'Color', 'k', 'FontSize', 14, 'FontWeight', 'bold');
            end
        end
    end
    
    % Set axes properties
    set(gca, 'YDir', 'reverse'); % Reverse Y-axis so (1,1) is at top-left
    axis equal; % Equal aspect ratio
    xlim([0 maxCol_standard]); % Set x-axis limits
    ylim([0 maxRow_standard]); % Set y-axis limits
    axis off; % Hide axes
    box on; % Enable box outline
    hold off; % Release hold
end         









function [write_matrix,logic_matrix,calculate_matrix,read_matrix] = circuit2matrices(stack_input_standard,stack_operator_standard,stack_shift_left_standard,stack_shift_right_standard)

% Convert circuit diagram into matrices: write matrix, logic matrix, calculate matrix, and read matrix

l = stack_input_standard{end}.Position(2);              % Length l
t = stack_operator_standard{end}.OutputPoint(1)-1;      % Layer count t
O = stack_operator_standard{end}.OutputPoint(2);        % Output position

write_matrix = zeros(3,l,t);       % Write matrix
logic_matrix = zeros(3,l,t);       % Logic matrix
calculate_matrix = zeros(3,l,t);   % Calculate matrix
read_matrix = zeros(3,l);          % Read matrix


Gatename = {'AND','OR','XOR','NAND','NOR'};
Gatematrix(:,:,1) = [0 1 0; 0 0 0; 0 0 0];   % AND
Gatematrix(:,:,2) = [0 1 0; 0 1 0; 0 0 0];   % OR
Gatematrix(:,:,3) = [0 1 0; 0 0 0; 0 1 0];   % XOR
Gatematrix(:,:,4) = [0 1 0; 0 0 0; 0 1 1];   % NAND
Gatematrix(:,:,5) = [0 1 0; 0 1 0; 0 1 0];   % NOR
WriteGate = [1 1 1; 0 1 0; 1 1 1];

Leftmatrix = [0 1 0;0 0 0;0 1 0];
Rightmatrix = [0 1 0;0 0 0;0 1 0];
WriteLeft = [1 1 1;1 1 0;1 1 1];
WriteRight = [1 1 1;0 1 1;1 1 1]; % Right-shift write unit matrix

Calcul = [0 0 0; 0 1 0; 0 0 0];  % Calculate unit matrix


% for i = 1 : size(Gatematrix,3)
%      disp(Gatematrix(:,:,i));
% end

for i = 1 : length(stack_operator_standard)
    targetStr = stack_operator_standard{i}.Name;
    [~, matchIndex] = ismember(targetStr, Gatename);
    write_matrix(1:3 , stack_operator_standard{i}.InputLeft(2):stack_operator_standard{i}.InputLeft(2)+2 , stack_operator_standard{i}.InputLeft(1)) = WriteGate;
    logic_matrix(1:3 , stack_operator_standard{i}.InputLeft(2):stack_operator_standard{i}.InputLeft(2)+2 , stack_operator_standard{i}.InputLeft(1)) = Gatematrix(:,:,matchIndex);
    calculate_matrix(1:3 , stack_operator_standard{i}.InputLeft(2):stack_operator_standard{i}.InputLeft(2)+2 , stack_operator_standard{i}.InputLeft(1)) = Calcul;
end

for i = 1 : length(stack_shift_left_standard)
    write_matrix(1:3 , stack_shift_left_standard{i}.Input(2)-2:stack_shift_left_standard{i}.Input(2) , stack_shift_left_standard{i}.Input(1)) = WriteLeft;
    logic_matrix(1:3 , stack_shift_left_standard{i}.Input(2)-2:stack_shift_left_standard{i}.Input(2) , stack_shift_left_standard{i}.Input(1)) = Leftmatrix;
    calculate_matrix(1:3 , stack_shift_left_standard{i}.Input(2)-2:stack_shift_left_standard{i}.Input(2) , stack_shift_left_standard{i}.Input(1)) = Calcul;
end

for i = 1 : length(stack_shift_right_standard)
    write_matrix(1:3 , stack_shift_right_standard{i}.Input(2):stack_shift_right_standard{i}.Input(2)+2 , stack_shift_right_standard{i}.Input(1)) = WriteRight;
    logic_matrix(1:3 , stack_shift_right_standard{i}.Input(2):stack_shift_right_standard{i}.Input(2)+2 , stack_shift_right_standard{i}.Input(1)) = Rightmatrix;
    calculate_matrix(1:3 , stack_shift_right_standard{i}.Input(2):stack_shift_right_standard{i}.Input(2)+2 , stack_shift_right_standard{i}.Input(1)) = Calcul;
end

read_matrix(2,O) = 1;
end




function showBinaryPattern(binaryMatrix)
% Plot binary matrix

    % Check if input is a 2D matrix
    if ndims(binaryMatrix) ~= 2
        error('Input must be a 2D matrix.');
    end
    
    % Get dimensions of original matrix
    [rows, cols] = size(binaryMatrix);
    
    % Define scaling factor (size of each unit block)
    scaleFactor = 10;
    
    % Create enlarged matrix where each element expands to scaleFactor x scaleFactor
    enlargedMatrix = zeros(scaleFactor*rows, scaleFactor*cols);
    
    % Expand each 1 into a scaleFactor x scaleFactor block
    for r = 1:rows
        for c = 1:cols
            if binaryMatrix(r, c) == 1
                startRow = (r-1)*scaleFactor + 1;
                startCol = (c-1)*scaleFactor + 1;
                enlargedMatrix(startRow:(startRow+scaleFactor-1), startCol:(startCol+scaleFactor-1)) = 1;
            end
        end
    end
    
    % Create figure window
    % figure;
    
    % Display image
    imshow(enlargedMatrix, 'InitialMagnification', 'fit');  % Use 'fit' initial magnification to fit window size
    
    % Set colormap to black and white
    colormap([1 1 1; 0 0 0]);  % White [1 1 1], Black [0 0 0]
    
    % Draw black grid lines
    hold on;
    for r = 0:scaleFactor:(rows*scaleFactor)
        plot([0.5, cols*scaleFactor + 0.5], [r + 0.5, r + 0.5], 'k');
    end
    for c = 0:scaleFactor:(cols*scaleFactor)
        plot([c + 0.5, c + 0.5], [0.5, rows*scaleFactor + 0.5], 'k');
    end
    hold off;
end