function option= repository_miNCAN(opt)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A1 = [1-40]Hz, CAR
% A2 = [3-40]Hz, CAR
% 
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Change these 2 lines

option.startFolder ='D:\0-MATLAB\1_Data\0_miNCAN_Data\miNCAN_results2-resultsData';
option.saveFolder = 'D:\0-MATLAB\1_Data\0_miNCAN_Data\miNCAN_results\2-resultsData';
option.channelLocationFile = 'D:\\0-MATLAB\\eeglab2021.1\\plugins\\dipfit\\standard_BEM\\elec\\standard_1005.elc';

%option.startFolder ='/Users/vatoadmin/Dropbox/03-MATLAB/1_Data/0_miNCAN_Data/miNcan_Results';
%option.saveFolder = '/Users/vatoadmin/Dropbox/03-MATLAB/1_Data/0_miNCAN_Data/miNcan_Results';


option.resample = 1000;

option.extension = '.set';

option.run_loadBCI2000 = 0;
option.run_preprocess = 0;
option.run_epochs= 0;
option.load_folder = 0;
option.merge_dataset = 0;
option.add_event = 0;

option.minEpoch1 = -1;
option.maxEpoch1 = -0.1;

option.minEpoch2 = 0.1;
option.maxEpoch2 = 2;

markers1 = [26 29 28 23 22 20 16 13 9 3 29 26 24 18 15 12 8 6];
markers2 = markers1/30;
markers3 = markers2 + [(0:9),(9:16)];

option.markers = markers3 * option.resample;
option.step = {'R' 'L' 'R' 'L' 'R' 'L' 'R' 'L' 'R' 'L' 'R' 'L' 'R' 'L' 'R' 'L' 'R' 'L' 'R'};
option.event = 'DigitalInput1';
option.suffix = opt;


switch(opt)
    
    
    
    
    %==============================
    %convert dat files to set files
    %==============================
    case 10 
    
    option.run_loadBCI2000 = 1;
    option.extension = '.dat';
    
    %==============
    % pre-pocessing
    %==============
    case 'A1'

    option.suffix = 'A1';
    option.lowFreqFilter = 1;
    option.highFreqFilter = 40;
    
    
    %==================
    % add marker/events
    %==================
    case 'B1'
    
    option.suffix = 'B1';
    option.load_folder = 1;
    option.add_event = 1;
    
    
    %======================================================================
    case 'C1'       % extract Gait Cycle (strating from R)
    %======================================================================
    
    option.run_epochs = 1;
    option.load_folder = 0;
    %option.event = 'R';
    
    option.minEpochSS = -0.3;
    option.maxEpochSS = 1.9;
    
    option.minEpoch = -0.1;
    option.maxEpoch= 0.9;
    
    option.minEpochBaseline = -0.6;
    option.maxEpochBaseline = -0.1;
    
    option.epochName  = 'Gait Cycle';
    %option.saveFolder = 'D:\0-MATLAB\1_Data\0_miNCAN_Data\miNCAN_results\Working\epochData'; 
    
    
    %======================================================================
    case 'C2'       % extract Baseline epochs
    %======================================================================
    
    option.run_epochs = 1;
    option.load_folder = 1;
    
    option.minEpoch = -2.2;
    option.maxEpoch = -0.2;
    option.epochName  = 'digIn';
    %option.saveFolder = 'D:\0-MATLAB\1_Data\0_miNCAN_Data\miNCAN_results\Working\4-epochedData';
    
       
    %======================================================================
    case 'C3'       % extract Stance & Swing
    %======================================================================   
    
    option.run_epochs = 1;
    option.load_folder = 0;
    option.event = 'R';
    
    option.minEpoch = -0.3;
    option.maxEpoch = 1.9;
    option.epochName  = 'Stance & Swing';
    %option.saveFolder = 'D:\0-MATLAB\1_Data\0_miNCAN_Data\miNCAN_results\Working\epochData';
    
    %======================================================================
    case 'C4'       % extract Right Swing
    %======================================================================   
    
    option.run_epochs = 1;
    option.load_folder = 0;
    option.event = 'L';
    
    option.minEpoch = 0;
    option.maxEpoch = 0.8;
    option.epochName  = 'Left&Right Swing';
    %option.saveFolder = 'D:\0-MATLAB\1_Data\0_miNCAN_Data\miNCAN_results\Working\epochData';
    
    %======================================================================
    case 'E1'       % Plot TF of Stance & Swing
    %======================================================================   
    
    option.run_epochs = 1;
    option.load_folder = 0;
    option.event = 'R';
    
    option.minEpoch = -0.3;
    option.maxEpoch = 1.9;
    option.epochName  = 'Stance & Swing';
    %option.saveFolder = 'D:\0-MATLAB\1_Data\0_miNCAN_Data\miNCAN_results\Working\epochData';
    
    option.chan2use = {'cp3'};
    
    
    %======================================================================
    case 'F1'       % plot Topographic Distribution
    %======================================================================
    
    %Window to plot the data
    option.WinLow  = 100;
    option.WinHigh = 800;
    option.frequencyToPlot = ['12'];
    
    option.minEpochBaseline = -600;
    option.maxEpochBaseline = -100;
    
    
    %======================================================================
    case 'F2'       % plot Topographic Distribution
    %======================================================================
    
     %Window to plot the data
    option.WinLow  = -100;
    option.WinHigh = 400;
    option.frequencyToPlot = ['8 12 20 24'];
    
    option.minEpochBaseline = -600;
    option.maxEpochBaseline = -100;
    
    %======================================================================
    case 'F3'       % plot Topographic Distribution
    %======================================================================
    
    %Window to plot the data
    option.WinLow  = 400;
    option.WinHigh = 899;
    option.frequencyToPlot = ['8 12 20 24'];
    
    option.minEpochBaseline = -600;
    option.maxEpochBaseline = -100;
    
    
    % extract pre-epochs 
    %=========
    case 21
    %=========    
    
    option.run_epochs = 1;
    option.load_folder = 1;
    option.minEpoch = -1;
    option.maxEpoch = -0.1;
    option.epochName  = 'pre';
    option.suffix = 'B1';
    
    % extract pos- epochs 
    %=========
    case 22
    %=========    
    
    option.run_epochs = 1;
    option.load_folder = 1;
    option.minEpoch = 0.1;
    option.maxEpoch = 2;
    option.epochName  = 'post';
    
    % extract pre and pos- epochs 
    %=========
    case 23
    %=========    
    
    option.run_epochs = 1;
    option.load_folder = 1;
    option.minEpoch = -1;
    option.maxEpoch = 1;
    option.epochName  = 'pre_post';
    
    
    
    % merge proc files with file selection
    %=========
    case 31
    %=========    
    
    option.merge_dataset = 1;
    
    %===
    
end