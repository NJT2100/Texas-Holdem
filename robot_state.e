note
	description: "Summary description for {ROBOT_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ROBOT_STATE			--deferred class

feature

	what_to_do(move:INTEGER):INTEGER deferred end		--all states need to implement

end
