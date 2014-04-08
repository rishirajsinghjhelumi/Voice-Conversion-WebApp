function Fcon(target, source, output)

Ft=load(target);
Fs=load(source);
tempt=Ft(find(Ft(:,1)~=0));
temps=Fs(find(Fs(:,1)~=0));

Ut=sum(log(tempt))/size(tempt,1);
Us=sum(log(temps))/size(temps,1);

Vt=var(log(tempt));
Vs=var(log(temps));

logFt=Ut+(Vt/Vs)*(log(Fs(:,1))-Us);

Fconv=exp(logFt);

fid=fopen([output],'w');
fprintf(fid,'%f\n',[Fconv]);
fclose(fid);

end
