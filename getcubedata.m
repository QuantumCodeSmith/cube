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


getdata();
raw_output = ans.data{1,1};
% Compute the mean along the third dimension (128 bands)
averageImage = mean(raw_output, 2);
% Reshape the result to be a 520x696 greyscale image
averageImage = squeeze(averageImage);  % Removes the length 1 dimension
imshow(averageImage, []);


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

