# Dégoguer les messages

Déboguer une application de calcul distribué en C++ avec RayPlatform

- opencode.ca 15

- Date: 2013-09-24
- Sébastien Boisvert
- Durée: 15 minutes


---

# Quelques concepts

- message
- acteur


---

# Message

* Contient:
 + Source
 + Destination
 + Sujet
 + Contenu


---

# Acteur

- Gul Agha 1986 http://dl.acm.org/citation.cfm?id=7929
- http://en.wikipedia.org/wiki/Actor\_model

* quand un acteur reçoit un message, il peut:
 + envoyer des messages
 + créer des acteurs
 + changer son comportement

- http://channel9.msdn.com/Shows/Going+Deep/Hewitt-Meijer-and-Szyperski-The-Actor-Model-everything-you-wanted-to-know-but-were-afraid-to-ask

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

# Boucle principale

	!cpp
	while(isAlive()) {
		receiveMessage();
		processMessage();
		doComputation();
		sendMessages();
	}

---

# mpiexec

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

