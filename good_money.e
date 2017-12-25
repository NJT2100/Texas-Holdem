note
	description: "Summary description for {GOOD_MONEY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GOOD_MONEY
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
		if move < 6 then				--good chances to raise and won't fold
			Result := 2
		else
			Result := 3
		end
	end
end

