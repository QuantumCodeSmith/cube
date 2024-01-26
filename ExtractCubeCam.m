function ExtractCubeCam = ExtractCubeCam(x)
    ExtractCubeCam = load(x);
    ExtractCubeCam = ExtractCubeCam.hyperspectral_image;

    % Add in PCA compression
    ExtractCubeCam = hyperpca(ExtractCubeCam, 30);

    % Resize cube size
    % imresize3 performs interpolation during the resizing process to estimate pixel values at non-integer coordinates. The default interpolation method is trilinear interpolation, but you can specify other methods using additional parameters (e.g., 'nearest', 'linear', 'cubic').
    ExtractCubeCam = imresize3(ExtractCubeCam, [64,64,30]);
end