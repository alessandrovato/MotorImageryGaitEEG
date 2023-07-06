function rsquare_miNCAN(loadFile,loadFolder,numFiles,option)

%% Extract epochs

for i = 1 : numFiles
    
    cd(loadFolder);
    
    if iscell(loadFile)
        fileName = loadFile(i);
    else
        fileName = {loadFile};
    end
    
    if contains(fileName,'.set')
        
        newFileName = erase(fileName,'.set');
        
        option.run_epochs = 1;
        option.load_folder = 0;
        
        
        option.event = 'R';
        option.epochName  = 'Stance';
        
        EEG = pop_loadset('filename',char(fileName),'filepath',loadFolder);
        
        EEGLS= pop_epoch( EEG, {  option.event  }, [option.minEpochStance  option.maxEpochStance], 'newname', option.epochName, 'epochinfo', 'yes');
        
        saveFileName = {[char(newFileName),option.suffix, 'LS.set']};
        if  ~isempty(EEG.urevent)
            EEGLS = pop_saveset( EEGLS, 'filename',char(saveFileName),'filepath',option.saveFolder);
        end
        
        option.event = 'R';
        option.epochName  = 'Swing';
        
        EEGRS= pop_epoch( EEG, {  option.event  }, [option.minEpochSwing  option.maxEpochSwing], 'newname', option.epochName, 'epochinfo', 'yes');
        
        saveFileName = {[char(newFileName),option.suffix, 'RS.set']};
        if  ~isempty(EEG.urevent)
            EEGRS = pop_saveset( EEGRS, 'filename',char(saveFileName),'filepath',option.saveFolder);
        end
        
%         option.event = 'DigitalInput1';
%         option.epochName  = 'Baseline';
%         
         EEGBS= pop_epoch( EEG, {  option.event  }, [option.minEpochBaseline  option.maxEpochBaseline], 'newname', option.epochName, 'epochinfo', 'yes');
         
         saveFileName = {[char(newFileName),option.suffix, 'BS.set']};
         if  ~isempty(EEG.urevent)
             EEGBS = pop_saveset( EEGBS, 'filename',char(saveFileName),'filepath',option.saveFolder);
         end
%         
%         
%         option.event = 'R';
%         option.epochName  = 'Stance & Swing';
%         
%         EEG = pop_loadset('filename',char(fileName),'filepath',loadFolder);
%         
%         EEGSS= pop_epoch( EEG, {  option.event  }, [option.minEpochSS  option.maxEpochSS], 'newname', option.epochName, 'epochinfo', 'yes');
%         
%         saveFileName = {[char(newFileName),option.suffix, '.set']};
%         if  ~isempty(EEG.urevent)
%             EEGSS = pop_saveset( EEGSS, 'filename',char(saveFileName),'filepath',option.saveFolder);
%         end
    end
    
%

%runBasicAnalysis line 560
% topoplot(data2plot, eloc_file, acqType, 'maplimits', [min(min(data2plot)), max(max(data2plot))], options{:} );
%       titletxt=sprintf(pltTitle, titleData{cur_topo, :});
%        title(titletxt); 
%        colormap jet;
 
% parms = [modelOrd, settings.hpCutoff+settings.freqBinWidth/2, ...
%     lp_cutoff-settings.freqBinWidth/2, settings.freqBinWidth, ...
%     round(settings.freqBinWidth/.2), settings.trend, samplefreq];
%clear;
%clc;

%default:
spectralStep = 166;
spectralSize = 333;



load('D:\0-MATLAB\1_Data\0_miNCAN_Data\miNCAN_results\SettingFile.mat','settings')

%load('D:\0-MATLAB\1_Data\0_miNCAN_Data\miNCAN_results\working.mat')

samplefreq = EEG.srate;

% 1 modelOrd
modelOrd = 18+round(samplefreq/100);

% 2 settings.hpCutoff+settings.freqBinWidth/2
settings.hpCutoff = -1;
settings.freqBinWidth = 4;


%3 lp_cutoff-settings.freqBinWidth/2

params.acqType = 'eeg';
settings.maxFreqEEG = 71;
settings.maxFreqECoG = 201;

 if strcmp(params.acqType, 'eeg')
     lp_cutoff = settings.maxFreqEEG;
 else
     lp_cutoff = settings.maxFreqECoG;
 end
 
 if lp_cutoff > samplefreq/2
     lp_cutoff = samplefreq/2;
     %if the last bin has less samples, truncate it
     lp_cutoff = lp_cutoff - mod(lp_cutoff-settings.hpCutoff, settings.freqBinWidth);
 end

 %4  settings.freqBinWidth
 
 %5 round(settings.freqBinWidth/.2)

 %6 settings.trend
 settings.trend = 1;

 %7 samplefreq
 

parms = [modelOrd, settings.hpCutoff+settings.freqBinWidth/2, ...
     lp_cutoff-settings.freqBinWidth/2, settings.freqBinWidth, ...
     round(settings.freqBinWidth/.2), settings.trend, samplefreq];

memparms = parms;
% 6 and 7 
if( length(memparms) < 6 )
  memparms(6) = 0;
end
if( length(memparms) < 7 )
  memparms(7) = 1;
end

%8 and 9
spectral_size = round(spectralSize/1000 * samplefreq);
spectral_stepping = round(spectralStep/1000 * samplefreq);

memparms(8) = spectral_stepping; %27%
memparms(9) = spectral_size/spectral_stepping; %(53/27)=1.9630

start=parms(2);
stop=parms(3);
binwidth=parms(4);

spectral_bins=round((stop-start)/binwidth)+1;
 
%%

%condition1data=double(signal(condition1idx, :));
avgdata1=[];
avgdata2=[];
countall=0;
countcond1=0;
countcond2=0;

%num_channels=size(signal, 2);
num_channels=EEG.nbchan;

%analysisParams.targetConditions = 2;

% pre-allocate matrices to speed up computation
avgdata1=zeros(spectral_bins, num_channels, countcond1);
avgdata2=zeros(spectral_bins, num_channels, countcond2);


for i = 1 : size ( EEGLS.data , 3)
    condition1data = double(EEGLS.data(:,:,i)');
    [trialspectrum, freq_bins] = mem( condition1data, memparms );
    countall = countall + size( trialspectrum, 3 );
    if( size( trialspectrum, 3 ) > 0 )
        trialspectrum = mean( trialspectrum, 3 );
        countcond1=countcond1+1;
        avgdata1(:, :, countcond1)=trialspectrum;
    end
    
end


for i = 1 : size ( EEGRS.data , 3)
    condition2data = double(EEGRS.data(:,:,i)');
    [trialspectrum, freq_bins] = mem( condition2data, memparms );
    countall = countall + size( trialspectrum, 3 );
    if( size( trialspectrum, 3 ) > 0 )
        trialspectrum = mean( trialspectrum, 3 );
        countcond2=countcond2+1;
        avgdata2(:, :, countcond2)=trialspectrum;
    end
    
end

%%

% trials=unique(trialnr);
% trials = trials( trials > 0  );
% start=parms(2);
% stop=parms(3);
% binwidth=parms(4);
% num_channels=size(signal, 2);

spectral_bins=round((stop-start)/binwidth)+1;

%default:
spectralStep = 166;
spectralSize = 333;

%here changes according to sample freq = 160


start=parms(2);
stop=parms(3);
binwidth=parms(4);

memparms(8) = spectral_stepping; %27%
memparms(9) = spectral_size/spectral_stepping; %(53/27)=1.9630



%samplefreq = 160

% condition1data is the data [samples x channels] of one trial

[trialspectrum, freq_bins] = mem( condition1data, memparms );

% % pre-allocate matrices to speed up computation
% avgdata1=zeros(spectral_bins, num_channels, countcond1);
% if length(analysisParams.targetConditions) == 2
%   avgdata2=zeros(spectral_bins, num_channels, countcond2);
% end

%%
% calculate average spectra for each condition and each channel
res1 = mean(avgdata1, 3);
res2 = [];
ressq = [];


  % calculate rvalue/rsqu for each channel and each spectral bin between the
  % two conditions
ressq = calc_rsqu(double(avgdata1), double(avgdata2), 1);

res2=mean(avgdata2, 3);

freq_bins = freq_bins - binwidth/2;

%%
params.acqType = 'eeg';

params.topoParams = ['30']; 

params.topoParams = eval(['[' params.topoParams ']']);

% %translate frequencies into bins - handle issue of user requesting
%  %the right edge of the final bin
 topoParams = params.topoParams;
%  %deal with right edge frequncies
  topoParams(topoParams == lp_cutoff) = lp_cutoff-settings.freqBinWidth;
%  %translate into bins
  topoParams = (topoParams+settings.freqBinWidth/2)/settings.freqBinWidth;
  topofrequencybins=ceil(topoParams);


%topofrequencybins = 8;


titleData = 'ciao';

handles = struct('r2', [], 'chans', [], 'topos', []);
%titleData = mat2cell(reshape(freq_bins(topofrequencybins) + settings.freqBinWidth/2, ...
%          length(topofrequencybins), 1), ...
%          ones(length(topofrequencybins), 1), 1);
%titleData(:, 2) = mat2cell(reshape(params.topoParams, ...
%          length(topofrequencybins), 1), ...
%          ones(length(topofrequencybins), 1), 1);


switch length(params.topoParams)
      case 1
        topogrid = [1 1];
      case 2
        topogrid = [1 2];
      case {3 4}
        topogrid = [2 2];
      case {5 6}
        topogrid = [2 3];
      case {7 8 9}
        topogrid = [3 3];
      otherwise
        error([funcName ':maxTopoFreqsExceeded'], 'Maximum number of topographic plots exceeded');
    end

plotTopos(params.acqType, topofrequencybins,'%0.2f ms (%0.2f ms requested)', titleData, handles, params, topogrid, ressq, res1, res2);

    
    
end
