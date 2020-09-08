function [app] = custommask(app) 
    % custom mask

    app.fmask = './data/7/runner7mask.csv';
    app = readMaskCSV(app, app.fmask);
    [ad, ~] = size(app.MaskCSV{1});
    [apic, bpic, ~] = size(actopic);
    cmask = ones(apic, bpic, 3);
    somedate = yyyymmdd(app.MaskCSV{:, 1});
    mask1 = hours(app.MaskCSV{:, 2});
    mask2 = hours(app.MaskCSV{:, 3});


    for i = 1:ad
        iDay = find(somedate(i) == app.dayNum);

        rind1 = 1 + app.BHPix * (iDay-1) + app.BHSpace * (iDay - 1);
        if iDay == app.dayLen  
            rind2 = app.BHPix * iDay + app.BHSpace * (iDay - 1);
        else
            rind2 = app.BHPix * iDay + app.BHSpace * iDay;
        end

        if app.BinSep
            cind1 = 1 + app.BWPix * app.BINPERHR * mask1(i) + floor(app.SPACEPERHR * mask1(i) * app.BWSpace);
            if mask2(i) == 24
                cind2 = 1 + app.BWPix * app.BINPERHR * mask2(i) + floor(app.SPACEPERHR * mask2(i) * app.BWSpace) - 2;
            else
                cind2 = 1 + app.BWPix * app.BINPERHR * mask2(i) + floor(app.SPACEPERHR * mask2(i) * app.BWSpace);
            end


        else
            rind1 = 1 + app.BWPix * app.BINPERHR * mask1(i);
            rind2 = 1 + app.BWPix * app.BINPERHR * mask2(i);
        end

        cind1
        cind2
        cmask(rind1:rind2, cind1:cind2, :) = 0.6;

    end


    figure(2)
    %imshow(actopic)
    imagesc(cmask)
end
    