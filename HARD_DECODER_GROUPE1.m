
function c_cor = HARD_DECODER_GROUPE1(c,H,MAX_ITER)
  
    %%%
    %c = vecteur colonne binaire de taille [1,N] -> mot de code en entrée
    %H = matrice de taille [M,N] binaire (true et false)
    %MAX_ITER : nombre maximal d'itérations
    %
    %sortie : c_cor : vecteur colonne binaire de taille [1,N] issu du décodage
    %%%
    
   	sizeMatrix = size(H);
    nCheckNodes = sizeMatrix(1); %Il y a autant de checknodes que de lignes dans H
    nVariableNodes = sizeMatrix(2); %Il y a autant de variablenodes que de colonnes dans H
    
    parity = zeros(nCheckNodes); %Matrice de parité : Test de parité des c_nodes
    parity = parity(1,:);
    c_cor = c; %Vecteur sortie
    nIter = 1; %Nombre d'itérations (ne doit pas dépasser MAX_ITER)
    
    majority = (sum(H(:,1)) + 1) / 2;
    %Lors de l'addition des valeurs retournées par les c nodes
    %dans chaque v node, majority est la valeur que cette somme doit
    %dépasser pour que l'on passe la valeur du bit concerné à 1.
    %
    %Cette valeur reste la même pour chaque v_node voir 1.2 dans le papier
    
    while (nIter <= MAX_ITER && mod(sum(c_cor),2) == 1)
        %TANT QUE : Max_iter pas dépassé et test de parité faux
        for i = 1:nCheckNodes
            parity(i) = mod(sum(H(i,:).*c_cor),2); 
            %Test de parité de chaque c_node : 0 si parité, 1 sinon
        end
        
        
        
        for j = 1:nVariableNodes
            nOnes = c_cor(j); %Nombre de 1 retournés par les c_nodes + valeur initiale du v_node
            for i = 1:nCheckNodes
                if H(i,j) == 1 %Si le c_node est lié au v_node
                    %Prise en compte de sa valeur :
                    nOnes = nOnes + mod(parity(i) + c_cor(j),2);
                    %On ajoute la valeur retournée par le c_node.
                end
            end
            %Si nOnes > majority : le v_node a reçu plus de 1 que de 0, il
            %faut donc passer sa valeur à 1. 0 sinon.
            if nOnes > majority
                c_cor(j) = 1;
            else
                c_cor(j) = 0;
            end
        end
        nIter = nIter + 1;
    end
    
    return;
    
end
