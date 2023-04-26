function outputFileName = addEvent_miNCAN(loadFile,loadFolder,numFiles,option)

%% Add events

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
        
        %this line delete the first DigitalInput if the second is too close
        % just in case there are more than just one DigitalInput
        if size(EEG.event,2)+1>2 && (EEG.event(2).latency-EEG.event(1).latency)<10000
            EEG.event(1)=[];
        end
        
        %=======================================
        % add extra markers after the main event
        %=======================================
        pos=size(EEG.event,2)+1;
        
        for i = 1 : size(EEG.event,2)
            for j = 1 : size(option.markers,2)
                EEG.event(pos).latency = (EEG.event(i).latency + option.markers(j));
                EEG.event(pos).type = option.step{j};
                pos = pos +1;
            end
        end
        
        %=================
        % save new dataset
        %=================
        EEG = pop_saveset( EEG, 'filename',char(saveFileName),'filepath',option.saveFolder);
        outputFileName = char(saveFileName);
        
    end
end
