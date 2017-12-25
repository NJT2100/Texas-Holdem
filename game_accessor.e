note
	description: "Summary description for {GAME_ACCESSOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_ACCESSOR

inherit
	SINGLETON_ACCESSOR
		rename singleton as the_game
	end

create
	make

feature

	make
	do  end

	the_game:GAME_CONTROLER
	once
		create Result.make
	end
end
