note
	description: "Summary description for {NOMBRE_RANDOM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	NOMBRE_RANDOM

inherit
	GAME_RANDOM_SHARED

feature

y_random:INTEGER

     gen_random
          do
               random.generate_new_random
              y_random:=random.last_random_integer_between(-250, -15)
          end

end
