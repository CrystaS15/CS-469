% Image A
A = imread("A.png");
A = im2bw(A);

% Image B
B = imfill(A, 'holes'); % Fill holes on A
imwrite(B, "B.png");    % Save to B
SE = strel('disk', 5);  % Create Disk SE, Radius: 5

% Image C
C = imerode(B, SE);     % Erode B
imwrite(C, 'C.png');    % Save to C

% Image D
D = imopen(C, SE);      % Opening on C
imwrite(D, 'D.png');    % Save to D

% Image E
E = imdilate(D, SE);    % Dilation on D
imwrite(E, 'E.png');    % Save to E

% Image F
F = imclose(E, SE);     % Closing on E
imwrite(F, 'F.png');    % Save to F

% Image G
G = imdilate(F, SE);    % Dilation on F
imwrite(G, 'G.png');    % Save to G

% Image H
G_erosion = imerode(G, SE);     % Erode G
H = G - G_erosion;              % Subtract G and Eroded G
imwrite(H, 'H.png');            % Save to H