mk_codebook_ramenother();
list=makelist_ramenother();
code=mk_code(list);
bof_pos=code(:,301:450);
bof_neg=code(:,1:300);

cv=5;
idx_pos=[1:150];
idx_neg=[1:300];

accuracy=[];

for i=1:cv 
    train_pos=bof_pos(:,find(mod(idx_pos,cv)~=(i-1)));
    eval_pos =bof_pos(:,find(mod(idx_pos,cv)==(i-1)));
    train_neg=bof_neg(:,find(mod(idx_neg,cv)~=(i-1)));
    eval_neg =bof_neg(:,find(mod(idx_neg,cv)==(i-1)));

    training_label=[ones(120,1); ones(240,1)*(-1)];
    training_data=[train_pos, train_neg]';
     
    testing_label=[ones(30,1); ones(60,1)*(-1)];
    testing_data=[eval_pos, eval_neg]';
    
    model=fitcsvm(training_data, training_label,'KernelFunction','rbf','KernelScale','auto');
    [plabel,score]=predict(model,testing_data);
     
    pcount=numel(find((plabel .* testing_label)==1));
    ncount=numel(find((plabel .* testing_label)==-1));
     
    accuracy=[accuracy pcount/(pcount+ncount)];
end

fprintf('accuracy: %f\n',sum(accuracy)/cv)