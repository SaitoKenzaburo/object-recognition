function database=makedb(list)
database=[];
for j=1:length(list)
  l=list{j};
  I=imread(list{j});
  R=I(:,:,1);
  G=I(:,:,2);
  B=I(:,:,3);
  X64= floor(double(R)/64) *4*4 +  floor(double(G)/64) *4 +  floor(double(B)/64);
  X64_vec=reshape(X64,1,numel(X64));
  h=histc(X64_vec,[0:63]);
  h=h / sum(h);
 
  database=[database; h];
end