function [outputFileName]=preProcessing_miNCAN(loadFile,loadFolder,numFiles,option)
% Pre-processing raw data 
% 
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
        
        % load the datafile %
        EEG = pop_loadset('filename',char(fileName),'filepath',loadFolder);
        %EEG = eeg_checkset( EEG );
        
        %======================
        % set channel locations 
        %======================
        %EEG=pop_chanedit(EEG, 'lookup','D:\\0-MATLAB\\eeglab2021.1\\plugins\\dipfit\\standard_BEM\\elec\\standard_1005.elc');
        EEG=pop_chanedit(EEG, 'lookup',option.channelLocationFile);
        
        %=================
        % band-pass filter 
        %=================
        EEG = pop_eegfiltnew(EEG, 'locutoff',option.lowFreqFilter,'hicutoff',option.highFreqFilter,'plotfreqz',0);
        
        
        %============================
        % resample to option.resample
        %============================
        EEG = pop_resample( EEG, option.resample);
        
        %=============
        % re-reference
        %=============
        EEG = pop_reref( EEG, []); % commmon average reference
        % Inputs:
        %  EEG - input dataset
        %  ref - reference:  [] = convert to average reference
        %                    [int vector]   = new reference electrode number(s)
        %                    'Cz'           = string
        %                    { 'P09' 'P10 } = cell array of strings
        
        %=================
        % save new dataset
        %=================
        EEG = pop_saveset( EEG, 'filename',char(saveFileName),'filepath',option.saveFolder);
        outputFileName = char(saveFileName);
    
    end
end
