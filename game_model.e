note
	description: "Summary description for {GAME_MODEL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_MODEL
create
	make

feature --Representation

	players:ARRAYED_LIST[PLAYER]		-- all players in the game

	current_player:PLAYER				-- the player who is currently making a move

	pot:INTEGER							--the total bets during a match

	round:INTEGER						--current round

	remaining_players:INTEGER 			-- # of players reaming this round

	current_bet:INTEGER					--The last bet made

	deck:DECK							--the deck

	river:LINKED_LIST[CARD]				--The river which is common beween all players

	hands:HANDS							--object representing the possible hands in texas holdem

	main_player:PLAYER					--The user

	action:STRING						--string representing the last action performed

	player_num : INTEGER 				-- current player's array index

	players_alive: INTEGER 				-- players with money left

	number_of_players:INTEGER = 6

feature
	make --initialize the deck, the list of players etc.
	local
		index:INTEGER
		p:PLAYER
	do
		create deck.make;
		create players.make(number_of_players);
		create hands.make
		current_bet := 0
		from
			index := 1
		until
			index > number_of_players
		loop
			create p.make (1000,"n/a")
			players.put_front (p)
			index := index + 1
		end
		main_player := players[1];
		current_player := players[1];
		remaining_players := number_of_players
		players_alive := number_of_players
		create river.make
		create action.make (10)
	end

	raise(amount:INTEGER)  --increase the current bet to current_bet + amount, and add to the pot
	local
		bet:INTEGER
	do
		if current_bet + amount - current_player.get_bet > current_player.get_money then			--check to see if player has enough money to match amount
			bet := current_player.get_money															--if not bet remainder of players money
			pot := pot + bet
			if current_player.get_money > current_bet then
				current_bet := current_player.get_money - (current_bet - current_player.get_bet)	--update models last bet
			end
			current_player.set_bet (bet)															--update players last bet and current money
			current_player.set_money (-bet)
		else																						--o.w player has enough money to make bet. Make the bet
			bet := current_bet + amount - current_player.get_bet
			current_player.set_bet (bet)
			current_player.set_money (-bet)
			current_bet := current_bet + amount
			pot := pot + bet
		end
	ensure
		current_player.get_money >= 0
	end

	call --increase pot by the current bet
	local
		bet:INTEGER
	do
		if current_bet - current_player.get_bet > current_player.get_money then
			bet := current_player.get_money
		elseif current_bet > current_player.get_bet then
			bet := current_bet - current_player.get_bet
		elseif current_player.get_bet > current_bet then
			current_bet := current_player.get_bet
		end
		pot := pot + bet
		current_player.set_bet (bet)
		current_player.set_money(-bet)
	ensure
		current_player.get_money >= 0
	end

	fold --mark player as folded
	do
		current_player.set_in_round (FALSE);
	ensure
		current_player.in = false
	end

	set_current_player(player:PLAYER) --after a player moves set the next player who has not folded or is not out of cash
	do
		current_player := player
	end

	deal --deal every player 2 cards
	local
		i:INTEGER
		j:INTEGER
	do
		from i := 1
		until i > 2					--deal 2 cards, 1 at a time
		loop
			from j := 1
			until j > 6
			loop
				if players[j].get_money > 0 then		--if player still in the game
					players[j].add_card (deck.deal)		--deal the player cards
				end
				j := j + 1
			end
			i := i + 1
		end
	ensure
		correct_hand = true								--ensure every play has the correct number of cards
	end

showdown(remaining_players1:ARRAYED_LIST[PLAYER]):PLAYER --if by the end of the fourth round there is more than one player remaining, determine who has the best hand
	local
		index:INTEGER
		high_hand:INTEGER
		high_player:INTEGER
		merg:LINKED_LIST[CARD]
		test:INTEGER
		river_copy: LINKED_LIST[CARD]
	do
		create merg.make		--create a new card linked list that will be hand and river
		create river_copy.make
		high_hand := -1;		--set this to -1 so it will take the first index
		high_player := 1
		from
			index := 1
		until
			index > remaining_players1.count		--loop	from the first index untill the end
		loop
			if remaining_players1[index].in then	--check if the player at index is still in the game
				river_copy := river					--make a copy of the river
				merg.put_front (remaining_players1[index].hand[1])	--merge hand into new list
				merg.put_front (remaining_players1[index].hand[2])
				from												--merge the river into the new list
					test := 1
				until
					test > 5
				loop
					merg.put_front (river[test])
					test := test + 1;
				end

				merg.start
				remaining_players1[index].set_hand_rank(hands.hand_rank(merg)) --get the rank of the hand and store it in the player class for later use

				if high_hand < hands.hand_rank(merg) then					   --check the rank of certain the currents indexes rank is higher than pervious highest
					high_hand := hands.hand_rank(merg);						   --if it is then change the highest to the current index
					high_player := index;

				else
					if high_hand = hands.hand_rank(merg) then				   --check if the ranks are the same if they are take the one with higher cards

						remaining_players1[index].hand.start				   --move to check first cards
						remaining_players1[high_player].hand.start

						if remaining_players1[index].hand.item.get_rank > remaining_players1[high_player].hand.item.get_rank then	--if first one is higher then check the second card to make sure its the highest
							remaining_players1[high_player].hand.forth;																--move to second card
							if remaining_players1[index].hand.item.get_rank > remaining_players1[high_player].hand.item.get_rank then	--if its higher set it to high card
								high_hand := hands.hand_rank(merg);
								high_player := index;
							end
							if remaining_players1[index].hand.item.get_rank = remaining_players1[high_player].hand.item.get_rank then	--if they equal move one forward and one back to make sure that they are the same
								remaining_players1[index].hand.forth																	--move it forward
								remaining_players1[high_player].hand.start																--move one back
									if remaining_players1[index].hand.item.get_rank > remaining_players1[high_player].hand.item.get_rank then	-- check to see if higher if it is set it as higher
										high_hand := hands.hand_rank(merg);
										high_player := index;
									end
							end
						elseif remaining_players1[index].hand.item.get_rank < remaining_players1[high_player].hand.item.get_rank then
							remaining_players1[index].hand.forth
							if remaining_players1[index].hand.item.get_rank > remaining_players1[high_player].hand.item.get_rank then
								remaining_players1[high_player].hand.forth																	--move it forward
								remaining_players1[index].hand.start																--move one back
								if remaining_players1[index].hand.item.get_rank > remaining_players1[high_player].hand.item.get_rank then	-- check to see if higher if it is set it as higher
									high_hand := hands.hand_rank(merg);
									high_player := index;
								end
							end
						else
							if remaining_players1[index].hand.item.get_rank = remaining_players1[high_player].hand.item.get_rank then	-- check if they are equal then move onto next card
							 remaining_players1[index].hand.forth;
							 remaining_players1[high_player].hand.forth;
							 if remaining_players1[index].hand.item.get_rank > remaining_players1[high_player].hand.item.get_rank then	-- if the new one is higher replace old highest with index
							 	high_hand := hands.hand_rank(merg);
								high_player := index;
							 end
							end
						end
					end

				end
				merg.wipe_out	--clean out the variable for reuse
			end
			index := index + 1;
		end

		Result := remaining_players1[high_player];	--return the person with the highest poker hand

	end

	return --return all cards to the deck after a show down or after all but one player folds
	local
		index:INTEGER
	do
		from
			index := 1
		until
			index > 6
		loop
			deck.retrieve (players[index].get_hand)		--return the players hand to the deck
			players[index].clear_hand					--clear the players hand
			index := index + 1;
		end
		deck.retrieve (river)							--return the river to the deck
		river.wipe_out;									--clear the river

	end

	get_players:ARRAYED_LIST[PLAYER]					--return the list of players
	do
		Result := players
	end

	get_action:STRING									--return the last action preformed
	do
		Result := action
	end

	set_action(new_action:STRING)						--set the last action preformed
	do
		action := new_action
	end

	set_round(round1:INTEGER)							-- set the current rount
	do
		round := round1;
	end

	get_human:PLAYER									--get human class
	do
		Result := main_player;
	end

	get_round:INTEGER									--get the current round
	do
		Result := round;
	end

	get_current_player:PLAYER							--get the current player
	do
		Result := current_player;
	end

	get_bet:INTEGER										--get the current bet
	do
		Result := current_player.get_money;
	end

	set_bet(amount:INTEGER)								--set the current bet
	do
		current_player.set_bet (amount);
		pot := pot + amount;
	end

	get_deck:DECK										--get the deck
	do
		Result := deck;
	end

	get_pot:INTEGER										--get the pot
	do
		Result := pot;
	end

	set_pot(amount:INTEGER)								--set the pot
	do
		pot := amount;
	end

	reset_current_bet									--reset all the bets
	do
		current_bet := 0								--reset the current bet
		from
			players.start								--loop through all the players and rest them
		until
			players.exhausted
		loop
			players.item.reset_bet
			players.forth
		end
	end

get_remaining_players:ARRAYED_LIST[PLAYER]				--get the players that are remaining
	local
		temp:ARRAYED_LIST[PLAYER]
		index:INTEGER									-- local variables
		count:INTEGER
	do
		create temp.make (number_of_players);			--create a temp list to store the ones that are going to be in use
		count := 1;
		temp.wipe_out									--make sure that temp is empty
		from
			index := 1									--loop through all players
		until
			index > number_of_players
		loop
			if players[index].in_round  then			--if they are currently in add them to temp
				temp.put_front (players[index])
			end
			index := index + 1
		end
		Result := temp									--return temp
	ensure
		remaining(Result) = true
	end

	get_num_remaining_players:INTEGER					--return number of people that in the round
	do
		Result := get_remaining_players.count
	end

	set_num_remaining_players(amount:INTEGER)			--set the number of players
	do
		remaining_players := amount;
	end

	deal_river											--deal the river
	do
		river.put_front (deck.deal);
	end

	feature --Contracts

	correct_hand:BOOLEAN									--ensures the players have the correct number of cards
	do
		Result := true
		from players.start
		until players.after
		loop
			if players.item.get_money > 0 then
				if players.item.get_hand.count /= 2 then
					Result := false
				end
			end
			players.forth
		end
	end

	remaining(list:ARRAYED_LIST[PLAYER]):BOOLEAN			--ensures all the remaining players have not folded
	do
		Result:= true
		from list.start
		until list.after
		loop
			if list.item.in = false then
				Result := false
			end
			list.forth
		end
	end


end
