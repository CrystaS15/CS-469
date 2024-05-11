% Load high-resolution satellite image of Earth
earth_image = imread('high-res_Earth.jpg');

% Load original Pale Blue Dot image
pale_blue_dot_image = imread('pale-blue-dot.jpg');

% Define parameters
num_frames = 6000; % Number of frames for the 3:20 minute animation
earth_distance = 1609344; % Distance of Earth image in kilometers
pale_blue_dot_distance = 5954573000; % Distance of Pale Blue Dot image in kilometers
distance_step = 992491.44; % Distance step in kilometers
blend_start_frame = 5820; % Frame number to start blending

% Get the initial size of the Earth image
[height, width, ~] = size(earth_image);

% Initialize arrays to store intermediate images and distances
intermediate_images = cell(1, num_frames);
distances = zeros(1, num_frames);

% Create a VideoWriter object
writerObj = VideoWriter('pale_blue_dot_animation.avi');
writerObj.FrameRate = 30; % Set the frame rate to 30 fps
open(writerObj);

% Create a figure with the expected frame size
fig = figure('Position', [100, 100, width, height]);

% Output the position (found using image tool & manually getting coords)
% Adjusting and fine tuned after several trials :-P
target_position = [622, 311];

% Perform resizing, sharpening, and blending to create intermediate images
for i = 1:num_frames
    % Calculate the current distance
    distance = earth_distance + (i - 1) * distance_step;
    
    % Calculate the scaling factor based on distance
    scaling_factor = 1 - (distance - earth_distance) / (pale_blue_dot_distance - earth_distance);
    
    % Resize the Earth image using the scaling factor
    resized_image = imresize(earth_image, scaling_factor);
    
    % Apply unsharp masking to sharpen the image
    blurred_image = imgaussfilt(resized_image, 2); % Adjust the sigma value for blurring
    sharpened_image = imsharpen(resized_image, 'Amount', 1.5); % Adjust the sharpening amount

    % Calculate the target position for the Earth image
    current_position = [width/2, height/2]; % Center of the frame
    target_factor = (i - 1) / (num_frames - 1);
    pos_x = current_position(1) + (target_position(1) - current_position(1)) * target_factor;
    pos_y = current_position(2) + (target_position(2) - current_position(2)) * target_factor;
    
    % Create a new blank frame
    blank_frame = uint8(zeros(height, width, 3));
    
    % Paste the resized and sharpened Earth image onto the blank frame at the calculated position
    earth_size = size(sharpened_image);
    earth_x = max(1, min(round(pos_x - earth_size(2)/2), width - earth_size(2) + 1));
    earth_y = max(1, min(round(pos_y - earth_size(1)/2), height - earth_size(1) + 1));
    blank_frame(earth_y:(earth_y+earth_size(1)-1), earth_x:(earth_x+earth_size(2)-1), :) = sharpened_image;

    % Check if blending should be applied
    if i >= blend_start_frame
        % Resize the Pale Blue Dot image to match the size of the blank frame
        resized_pale_blue_dot_image = imresize(pale_blue_dot_image, [height, width]);
        
        % Blend the repositioned Earth image with the resized Pale Blue Dot image using alpha blending
        blend_factor = (i - blend_start_frame + 1) / (num_frames - blend_start_frame + 1);
        blended_image = blend_images(blank_frame, resized_pale_blue_dot_image, blend_factor);
    else
        blended_image = blank_frame;
    end
    
    % Resize the blended image to the original size of the Earth image
    final_image = imresize(blended_image, [height, width]);
    
    % Store the intermediate image
    intermediate_images{i} = final_image;
    
    % Store the current distance
    distances(i) = distance;
    
    % Display the current frame along with the distance from Earth
    imshow(final_image);
    title(sprintf('Distance from Earth: %d kilometers', round(distances(i))));
    drawnow; % Refresh the figure window
    
    % Write the frame to the video
    writeVideo(writerObj, getframe(fig));
end

% Close the VideoWriter object
close(writerObj);

% Create a new VideoWriter object for the reversed video
reversedWriterObj = VideoWriter('pale_blue_dot_animation_reversed.avi');
reversedWriterObj.FrameRate = 30; % Set the frame rate to 30 fps
open(reversedWriterObj);

% Create a new figure for the reversed video
reversed_fig = figure('Position', [100, 100, width, height], 'Visible', 'off');
reversed_ax = axes(reversed_fig);

% Iterate through the intermediate images in reverse order
for i = num_frames:-1:1
    % Display the intermediate image
    imshow(intermediate_images{i}, 'Parent', reversed_ax);
    
    % Display the distance text on the reversed frame
    title(reversed_ax, sprintf('Distance from Earth: %d kilometers', round(distances(i))));
    
    % Write the reversed frame with distance text to the new video
    writeVideo(reversedWriterObj, getframe(reversed_fig));
end

% Close the reversed figure
close(reversed_fig);

% Close the reversed VideoWriter object
close(reversedWriterObj);

% Function to blend two images using alpha blending
function blended_image = blend_images(image1, image2, erode_factor)
    alpha = erode_factor;
    blended_image = uint8(alpha * double(image2) + (1 - alpha) * double(image1));
end