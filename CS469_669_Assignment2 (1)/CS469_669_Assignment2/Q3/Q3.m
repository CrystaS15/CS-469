% Read input image
input_image = imread('Input.jpg');

% Preprocessing: Apply Gaussian filter to remove noise
filtered_image = imgaussfilt(input_image, 2);

% Calculate histogram
num_bins = 256;
histogram = zeros(num_bins, 1);
for i = 1:num_bins
    histogram(i) = sum(filtered_image(:) == (i-1));
end
% Normalize histogram
histogram = histogram / sum(histogram);

% Calculate cumulative sum of histogram
cumulative_sum = cumsum(histogram);
% Calculate cumulative mean
cumulative_mean = cumsum(histogram .* (1:num_bins)');

% Global mean
global_mean = cumulative_mean(end);

% Initialize variables
maximum_variance = 0;
threshold = 0;

% Calculate between-class variance for all possible thresholds
for t = 1:num_bins
    % Background probability
    wb = cumulative_sum(t);
    % Foreground probability
    wf = 1 - wb;
    % Background mean
    mb = cumulative_mean(t) / wb;
    % Foreground mean
    mf = (global_mean - cumulative_mean(t)) / wf;
    % Between-class variance
    between_class_variance = wb * wf * (mb - mf)^2;
    % Check if maximum variance is achieved
    if between_class_variance > maximum_variance
        maximum_variance = between_class_variance;
        threshold = t - 1; % Adjust threshold index to match pixel intensity
    end
end

% Apply threshold
binary_image = filtered_image > threshold;

% Display binary image after thresholding
figure;
imshow(binary_image);
title('Output');