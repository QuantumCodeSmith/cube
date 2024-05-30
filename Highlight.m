addpath("/Users/kasik2/Downloads/npy-matlab-master/npy-matlab");
savepath

for c = 1:15
    filename = '/Users/kasik2/Documents/Lipstick_Sunscreen Images/Lipstick 1/Lipstick type 1 image ' + string(c) + '.hdr';
    npy = readNPY('/Users/kasik2/Documents/Lipstick_Sunscreen Images/Lipstick 1/Lipstick type 1 image ' + string(c) + '.npy');
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
    npy = cast(npy, 'double');
    hcube = hypercube(npy, wavelengths);
    save('/Users/kasik2/Documents/Lipstick_Sunscreen Images/Lipstick 1/Lipstick type 1 image ' + string(c) + '.mat',"hcube")
end

