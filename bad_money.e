note
	description: "Summary description for {GOOD_MONEY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BAD_MONEY
inherit
	ROBOT_STATE
create
	make
feature
	make
	do

	end
	what_to_do(move:INTEGER):INTEGER				--more likely to fold and less likely to raise or call
	do
			if move < 4 then
				Result := 1
			else
				Result := 2
			end
	end
end
