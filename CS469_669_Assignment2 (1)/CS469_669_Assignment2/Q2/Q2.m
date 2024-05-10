% Read noisy image
noisy_image = imread('noisy_image.jpeg');
% Convert to double for processing
noisy_image = im2double(noisy_image);
% Convert to frequency domain using FFT
freq_domain = fft2(noisy_image);

% Define image size
[m, n] = size(noisy_image);
% Generate frequency grid
[u, v] = meshgrid(1:n, 1:m);
% Center frequency grid
u = u - floor(n/2);
v = v - floor(m/2);

% Define cutoff frequency for the filters
cutoff = 90;

% Ideal low-pass filter
ideal = double(sqrt(u.^2 + v.^2) <= cutoff);
% Gaussian low-pass filter
gaussian = exp(-(u.^2 + v.^2) / (2 * (cutoff)^2));
% Butterworth low-pass filter
n_order = 9;
butterworth = 1 ./ (1 + (sqrt(u.^2 + v.^2) ./ cutoff) .^ 2 * n_order)

% Apply filters in frequency domain
filtered_ideal = real(ifft2(freq_domain .* fftshift(ideal)));
filtered_gaussian = real(ifft2(freq_domain .* fftshift(gaussian)));
filtered_butterworth = real(ifft2(freq_domain .* fftshift(butterworth)));

% Normalize filtered images to range [0, 1]
filtered_ideal = mat2gray(filtered_ideal);
filtered_gaussian = mat2gray(filtered_gaussian);
filtered_butterworth = mat2gray(filtered_butterworth);

% Display images
subplot(2, 2, 1), imshow(noisy_image), title('Noisy Image');
subplot(2, 2, 2), imshow(filtered_ideal), title('Ideal LPF');
subplot(2, 2, 3), imshow(filtered_gaussian), title('Gaussian LPF');
subplot(2, 2, 4), imshow(filtered_butterworth), title('Butterworth LPF');

% Save filtered images
imwrite(filtered_ideal, 'filtered_ideal.jpeg');
imwrite(filtered_gaussian, 'filtered_gaussian.jpeg');
imwrite(filtered_butterworth, 'filtered_butterworth.jpeg');