net = alexnet;

list=makelist_redfruit();
IM=[];
accuracy=[];
PosList=list(1:100);   
NegList=list(101:295);
tlist={PosList{:} NegList{:}};

for i=1:length(tlist)
  I = imread(tlist{i});
  I = imresize(I,net.Layers(1).InputSize(1:2)); 
  IM = cat(4,IM,I);
end

dcnnf = activations(net,IM,'fc7');
dcnnf = squeeze(dcnnf);
dcnnf = dcnnf/norm(dcnnf);

data=dcnnf';
data3=repmat(sqrt(abs(data)).*sign(data),[1 3]).*[0.8*ones(size(data)) 0.6*cos(0.6*log(abs(data)+eps)) 0.6*sin(0.6*log(abs(data)+eps))];
data_pos=data3(1:length(PosList),:);
data_neg=data3(length(PosList):length(PosList)+length(NegList),:);

cv=5;
idx_pos=[1:length(PosList)];
idx_neg=[1:length(NegList)];

accuracy=[];

% idx番目(idxはcvで割った時の余りがi-1)が評価データ
% それ以外は学習データ
for i=1:cv 
  train_pos=data_pos(find(mod(idx_pos,cv)~=(i-1)),:);
  eval_pos =data_pos(find(mod(idx_pos,cv)==(i-1)),:);
  train_neg=data_neg(find(mod(idx_neg,cv)~=(i-1)),:);
  eval_neg =data_neg(find(mod(idx_neg,cv)==(i-1)),:);

  train=[train_pos; train_neg];
  eval=[eval_pos; eval_neg];

  train_pos_size=size(train_pos);
  train_pos_size=train_pos_size(1);
  train_neg_size=size(train_neg);
  train_neg_size=train_neg_size(1);
 
  eval_pos_size=size(eval_pos);
  eval_pos_size=eval_pos_size(1);
  eval_neg_size=size(eval_neg);
  eval_neg_size=eval_neg_size(1);
  
  train_label=[ones(train_pos_size,1); ones(train_neg_size,1)*(-1)];
  eval_label =[ones(eval_pos_size,1); ones(eval_neg_size,1)*(-1)];

  model=fitcsvm(train, train_label,'KernelFunction','linear','KernelScale','auto');
  [plabel,score]=predict(model,eval);
  pcount=numel(find((plabel.* eval_label)==1));
  ncount=numel(find((plabel.* eval_label)==-1));
  ac=pcount/(pcount+ncount);

  accuracy=[accuracy ac];
end

fprintf('accuracy: %f\n',sum(accuracy)/cv)