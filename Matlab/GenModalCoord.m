classdef GenModalCoord < Plots & handle
    %% Modal amplitude 
    %   Detailed explanation goes here
    
    properties
        % Modal amplitude
        max_Ampl double   % amplitude
        max_A_k double    % 
        
        % Spectrum
        freq_A_k cell    % frequency
        ampl_A_k cell    % amplitude
        Fd_A_k (1,3) double  % dominant frequency
        Ad_A_k (1,3) double  % dominant amplitude
        
        % Struct with output booleans 
        out_bools_A
        
    end
    
    properties (Constant)
        % Plot labels (not equals for all cases)
        labels = struct('A',["A_1(\tau)/D" "A_2(\tau)/D" "A_3(\tau)/D"],...
            'dA',["A_1'(\tau) / D" "A_2'(\tau) / D" "A_3'(\tau) / D"]);
       
        % Tab titles
        titles = ["A1" "A2" "A3"];
    end
    
    
    properties (GetAccess = public, SetAccess = private)
        save_A (1,1) logical = false;  % Resposta total
        save_Ak (1,1) logical = false; % Respostas modais
        phaseSpace 
    end
    
    
    
    %% Methods
    methods
        
        % 
        function this = GenModalCoord(bool_saveA, bool_saveAk)
            if nargin == 2
                % Initialize empty cells
                this.freq_A_k{3} = {};
                this.ampl_A_k{3} = {};
                
                
                this.save_A = bool_saveA;
                this.save_Ak = bool_saveAk;
            end
        end
        
        
        % 
        function this = SetOutputOptions(this, show_A, show_max_Ak, ...
                show_Ampl, save_A, save_Ak, save_Ampl, show_phSpace)
            
            % Plot options 
            this.out_bools_A = struct('show_A', show_A, ...
                'show_max_Ak', show_max_Ak, 'show_Ampl', show_Ampl, ...
                'save_A', save_A, 'save_Ak', save_Ak, ...
                'save_Ampl', save_Ampl, 'include_phaseSpace',show_phSpace);
        end
              
        
        %% Plot general results
        function this = PlotResults(this, k, open_tab, t_sol, x_sol)
            
            % Open new tab
            if open_tab == true
                thistab = uitab('Title',this.titles(k),'BackgroundColor', 'w'); % build iith tab
                axes('Parent',thistab); % somewhere to plot
            end
            
            if this.out_bools_A.include_phaseSpace == true
                % Displacement time series
                subplot(2,2,2)
                hold on; box on;
                xlabel('\tau = t\omega_1','FontName',this.FontName,'fontsize',this.FontSize)
                ylabel(this.labels.A(k),'FontName',this.FontName,'fontsize',this.FontSize)
                set(gca, 'fontsize', this.FontSize, 'xlim', GeneralOptions.SolOpt.permaPlot)
                
                plot(t_sol, x_sol(:,k), this.lines(1,1))
                
                
                % Frequency spectrum
                subplot(2,2,4)
                hold on; box on;
                xlabel('f/f_1', 'FontName', this.FontName, 'fontsize', this.FontSize)
                ylabel("Amplitude", 'FontName', this.FontName, 'fontsize', this.FontSize)
                set(gca, 'FontName', this.FontName, 'fontsize', this.FontSize, 'xlim', this.lim_plot_freq)
                
                plot(this.freq_A_k{k}, this.ampl_A_k{k}, this.lines(1,1))
                
                % Phase space
                subplot(2,2,[1 3])
                hold on; box on;
                xlabel(this.labels.A(k), 'FontName', this.FontName, 'fontsize', this.FontSize)
                ylabel(this.labels.dA(k), 'FontName', this.FontName, 'fontsize', this.FontSize)
                set(gca, 'FontName', this.FontName, 'fontsize', this.FontSize)
                
                plot(x_sol(:,k), x_sol(:,k+3), this.lines(1,1));
                
            else %-- not include phase space
                 % Displacement time series
                 subplot(2,1,1)
                 hold on; box on;
                 xlabel('\tau = t\omega_1', 'FontName', this.FontName, 'fontsize', this.FontSize);
                 ylabel(this.labels.A,'FontName', this.FontName, 'fontsize', this.FontSize);
                 set(gca, 'FontName', this.FontName, 'fontsize', this.FontSize, 'xlim', GeneralOptions.SolOpt.permaPlot);
                 
                 plot(t_sol, x_sol(:,k), this.lines(1,1));
                 
                 
                 % Frequency spectrum
                 subplot(2,1,2)
                 hold on; box on;
                 xlabel('f/f_1', 'FontName', this.FontName, 'fontsize', this.FontSize)
                 ylabel('Amplitude', 'FontName', this.FontName, 'fontsize', this.FontSize)
                 set(gca, 'FontName', this.FontName, 'fontsize', this.FontSize, 'xlim', this.lim_plot_freq)
                 
                 plot(this.freq_A_k{k}, this.ampl_A_k{k}, this.lines(1,1))
            end
        end
                
        
        
        function SinglePlot(~, ~, ~)
            error('ROM object can not use ''SinglePlot'' function');
        end
        
        
    end
end

