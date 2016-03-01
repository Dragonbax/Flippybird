note
	description: "Summary description for {OISEAU}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	OISEAU

create
	make
inherit
	CADRE_IMAGE

feature {NONE} -- Initialization

	make
	local
		position_x:INTEGER
		etat:BOOLEAN
		vol:BOOLEAN
		joueur_actif:BOOLEAN

			-- Initialization for `Current'.
		do

		end

end
