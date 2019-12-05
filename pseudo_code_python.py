# -*- coding: utf-8 -*-

def multiplyList(myList) :

    # Multiply elements one by one
    result = 1
    for x in myList:
         result = result * x
    return result

def HARD_DECODER_GROUPE1(c,H,MAX_ITER):
    """
    c = vecteur colonne binaire de taille [1,N] -> mot de code en entrée
    H = matrice de taille [M,N] binaire (true et false)
    MAX_ITER : transparent

    sortie : c_cor : vecteur colonne binaire de taille [1,N] issu du décodage
    """
    parity = [0 for i in H] #Vecteur parité, donne la valeur du test de parité de chaque c_node
    #(INITIALISÉE À 0)
    c_cor = c #Vecteur sortie
    nIter = 1

    #Calcul de la valeur de "1" examinés par le v_node à dépasser pour supposer
    #Que le 1 a la majorité. En dessous, c'est 0.
    majority = (sum([H[0][j] for j in range(len(H))]) + 1 ) / 2

    while sum(c_cor)%2 == 1 and nIter <= MAX_ITER:
        #print("\nITERATION NUMERO {}\n\n".format(nIter))
        for i in range(len(H)):
            parity[i] = sum([H[i][j] * c[j] for j in range(len(H[i]))]) % 2
        #print(parity)
        #A ce stade, on a les valeurs de chaque test de parité (1=impair, 0=pair)


        #Chaque colonne représente les c_nodes associés à chaque bit.
        #On calcule donc le nombre de "1" retournés par les c_nodes
        #Nous lisons colonne par colonne.
        for j in range(len(H[0])):
            #print("\nCalcul pour le bit " + str(j))
            nOnes = c_cor[j]
            #print("   Valeur de base : " + str(nOnes))
            #Parcours de la colonne avec vérification des c_nodes
            for i in range(len(H)):
                if H[i][j] == 1 :
                    nOnes += (parity[i] + c_cor[j]) % 2
                    #print("   Valeur après retour du c_node {} (= {}) : {}".format(i,parity[i],nOnes))
            if nOnes > majority:
                c_cor[j] = 1
            else:
                c_cor[j] = 0

        nIter +=1
        #print(c_cor)
        #Test de parité de fin

    return c_cor

def SOFT_DECODER_GROUPE1(c,H,MAX_ITER,p):
    """
    c = vecteur colonne binaire de taille [1,N] -> mot de code en entrée
    H = matrice de taille [M,N] binaire (true et false)
    p = vecteur des probabilités tq p(i) = proba que c(i) = 1
    MAX_ITER : transparent

    sortie : c_cor : vecteur colonne binaire de taille [1,N] issu du décodage
    """
    c_cor = c #Vecteur sortie
    nIter = 1
    Q1 = [p for j in range(len(H))] #Messages du v_node i-> c_node j (Q[i][j] = qij(1))
    R1 = [[] for i in range(len(H[0]))] #Messages du c_node j-> v_node i (R[j][i] = rji(1))

    while sum(c_cor)%2 == 1 and nIter <= MAX_ITER:
        #Calcul des messages de réponse
        for j in range(H):
            for i in range(H[0]):
                R1[j][i] = 1 - (0.5 + 0.5* multiplyList([(1 - 2 * Q1[iPrime][j] for iPrime in range(H[0]).pop(i))]))
                #La ligne du dessus exécute l'équation (4) du papier.
                #range(H[0]).pop(i) = liste de tous les i possibles sauf le i actuel

        #Mise à jour des messages des v_nodes
        for i in range(H[0]):
            for j in range(H):
                Q1[i][j] = p[i] * multiplyList([R1[jprime][i] for jPrime in range(H).pop(j)])
                #Calcul de qij(0), nécessaire pour "pondérer" la valeur calculée au dessus
                q0 = (1 - p[i]) * multiplyList([(1 - R1[jprime][i]) for jPrime in range(H).pop(j)])
                Q1[i][j] = Q1[i][j] / (Q1[i][j] + q0)

        #Pour chaque bit, calculer les probabilités pour la détection :
        for i in range(c):
            q0 = (1 - p[i]) * multiplyList([(1 - R1[j][i]) for j in range(H)])
            q1 = p(i) * multiplyList([R1[j][i] for j in range(H)])
            if q1>q0:
                c_cor[i] = 1
            else:
                c_cor[i] = 0

        nIter += 1

    return c_cor


H = [[0,1,0,1,1,0,0,1],
     [1,1,1,0,0,1,0,0],
     [0,0,1,0,0,1,1,1],
     [1,0,0,1,1,0,1,0]]
c = [1,1,0,1,0,1,0,1]
c_correct = [1,0,0,1,0,1,0,1]
p = [0.8, 0.55, 0.2, 0.75, 0.3, 0.9, 0.15, 0.79]
MAX_ITER = 10

print(HARD_DECODER_GROUPE1(c,H,MAX_ITER))
print(SOFT_DECODER_GROUPE1(c,H,MAX_ITER,p))
