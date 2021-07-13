%% Main file
clc; close all;

tic

%% Set general options
% Parameters = booleans to indicate which models to analyze/plot  
genOpt = GeneralOptions(...
    1,... analyse FEM model in water
    1,... analyse FEM model in air
    1,... analyse ROM model in water
    1,... analyse ROM model in air
    1,... plot tensions (bottom and top)
    1,... plot results in multiple tabs
    0,... save ALL figures
    0,... export .mat
    0 ... load .mat
);
genOpt.SolOpt.n_plot = [2 4];

%% Increment 'n' and show demanded data
for cur_n = genOpt.SolOpt.n0 : genOpt.SolOpt.dn : genOpt.SolOpt.nf

    %% Initialize data
    db = strcat('..\Data\Database-n',num2str(cur_n),'.mat');
    
    % Read data
    if genOpt.load_data == true
        load(db);
    else
        [shpFun, rom, fem] = SetModel(genOpt, cur_n);
    end
    
    
    %% Solve EDOs, evaluate displacements and modal response, and plot results
    if ~isempty(rom)
        rom = Analysis.ROMs(rom, shpFun, cur_n);
    end
    
    
    %% Finite Element Model (Giraffe) data -> evaluate espectrum
    if sum(~cellfun(@isempty,fem)) && ismember(cur_n, genOpt.SolOpt.n_plot)
        fem = Analysis.FEMs(fem);
    end
    
    
    %% Show results
    if ismember(cur_n, genOpt.SolOpt.n_plot)
        PostProcessing.PlotResults(rom, fem, shpFun, cur_n, genOpt);
    end
    
    
    %% Export data
    if genOpt.export_data == true
        save(db,'rom','fem','shpFun');
    end
	
end

toc
