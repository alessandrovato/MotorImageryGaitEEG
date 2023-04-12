function [loadFile,loadFolder,numFiles]=loadFilesToProcess(option)
%load multiple file and compute the number of file selected

[loadFile,loadFolder] = uigetfile(option.extension, 'Select One or More Files',...
    option.startFolder,'MultiSelect', 'on');

numFiles = 1;

if iscell(loadFile)
    numFiles = size(loadFile,2);
end

%load('EEGlabStruct.mat')