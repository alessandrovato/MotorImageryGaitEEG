function plotTopoDist(loadFile,loadFolder,numFiles,option)


for i = 1 : numFiles
    
    cd(loadFolder);
    
    if iscell(loadFile)
        fileName = loadFile(i);
    else
        fileName = {loadFile};
    end
    
    if contains(fileName,'.set')
        
        %newFileName = erase(fileName,'L.set');
        newFileName = erase(fileName,'.set');
        
        saveFileName = {[char(newFileName),option.suffix, '.set']};
        
        fileNameL = [char(newFileName),'L.set'];
        
        EEGLS = pop_loadset('filename',fileNameL,'filepath',loadFolder);
        
        fileNameR = [char(newFileName),'R.set'];
        EEGRS = pop_loadset('filename',fileNameR,'filepath',loadFolder);
        
        fileNameB = [char(newFileName),'B.set'];
        EEGBS = pop_loadset('filename',fileNameB,'filepath',loadFolder);

        EEGLS = eeg_checkset( EEGLS );
        EEGRS = eeg_checkset( EEGRS );
        EEGBS = eeg_checkset( EEGBS );
    end
    
spectralStep = 166;
spectralSize = 333;

%load('D:\0-MATLAB\1_Data\0_miNCAN_Data\miNCAN_results\SettingFile.mat','settings')

EEG = EEGLS;

samplefreq = EEG.srate;

% 1 modelOrd
modelOrd = 18+round(samplefreq/100);

%modelOrd = 18;

% 2 settings.hpCutoff+settings.freqBinWidth/2
settings.hpCutoff = -1;


settings.freqBinWidth = 2; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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

spectral_bins = round((stop-start)/binwidth)+1;

%condition1data=double(signal(condition1idx, :));
avgdata1=[];
avgdata2=[];
avgdata3=[];

countall=0;
countcond1=0;
countcond2=0;
countcond3=0;

%num_channels=size(signal, 2);
num_channels=EEG.nbchan;

%analysisParams.targetConditions = 2;

% pre-allocate matrices to speed up computation
avgdata1=zeros(spectral_bins, num_channels, countcond1);
avgdata2=zeros(spectral_bins, num_channels, countcond2);
avgdata3=zeros(spectral_bins, num_channels, countcond3);


winMinMax = [find(EEGLS.times==option.WinLow)  find(EEGLS.times==option.WinHigh)];
winMinMaxBS = [find(EEGBS.times==option.minEpochBaseline)  find(EEGBS.times==option.maxEpochBaseline-1)];


for i = 1 : size ( EEGLS.data , 3)
    condition1data = double(EEGLS.data(:,winMinMax(1):winMinMax(2),i)');
    [trialspectrum, freq_bins] = mem( condition1data, memparms );
    countall = countall + size( trialspectrum, 3 );
    if( size( trialspectrum, 3 ) > 0 )
        trialspectrum = mean( trialspectrum, 3 );
        countcond1=countcond1+1;
        avgdata1(:, :, countcond1)=trialspectrum;
    end
    
end


for i = 1 : size ( EEGRS.data , 3)
    condition2data = double(EEGRS.data(:,winMinMax(1):winMinMax(2),i)');
    [trialspectrum, freq_bins] = mem( condition2data, memparms );
    countall = countall + size( trialspectrum, 3 );
    if( size( trialspectrum, 3 ) > 0 )
        trialspectrum = mean( trialspectrum, 3 );
        countcond2=countcond2+1;
        avgdata2(:, :, countcond2)=trialspectrum;
    end
    
end


for i = 1 : size ( EEGBS.data , 3)
    condition3data = double(EEGBS.data(:,winMinMaxBS(1):winMinMaxBS(2),i)');
    [trialspectrum, freq_bins] = mem( condition3data, memparms );
    countall = countall + size( trialspectrum, 3 );
    if( size( trialspectrum, 3 ) > 0 )
        trialspectrum = mean( trialspectrum, 3 );
        countcond3=countcond3+1;
        avgdata3(:, :, countcond3)=trialspectrum;
    end
    
end


% % trials=unique(trialnr);
% % trials = trials( trials > 0  );
% % start=parms(2);
% % stop=parms(3);
% % binwidth=parms(4);
% % num_channels=size(signal, 2);
% 
% spectral_bins=round((stop-start)/binwidth)+1;
% 
% %default:
% spectralStep = 166;
% spectralSize = 333;
% 
% %here changes according to sample freq = 160
% 
% 
% 
% start=parms(2);
% stop=parms(3);
% binwidth=parms(4);
% 
% memparms(8) = spectral_stepping; %27%
% memparms(9) = spectral_size/spectral_stepping; %(53/27)=1.9630
% 
% 
% 
% 
% %samplefreq = 160
% 
% % condition1data is the data [samples x channels] of one trial
% 
% [trialspectrum, freq_bins] = mem( condition1data, memparms );

% % pre-allocate matrices to speed up computation
% avgdata1=zeros(spectral_bins, num_channels, countcond1);
% if length(analysisParams.targetConditions) == 2
%   avgdata2=zeros(spectral_bins, num_channels, countcond2);
% end


% calculate average spectra for each condition and each channel
res1=mean(avgdata1, 3);
res2 = [];
ressq = [];


  % calculate rvalue/rsqu for each channel and each spectral bin between the
  % two conditions
%ressq = calc_rsqu(double(avgdata1), double(avgdata2), 1);
ressq = calc_rsqu(double(avgdata2), double(avgdata1), 1);

ressq13 = calc_rsqu(double(avgdata1), double(avgdata3), 1);


ressq23 = calc_rsqu(double(avgdata2), double(avgdata3), 1);

res2=mean(avgdata2, 3);

freq_bins = freq_bins - binwidth/2; %????????

params.acqType = 'eeg';

params.topoParams = option.frequencyToPlot; 

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

handles = struct('r2', [], 'chans', [], 'topos', []);
titleData = mat2cell(reshape(freq_bins(topofrequencybins) + settings.freqBinWidth/2, ...
          length(topofrequencybins), 1), ...
          ones(length(topofrequencybins), 1), 1);
titleData(:, 2) = mat2cell(reshape(params.topoParams, ...
          length(topofrequencybins), 1), ...
          ones(length(topofrequencybins), 1), 1);


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

plotTopos2(params.acqType, topofrequencybins, ...
        '%0.2f Hz (%0.2f Hz requested)', titleData, handles, params, topogrid, ressq, res1, res2);
    
%plotTopos2(params.acqType, topofrequencybins, ...
%        '%0.2f ms (%0.2f ms requested)', titleData, handles, params, topogrid, ressq13, res1, res2);
    
%plotTopos2(params.acqType, topofrequencybins, ...
%        '%0.2f ms (%0.2f ms requested)', titleData, handles, params, topogrid, ressq23, res1, res2);
end
