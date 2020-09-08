
function app = basicpara(app, inPara)
    
    % First level para
    % Adjust TimeZone and Time
    app.LOCALGMT = 8; % GMT+8 Taipei
    app.TIMESHIFT = str2double(inPara{3});
    app.DARKHR =  str2double(inPara{4});
    
    % Firt level Time adj
    % parse time
    app.timetag = datetime(app.ActoCSV{2}, 'convertfrom','posixtime') + hours(app.LOCALGMT); % GMT+8 Taipei
    app.timeadj = app.timetag - hours(app.TIMESHIFT); % 11.5/11.5 cycle
    if 1
        dt = diff(app.timeadj);
        dt = seconds(dt);
        app.dt = seconds(dt);
        
        app.dt1 = dt(dt < 1);
        figure(10)
        histogram(app.dt1)
        
        dt2 = (dt<0.15);
        app.timeadj([false; dt2]) = [];
    end
    %app.hr = app.timeadj.Hour + app.timeadj.Minute/60 + app.timeadj.Second/60/60;
    app.hr = hours(timeofday(app.timeadj));
    %app.datetag = app.timeadj.Year*10000+ app.timeadj.Month*100 + app.timeadj.Day;
    app.datetag = yyyymmdd(app.timeadj);
    [app.dayNum, app.uInd, app.totalInd] = unique(app.datetag);
    app.dayNum
    app.dayLen = length(app.dayNum);
    
    
    
    % First level Time adj
    % 24 hrs per day
    % 
    app.HRPERDAY = 24;
    if app.HRPERDAY ~= 24
        % add code here
    end
    
    % Second level para
    app.BINPERHR = str2double(inPara{2});
    app.Edges = linspace(0, app.HRPERDAY, app.HRPERDAY*app.BINPERHR + 1);
    app.BINPERDAY = app.BINPERHR*app.HRPERDAY;
    
    % histo
    app.actoHistCount = zeros(app.dayLen, app.BINPERDAY);
    app.actoHistPix = zeros(app.dayLen, app.BINPERDAY);
    for i = 1:app.dayLen
        %h = histogram(app.hr(app.totalInd == i), 'BinEdges', app.Edges, 'Normalization', 'count');
        %actHist = h.Values/max(h.Values); % 1 base
        %app.actHistPix(i, :) = round(h.Values * app.BHPix / max(h.Values)); % Pixel wise
        app.actoHistCount(i, :) = histcounts(app.hr(app.totalInd == i), 'BinEdges', app.Edges, 'Normalization', 'count');
    end
    
    % clear matrix
    app.ActoCSV = [];
    app.timetag = [];
    %app.timeadj = [];
    app.datetag = [];
    app.hr = [];
    %
    
    % Third level para for graph
    app.BHPix = 50; % bin height (pixel)
    % Digital
    app.actoHistPix = ceil(app.actoHistCount * app.BHPix ./ max(app.actoHistCount, [], 2)); % Pixel wise
    
    % Forth level para for graph
    % only para
    app.SPACEPERHR = 2; % 1 or 2 or NaN
    app.BHSpace = 3;
    app.BHPixSp = app.BHPix + app.BHSpace;
    app.BWPix = 5;
    app.BWSpace = 1;
    app.BWPixSp = app.BINPERHR * app.BWPix + app.SPACEPERHR * app.BWSpace;
    if isnan(app.SPACEPERHR)
        app.BinSep = 0;
    elseif rem(app.BINPERHR, 2)
        app.SPACEPERHR = 1; % force choice
        app.BinSep = app.BINPERHR; % bins
        
    else
        app.BinSep = app.BINPERHR/app.SPACEPERHR; % bins
    end
    
    % truncate
    app.firstDay = str2double(inPara{5});
    app.lastDay = str2double(inPara{6});
    for i = 1:app.dayLen
        app.y1Truncat(i) = 1 + app.BHPixSp * (i - 1);
        app.y2Truncat(i) = app.BHPixSp * i - app.BHSpace;
    end
        
    
    % Temp pic
    app.WIDTH24 = app.BWPixSp * 24 - 1;
    app.oneDayPic = ones(app.BHPix, app.WIDTH24, 3);
    app.oneDaySep = ones(app.BHSpace, app.WIDTH24, 3);
    
    
    % Low level para
    app.firstDay = str2double(inPara{5});
    app.lastDay = str2double(inPara{6});
 
    
    
    
    
end