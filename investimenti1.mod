set BIMESTRI ordered; # Gli orizzonti temporali devono essere ordinati cronologicamente
# b
set PROGETTI;
# t

param Flusso_cassa{PROGETTI, BIMESTRI};
param Budget{BIMESTRI};
param Interesse;
param Flusso_cassa_att{p in PROGETTI, b in BIMESTRI}:=
	Flusso_cassa[p, j]/(1+Interesse)^(ord(b, BIMESTRI)-1);
	#ord(b, BIMESTRI) restituisce iterativamente gli indici dell'insieme ordinato BIMESTRI

var attivo{PROGETTI} binary; # L'unica variabile è quella di attivazione dei progetti
	# x[i] = 0 ==> i-esimo progetto non attivo
	# x[i] = 1 ==> i-esimo progetto attivo
	
maximize npt_totale: #Net-Present-Value totale (somma su ogni progetto)
	sum{p in PROGETTI} sum{b in BIMESTRI} Flusso_cassa_att[p, b]*attivo[p];

subject to budget{b in BIMESTRI}:
	- sum{p in PROGETTI} Flusso_cassa[p, b]*attivo[p] <= Budget[b];

subject to logico1:
	2*attivo['Prog6'] <= attivo['Prog1']+attivo['Prog3'];
	# Vincolo logico: Se il Progetto 6 devono esserlo anche 1 e 3
	# Si usa <= e non = perché i prog. 1 e 3 possono anche essere attivati indipendentemente dal 6
	# Se 'attivo['Prog6'] = 1' risulta '2*1 <= 1+1'
	
subject to logico2:
	attivo['Prog6']+attivo['Prog4'] >= 1;
	# Vincolo logico: Almeno uno tra i progetti 6 e 4 deve essere attivo

subject to logico3:
	attivo['Prog5']+attivo['Prog2'] <= 1;
	# Vincolo logico: Solo uno tra i progeti 2 e 5 può essere attivato

# Appunti di riferimento: https://appunti-lobello.notion.site/Modelli-di-Scelta-Ottima-degli-Investimenti-14794a74d47180f98cb2f56aec045316?pvs=4

# Github repo: https://github.com/sosageek/ProgMat-PLI