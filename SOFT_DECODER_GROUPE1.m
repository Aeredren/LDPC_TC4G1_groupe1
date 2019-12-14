function c_cor = SOFT_DECODER_GROUPE1(c,H,p,MAX_ITER)

    %%%
    %c = vecteur colonne binaire de taille [1,N] -> mot de code en entrée
    %H = matrice de taille [M,N] binaire (true et false)
    %MAX_ITER : nombre maximal d'itérations
    %p : probabilités tq p(i) est la probabilité que c(i) = 1
    %
    %sortie : c_cor : vecteur colonne binaire de taille [1,N] issu du décodage
    %%%

   	sizeMatrix = size(H);
    nCheckNodes = sizeMatrix(1); %Il y a autant de checknodes que de lignes dans H
    nVariableNodes = sizeMatrix(2); %Il y a autant de variablenodes que de colonnes dans H
    
    Q1 = zeros(nVariableNodes,nCheckNodes);
    %Q1 est la matrice contenant les messages des v_nodes au c_nodes
    %messages du v_node i-> c_node j (Q(i,j) = qij(1))
    
    R1 = zeros(nCheckNodes,nVariableNodes);
    %Q1 est la matrice contenant les messages des c_nodes au v_nodes
    %messages du c_node j-> v_node i (R(j,i) = rji(1))    
    
    %On fera varier i et j de mani�res � ce que :
    %   - i repr�sente les v_nodes
    %   - j repr�sente les c_nodes
    
    produit1 = 1;
    produit2 = 1;
    %Ces variables seront utilisées pour calculer des produits
    
    c_cor = c;
    nIter = 1;
    
    %Initialement, Q1(i,j) = qij(1) = Pi, a defaut d'informations
    for i = 1:nVariableNodes    
        for j = 1:nCheckNodes
            Q1(i,j) = p(i);
        end
    end
    
    while(nIter <= MAX_ITER && mod(sum(c_cor),2) == 1)
        %TANT QUE : Max_iter pas dépassé et test de parité faux
        
        %Calcul des messages envoyés des c_nodes aux v_nodes
        for j = 1:nCheckNodes
            for i = 1:nVariableNodes
                if H(j,i) == 1
                    produit1 = 1;
                    for iprime = setdiff(1:nVariableNodes,i)
                        produit1 = produit1 * (1-2*Q1(iprime,j));
                    end
                    R1(j,i) = 1 - (0.5 + 0.5 * produit1);
                end
            end
        end
        
        %Calcul des messages envoyés des v_nodes aux c_nodes
        for i = 1:nVariableNodes
            for j = 1:nCheckNodes
                if H(j,i) == 1
                    produit1 = 1;
                    produit2 = 1;
                    for jprime = setdiff(1:nCheckNodes,j)
                       produit1 = produit1 * (R1(jprime,i));
                       produit2 = produit2 * (1 - R1(jprime,i));
                    end
                    Q1(i,j) = p(i) * produit1;
                    %Calcul de qij(0), nécessaire pour pondérer la valeur 
                    %calculée au dessus
                    q0 = (1 - p(i)) * produit2;
                    Q1(i,j) = (Q1(i,j)/(Q1(i,j) + q0));
                end
            end
        end

        %Calcul des probabilités pour la détection
        for i = 1:nVariableNodes
            produit1 = 1;
            produit2 = 1;
            for j = 1:nCheckNodes
                if H(j,i) == 1
                    produit1 = produit1 * (R1(j,i));
                    produit2 = produit2 * (1 - R1(j,i));
                end
            end
            q1 = p(i) * produit1;
            q0 = (1 - p(i)) * produit2;
            if q1 > q0
                c_cor(i) = 1;
            else
                c_cor(i) = 0;
            end
        end
        
        nIter = nIter+1;
    end 
    return;
end
