% Step 1: Convert images to binary using Otsu's method and perform global thresholding

% Load images
img1 = imread('Seattle 1.jpg');
img2 = imread('Seattle 2.jpg');

% Convert to grayscale if necessary
if size(img1, 3) == 3
    img1 = rgb2gray(img1);
end
if size(img2, 3) == 3
    img2 = rgb2gray(img2);
end

% Perform Otsu's thresholding
thresh1 = graythresh(img1);
bw1 = imbinarize(img1, thresh1);
hist1_orig = imhist(img1);
hist1_bin = imhist(bw1);

thresh2 = graythresh(img2);
bw2 = imbinarize(img2, thresh2);
hist2_orig = imhist(img2);
hist2_bin = imhist(bw2);

% Perform global thresholding
level = 0.6; % Adjust this threshold value as needed
bw1_global = imbinarize(img1, level);
bw2_global = imbinarize(img2, level);

% Display histograms and binary images
figure;
subplot(2,4,1), plot(hist1_orig), title('Histogram of Seattle 1 (Original)');
subplot(2,4,2), imshow(img1), title('Seattle 1 (Original)');
subplot(2,4,3), plot(hist1_bin), title('Histogram of Seattle 1 (Binary)');
subplot(2,4,4), imshow(bw1), title('Seattle 1 (Binary)');
subplot(2,4,5), plot(hist2_orig), title('Histogram of Seattle 2 (Original)');
subplot(2,4,6), imshow(img2), title('Seattle 2 (Original)');
subplot(2,4,7), plot(hist2_bin), title('Histogram of Seattle 2 (Binary)');
subplot(2,4,8), imshow(bw2), title('Seattle 2 (Binary)');

% Display global thresholding results
figure;
subplot(1,2,1), imshow(bw1_global), title('Seattle 1 (Global Thresholding)');
subplot(1,2,2), imshow(bw2_global), title('Seattle 2 (Global Thresholding)');

% Step 2: Implement local thresholding method

% Define parameters
thresholdFactor = 0.5; % Adjust this factor as needed
window_sizes = 15:5:45;

% Initialize figure for local thresholding results
figure;

num_plots = length(window_sizes);
rows = 2;
cols = ceil(num_plots / rows);

for i = 1:num_plots
    % Perform local thresholding
    window_size = window_sizes(i);
    
    % Compute local mean
    local_mean1 = conv2(double(img1), ones(window_size) / window_size^2, 'same');
    local_mean2 = conv2(double(img2), ones(window_size) / window_size^2, 'same');
    
    % Compute thresholds
    threshold1 = local_mean1 * thresholdFactor;
    threshold2 = local_mean2 * thresholdFactor;
    
    % Perform thresholding
    img1_local = img1 <= threshold1;
    img2_local = img2 <= threshold2;
    
    % Calculate subplot indices
    subplot_index_1 = i;
    subplot_index_2 = i + num_plots;
    
    % If the subplot index exceeds the total number of subplots, break the loop
    if subplot_index_1 <= rows * cols && subplot_index_2 <= rows * cols
        % Display local thresholding results
        subplot(rows, cols, subplot_index_1), imshow(img1_local), title(['Seattle 1 (Local Thresholding, Window Size: ' num2str(window_size) ')']);
        subplot(rows, cols, subplot_index_2), imshow(img2_local), title(['Seattle 2 (Local Thresholding, Window Size: ' num2str(window_size) ')']);
    else
        break; % Exit the loop if the subplot indices exceed the total number of subplots
    end
end

% Step 3: Apply morphological operations

% Define structuring element for morphological operations
se = strel('disk', 3);

% Initialize figure for morphological operation results
figure;

num_plots = length(window_sizes);
rows = 2;
cols = ceil(num_plots / rows);

for i = 1:num_plots
    % Perform local thresholding
    window_size = window_sizes(i);
    
    % Compute local mean
    local_mean1 = conv2(double(img1), ones(window_size) / window_size^2, 'same');
    local_mean2 = conv2(double(img2), ones(window_size) / window_size^2, 'same');
    
    % Compute thresholds
    threshold1 = local_mean1 * thresholdFactor;
    threshold2 = local_mean2 * thresholdFactor;
    
    % Perform thresholding
    bw1_local = img1 <= threshold1;
    bw2_local = img2 <= threshold2;
    
    % Apply morphological operations
    bw1_processed = imclose(bw1_local, se);
    bw2_processed = imclose(bw2_local, se);
    
    % Calculate subplot indices
    subplot_index_1 = i;
    subplot_index_2 = i + num_plots;
    
    % If the subplot indices exceed the total number of subplots, break the loop
    if subplot_index_1 <= rows * cols && subplot_index_2 <= rows * cols
        % Display morphological operation results
        subplot(rows, cols, subplot_index_1), imshow(bw1_processed), title(['Seattle 1 (Morphological Operations, Window Size: ' num2str(window_size) ')']);
        subplot(rows, cols, subplot_index_2), imshow(bw2_processed), title(['Seattle 2 (Morphological Operations, Window Size: ' num2str(window_size) ')']);
    else
        break; % Exit the loop if the subplot indices exceed the total number of subplots
    end
end