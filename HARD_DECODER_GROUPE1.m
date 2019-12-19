
function c_cor = HARD_DECODER_GROUPE1(c,H,MAX_ITER)
  
    %%%
    %c = vecteur colonne binaire de taille [1,N] -> mot de code en entree
    %H = matrice de taille [M,N] binaire (true et false)
    %MAX_ITER : nombre maximal d'iterations
    %
    %sortie : c_cor : vecteur colonne binaire de taille [1,N] issu du decodage
    %%%
    
    %Entr�es = colonnes. On transpose le tout. (sinon erreur ligne 31)
    c = c';
    
   	sizeMatrix = size(H);
    nCheckNodes = sizeMatrix(1); %Il y a autant de checknodes que de lignes dans H
    nVariableNodes = sizeMatrix(2); %Il y a autant de variablenodes que de colonnes dans H
    
    parity = zeros(nCheckNodes); %Matrice de parite : Test de parite des c_nodes
    parity = parity(1,:);
    c_cor = c; %Vecteur sortie
    nIter = 1; %Nombre d'iterations (ne doit pas depasser MAX_ITER)
    
    majority = zeros(nCheckNodes,1);
    %Lors de l'addition des valeurs retournees par les c nodes
    %dans chaque v node j, majority(j) est la valeur que cette somme doit
    %depasser pour que l'on passe la valeur du bit concerne a 1.
    %Les matrices pouvant etre irregulieres, il faut calculer majority pour
    %chaque v_node !
    
    for j = 1:nVariableNodes
       majority(j) = (sum(H(:,j)) + 1) / 2; 
    end
    
    
    while (nIter <= MAX_ITER && mod(sum(c_cor),2) == 1)
        %TANT QUE : Max_iter pas depasse et test de parite faux
        for i = 1:nCheckNodes
            parity(i) = mod(sum(H(i,:).*c_cor),2); 
            %Test de parite de chaque c_node : 0 si parite, 1 sinon
        end
        
        
        
        for j = 1:nVariableNodes
            nOnes = c_cor(j); %Nombre de 1 retournes par les c_nodes + valeur initiale du v_node
            for i = 1:nCheckNodes
                if H(i,j) == 1 %Si le c_node est lie au v_node
                    %Prise en compte de sa valeur :
                    nOnes = nOnes + mod(parity(i) + c_cor(j),2);
                    %On ajoute la valeur retournee par le c_node.
                end
            end
            %Si nOnes > majority : le v_node a recu plus de 1 que de 0, il
            %faut donc passer sa valeur a 1. 0 sinon.
            if nOnes > majority(j)
                c_cor(j) = 1;
            else
                c_cor(j) = 0;
            end
        end
        nIter = nIter + 1;
    end
       
    %On transpose une derniere fois c_cor afin de correspondre a la
    %signature demandee
    c_cor = c_cor';
    return;
    
end
