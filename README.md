﻿Proposition d'algo (pas forcément abouti) :

**HARD_DECODER_GROUPE1(c,H,MAX_ITER) :**

%%%
c = vecteur colonne binaire de taille [1,N] -> mot de code en entrée
H = matrice de taille [M,N] binaire (true et false)
MAX_ITER : transparent

sortie : c_cor : vecteur colonne binaire de taille [1,N] issu du décodage
%%%

* *Première étape :* on crée un vecteur de taille N qui représente les valeurs des tests de parité.
	parity(i) = 1 si le test de parité du c_node i est faux,
		    0 si il est vrai.
On l'initialise à 0 pour chaques valeurs.

* *Deuxième étape :* on crée le vecteur c_cor de taille [1,N], identique à c pour le moment.

* *Troisième étape :* on lit chaque ligne de la matrice H.
Pour la ligne i : on effectue un test de parité sur Hi * c de la manière suivante :
	parity(i) = Sum(Hi*c) % 2
On aura donc les valeurs de chaque c_node.

* *Quatrième étape :* 
__Dans l'algorithme présenté sur le papier, les c nodes envoient au v nodes la valeur suivante : (test de parité) XOR (valeur du c node).
Chaque v node aura donc plusieurs valeurs (les différents retours des c nodes et son ancienne valeur) et devra choisir la plus présente parmi elles.__

Pour l'implémentation Matlab :
- lire la colonne j de H (notée Hj)
- calculer le nombre d'occurences d'une valeur à dépasser pour qu'elle soit adoptée : Sum(Hj)/2
- calcul du nombre de "1" :
	nOnes = c_cor(j) %initialisée à 1 si c_cor(j) était égal à 1
	On parcourt Hj avec l'indice i
	if Hj(i) ==1 : nOnes = nOnes + ( parity(i) + c_cor(j) % 2)  
	si nOnes > Sum(Hj)/2 : c_cor(j) = 1, 0 sinon

* *Cinquième étape :*
Test de fin.