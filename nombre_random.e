note
	description: "Classe générant des nombres aléatoires"
	author: "Félix-Olivier Lafleur-Duhamel"
	date: "26 mai 2016"
	version: "1.0"

class
	NOMBRE_RANDOM

inherit

	GAME_RANDOM_SHARED

feature

	nombre_aleatoire: INTEGER
		--Représente un nombre généré aléatoirement

	gen_random
		--Génère un nombre aléatoire se situant entre -250 et -15,et l'assigne à 'nombre_aleatoire'
		do
			random.generate_new_random
			nombre_aleatoire := random.last_random_integer_between (-250, -15)
		ensure
			nombre_aleatoire = random.last_random_integer_between (-250, -15)
		end

end
