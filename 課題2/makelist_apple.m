function list=makelist_apple()
  n=0; list={};
  LIST={'apple_train' 'apple_eval'};
  DIR0='';
  for i=1:length(LIST)
    DIR=strcat(DIR0,LIST(i),'/');
    W=dir(DIR{:});
    for j=1:size(W)
      if (strfind(W(j).name,'.jpg'))
        fn=strcat(DIR{:},W(j).name);
        n=n+1;
        list={list{:} fn};
      end
    end
  end
end