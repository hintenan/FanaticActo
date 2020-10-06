
path('/Users/hintenan/Documents/MATLAB/FanaticActo/lib', path)
app = [];
app.apppath = './';

prompt = {'Cage NO.:', 'Bins Per Hour:', 'Light Hour', 'Dark Hour', 'First Day', 'Last Day', 'CustomMask'};
dlgtitle = 'Input';
dims = [1 35];
definput = {'11', '12', '0', '11', '1', '2', '0'};
InDia = inputdlg(prompt,dlgtitle,dims,definput); % cageNO., BINPERHOUR, L, D, STARTDAY, ENDDAY
fprintf("Cage NO.: %s\nBins / Hour: %s\nLight Hour: %s", InDia{1}, InDia{2}, InDia{3})

tic
% read file
CHAMBERKEY = str2double(InDia{1});
app.fm = ['./data/' num2str(CHAMBERKEY) '/runner' num2str(CHAMBERKEY) '.csv'];
app.maskfm = ['./mask/' num2str(CHAMBERKEY) '/runner' num2str(CHAMBERKEY) 'mask.csv'];
app = readActoCSV(app, CHAMBERKEY, './data');
% end of read file
toc

tic
% graphic para
app.LOCALGMT = 8;
app.TIMESHIFT = 0;
app.HRPERDAY = 24;

app.BINPERHR = 12;
app.MINPERBIN = 60/app.BINPERHR;
app.BINHALFHR = app.BINPERHR/2;
app.BINPERDAY = app.BINPERHR * app.HRPERDAY;

app.BHPix = 50;
app.BHSpace = 3;
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

app.LDMask = 0;
% Color
app.ColorSample = 0;
        
app = data2Hist(app);
app = hist2Graph(app);
toc


HourPerTick = 2;
tic
app = fastTick(app, HourPerTick);
toc

% tick



figure(2)
imagesc(app.actopic)
%imagesc(actopic(app.y1Truncat(app.firstDay):app.y2Truncat(end), :, :))
xticks(app.xt)
xticklabels(app.xtl)

truesize
%colormap(gray)


%}
