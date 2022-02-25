function list=makelist_ramenother
  n=0; list={};
  LIST={'bgimg' 'ramendir'};
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
    if i==1
        list=list(randperm(1000,300));
    end
  end
end