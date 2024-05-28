addpath("/Users/kasik2/Downloads/npy-matlab-master/npy-matlab");
savepath

filename = '/Users/kasik2/Documents/Lipstick_Sunscreen Images/Lipstick 1/Lipstick type 1 image 1.hdr';
fid = fopen(filename, 'r');
file_content = fscanf(fid, '%c');
lines = strsplit(file_content, '\n');
%remove content that doesn't have to do with wavelengths
lines(1:16) = [];
% Rejoin the lines into a single string
updated_content = strjoin(lines, '\n');
% Display the updated content (optional)
disp(updated_content);
cleaned_string = regexprep(updated_content, '[^0-9\s\.]', '');
% Split the string into an array of substrings
split_strings = strsplit(cleaned_string, ' ');
% Convert the substrings to numbers
numbers = str2double(split_strings);
% Remove NaN values (in case of non-numeric characters)
wavelengths = numbers(~isnan(numbers));
a = cast(a, 'int32');
hcube = hypercube(a, wavelengths);

