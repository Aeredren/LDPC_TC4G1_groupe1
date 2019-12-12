function c_cor = SOFT_DECODER_GROUPE(c,H,p,MAX_ITER)
produit1 = 1;
produit2 = 1;
produit3 = 1; 
c_cor = c;
nIter = 1;
for j = 1:length(H)+1
    Q1(j;) = p;
    j = j+1;
end
for i = 1:length(H[0])+1
    R1(1;) = [];
end
while(nIter <= MAX_ITER & mod(sum(c_cor),2) ==1)
    
    for j = 1:L
        for i = 1:n
            for iprime = setdiff(1:n,i)
                produit1 = (produit1 * (1-2*Q1(iprime;j)));
            end
            R1(j;i) = (1 - (0.5 + (0.5 * produit)));
        end
    end
    for i = 1:n
        for j = 1:L
             for jprime = setdiff(1:L,j)
                produit2 = (produit2 * (R1(jprime;i)));
                produit3 = (produit3 * (1 - R1(jprime;i)));
             end
             Q1(i;j) = p[i] * produit2;
             q0 = (1 - (p[i] * produit3));
             Q1(i;j) = (Q1(i;j)/(Q1(i;j) + q0));
        end
    end
    
    
    for i = 1:n
        %for jprime = setdiff(1:L,j)
        produit4 = (produit4*(R1(j;i)));
        produit5 = (produit5*(1 - R1(j;i)));
        end
        
        q0 = (1 - (p[i] * produit5));
        Q1(i;j) = p[i] * produit4;
        
        if Q1>q0;
      
           c_cor(i)=1;
        else
            c_cor(i)=0;
            
        nIter = nIter+1;
           
          
  
endfunction