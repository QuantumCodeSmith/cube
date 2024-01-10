% Specify the folder path
folderPath = '/Users/kasik2/Documents/Soil Playground/Hcube Soil Full';

% Get a list of all files in the folder
files = dir(fullfile(folderPath, '*.*'));

% Loop through each file in the folder
for i = 1:length(files)
    % Skip folders (directories)
    if files(i).isdir
        continue;
    end
    
    hcube = load(files(i));
    hcube = hcube.hcube;
    
end



[outputDataCube,coeff,var] = hyperpca(hcube,3,'Method','Eig');
figure
rescalePC = rescale(outputDataCube,0,1);
montage(rescalePC,'BorderSize',[10 10],'Size',[1 3]);
title('Principal Component Bands of Data Cube')
figure
plot(hcube.Wavelength,coeff);
legend(['PC1';'PC2';'PC3'],'Location','SouthEast')
text(430,0.19,'Retained variance');
text(430,0.17,['PC1: ' num2str(var(1))])
text(430,0.15,['PC2: ' num2str(var(2))])
text(430,0.13,['PC3: ' num2str(var(3))])
xlabel('Wavelength')
ylabel('PC Coefficients')