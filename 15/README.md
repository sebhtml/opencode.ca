# Déboguer une application de calcul distribué en C++ avec RayPlatform

-
-
-
-

- opencode.ca 15

	- Date: 2013-09-24
	- Sébastien Boisvert
	- Durée: 15 minutes


---

# Quelques concepts

- message
- acteur
- boucle principale
- MPI (Message Passing Interface)

---

# Message

- Contient:
	- Source
	- Destination
	- Sujet
	- Contenu


---

# Acteur

- D'où ça vient ?
	- Carl Hewitt, Peter Bishop, Richard Steiger (1973) http://dl.acm.org/citation.cfm?id=1624804
	- Gul Agha 1986 http://dl.acm.org/citation.cfm?id=7929
	- http://en.wikipedia.org/wiki/Actor\_model
	- http://channel9.msdn.com/Shows/Going+Deep/Hewitt-Meijer-and-Szyperski-The-Actor-Model-everything-you-wanted-to-know-but-were-afraid-to-ask

- quand un acteur reçoit un message, il peut:
	- envoyer des messages
	- créer des acteurs
	- changer son comportement

- Deux langages populaires
	- erlang
	- scala

---

# Boucle principale d'un acteur (scala)

	!scala
	loop {
	  react {
	    case A => ...
	    case B => ...
	  }
	}


- loop / react ne peut rien faire si aucun message n'est reçu

---

# Observations

- un acteur ne fait rien si il ne reçoit pas de message


# Boucle principale RayPlatform

	!cpp
	while(isAlive()) {
		receiveMessage();
		processMessage();
		doComputation();
		sendMessages();
	}

- doComputation est un moyen de faire quelque chose en l'absence de message
- modèle comme dans un jeu vidéo
- ne suit pas le modèle des acteurs à la lettre

---

# Message Passing Interface

- http://www.mpi-forum.org/docs/mpi-3.0/mpi30-report.pdf

- Résumé pour les messages:
	- MPI_Isend => envoyer un message de manière non-bloquante
	- MPI_Iprobe => vérifier si un message est disponible
	- MPI_Recv => recevoir un message
	- MPI_Test => tester la complétion d'une opération non-bloquante

---

# Lancer mpiexec

mpiexec -n 32 date -o T2

---

# assembler un casse-tête

mpiexec -n 64 Ray -detect-sequence-files BigData -o T3

---

# plus d'acteurs par processus

mpiexec -n 8 Ray -mini-ranks-per-rank 7 -detect-sequence-files BigData -o T5

---

# Chasser les bogues parallèles non-déterministes !


---

# -show-communication-events

---

# -run-profiler -with-profiler-details

---

# -write-scheduling-data

---

# -read-write-checkpoints GameSave.state

---

# -write-plugin-data

---

