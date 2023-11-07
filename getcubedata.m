clear; 
% Get hyperspectral data from cube file(s)
% created by Chet Szwejkowski, Application Scientist, Surface Optics Corp.
% on September 28, 2018
%
% Use:
%   Change directory to location where this file is saved
%   Type '[cube] = getdata();' in MATLAB Command window
%   Follow prompts
%   File names and data are saved in structure called 'cube'

%% Run function for output
getdata();
raw_output = ans.data{1,1};

%% Find Greyscale Image
% Compute the mean along the 2nd dimension (128 bands)
averageImage = mean(raw_output, 2);
% Reshape the result to be a 520x696 greyscale image
averageImage = squeeze(averageImage);  % Removes the length 1 dimension
figure(1)
imshow(averageImage, []); %Greyscale image from averaging each band's activation

%% Find Color Image
% assume that bands 1-42 are red, 43-84 are green, 86-128 are blue
red_bands = raw_output(:, 1:22, :);
green_bands = raw_output(:, 23:43, :);
blue_bands = raw_output(:, 44:60, :);
%compute the average along the 2nd dimension of each band
red_bands = mean(red_bands, 2);
green_bands = mean(green_bands, 2);
blue_bands = mean(blue_bands, 2);
% reshape the result to be a 520x696 image for each
red_bands = squeeze(red_bands);
green_bands = squeeze(green_bands);
blue_bands = squeeze(blue_bands);

% Normalize the bands to [0, 1] for each channel
red_bands = (red_bands - min(red_bands(:))) / (max(red_bands(:)) - min(red_bands(:)));
green_bands = (green_bands - min(green_bands(:))) / (max(green_bands(:)) - min(green_bands(:)));
blue_bands = (blue_bands - min(blue_bands(:))) / (max(blue_bands(:)) - min(blue_bands(:)));

% Combine the three channels into a color image
colorImage = cat(3, blue_bands, green_bands, red_bands);

% Display the color image
figure(2)
imshow(colorImage);

hold on
plot(490, 245, 'r*', 'MarkerSize', 10); % Adds marker for our target


% If you want to save the color image to a file
imwrite(colorImage, 'color_image.png');

%% Get photo Data to a matrix
function [cube] = getdata()
  % settings
  header = 32768/2;
  samples = 520; %height
  lines = 696; %width
  bands = 128; %number of bands
  datalength = samples*lines*bands;
  
  % user selects data file(s)
  homepath = cd();
  [fname,fpath] = uigetfile('*.cube','Choose data file(s)','MultiSelect','on');
  if iscell(fname)
    fname = fname;
  else
    fname = {fname};
  end
  num_files = size(fname,2);
  cd(fpath)
    
  % loop through files to extract data
  cube.files = fname;
  for ii = 1:num_files
    fid = fopen(fname{ii});
    dummy = fread(fid,inf,'uint16');
    dummy = dummy(header+1:header+datalength);
    cube.data{ii,1} = reshape(dummy,[samples,bands,lines]);
  end
  
  cd(homepath)
  
end

