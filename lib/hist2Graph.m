function app = hist2Graph(app, varargin)
%%
%     1.1 Width of bin
%     1.2 WSpace
%     2 color tag
%     3 double plot


%%
    % Width of Bin
    app.BWPix = 5; % varargin{5}{1}
    app.BWSpace = 1; % varargin{5}{2};
    app.BWPixSp = app.BWPix + app.BWSpace;
    
    % Default Separation
    if rem(app.BINHALFHR, 1) == 0
        app.BinSep = app.BINHALFHR; % bins
    else
        app.BinSep = app.BINPERHR;
    end
    % pix related
    if app.BinSep
        app.WIDTHFULLDAY = app.BINPERDAY*app.BWPix + app.BWSpace*((app.BINPERDAY/app.BinSep) - 1);
        app.oneDayPic = ones(app.BHPix, app.WIDTHFULLDAY, 3);
        app.oneDaySep = ones(app.BHSpace, app.WIDTHFULLDAY, 3);
    else
        app.WIDTHFULLDAY = app.BINPERDAY*app.BWPix;
        app.oneDayPic = ones(app.BHPix, app.WIDTHFULLDAY, 3);
        app.oneDaySep = ones(app.BHSpace, app.WIDTHFULLDAY, 3);
    end


    % Color Gradien
    app.tmpbin = colorGradient(app, varargin{2}, 1);
    
    
    irange = 1:app.lenDay;
    ir = length(irange);
    
    app.indRowTop = 1;
    app.indRowBottom = app.BHPixSp * ir - app.BHSpace;
    app.indColumnRight = app.WIDTHFULLDAY;
    app.indColumnRightDouble = app.indColumnRight * 2;
    app.actopic = ones(app.indRowBottom, app.indColumnRight, 3);
    
    halfMaskW = ones(app.indRowBottom, ceil(app.indColumnRight / 2), 3);
    halfMaskG = ones(app.indRowBottom, floor(app.indColumnRight / 2), 3)*0.6;
    app.actopicmask = [halfMaskW halfMaskG];
    
    if app.existMask
        app = custommask(app);
    end
    
    for iDay = irange
        for jBin = 1:app.BINPERDAY
            if app.actoHistPix(iDay, jBin)
                if app.BinSep
                    indR1 = 1 + app.BHPix * iDay + app.BHSpace * (iDay - 1) ...
                        - app.actoHistPix(iDay, jBin);
                    indR2 = app.BHPix * iDay + app.BHSpace * (iDay - 1);
                    indC1 = 1 + app.BWPix * (jBin - 1) + app.BWSpace * fix((jBin - 1)/app.BinSep);
                    indC2 = app.BWPix * jBin + app.BWSpace * fix((jBin - 1)/app.BinSep);
                else
                    indR1 = 1 + app.BHPix * iDay + app.BHSpace * (iDay - 1) ...
                        - app.actoHistPix(iDay, jBin);
                    indR2 = app.BHPix * iDay + app.BHSpace * (iDay - 1);
                    indC1 = 1 + app.BWPix * (jBin - 1);
                    indC2 = app.BWPix * jBin;
                end
                
                app.actopic(indR1:indR2, indC1:indC2, :) = app.tmpbin(1 + end - app.actoHistPix(iDay, jBin):end, :, :);
                app.actopicmask(indR1:indR2, indC1:indC2, :) = app.tmpbin(1 + end - app.actoHistPix(iDay, jBin):end, :, :);
                if app.existMask
                    app.cmask(indR1:indR2, indC1:indC2, :) = app.tmpbin(1 + end - app.actoHistPix(iDay, jBin):end, :, :);
                end
            end
        end
        
    end
    
  
    halfMaskW = ones(app.BHPixSp, ceil(app.indColumnRight / 2), 3);
    halfMaskG = ones(app.BHPixSp, floor(app.indColumnRight / 2), 3) * 0.6;
    
    app.actopicDouble = [app.actopic [app.actopic(app.BHPixSp + 1: end, :, :); [app.oneDayPic; app.oneDaySep]]];
    app.actopicmaskDouble = [app.actopicmask [app.actopicmask(app.BHPixSp + 1: end, :, :); [halfMaskW halfMaskG]]];
    if app.existMask
        app.actopicCustomMaskDouble = [app.cmask [app.cmask(app.BHPixSp + 1: end, :, :); [app.oneDayPic; app.oneDaySep]]];
    end
    if varargin{3}
        app.actopic = app.actopicmaskDouble;
    else
        app.actopic = app.actopicDouble;
    end
    
    
    % onset estimation
    app.onset = zeros(5, app.lenDay);
    app.onsetStarNo = ones(1, app.lenDay);
    for i = 1:app.lenDay
        [q, ~] = findchangepts(app.actoHist(i, :), 'MaxNumChanges',5);
        %findchangepts(app.actoHist(i, :), 'MaxNumChanges',5);
        a = length(q);
        app.onset(1:a, i) = q;
        
    end
    
    bestguess = diff(app.onset);
    [py, dx, ~] = find(bestguess > 108);
    app.onsetGuessNo = zeros(1, app.lenDay);
    app.onsetGuess = zeros(1, app.lenDay);
    for i = 1:app.lenDay
        j = find(dx == i);
        if isempty(j)
            app.onsetGuessNo(i) = 1;
        else
        
            app.onsetGuessNo(i) = py(j(1)) + 1;
        end
    end
    
    
    for i = 1:app.lenDay
        app.onsetGuess(i) = app.onset(app.onsetGuessNo(i), i);
    end
    app.onset
    app.onsetGuess
    app.onsetGuessNo
end

