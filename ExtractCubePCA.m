function ExtractCubePCA = ExtractCubePCA(x)
    ExtractCube = load(x);
    ExtractCube = ExtractCube.hcube;
    ExtractCubePCA = hyperpca(ExtractCube, 3);
    disp("done");
end