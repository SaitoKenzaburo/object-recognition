%画像データセットの取得
list=textread('ramenurllist.txt','%s');
OUTDIR='ramendir';
mkdir(OUTDIR);
for i=1:size(list,1)
  fname=strcat(OUTDIR,'/',num2str(i,'%04d'),'.jpg');
  websave(fname,list{i});
end

list=textread('appleurllist.txt','%s');
OUTDIR='appledir';
mkdir(OUTDIR);
for i=1:size(list,1)
  fname=strcat(OUTDIR,'/',num2str(i,'%04d'),'.jpg');
  websave(fname,list{i});
end

list=textread('strawberryurllist.txt','%s');
OUTDIR='strawberrydir';
mkdir(OUTDIR);
for i=1:size(list,1)
  fname=strcat(OUTDIR,'/',num2str(i,'%04d'),'.jpg');
  websave(fname,list{i});
end