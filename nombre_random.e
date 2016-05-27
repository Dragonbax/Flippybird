note
	description: "Classe g�n�rant des nombres al�atoires"
	author: "F�lix-Olivier Lafleur-Duhamel"
	date: "26 mai 2016"
	version: "1.0"

class
	NOMBRE_RANDOM

inherit

	GAME_RANDOM_SHARED

feature

	nombre_aleatoire: INTEGER
		--Repr�sente un nombre g�n�r� al�atoirement

	gen_random
		--G�n�re un nombre al�atoire se situant entre -250 et -15,et l'assigne � 'nombre_aleatoire'
		do
			random.generate_new_random
			nombre_aleatoire := random.last_random_integer_between (-250, -15)
		ensure
			nombre_aleatoire = random.last_random_integer_between (-250, -15)
		end

end
