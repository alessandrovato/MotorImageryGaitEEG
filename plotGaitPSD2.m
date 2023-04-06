
function [eegpower] = plotGaitPSD2(loadFile,loadFolder,numFiles,option)
% 1/19/2023

%close all;


for i = 1 : numFiles
    
    cd(loadFolder);
    
    if iscell(loadFile)
        fileName = loadFile(i);
    else
        fileName = {loadFile};
    end
    
    if contains(fileName,'.set')
        
        newFileName = erase(fileName,'.set');
        
        saveFileName = {[char(newFileName),option.suffix, '.set']};
        
        EEG = pop_loadset('filename',char(fileName),'filepath',loadFolder);
        
        EEG = eeg_checkset( EEG );
        
        %filenameToLoad = [SubjSessionTrial,'EEGA1B1.set'];
        
        %loadFolder = 'D:\0-MATLAB\1_Data\0_miNCAN_Data\miNCAN_results\3-addedEventData';
        
        %EEG= pop_loadset('filename',filenameToLoad,'filepath',loadFolder);
        
        % events =209 - DigintalInput = 11 - R = 99 - L = 99;
        % option.run_epochs = 1;
        % option.load_folder = 0;
        % option.event = 'DigitalInput1';
        % option.minEpoch = - 0.5;
        % option.maxEpoch = -0.2;
        % option.epochName  = 'baseline';
        %
        % EEGBS= pop_epoch( EEG, {  option.event  }, [option.minEpoch  option.maxEpoch], 'newname', option.epochName, 'epochinfo', 'yes');
        
        
        if ~isempty(EEG.event)
            
            
%             option.run_epochs = 1;
%             %option.load_folder = 0;
%             option.event = 'R';
%             %option.minEpoch = -0.5;
%             %option.maxEpoch = 0.7;
%             option.epochName  = 'Left Swing';
%             
%             EEGLS= pop_epoch( EEG, {  option.event  }, [option.minEpoch  option.maxEpoch], 'newname', option.epochName, 'epochinfo', 'yes');
%             
%             %option.run_epochs = 1;
%             %option.load_folder = 0;
%             option.event = 'L';
%             %option.minEpoch = 0.2;
%             %option.maxEpoch = 1.2;
%             option.epochName  = 'Right Swing';
%             
%             EEGRS= pop_epoch( EEG, {  option.event  }, [option.minEpoch  option.maxEpoch], 'newname', option.epochName, 'epochinfo', 'yes');
%             
%             %chan2use = 'fcz';
%             
%             %option.run_epochs = 1;
%             %option.load_folder = 0;
%             option.event = 'R';
%             option.minEpoch = -0.3;
%             option.maxEpoch = 1.9;
%             option.epochName  = 'Stance &  Swing';
%             
%             EEGSS= pop_epoch( EEG, {  option.event  }, [option.minEpoch  option.maxEpoch], 'newname', option.epochName, 'epochinfo', 'yes');
%             
            
            %%%%%%%%%%%%%%data2use = {EEGRS,EEGLS}; %%%%%%%%%%%%%%%%
            
            data2use = {EEG};
            %chan2useall = {'c1','c3','cp3','cz','cpz','c2','c4','cp4'};
            chan2useall = {'cp3','cz','cp4'};
            
            %chan2useall = option.chan2use;
            z=1;
            a = get(0,'screensize');
            %figure('Position',[0.4*a(3),0.1*a(4),0.5*a(4),0.8*a(4)]);
            figure('Position',[0.4*a(3),0.1*a(4),0.7*a(4),0.5*a(4)]);
            titleFigure = ['Subject:' EEG.filename(1:3) '   Session:' EEG.filename(4:6) '    Run:' EEG.filename(7:9)];
            %annotation('textbox', [0.2, 0.88, 0.1, 0.1], 'String', titleFigure, 'Fontsize',18,'FontWeight','bold','LineStyle','none');
            
            for i = 1: size(data2use,2)
                for j = 1 : size(chan2useall,2)
                    
                    
                    EEG = data2use{i};
                    chan2use = chan2useall{j};
                    min_freq =  2;
                    max_freq = 40;
                    %max_freq = 80;
                    num_frex = 50;
                    
                    % define wavelet parameters
                    time = -1:1/EEG.srate:1;
                    frex = logspace(log10(min_freq),log10(max_freq),num_frex);
                    s    = logspace(log10(3),log10(10),num_frex)./(2*pi*frex);
                    %s    =  3./(2*pi*frex); % this line is for figure 13.14
                    %s    = 10./(2*pi*frex); % this line is for figure 13.14
                    
                    % definte convolution parameters
                    n_wavelet            = length(time);
                    n_data               = EEG.pnts*EEG.trials;
                    n_convolution        = n_wavelet+n_data-1;
                    n_conv_pow2          = pow2(nextpow2(n_convolution));
                    half_of_wavelet_size = (n_wavelet-1)/2;
                    
                    % get FFT of data
                    eegfft = fft(reshape(EEG.data(strcmpi(chan2use,{EEG.chanlocs.labels}),:,:),1,EEG.pnts*EEG.trials),n_conv_pow2);
                    
                    % initialize
                    eegpower = zeros(num_frex,EEG.pnts); % frequencies X time X trials
                    
                    baseidx = dsearchn(EEG.times',[-500 -200]');
                    
                    % loop through frequencies and compute synchronization
                    for fi=1:num_frex
                        
                        wavelet = fft( sqrt(1/(s(fi)*sqrt(pi))) * exp(2*1i*pi*frex(fi).*time) .* exp(-time.^2./(2*(s(fi)^2))) , n_conv_pow2 );
                        
                        % convolution
                        eegconv = ifft(wavelet.*eegfft);
                        eegconv = eegconv(1:n_convolution);
                        eegconv = eegconv(half_of_wavelet_size+1:end-half_of_wavelet_size);
                        
                        % Average power over trials (this code performs baseline transform,
                        % which you will learn about in chapter 18)
                        temppower = mean(abs(reshape(eegconv,EEG.pnts,EEG.trials)).^2,2);
                        eegpower(fi,:) = 10*log10(temppower./mean(temppower(baseidx(1):baseidx(2))));
                    end
                    
                    
                    %subplot(121)
                    subplot(size(chan2useall,2),size(data2use,2),z);
                    contourf(EEG.times,frex,eegpower,40,'linecolor','none')
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %set(gca,'clim',[-3 3],'xlim',[-200 option.maxEpoch*1000],'yscale','log','ytick',logspace(log10(min_freq),log10(max_freq),6),'yticklabel',round(logspace(log10(min_freq),log10(max_freq),6)*10)/10)
                    set(gca,'xlim',[-200 option.maxEpoch*1000],'yscale','log','ytick',logspace(log10(min_freq),log10(max_freq),6),'yticklabel',round(logspace(log10(min_freq),log10(max_freq),6)*10)/10)
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%               
                    %set(gca,'xlim',[-200 1900])
                    
                    %set(gca,'clim',[-3 3],'xlim',[-200 1000],'yscale','log','ytick',logspace(log10(min_freq),log10(max_freq),6),'yticklabel',round(logspace(log10(min_freq),log10(max_freq),6)*10)/10)
                   %% title([chan2use, ' ', data2use{i}.setname]);
                    xlabel('Time (ms)','FontSize',16); ylabel('Frequency (Hz)','FontSize',16);
                    %title('Logarithmic frequency scaling')
                    z = z+1;
                    
                    ax = gca;
                    ax.XAxis.FontSize = 24;
                    ax.YAxis.FontSize = 24;
                    
                    
                    %         subplot(122)
                    %         contourf(EEG.times,frex,eegpower,40,'linecolor','none')
                    %         set(gca,'clim',[-3 3],'xlim',[-200 500])
                    %         %set(gca,'clim',[-3 3],'xlim',[-200 1000])
                    %         title('Linear frequency scaling')
                    
                end
            end
        end
        
    end
end