/*Probleme du Taquin*/

etatInitialT([[b,h,c],[a,f,d],[g,o,e]]).
etatFinalT([[a,b,c],[h,o,d],[g,f,e]]).
/*gauche*/
operateurT(gauche,Ect,Est):-horiz_mouv(X,o,Ect,Est).
/*droite*/
operateurT(droite,Ect,Est):-horiz_mouv(o,X,Ect,Est).
/*operateur bas */
operateurT(bas,Ect,Est):-vertical_mouv(o,X,Ect,Est).
/*operateur haut*/
operateurT(haut,Ect,Est):-vertical_mouv(X,o,Ect,Est).


/*predicat qui echange deux elements X et Y dans une liste donnee*/
echange(X,Y,[X,Y|L],[Y,X|L]).
echange(X,Y,[Z|L1],[Z|L2]):-echange(X,Y,L1,L2).

/*fonctionne parfaitement*/
horiz_mouv(X,Y,Ect,Est):-append(Agauche,[Ligne1|Adroite],Ect),
					   echange(X,Y,Ligne1,Ligne2),
					   append(Agauche,[Ligne2|Adroite],Est).
/*predicat qui supprime X dans une liste et stock sa position dans N*/
suppr(1,X,[X|L],L).
suppr(N,X,[Y|L],[Y|R]):- suppr(N1,X,L,R),
						 N is N1 + 1.

/*fonctionne parfaitement*/
vertical_mouv(X,Y,Ect,Est):-append(Audessus,[Ligne1,Ligne2|Endessous],Ect),
						  suppr(N,X,Ligne1,Rest1),
						  suppr(N,Y,Ligne2,Rest2),
						  suppr(N,Y,Ligne3,Rest1),
						  suppr(N,X,Ligne4,Rest2),
						  append(Audessus,[Ligne3,Ligne4|Endessous],Est).

/*predicat recherche pour Taquin*/
/*le probleme vient d'ici*/					 

/* Etat pour arreter le code au bout de 60*/
/*rechercheT(_,_,_,[],X) :- X == 60,!.*/


/*rechercheT(Eft,Eft,_,[],_) :- !.*/
rechercheT(Eft,Eft,_,[],_) :- !. 
rechercheT(Ect,Eft,Ltt,[Opt|Lopt],X) :- operateurT(Opt,Ect,[A,B,C]),
									  not(member([A,B,C],Ltt)),
									  print(X),print(' '),print(Opt),print(' '),nl,print(A),nl,print(B),nl,print(C),nl,
									  X1 is X+1,
									  rechercheT([A,B,C],Eft,[[A,B,C]|Ltt],Lopt,X1).

resoudreT(Solt) :- etatInitialT(Eit), etatFinalT(Eft),
				   rechercheT(Eit,Eft,[Eit],Solt,0).

/*rechercheT+ -> amelioration de la recherche en profondeur*/

/*predicat test qui va appliquer les 4 operateurs et verfier si la sortie est etat final*/

test(Ectt,Estt):-operateurT(gauche,Ectt,Estt),
				  etatFinalT(Estt),
				  rechercheT+(Ectt,Eftt,Ltt,[gauche|Loptt],X).

test(Ectt,Estt):-operateurT(droite,Ectt,Estt),
				  etatFinalT(Estt),
				  rechercheT+(Ectt,Eftt,Ltt,[droite|Loptt],X).

test(Ectt,Estt):-operateurT(bas,Ectt,Estt),
				  etatFinalT(Estt),
				  rechercheT+(Ectt,Eftt,Ltt,[bas|Loptt],X).
test(Ectt,Estt):-operateurT(haut,Ectt,Estt),
				  etatFinalT(Estt),
				  rechercheT+(Ectt,Eftt,Ltt,[haut|Loptt],X).

/*sinon on applique le premier operateur appliquable*/
rechercheT+(Eftt,Eftt,_,[],_) :- !.  

/*si test renvoie true*/
rechercheT+(Ectt,Eftt,Ltt,[Optt|Loptt],X):- test(Ectt,Estt),
										   operateurT(Optt,Ectt,[A,B,C]),
										   not(member([A,B,C],Ltt)),
										   print(X),print(' '),print(Optt),print(' '),nl,print(A),nl,print(B),nl,print(C),nl,
										   X1 is X+1, 
/*sinon */									   rechercheT+([A,B,C],Eftt,[[A,B,C]|Ltt],Loptt,X1).
rechercheT+(Ectt,Eftt,Ltt,[Optt|Loptt],X):- not(test(Ectt,Estt)),
										   operateurT(Optt,Ectt,[A,B,C]),
										   not(member([A,B,C],Ltt)),
										   print(X),print(' '),print(Optt),print(' '),nl,print(A),nl,print(B),nl,print(C),nl,
										   X1 is X+1,
										   rechercheT+([A,B,C],Eftt,[[A,B,C]|Ltt],Loptt,X1).

resoudreT+(Soltt) :- etatInitialT(Eitt), etatFinalT(Eftt),
				   rechercheT+(Eitt,Eftt,[Eitt],Soltt,0).


/*Heuristique*/

/*renvoie la distance entre l'etat actuel et l'etat final*/

distance(Etct,Etft,X):- 
			  diff_etats(Etct,Etft,X).

/*distance entre deux etats*/
diff_etats([],[],0).
diff_etats(E1,E2,Diff):- E1 = [L1|R1], /*on recupere la premiere ligne de la grille*/
						 E2 = [L2|R2], /* idem pour la deuxieme grille*/
						 diff_lignes(L1,L2,Diffl),
						 diff_etats(R1,R2,Dres),
						 Diff is Diffl + Dres.
/*distance entre 2 lignes*/
diff_lignes([],[],0).
diff_lignes(L1,L2,Diffl):- L1 = [E1|R1],/*on recupere le 1 er element de La ligne*/
						   L2 = [E2|R2],/*idem pour la 2 eme ligne */
						   diff_cases(E1,E2,Diffc),
						   diff_lignes(R1,R2,Dres),
						   Diffl is Diffc+Dres.
/*test 2 cases */
diff_cases(o,E,0). /*si une case vide*/
diff_cases(E,E,0):- E \= o.
diff_cases(E1,E2,1):-E1 \= o,E1 \= E2. /*on ajoute 1 si ils sont differents l'un de l'autre et differents de vide*/


/*Preedicat de recherche */


rechercheTT(Etft,Etft,_,_,[],_)	:- !.

rechercheTT(Etct,Etft,Ltt,Ldistance,[Optt|Lopttt],X):- operateurT(gauche,Etct,[A,B,C]),
 										 not(member([A,B,C],Ltt)),
 										 print(X),print(' '),print(gauche),print(' '),nl,print(A),nl,print(B),nl,print(C),nl,
 										 X1 is X+1,
 									     distance([A,B,C],Etft,D),
 									     print(distance),print(: ),print(D),nl,
 									     print(listedist),print(: ),print(Ldistance),nl,
 									     min_list(Ldistance,D), 
 									     rechercheTT(Etct,Etft,[[A,B,C]|Ltt],[D|Ldistance],[gauche|Lopttt],X1).
/*idem pour droite*/
rechercheTT(Etct,Etft,Ltt,Ldistance,[Optt|Lopttt],X):- operateurT(droite,Etct,[A,B,C]),
										 not(member([A,B,C],Ltt)),
										 print(X),print(' '),print(droite),print(' '),nl,print(A),nl,print(B),nl,print(C),nl,
										  X1 is X+1,
 									     distance([A,B,C],Etft,D),
 									     print(distance),print(: ),print(D),nl,
 									     print(listedist),print(: ),print(Ldistance),nl,
 									     min_list(Ldistance,D),
 									     rechercheTT(Etct,Etft,[[A,B,C]|Ltt],[D|Ldistance],[droite|Lopttt],X1).

/*idem pour bas*/
rechercheTT(Etct,Etft,Ltt,Ldistance,[Optt|Lopttt],X):- operateurT(bas,Etct,[A,B,C]),
										 not(member([A,B,C],Ltt)),
										 print(X),print(' '),print(bas),print(' '),nl,print(A),nl,print(B),nl,print(C),nl,
										  X1 is X+1,
 									     distance([A,B,C],Etft,D),
 									     print(distance),print(: ),print(D),nl,
 									     print(listedist),print(: ),print(Ldistance),nl,
 									     min_list(Ldistance,D),
 									     rechercheTT(Etct,Etft,[[A,B,C]|Ltt],[D|Ldistance],[bas|Lopttt],X1).

/*idem pour haut*/
rechercheTT(Etct,Etft,Ltt,Ldistance,[Optt|Lopttt],X):- operateurT(haut,Etct,[A,B,C]),
										 not(member([A,B,C],Ltt)),
										 print(X),print(' '),print(haut),print(' '),nl,print(A),nl,print(B),nl,print(C),nl,
										  X1 is X+1,
 									     distance([A,B,C],Etft,D),
 									    print(distance),print(: ),print(D),nl,
 									     print(listedist),print(: ),print(Ldistance),nl,
 									     min_list(Ldistance,D),
 									     rechercheTT(Etct,Etft,[[A,B,C]|Ltt],[D|Ldistance],[haut|Lopttt],X1).
 


/*resoudre++*/
resoudreTT(Soltt) :- etatInitialT(Eitt), etatFinalT(Etft),
				   rechercheTT(Eitt,Etft,[Eitt],Ldistance,Soltt,0).