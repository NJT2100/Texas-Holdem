note
	description: "Summary description for {ALRIGHT_MONEY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ALRIGHT_MONEY				--alright state class
inherit
	ROBOT_STATE
create
	make
feature
	make
	do

	end
	what_to_do(move:INTEGER):INTEGER
	do
		if move = 0 then						--since its alright chances of folding is low and chances of raising is not too high as well											
				Result := 1
		elseif move > 0 and move < 8 then
				Result := 2
		else
				Result := 3
		end
	end
end
