% Read the image
image = imread('Huffman.png');

% Get the size of the image
[rows, cols] = size(image);

% Flatten the image into a 1D array
image_data = image(:);

% Part 1: Identify and count unique pixel values
[unique_values, ~, idx] = unique(image_data);
counts = accumarray(idx, 1);

% Display unique values and their counts
disp('Unique Pixel Values and Counts:')
for i = 1:length(unique_values)
    fprintf('%d: %d\n', unique_values(i), counts(i));
end

% Part 2: Calculate probability of each pixel value
total_pixels = rows * cols;
probabilities = counts / total_pixels;

% Display probabilities
disp('Probabilities of each pixel value:')
for i = 1:length(unique_values)
    fprintf('%d: %.4f\n', unique_values(i), probabilities(i));
end

% Build the Huffman tree
% Create a priority queue
queue = cell(1, length(unique_values));
for i = 1:length(unique_values)
    queue{i} = struct('symbol', unique_values(i), 'prob', probabilities(i), 'left', [], 'right', []);
end

% Build the Huffman tree using a priority queue
while length(queue) > 1
    % Sort the queue based on probabilities
    [~, sort_idx] = sort(cellfun(@(x) x.prob, queue));
    queue = queue(sort_idx);

    % Extract nodes with minimum probabilities
    node1 = queue{1};
    queue(1) = [];
    node2 = queue{1};
    queue(1) = [];

    % Create a parent node with combined probability
    parent.symbol = [];
    parent.prob = node1.prob + node2.prob;
    parent.left = node1;
    parent.right = node2;

    % Add parent node back to the queue
    queue{end + 1} = parent;
end

% The remaining node is the root of the Huffman tree
huffman_tree = queue{1};

% Assign Huffman codes
codes = cell(1, length(unique_values));
for i = 1:length(unique_values)
    symbol = unique_values(i);
    code = '';
    currentNode = huffman_tree;
    while true
        if isempty(currentNode.left) && isempty(currentNode.right)
            if currentNode.symbol == symbol
                codes{i} = code;
            end
            break;
        else
            if symbol <= currentNode.left.symbol
                code = [code, '0'];
                currentNode = currentNode.left;
            else
                code = [code, '1'];
                currentNode = currentNode.right;
            end
        end
    end
end

% Encode image data with Huffman codes
encoded_data = '';
for i = 1:length(image_data)
    symbol = find(unique_values == image_data(i), 1);  % Find the index of the symbol in unique_values
    encoded_data = [encoded_data, codes{symbol}];
end

% Calculate average bits per symbol
total_bits = length(encoded_data);
average_bits_per_symbol = total_bits / total_pixels;

% Calculate storage size (in KB) after encoding
encoded_bits_size = total_bits;
storage_size_kb = encoded_bits_size / 8000;

% Compression Rate (C)
original_size_bytes = rows * cols;
compressed_size_bytes = encoded_bits_size / 8;
compression_rate = original_size_bytes / compressed_size_bytes;

% Percentage decrease (R)
percentage_decrease = (1 - compressed_size_bytes / original_size_bytes) * 100;

% Display results
disp('Encoded data:')
disp(encoded_data(1:100)); % Display only the first 100 characters for brevity
fprintf('Average bits per symbol: %.2f\n', average_bits_per_symbol);
fprintf('Storage size after encoding: %.2f KB\n', storage_size_kb);
fprintf('Compression Rate: %.4f\n', compression_rate);
fprintf('Percentage decrease: %.2f%%\n', percentage_decrease);
