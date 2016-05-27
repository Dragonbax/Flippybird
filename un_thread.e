note
	description: "Classe pour un thread"
	author: "Félix-Olivier Lafleur-Duhamel"
	date: "26 mai 2016"
	version: "1.0"

class
	UN_THREAD

inherit
	THREAD
	rename
		make as make_thread
	end

create
	make

feature {NONE} 

	make (a_chaine: STRING)
			-- Initialisation de `Current' utilisant `a_chaine' comme `chaine_affiche'
		do
			make_thread
			must_stop := false

		end

feature -- Access

	stop_thread
			-- Terminer `Current'
		do
			must_stop := true
		end

feature {NONE} -- Thread methods

	execute
			-- L'exécution du {THREAD}
		do
			from
			until
				must_stop
			loop
				io.put_string ("test")
				io.output.flush
			end
		end

feature {NONE} -- Implementation

	must_stop: BOOLEAN
			-- La boucle de `make' doit quitter.


end
