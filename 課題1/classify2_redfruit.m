mk_codebook_redfruit();
list=makelist_redfruit();
code=mk_code(list);
bof_pos=code(:,1:100);
bof_neg=code(:,101:295);

cv=5;
idx_pos=[1:100];
idx_neg=[1:195];

accuracy=[];

for i=1:cv 
    train_pos=bof_pos(:,find(mod(idx_pos,cv)~=(i-1)));
    eval_pos =bof_pos(:,find(mod(idx_pos,cv)==(i-1)));
    train_neg=bof_neg(:,find(mod(idx_neg,cv)~=(i-1)));
    eval_neg =bof_neg(:,find(mod(idx_neg,cv)==(i-1)));

    training_label=[ones(80,1); ones(156,1)*(-1)];
    training_data=[train_pos, train_neg]';
     
    testing_label=[ones(20,1); ones(39,1)*(-1)];
    testing_data=[eval_pos, eval_neg]';
    
    model=fitcsvm(training_data, training_label,'KernelFunction','rbf','KernelScale','auto');
    [plabel,score]=predict(model,testing_data);
     
    pcount=numel(find((plabel .* testing_label)==1));
    ncount=numel(find((plabel .* testing_label)==-1));
     
    accuracy=[accuracy pcount/(pcount+ncount)];
end

fprintf('accuracy: %f\n',sum(accuracy)/cv)