function app = basicpara2(app, inputPara)
    %{
    1: Bins per hr
    2: Light hour
    3: Dark hour
    4: first day
    5: last day
    6: mask
    7: color gradient
    %}

    % First level para
    % Adjust TimeZone and Time
    app.LOCALGMT = 8; % GMT+8 Taipei
    app.TIMESHIFT = inputPara{2};
    %app.DARKHR = str2double(inputPara{3});
    app.HRPERDAY = 24;
    
    
    % unuse
    app.firstDay = str2double(inputPara{4});
    app.lastDay = str2double(inputPara{5});
    % unuse
    
    app.BINPERHR = inputPara{1}{1};
    app.MINPERBIN = 60/app.BINPERHR;
    app.BINHALFHR = app.BINPERHR/2;
    app.BINPERDAY = app.BINPERHR*24;
    % bins per hr
    app.BHPix = 50; % bin height (pixel)
    app.BHSpace = inputPara{1}{2};
    app.BHPixSp = app.BHPix + app.BHSpace;

    app.BWPix = 5;
    app.BWSpace = 1;
    app.BWPixSp = app.BWPix + app.BWSpace;
    % Default Separation
    if rem(app.BINHALFHR, 1) == 0
        app.BinSep = app.BINHALFHR; % bins
    else
        app.BinSep = app.BINPERHR;
    end
    
    app.Edges = linspace(0, 24, 24*app.BINPERHR + 1);
    if app.BinSep
        app.WIDTH24 = app.BINPERDAY*app.BWPix + app.BWSpace*((app.BINPERDAY/app.BinSep) - 1);
        app.oneDayPic = ones(app.BHPix, app.WIDTH24, 3);
        app.oneDaySep = ones(app.BHSpace, app.WIDTH24, 3);
    else
        app.WIDTH24 = app.BINPERDAY*app.BWPix;
        app.oneDayPic = ones(app.BHPix, app.WIDTH24, 3);
        app.oneDaySep = ones(app.BHSpace, app.WIDTH24, 3);
    end
    
    % Parsing time
    app.timetag = datetime(app.ActoCSV{2}, 'convertfrom','posixtime') + hours(app.LOCALGMT); % Taipei local time
    app.timeadj = app.timetag - hours(app.TIMESHIFT); % 11.5/11.5 cycle
    if 1
        dt = diff(app.timeadj);
        dt = seconds(dt);
        
        dt1 = dt(dt < 1);
        figure(10)
        histogram(dt1)
        
        dt2 = (dt<0.15);
        app.timeadj([false; dt2]) = [];
        
    end
    % parse time
    app.hr = app.timeadj.Hour + app.timeadj.Minute/60 + app.timeadj.Second/60/60;
    app.datetag = app.timeadj.Year*10000+ app.timeadj.Month*100 + app.timeadj.Day;

    [app.dayNum, app.uInd, app.totalInd] = unique(app.datetag);
    %app.dayNum
    app.dayLen = length(app.dayNum);
    
    app.actoHistPix = zeros(app.dayLen, app.BINPERDAY);
    app.actoHist = zeros(app.dayLen, app.BINPERDAY);
    for i = 1:app.dayLen
        %h = histogram(app.hr(app.totalInd == i), 'BinEdges', app.Edges, 'Normalization', 'count');
        %actHist = h.Values/max(h.Values); % 1 base
        %app.actHistPix(i, :) = round(h.Values * app.BHPix / max(h.Values)); % Pixel wise
        h = histcounts(app.hr(app.totalInd == i), 'BinEdges', app.Edges, 'Normalization', 'count');
        app.actoHist(i, :) = h;
        app.actoHistPix(i, :) = ceil(h * app.BHPix / max(h)); % Pixel wise
    end
    
    % Color Gradien
    app.tmpbin = colorGradient(app, inputPara{7}, 1);
    
    kOne = 1;
    irange = 1:app.dayLen;
    ir = length(irange);

    app.actopic = ones(app.BHPixSp * ir - app.BHSpace, app.WIDTH24, 3);
    [a, b, ~] = size(app.actopic);
    halfMaskW = ones(a, ceil(b/2),3);
    halfMaskG = ones(a, floor(b/2), 3)*0.6;
    app.actopicmask = [halfMaskW halfMaskG];

    for iDay = irange
        for jBin = 1:app.BINPERDAY
            if app.BinSep
                rind1 = 1 + app.BHPix * iDay + app.BHSpace * (iDay - 1) ...
                    - app.actoHistPix(iDay, jBin);
                rind2 = app.BHPix * iDay + app.BHSpace * (iDay - 1);
                cind1 = 1 + app.BWPix * (jBin - 1) + app.BWSpace * fix((jBin - 1)/app.BinSep);
                cind2 = app.BWPix * jBin + app.BWSpace * fix((jBin - 1)/app.BinSep);
            else
                rind1 = 1 + app.BHPix * iDay + app.BHSpace * (iDay - 1) ...
                    - app.actoHistPix(iDay, jBin);
                rind2 = app.BHPix * iDay + app.BHSpace * (iDay - 1);
                cind1 = 1 + app.BWPix * (jBin - 1);
                cind2 = app.BWPix * jBin;
            end

            if app.actoHistPix(iDay, jBin)
                app.actopic(rind1:rind2, cind1:cind2, :) = app.tmpbin(1 + end - app.actoHistPix(iDay, jBin):end, :, :);
                app.actopicmask(rind1:rind2, cind1:cind2, :) = app.tmpbin(1 + end - app.actoHistPix(iDay, jBin):end, :, :);

            end

        end
        kOne = kOne + 1;
    end
    
    halfMaskW = ones(app.BHPixSp, ceil(b/2),3);
    halfMaskG = ones(app.BHPixSp, floor(b/2), 3)*0.6;
    
    app.actopicDouble = [app.actopic [app.actopic(app.BHPixSp + 1: end, :, :); [app.oneDayPic; app.oneDaySep]]];
    app.actopicmaskDouble = [app.actopicmask [app.actopicmask(app.BHPixSp + 1: end, :, :); [halfMaskW halfMaskG]]];
    if inputPara{6}
        app.actopic = app.actopicmaskDouble;
    else
        app.actopic = app.actopicDouble;
    end
    
    % onset estimation
    app.onset = zeros(5, app.dayLen);
    app.onsetStarNo = ones(1, app.dayLen);
    for i = 1:app.dayLen
        [q, ~] = findchangepts(app.actoHist(i, :), 'MaxNumChanges',5);
        %findchangepts(app.actoHist(i, :), 'MaxNumChanges',5);
        a = length(q);
        app.onset(1:a, i) = q;
        
    end
    app.onset
    bestguess = diff(app.onset);
    [py, dx, ~] = find(bestguess > 108);
    app.onsetGuessNo = zeros(1, app.dayLen);
    app.onsetGuess = zeros(1, app.dayLen);
    for i = 1:app.dayLen
        j = find(dx == i);
        if isempty(j)
            app.onsetGuessNo(i) = 1;
        else
        
            app.onsetGuessNo(i) = py(j(1)) + 1;
        end
    end
    
    
    for i = 1:app.dayLen
        app.onsetGuess(i) = app.onset(app.onsetGuessNo(i), i);
    end

    app.onsetGuess
    app.onsetGuessNo
end
