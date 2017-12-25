note
	description: "texas_holdem application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
	local
		game:GAME_ACCESSOR
		model:GAME_MODEL
		view:GAME_VIEW
	do
		create model.make
		create view.make
		create game.make
		game.the_game.game
	end

end
