function app = data2Hist(app, varargin)
%%    
%    new arangement
%    1.1 TimeZone
%    1.2 TimeShift
%    1.3 Hour Per Day
%    2.1 First Day cut off
%    2.2 Last Day cut off
%    3 Bin Per Hour

%    4.1 HPix
%    4.2 HSpace

%%

    % First Level Parameters
    % Adjust TimeZone and Time Shift
    app.LOCALGMT = 8; % varargin{1}{1}; GMT+8 Taipei
    app.TIMESHIFT = varargin{1}{2};
    
    app.HRPERDAY = varargin{1}{3};
    
    % unuse
    app.firstDay = varargin{2}{1};
    app.lastDay = varargin{2}{2};
    % unuse
    
    % Bins Per Hour
    app.BINPERHR = varargin{3};
    app.MINPERBIN = 60/app.BINPERHR;
    app.BINHALFHR = app.BINPERHR/2;
    app.BINPERDAY = app.BINPERHR * app.HRPERDAY;
    
    % Height of Bin
    app.BHPix = 50; % varargin{4}{1} bin height (pixel)
    app.BHSpace = varargin{4}{2};
    app.BHPixSp = app.BHPix + app.BHSpace;
    
    % Parse acto time
    tic
    app.timetag = datetime(app.ActoCSV{2}, 'convertfrom','posixtime') + hours(app.LOCALGMT); % Taipei local time
    toc
    app.timeadj = app.timetag - hours(app.TIMESHIFT); % 11.5/11.5 cycle
    
    
    % Parse mask
    
    % denoise
    if 1
        dt = diff(app.timeadj);
        dt = seconds(dt);
        
        dt1 = dt(dt < 1);
        figure(10)
        histogram(dt1)
        
        dt2 = (dt<0.15);
        app.timeadj([false; dt2]) = [];
    end
    
    % Parse Time
    app.hrs = hours(timeofday(app.timeadj));
    initDay = datetime(app.timeadj(1).Year, app.timeadj(1).Month, app.timeadj(1).Day);
    app.allhrs = hours(app.timeadj - initDay);
    app.ind24HR = floor(hours(app.timeadj - initDay) / 24);
    app.indDay = floor(hours(app.timeadj - initDay) / app.HRPERDAY);
    app.lenDay = app.indDay(end) + 1;
    
    tmpa = app.timeadj;
    tmpb = app.timeadj;
    %tmpb = app.MaskCSVe;
    %b = app.ind24HR;
    save([app.apppath '/tmp_data/histsome.mat'], 'tmpa', 'tmpb');
    somedate = yyyymmdd(app.timeadj);
    [app.dayList, ~, ~] = unique(somedate);
    % Edges for Histogram
    app.Edges = linspace(0, app.HRPERDAY, app.HRPERDAY * app.BINPERHR + 1);
    % Empty Grid
    app.actoHist = zeros(app.lenDay, app.BINPERDAY);
    app.actoHistPix = zeros(app.lenDay, app.BINPERDAY);
    app.maxh = zeros(app.lenDay, 1);
    if app.HRPERDAY == 24
        for i = 1:app.lenDay
            h = histcounts(app.hrs(app.indDay == (i - 1)), 'BinEdges', app.Edges, 'Normalization', 'count');
            app.actoHist(i, :) = h;
            app.maxh(i) = max(h);
            if app.maxh(i) == 0
                app.actoHistPix(i, :) = h; % Pixel wise
            %{
            elseif app.maxh(i) > 100
                app.maxh(i)
                h(h > 100) = 100;
                app.maxh(i) = 100;
                app.actoHistPix(i, :) = ceil(h * app.BHPix / app.maxh(i)); % Pixel wise
              %}
            else
                app.actoHistPix(i, :) = ceil(h * app.BHPix / app.maxh(i)); % Pixel wise
            end
        end
    else
        %app.hrs = app.hrs + app.ind24HR * 24;
        for i = 1:app.lenDay
            h = histcounts(app.allhrs(app.indDay == (i - 1)) - ((i - 1) * app.HRPERDAY), 'BinEdges', app.Edges, 'Normalization', 'count');
            app.actoHist(i, :) = h;
            app.maxh(i) = max(h);
            if app.maxh(i) == 0
                app.actoHistPix(i, :) = h; % Pixel wise
            else
                app.actoHistPix(i, :) = ceil(h * app.BHPix / app.maxh(i)); % Pixel wise
            end
        end
    end
    
    
    app.countsPerDay = sum(app.actoHist, 2);
    countsPerDay = app.countsPerDay;
    csvwrite([app.apppath '/tmp_data/CountsPerDay.csv'], [(1:length(countsPerDay))' countsPerDay]);
    %}

end
