function code=mk_code(list)
 
  load('codebook.mat','codebook');
  load('tlist.mat','tlist');
  k=size(codebook,1);
  dim=size(codebook,2);
  tlist=list;
 
  code=[];
 
  for i=1:length(tlist)
    c=zeros(k,1);
    I=rgb2gray(imread(list{i}));
    fprintf('reading [%d] %s\n',i,tlist{i});
    pnt=detectSURFFeatures(I);
    [fea,vpnt] = extractFeatures(I,pnt);
 
    for j=1:size(fea,1)
      s=zeros(1,k);
      for t=1:dim
        s=s+(codebook(:,t)-fea(j,t)).^2;
      end
      [dist,sidx]=min(s);
      c(sidx,1)=c(sidx,1)+1.0;
    end
    %c=c/sum(c); % BoFベクトルのL1正規化．
    code=[code c];
  end
end