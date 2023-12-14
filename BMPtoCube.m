% Specify the path to the folder containing BMP images
% https://data.mendeley.com/datasets/fvgswvt5ws/3

wavelengths = linspace(420, 1000, 145);
wavelengths = wavelengths';

% Specify the path to the main folder containing subfolders
mainFolderPath = '/Users/kasik2/Downloads/Images M101_M110';

% Get a list of all subfolders in the main folder
subfolders = dir(fullfile(mainFolderPath, '*'));

% Remove entries for '.' and '..' (current and parent directory)
subfolders = subfolders([subfolders.isdir] & ~ismember({subfolders.name}, {'.', '..'}));

% Initialize a cell array to store subfolder paths
subfolderPaths = cell(numel(subfolders), 1);

% Loop through each subfolder and save its path
for i = 1:numel(subfolders)
    subfolderPaths{i} = fullfile(mainFolderPath, subfolders(i).name);
end

for j = 1:numel(subfolderPaths)
    folderPath = subfolderPaths{j};
    
    % Get a list of all BMP files in the folder
    bmpFiles = dir(fullfile(folderPath, '*.bmp'));
    
    % Initialize an empty 3D matrix to store image data
    allImageData = [];
    
    % Loop through all BMP files in the folder
    for i = 1:numel(bmpFiles)
        % Construct the full path to the current BMP file
        currentFilePath = fullfile(folderPath, bmpFiles(i).name);
        
        % Read the grayscale BMP image
        img = imread(currentFilePath);
        
        % Save the image data to a matrix
        imageMatrix = double(img); % Convert to double for precision if needed
        
        % Append the image data to the 3D matrix
        allImageData(:, :, i) = imageMatrix;
    end
    
    % Check the size of the 3D matrix
    [rows, cols, numImages] = size(allImageData);
    fprintf('3D Matrix size: %d rows x %d columns x %d images\n', rows, cols, numImages);


% Save the first image in allImageData as a new BMP file
% Sanity check to make sure images were imported okay
%outputFilePath = 'first_image.bmp';
%firstImage = uint8(allImageData(:, :, 1)); % Convert back to uint8 before saving
%imwrite(firstImage, outputFilePath);

%fprintf('First image saved as: %s\n', outputFilePath);



    hcube = hypercube(allImageData, wavelengths);
    path = "/Users/kasik2/Documents/Hcube Soil/" + string(subfolderPaths{j}(end-3:end)) + ".mat";
    save(path, 'hcube')
end


% Now 'allImageData' contains the data of all BMP images in the folder
% You can access individual images using allImageData(:, :, index)
% For example, allImageData(:, :, 2) will give you the data of the second image