function app = hist2Pix(app)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    %unit 1
    for i = 1:app.lenDay
        if max(h) == 0
            app.actoHistPix(i, :) = app.actoHist(i, :); % Pixel wise
        else
            app.actoHistPix(i, :) = ceil(app.actoHist(i, :) * app.BHPix / app.maxh(i)); % Pixel wise
        end
    end
    
    %unit 2
    app.actoHistPix = bsxfun(@cdivide, app.actoHist', app.maxh)';
    
end

