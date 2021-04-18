classdef FEM < Plots & handle
    %FEM Summary of this class goes here
    %   Detailed explanation goes here
    
    %% Properties
    properties
        
        % Immersed? 
        isImmersed (1,1) logical
        
        % Time series readed from file
        time (:,1) double
        
        % Results
        U  cell   % displacement
        dU (:,3) double % TODO - mudar para 'cell' e colocar input do Giraffe
        
         % Spectrum
        Freq  cell    % frequency
        Ampl  cell    % amplitude
        Fd    (1,3) double  % dominant frequency
        Ad    (1,3) double  % dominant amplitude
        
        % Permanent regime
        %permaTime = []
        
        % Struct with output booleans 
        out_bools 
        
        % Frequency of the prescribed displacement
        f (1,1) double;
    end
    
    
    properties (Constant)
        titles = ["u(L/4)" "u(L/2)" "u(3L/4)"]
        labels = struct('u',["u(L/4,\tau)/D" "u(L/2,\tau)/D" "u(3L/4,\tau)/D"],...
            'du',["u'(L/4,\tau)/D" "u'(L/2,\tau)/D" "u'(3L/4,\tau)/D"])
        
        % Directory of the Giraffe monitors
        data_dir = "..\GiraffeData\"
        
        % Giraffe monitor numbers => [L/4  L/2  3L/4 L]
        monitors = [11 21 31 41]
    end
    
    
    %% Methods
    methods
        
        %% Constructor
        function this = FEM(bool_immersed,data_file, f)
            %FEM Construct an instance of this class
            
            global beamData
            this.isImmersed = bool_immersed;
            this.f = f;
            
            % Read data
            for cont = 1:3
                inpt = readtable(strcat(data_file,'monitor_node_',num2str(this.monitors(cont))),'HeaderLines',1);
                
                % Creates arrays with data from the table
                this.time = table2array(inpt(:,1))*2*pi*this.f+5402;
                this.U{cont} = table2array(inpt(:,2)) / beamData.d; % match ROM nondimensional
            end
        end
        
        
        %% Functions
        
        % Setting plot/save options
        function this = SetOutputOptions(this, save_fig, ~)
            % Saving options
            this.out_bools.save_fig = save_fig;
            %             this.out_bools.save_scalogram = save_scalogram;
            
            % Plot options
            this.out_bools.phaseSpace = false;
%             this.out_bools.scalogram = show_scalogram;
        end
        
        
        % Calculate frequency spectrum
        function this = CalculateSpectrum(this,k)
            [this.Freq{k}, this.Ampl{k}, this.Fd(k), this.Ad(k)] = Spectrum(this.time, this.U{k});
        end
        
        
        % Plot in multiple tabs
        function this = MultiTabPlot(this, k, bool_open_tab, nPlots)
            % Open new tab
            if bool_open_tab == true
                thistab = uitab('Title',this.titles(k),'BackgroundColor', 'w'); % build iith tab
                axes('Parent',thistab); % somewhere to plot
            end
            
            % Displacement time series
            if nPlots == 3
                subplot(2,2,2)
            else
                subplot(2,1,1)
            end
            hold on; box on;
            xlabel('\tau = t\omega_1','FontName',this.FontName,'FontSize',this.FontSize)
            ylabel(this.labels.u(k),'FontName',this.FontName,'FontSize',this.FontSize)
            set(gca, 'fontsize', this.FontSize, 'xlim', GeneralOptions.SolOpt.permaTime)
            
            plot(this.time, this.U{k}, this.dots(2))
            
            % Frequency spectrum
            if nPlots == 3
                subplot(2,2,4)
            else
                subplot(2,1,2)
            end
            hold on; box on;
            xlabel('f/f_1', 'FontName', this.FontName, 'fontsize', this.FontSize)
            ylabel("Amplitude", 'FontName', this.FontName, 'fontsize', this.FontSize)
            set(gca, 'FontName', this.FontName, 'fontsize', this.FontSize, 'xlim', this.lim_plot_freq)
            
            plot(this.Freq{k}, this.Ampl{k}, this.lines(1,2))
            
        end
        
        
        
        %%% TODO
        function this = SinglePlot(this, data, ~)
            if isempty(data)
                error('FEM object is supposed to use MultiTabPlot with contains no data to plot');
            end
        end
        
    end
end

