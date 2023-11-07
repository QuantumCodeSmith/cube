% Define the file path to your .cube file
cubeFilePath = '/Users/maycaj/Documents/Cube/read-cube-matlab/Test_5.cube';

% Use importdata to read the data from the .cube file
cubeData = importdata(cubeFilePath);

%cubedata is 26000000x1 array. Why isn't it 3D?
