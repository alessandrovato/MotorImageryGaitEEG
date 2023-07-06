function plotTopos(acqType, topoBins, pltTitle, titleData,handles, params, topogrid, ressq, res1, res2)
      if isempty(handles.topos)
        handles.topos = figure;
      else
        figure(handles.topos);
      end
      clf;
      set(handles.topos, 'name', 'Topographies');
      
      num_topos=length(params.topoParams);
      topoHandles = zeros(num_topos, 1);
      
      params.targetConditions{1}= 'left Swing';
      params.targetConditions{2}=' right swing';
      
      for cur_topo=1:num_topos
        pltIdx = cur_topo;
        hPlt = subplot(topogrid(1), topogrid(2), pltIdx);
        topoHandles(cur_topo) = hPlt;
        if length(params.targetConditions) == 2
          data2plot=ressq(topoBins(cur_topo), :);
        else
          data2plot = res1(topoBins(cur_topo), :);
        end
        
        options = {'maplimits', [min(min(data2plot)), max(max(data2plot))]};
        options = { 'gridscale', 200 };
        if strcmpi( acqType, 'eeg' )
          options = { options{:}, 'electrodes', 'labels' };
        end
        
        eloc_file = 'D:\BCI2000 v3.6.R6143\BCI2000.x64\data\samplefiles\eeg64.loc';
        
        
        topoplot(data2plot, eloc_file, options{:} );
        %titletxt=sprintf(pltTitle, titleData{cur_topo, :});
        %title(titletxt); 
        
        %colormap jet;
        
        if cur_topo == 1
          topoPos = get(hPlt, 'position');
        end
        
        if(cur_topo == num_topos)
          hCb = colorbar;
          
          %compensate for matlab deforming the graph showing the colorbar
          topoPosLast = get(hPlt, 'position');
          topoPosLast(3) = topoPos(3);
          set(gca, 'position', topoPosLast);
        end      
      end
      lastRow = 0;
      
      cbPos = get(hCb, 'position');
      bufLen = cbPos(1) - topoPosLast(1);
      
      for cur_topo=1:num_topos
        pltIdx = cur_topo;
        hPlt = topoHandles(cur_topo);
        pos = get(hPlt, 'position');
        
        if cur_topo==1
          shiftAmt = pos(1)/2;
        end
        if mod(pltIdx-1, topogrid(2)) == 0
          rowY = pos(2);
        else
          pos(2) == rowY;
        end
        
        pos(1) = pos(1)-shiftAmt;
        set(hPlt, 'position', pos);
      end
    
    end
