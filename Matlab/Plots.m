classdef Plots < handle
    %% Plots summary 
    
        
    %% Constants
    properties (Constant, GetAccess = public)
        % Formatting options
        FontSize = 18;
        FontSizeLegend = 15;
        LegLoc = 'NorthWest';
        FontName = "Cambria Math";
        default_pos = [500 80 1180 700];
        default_paperSize = [11 7]; 
        figFormat = '-dpdf'; % Format to save
        figRes = '-r600';	 % resolution
        interpreter = 'latex';
        
        % Default axis labels
        defAxis = containers.Map(...
            ["f" "Su" "tau" "z"],...
            ["$ f/f_1 $" "$ S_{\hat{u}}(f) $" "$ \tau = t\omega_1 $" "$ z/L $"]);
        
        lines = [...
            struct('LineStyle','-','Color','k','LineWidth',0.5) ...
            struct('LineStyle','-','Color','r','LineWidth',0.5) ...
            struct('LineStyle','-','Color',[0.8500 0.3250 0.0980],...
            'LineWidth',0.8) ...
            struct('LineStyle','-','Color','b','LineWidth',0.5) ; ...
            % 
            struct('LineStyle',':','Color','k','LineWidth',1.4) ...
            struct('LineStyle',':','Color','r','LineWidth',1.4) ...
            struct('LineStyle',':','Color',[0.8500 0.3250 0.0980],...
            'LineWidth',1.4) ...
            struct('LineStyle',':','Color',[0 0.4470 0.7410], ...
            'LineWidth',1.4) ; ...
            % 
            struct('LineStyle','-.','Color','k','LineWidth',0.5) ...
            struct('LineStyle','-.','Color','r','LineWidth',0.5) ...
            struct('LineStyle','-.','Color',[0.8500 0.3250 0.0980],...
            'LineWidth',0.5) ...
            struct('LineStyle','-.','Color','b','LineWidth',0.5) ...
            ];
        markers = [...
            % 
            struct('Marker','.','MarkerFaceColor','none',...
            'MarkerEdgeColor','k','MarkerSize',6,...
            'LineStyle','none')...
            %
            struct('Marker','.','MarkerFaceColor','none',...
            'MarkerEdgeColor','r','MarkerSize',6,...
            'LineStyle','none')...
            %
            struct('Marker','.','MarkerFaceColor','none',...
            'MarkerEdgeColor','g','MarkerSize',6,...
            'LineStyle','none') ...
            %
            struct('Marker','o','MarkerFaceColor','none',...
            'MarkerEdgeColor',[0 0.4470 0.7410],'MarkerSize',3.5,...
            'LineStyle','none')...
            ];
		
        % frequency range
		lim_plot_freq = [0 7];
    end
    

    %% Methods
    methods (Abstract)
        PlotResults(this, k, open_tab) 
    end
    
    
    methods 
        function fig = OpenSiglePlotFig(this,figTitle)
            fig = figure('Name',figTitle,'position', ...
                this.default_pos, 'color', 'w');
        end
    end
    
    methods (Static)
        
        
        
        %% Create window to include plots in different tabs
        function tab_group = OpenTabularPlot(tabGroupName)
            figure('Name',tabGroupName, ...
                'position', Plots.default_pos, 'color', 'w');
            tab_group = uitabgroup;
        end
        
        function AddLegend(leg)
            legend(leg,'FontName', Plots.FontName, ...
                'FontSize',Plots.FontSizeLegend, 'Location',Plots.LegLoc,...
                'Interpreter', Plots.interpreter);
        end
        
        function fig = OpenFig(figName, xlab, ylab, plot_lim)
            fig = figure('Name',figName, ...
                'position',Plots.default_pos, 'color','w');
            hold on; box on;
            set(gca, 'FontName',Plots.FontName, ...
                'FontSize', Plots.FontSize, 'xlim', plot_lim,...
                'TickLabelInterpreter',Plots.interpreter);
            xlabel(xlab,'FontName',Plots.FontName,...
                'FontSize',Plots.FontSize,'Interpreter',Plots.interpreter);
            ylabel(ylab,'FontName',Plots.FontName,...
                'FontSize',Plots.FontSize,'Interpreter',Plots.interpreter);
            
        end
        
    end
    
end

