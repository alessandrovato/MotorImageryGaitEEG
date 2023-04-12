function epoch_miNCAN(loadFile,loadFolder,numFiles,option)

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
 
%                 option.run_epochs = 1;
%                 option.load_folder = 0;
%                 
%                 
%                 option.event = 'R';
%                 option.epochName  = 'Left Swing';
%                 
%                 EEG = pop_loadset('filename',char(fileName),'filepath',loadFolder);
%                 
%                 EEGLS= pop_epoch( EEG, {  option.event  }, [option.minEpoch  option.maxEpoch], 'newname', option.epochName, 'epochinfo', 'yes');
%                 
%                 saveFileName = {[char(newFileName),option.suffix, 'L.set']};
%                 if  ~isempty(EEG.urevent)
%                     EEGLS = pop_saveset( EEGLS, 'filename',char(saveFileName),'filepath',option.saveFolder);
%                 end
%                 
%                 option.event = 'L';
%                 option.epochName  = 'Right Swing';
%                 
%                 EEGRS= pop_epoch( EEG, {  option.event  }, [option.minEpoch  option.maxEpoch], 'newname', option.epochName, 'epochinfo', 'yes');
%                 
%                 saveFileName = {[char(newFileName),option.suffix, 'R.set']};
%                 if  ~isempty(EEG.urevent)
%                     EEGRS = pop_saveset( EEGRS, 'filename',char(saveFileName),'filepath',option.saveFolder);
%                 end
%                 
%                 option.event = 'DigitalInput1';
%                 option.epochName  = 'Baseline';
%                 
%                 EEGBS= pop_epoch( EEG, {  option.event  }, [option.minEpochBaseline  option.maxEpochBaseline], 'newname', option.epochName, 'epochinfo', 'yes');
%                 
%                 saveFileName = {[char(newFileName),option.suffix, 'B.set']};
%                 if  ~isempty(EEG.urevent)
%                     EEGBS = pop_saveset( EEGBS, 'filename',char(saveFileName),'filepath',option.saveFolder);
%                 end
              
                option.event = 'R';
                option.epochName  = 'Stance & Swing';
                
                EEG = pop_loadset('filename',char(fileName),'filepath',loadFolder);
                
                EEGSS= pop_epoch( EEG, {  option.event  }, [option.minEpochSS  option.maxEpochSS], 'newname', option.epochName, 'epochinfo', 'yes');
                
                saveFileName = {[char(newFileName),option.suffix, '.set']};
                if  ~isempty(EEG.urevent)
                    EEGSS = pop_saveset( EEGSS, 'filename',char(saveFileName),'filepath',option.saveFolder);
                end
                        
                
        
    end
    
    
    %     if contains(fileName,'.set')
    %
    %         newFileName = erase(fileName,'.set');
    %
    %         saveFileName = {[char(newFileName),option.suffix, '.set']};
    %
    %         EEG = pop_loadset('filename',char(fileName),'filepath',loadFolder);
    %
    %         EEG = eeg_checkset( EEG );
    %
    %         EEG = pop_epoch( EEG, {  option.event  }, [option.minEpoch  option.maxEpoch], 'newname', option.epochName, 'epochinfo', 'yes');
    %         EEG = eeg_checkset( EEG );
    %         if  ~isempty(EEG.urevent)
    %             EEG = pop_saveset( EEG, 'filename',char(saveFileName),'filepath',option.saveFolder);
    %         end
    %
    %
    %         %win
    %         %newDir = [option.startFolder,'\', nameSubject '-res\'  nameSubject '-res-eeg\' nameSubject '-res-eeg-epoch\'];
    %         %ios
    %         %newDir = [option.startFolder,'/', nameSubject '-res/'  nameSubject '-res-eeg/' nameSubject '-res-eeg-epoch/'];
    %         %     if not(isfolder(newDir))
    %         %         mkdir(newDir)
    %         %     end
    %
    %         %[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'savenew',[newDir saveFileName] ,'gui','on');
    %
    %
    %     end
end