% Load high-resolution satellite image of Earth
earth_image = imread('high-res_Earth.jpg');

% Load original Pale Blue Dot image
pale_blue_dot_image = imread('pale-blue-dot.jpg');

% Define parameters
num_frames = 100; % Number of frames for the animation
distance_step = 1000000; % Distance step in kilometers

% Get the initial size of the Earth image
[height, width, ~] = size(earth_image);

% Initialize arrays to store intermediate images and distances
intermediate_images = cell(1, num_frames);
distances = zeros(1, num_frames);

% Create a VideoWriter object
writerObj = VideoWriter('pale_blue_dot_animation.avi');
open(writerObj);

% Create a figure with the expected frame size
fig = figure('Position', [100, 100, width, height]);

% Perform erosion to create intermediate images
for i = 1:num_frames
    % Calculate the erosion factor for this frame
    erode_factor = i / num_frames;
    
    % Apply erosion to the Earth image
    shrunk_image = imerode(earth_image, strel('disk', round(erode_factor * 350))); % Adjust the disk size for erosion
    
    % Resize the Pale Blue Dot image to match the size of the eroded Earth image
    resized_pale_blue_dot_image = imresize(pale_blue_dot_image, [size(shrunk_image, 1), size(shrunk_image, 2)]);
    
    % Blend the eroded Earth image with the resized Pale Blue Dot image
    blended_image = blend_images(shrunk_image, resized_pale_blue_dot_image, erode_factor);
    
    % Store the intermediate image
    intermediate_images{i} = blended_image;
    
    % Calculate distance from Earth for this frame
    distance = i * distance_step;
    distances(i) = distance;
    
    % Display the current frame along with the distance from Earth
    imshow(intermediate_images{i});
    title(sprintf('Distance from Earth: %d kilometers', distance));
    drawnow; % Refresh the figure window
    
    % Write the frame to the video
    writeVideo(writerObj, getframe(fig));
end

% Close the VideoWriter object
close(writerObj);

% Function to blend two images based on an erosion factor
function blended_image = blend_images(image1, image2, erode_factor)
    blended_image = uint8((1 - erode_factor) * double(image1) + erode_factor * double(image2));
end