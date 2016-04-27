note
	description: "Classe générant des nombres aléatoires"
	author: "Félix-Olivier Lafleur-Duhamel"
	date: "26 avril 2016"
	version: "1.0"

class
	NOMBRE_RANDOM

inherit

	GAME_RANDOM_SHARED

feature

	y_random: INTEGER

	gen_random
		do
			random.generate_new_random
			y_random := random.last_random_integer_between (-250, -15)
		ensure
			y_random = random.last_random_integer_between (-250, -15)
		end

end
