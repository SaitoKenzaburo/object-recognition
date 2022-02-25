net = alexnet;

n=50;
list_apple=makelist_apple();
list_neg=makelist_neg();
IM=[];
eIM=[];
accuracy=[];
PosList=list_apple(1:n);
NegList=list_neg;
tlist={PosList{:} NegList{:}};
elist=list_apple(51:350);

%学習用データ
for i=1:length(tlist)
  I = imread(tlist{i});
  I = imresize(I,net.Layers(1).InputSize(1:2)); 
  IM = cat(4,IM,I);
end
dcnnf = activations(net,IM,'fc7');
dcnnf = squeeze(dcnnf);
dcnnf = dcnnf/norm(dcnnf);
training_label=[ones(n,1); ones(500,1)*(-1)] ;
data=dcnnf';
data3=repmat(sqrt(abs(data)).*sign(data),[1 3]).*[0.8*ones(size(data)) 0.6*cos(0.6*log(abs(data)+eps)) 0.6*sin(0.6*log(abs(data)+eps))];
training_data=data3;

%テスト用データ
for i=1:length(elist)
  eI = imread(elist{i});
  eI = imresize(eI,net.Layers(1).InputSize(1:2)); 
  if ndims(eI)==3
    eIM = cat(4,eIM,eI);
  end
end
dcnnf = activations(net,eIM,'fc7');
dcnnf = squeeze(dcnnf);
dcnnf = dcnnf/norm(dcnnf);
data=dcnnf';
data3=repmat(sqrt(abs(data)).*sign(data),[1 3]).*[0.8*ones(size(data)) 0.6*cos(0.6*log(abs(data)+eps)) 0.6*sin(0.6*log(abs(data)+eps))];
testing_data=data3;
 
% liner を使います．
model=fitcsvm(training_data, training_label,'KernelFunction','linear','KernelScale','auto');
[label,score]=predict(model,testing_data);

% 降順 ('descent') でソートして，ソートした値とソートインデックスを取得します．
[sorted_score,sorted_idx] = sort(score(:,2),'descend');

%上位100枚を出力
for i=1:100
  s=sorted_idx(i);
  fprintf('%s %f\n',list{s},sorted_score(i));
end

for i=1:100
  s=sorted_idx(i);
  fprintf('%d\n',s);
end