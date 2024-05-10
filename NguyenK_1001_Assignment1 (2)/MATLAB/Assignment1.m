% Question 1
% Define the input image and filter
image_a = [0 1 4 1 5 9 0;
           3 2 4 1 1 9 2;
           3 3 2 1 3 0 2;
           0 1 0 3 5 9 2;
           3 1 1 1 0 0 2;
           3 2 2 1 5 1 2;
           7 1 4 1 5 9 1];

filter_b = [3 1 1 4 5;
            1 2 0 3 0;
            0 1 3 0 3;
            1 0 1 1 0;
            2 3 0 3 1];

% Pad the input image with zeros
pad_size = (size(filter_b, 1) - 1) / 2;
padded_image_a = padarray(image_a, [pad_size, pad_size]);

% Perform convolution
conv_result = conv2(padded_image_a, filter_b, 'valid');

% Perform correlation
correlation_result = conv2(padded_image_a(end:-1:1, end:-1:1), filter_b, 'valid');

% Display results
disp("Convolution result:");
disp(conv_result);

disp("Correlation result:");
disp(correlation_result);

% Question 2
% Step 1: Read the image into MATLAB
image = imread('NuclearMedicine.tif');

% Step 2: Apply noise reduction (Gaussian blur)
image_blurred = imgaussfilt(image, 2);

% Step 3: Equalize the histogram of the left half of the image
left_half = image(:, 1:end/2); % Assuming the left half is the first half of the image
left_half_equalized = histeq(left_half);

% Combine the equalized left half with the unchanged right half
image_equalized = [left_half_equalized, image(:, end/2+1:end)];

% Step 4: Sharpen the image using unsharp masking with K=3
image_sharpened = imsharpen(image_equalized, 'Amount', 3);

% Step 5: Further sharpen the image with the Laplacian technique
laplacian_filter = fspecial('laplacian', 0.5);
image_laplacian_sharpened = imfilter(image_sharpened, laplacian_filter);

% Step 6: Smooth the image with a Gaussian filter
image_smoothed = imgaussfilt(image_laplacian_sharpened, 1);

% Save each processed image
imwrite(image_blurred, '2_Step1.jpg');
imwrite(image_equalized, '2_Step2.jpg');
imwrite(image_sharpened, '2_Step3.jpg');
imwrite(image_laplacian_sharpened, '2_Step4.jpg');
imwrite(image_smoothed, '2_Step5.jpg');

% Question 3-A
% Step 1: Extract and save all 8 bit planes individually
galaxy_image = imread('Galaxy.png');

for i = 1:8
    bit_plane = bitget(galaxy_image, i) * 255; % Scale to full range
    imwrite(uint8(bit_plane), ['3AStep1_', num2str(i), '.jpg']);
end


% Step 2: Reconstruct the image using the three most significant bit planes
reconstructed_image = zeros(size(galaxy_image));
for i = 5:7
    bit_plane = double(bitget(galaxy_image, i)); 
    reconstructed_image = reconstructed_image + bit_plane * 2^(i-1);
end

% Convert back to uint8
reconstructed_image = uint8(reconstructed_image); 
imwrite(reconstructed_image, '3AStep2.jpg');

% Step 3: Enhance edges with the Sobel operator
edge_image = edge(rgb2gray(galaxy_image), 'Sobel');
imwrite(edge_image, '3AStep3.jpg');

% Step 4: Reduce noise with a median filter
grayscale_galaxy_image = rgb2gray(galaxy_image);
median_filtered_image = medfilt2(grayscale_galaxy_image);
imwrite(median_filtered_image, '3AStep4.jpg');

% Step 5: Apply gamma correction using the best gamma parameter
gamma_corrected_image = imadjust(median_filtered_image, [], [], 0.7);
imwrite(gamma_corrected_image, '3AStep5.jpg');

% Question 3-B
image_4x4 = [4 12 15 1;
             14 0 9 2;
             3 7 8 13;
             1 0 10 11];

% Step 1: Extract and save all 4 bit planes individually
for i = 1:4
    bit_plane = bitget(image_4x4, i);
    imwrite(bit_plane, ['3BStep1_', num2str(i), '.jpg']);
end