dsa_pub = [Mod(16, 2359457956956300567038105751718832373634513504534942514002305419604815592073181005834416173), 589864489239075141759526437929708093408628376133735628500576354901203898018295251458604043, 2028727269671031475103905404250865899391487240939480351378663127451217489613162734122924934];
check(s,dsa_pub) = {
  my(h,r,g,q,X);
  [h,r,s] = s;
  [g,q,X] = dsa_pub;
  lift( (g^h*X^r)^(1/s % q) ) % q == r;
}

/*On va tenter une attaque par collision. Si on ne la trouve pas dans les signatures fournies, 
on testera des valeurs supplémentaires de k */

/*On aura recours à des tables de hashage*/

sig = readvec("input.txt");
[g,q,X] = dsa_pub;
p = g.mod;

coll_search() = {
  map = Map();
  test = 0;
  for(i = 1, #sig,
    if(mapisdefined(map,sig[i][2]),[h,r,s] = mapget(map,sig[i][2]); test =1; break);
    mapput(map, sig[i][2], sig[i])
  );
  while(test==0, 
    k = random(10^10-1)+1; 
    rk = lift(Mod(lift(g^k),q));
    if(mapisdefined(map,rk),[h,r,s] = mapget(map,rk); test =1)
  );
  X = Mod(lift((s*k-h)*r^(-1)),q);
  print(lift(X));
}

coll_search();
