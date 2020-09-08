function [app] = custommask(app) 
    % custom mask
    
    app = readMaskCSV(app, 11, '');
    
    [ad, ~] = size(app.MaskCSVs);
    app.cmask = ones(app.indRowBottom, app.indColumnRight, 3);
    somedate = yyyymmdd(app.MaskCSVs);
    mask1 = hours(timeofday(app.MaskCSVs));
    mask2 = hours(timeofday(app.MaskCSVe));
    
    
    for i = 1:ad
        
        iDay = find(somedate(i) == app.dayList);
        %mask1(i)
        if ~isempty(iDay)
            if ~isnan(mask1(i))
                if app.BinSep
                    indR1 = 1 + app.BHPix * (iDay - 1) + app.BHSpace * (iDay - 1);
                    indR2 = app.BHPix * iDay + app.BHSpace * (iDay - 1);

                    indC1 = 1 + app.BWPix * app.BINPERHR * mask1(i) + fix((mask1(i) * app.BINPERHR -1) / app.BinSep) ;
                    
                    indC2 = app.BWPix * app.BINPERHR * mask2(i) + fix((mask2(i) * app.BINPERHR -1) / app.BinSep);
                end
            end
            %{
            indR1
            indR2
            indC1
            indC2
            %}
            app.cmask(indR1:indR2, indC1:indC2, :) = 0.6;
        end
        
        
    end


    figure(2)
    
    imagesc(app.cmask)
    
end
    