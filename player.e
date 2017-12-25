note
	description: "Summary description for {PLAYER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLAYER
create
	make
feature
	money : INTEGER										-- money variables
	name : STRING										-- player name
	in_round : BOOLEAN									-- variable for if they are in this round
	current_bet : INTEGER								-- current bet for the player
	hand: LINKED_LIST[CARD]								-- what cards it has
	hand_rank : INTEGER									-- the rank of those cards
	robot: ROBOT_STATE									-- State class for the computer players depending on how much money they have
	good : GOOD_MONEY									-- a good money state
	alright : ALRIGHT_MONEY								-- an alright money state
	bad : BAD_MONEY										-- a bad money state

	make(start_amount: INTEGER ; start_name: STRING)	-- create all variables
	do
		create good.make								-- create the good state
		create alright.make								-- create the alright state
		create bad.make									-- create the bad state
		robot := alright								-- start with the alright state
		money := start_amount;							-- set money to starting money
		name := start_name;								-- set the name
		create hand.make								-- create the hand class
	ensure
		money = start_amount							-- make sure the money gets set
		name = start_name								-- make sure the name gets set
	end

	what_to_do(move:INTEGER):INTEGER					-- computer players call this method to determine what state they are in and what move they should do
	do
		if money > 2000 then							-- if the money is over 2000 set the state to good
			robot := good
		elseif money > 200 then							-- if money is less that 2000 but over 500 then set the state to alright
			robot := alright
		else											-- otherwise in a bad state
			robot := bad
		end
		Result := robot.what_to_do(move)				-- call the state and get what the computer should do
	end

	get_hand:LINKED_LIST[CARD]							-- get the hand
	do
		Result := hand
	end

	get_money:INTEGER									-- get money
	do
		Result := money;
	ensure
		Result = money
	end

	get_bet:INTEGER										-- get the current bet
	do
		Result := current_bet;
	end

	in:BOOLEAN											--check if its in the round or not
	do
		Result := in_round;
	end

	set_money(amount:INTEGER)							--set the money
	do
		money := money + amount;
	ensure
		money = old money + amount
	end

	get_name:STRING										--get the name of the player
	do
		Result := name
	end

	set_name(set:STRING)								--set the name of the player
	do
		name := set;
	ensure
		name = set
	end

	set_bet(amount:INTEGER)								-- set the bet amount
	do
		current_bet := current_bet + amount;
	ensure
		current_bet = old current_bet + amount
	end

	set_in_round(set_round:BOOLEAN)						--set if we in the round or not
	do
		in_round := set_round;
	ensure
		in_round = set_round
	end

	add_card(card:CARD)									-- add the cards
	do
		hand.put_front(card)
	end

	reset_bet											--reset the bet
	do
		current_bet := 0
	end

	set_hand_rank(rank:INTEGER)							-- set the hand rank
	do
		hand_rank := rank
	end

	get_hand_rank:INTEGER								-- get the hand rank
	do
		Result := hand_rank
	end

	clear_hand											--reset the hand
	do
		hand.wipe_out
	end

end
