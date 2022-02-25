%画像データセットの取得
list=textread('appleurllist.txt','%s');
OUTDIR='apple_train';
mkdir(OUTDIR);
for i=1:(size(list,1)/4)
  fname=strcat(OUTDIR,'/',num2str(i,'%04d'),'.jpg');
  websave(fname,list{i});
end

opt=weboptions('Timeout',10);
list=textread('apple_noise.txt','%s');
OUTDIR='apple_eval';
mkdir(OUTDIR);
for i=1:size(list,1)
  fname=strcat(OUTDIR,'/',num2str(i,'%04d'),'.jpg');
  websave(fname,list{i},opt);
end