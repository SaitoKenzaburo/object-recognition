function [desc codebook]=mk_codebook_red()
 
  k=500;
 
  list=makelist_redfruit();
  PosList=list(1:100);   
  NegList=list(101:295);
  tlist={PosList{:} NegList{:}};
 
  % 200枚の画像からSURF特徴をdetectSURFFeaturesとextractFeaturesで抽出．
  features=[];
  for i=1:length(tlist)
    I=rgb2gray(imread(tlist{i}));
    % fprintf('reading [%d] %s\n',i,tlist{i});
    % pnt=detectSURFFeatures(I);
    pnt=createRandomPoints(I,1000); % dense sampling を使う場合
    [fea,vpnt] = extractFeatures(I,pnt);
    features=[features; fea];
  end
 
  size(features)
  [index, codebook]=kmeans(features,k); % クラスタ中心がvisual wordになります．
  size(codebook)
  % codebook を save します．
  save('codebook.mat','codebook');
  % ついでに 学習に用いる 画像リストtlist も save しておきます．
  save('tlist.mat','tlist');
end