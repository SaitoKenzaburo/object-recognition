list=makelist_ramenother;
cv=5;
accuracy=[];
idx_pos=[301:450];
idx_neg=[1:300];

for h=1:cv

    train_pos=list(find(mod(idx_pos,cv)~=(h-1)));
    eval_pos =list(find(mod(idx_pos,cv)==(h-1)));
    train_neg=list(find(mod(idx_neg,cv)~=(h-1)));
    eval_neg =list(find(mod(idx_neg,cv)==(h-1)));

    train=[train_pos, train_neg];
    eval=[eval_pos, eval_neg];

    database=makedb(list);
    % listとdatabaseをファイルに出力する．
    save('list.mat','list');
    save('db.mat','database');
     
    load('list.mat');
    load('db.mat');
    
    accuracy_count=0;
     
    for i=1:length(eval)
        query=database(i,:);
        sim=[];  
        for j=1:size(database,1)  % databaseの行数が画像枚数
          sim=[sim sum(min(database(j,:),query))];  % インターセクション値を求める．
        end
        [sorted,index]=sort(sim,'descend'); 
        %最もインターセクション値が高くて１でない画像が正しく分類されるか検証
        if (i<=30&&index(2)<=120)||(i>30&&index(2)>120)
            accuracy_count=accuracy_count+1;
        end
    end
    accuracy=[accuracy accuracy_count/length(eval)];
end

fprintf('accuracy: %f\n',sum(accuracy)/cv)