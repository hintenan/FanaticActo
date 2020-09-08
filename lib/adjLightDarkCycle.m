
function app = adjLightDardCycle(app, InDia)
    app.LIGHTHR = str2double(InDia{1});
    app.DARKHR =  str2double(InDia{2});
    
    app.timeadj = app.timetag - hours(app.LIGHTHR); % 11.5/11.5 cycle
    
    % adj time
    app.hr = app.timeadj.Hour + app.timeadj.Minute/60 + app.timeadj.Second/60/60;
    app.datetag = app.timeadj.Year*10000+ app.timeadj.Month*100 + app.timeadj.Day;

    [app.dayNum, app.uInd, app.totalInd] = unique(app.datetag);
    app.dayNum
    app.dayLen = length(app.dayNum);
    
end
