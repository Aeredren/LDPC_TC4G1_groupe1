function c_cor = SOFT_DECODER_GROUPE1(c,H,p,MAX_ITER)

    %%%
    %c = vecteur colonne binaire de taille [1,N] -> mot de code en entree
    %H = matrice de taille [M,N] binaire (true et false)
    %MAX_ITER : nombre maximal d'iterations
    %p : probabilites tq p(i) est la probabilite que c(i) = 1
    %
    %sortie : c_cor : vecteur colonne binaire de taille [1,N] issu du decodage
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
    
    %On fera varier i et j de manière a ce que :
    %   - i reprï¿½sente les v_nodes
    %   - j reprï¿½sente les c_nodes
    
    produit1 = 1;
    produit2 = 1;
    %Ces variables seront utilisees pour calculer des produits
    
    c_cor = c;
    nIter = 1;
    
    %Initialement, Q1(i,j) = qij(1) = Pi, a defaut d'informations
    for i = 1:nVariableNodes    
        for j = 1:nCheckNodes
            Q1(i,j) = p(i); 
        end
    end
    
    while(nIter <= MAX_ITER && mod(sum(c_cor),2) == 1)
        %TANT QUE : Max_iter pas depasse et test de parite faux
        
        %Calcul des messages envoyes des c_nodes aux v_nodes
        for j = 1:nCheckNodes
            for i = 1:nVariableNodes
                if H(j,i) == 1 %Si le c_node est lie au v_node
                    produit1 = 1; %initialisation des produits
                    for iprime = setdiff(1:nVariableNodes,i) %pour chaque iprime different de i
                        produit1 = produit1 * (1-2*Q1(iprime,j));  %produit1 = PI(1-2p(iprime)) 
                    end
                    R1(j,i) = 1 - (0.5 + 0.5 * produit1); 
                    %on change la probabilite de liaison du c_node j au v_node i 
                    %dans la matrice de messages envoyes des c_nodes au v_nodes
                end
            end
        end
        
        %Calcul des messages envoyes des v_nodes aux c_nodes
        for i = 1:nVariableNodes
            for j = 1:nCheckNodes
                if H(j,i) == 1  %Si le c_node est lie au v_node
                    produit1 = 1; %initialisation des produits
                    produit2 = 1;
                    for jprime = setdiff(1:nCheckNodes,j)  %pour chaque jprime different de j
                       produit1 = produit1 * (R1(jprime,i)); %produit1 = PI(R1(jprime,i))
                       produit2 = produit2 * (1 - R1(jprime,i)); %produit2 = PI(1-R1(jprime,i))
                    end
                    Q1(i,j) = p(i) * produit1;
                    %Calcul de qij(0), necessaire pour ponderer la valeur 
                    %calculee au dessus
                    q0 = (1 - p(i)) * produit2;
                    Q1(i,j) = (Q1(i,j)/(Q1(i,j) + q0));
                end
            end
        end

        %Calcul des probabilites pour la detection
        for i = 1:nVariableNodes
            produit1 = 1;
            produit2 = 1;
            for j = 1:nCheckNodes
                if H(j,i) == 1  %Si le c_node est lie au v_node
                    produit1 = produit1 * (R1(j,i)); 
                    %Produit1 vaut la probabilite d'un 1 envoye par le v_node au c_node
                    produit2 = produit2 * (1 - R1(j,i));
                    %Produit2 vaut la probabilite d'un 0 envoye par le v_node au c_node
                end
            end
            q1 = p(i) * produit1; 
            %q1 vaut la probabilite que le v_node=1 multiplie par la probabilite
            %que le v_node ait transmis un 1 au c_node
            q0 = (1 - p(i)) * produit2;
            %q0 vaut la probabilite que le v_node=0 multiplie par la probabilite
            %que le v_node ait transmis un 0 au c_node
            if q1 > q0 
                c_cor(i) = 1; %si q1>q0, on deduit que le bit vaut 1
            else
                c_cor(i) = 0; %sinon, il vaut 0
            end
        end
        
        nIter = nIter+1; %on met a jour l'iteration
    end 
    return;
end
