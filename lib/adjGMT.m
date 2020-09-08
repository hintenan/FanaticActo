
function app = adjGMT(app)
    app.LOCALGMT = 8; 
    app.timetag = datetime(app.ActoCSV{2}, 'convertfrom','posixtime') + hours(app.LOCALGMT); % Taipei local time
    
end
