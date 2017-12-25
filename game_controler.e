note
	description: "Summary description for {GAME_CONTROLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_CONTROLER

inherit
	SINGLETON

create
	make
feature
	model:GAME_MODEL
	view:GAME_VIEW
	finished:BOOLEAN
	make
	do							--create the model and view
		create model.make
		create view.make
	end

	get_view:GAME_VIEW			--get the game view
	do
		Result := view
	end

	set_view(view1:GAME_VIEW)	--set the game view
	do
		view := view1
	end

	get_model:GAME_MODEL		--get the game model
	do
		Result := model
	end

	set_model(model1:GAME_MODEL)	--set the game model
	do
		model := model1
	end

	set_finsihed(finished1:BOOLEAN)	--set if its finished
	do
		finished := finished1
	end

	is_finished:BOOLEAN				--checked if its finished
	do
		Result := finished
	end

	print_round_information			--print out round information
	do
		view.state(model.get_remaining_players.count,model.get_round, model.get_pot, model.get_players)		--call the view class and send over the amount of players
	end

	match_bets						--match the bets if there was a raise after ones turn
	local
		index:INTEGER
	do
			from model.get_players.start		--loop through all the players
				until model.get_players.after
				loop

						if model.get_players.item.get_money > 0 and model.get_players.item.in then		--check if they have money and are in the round
							model.set_current_player(model.get_players.item)
							if model.get_current_player = model.get_human then							--check if its the human player
								if model.current_bet > model.get_current_player.current_bet then
									get_user_move_re													--call the feature that askes user if they want to follow
								end
							else
								model.call																--computer players always follow
							end

						end

					model.get_players.forth																--move to next player
				end

	end

	get_user_move_re																					--get the user move for when somebody raises after them
	local
		move:CHARACTER
	do
		view.get_move_re(model.current_bet - model.get_current_player.current_bet)						-- print out how much they have to bet and get input
		move := view.get_last_char
		if move = view.fold then																		--if they fold fold
				model.fold
		end
		if move = view.call then																		--if they follow then call
			model.call
		end
	end

	get_user_move																						--get a user move for normal betting rounds
	local
		move:CHARACTER
	do
		view.deal (model.current_player.hand)															--show the delt cards and ask for user input
		view.get_move																					--get the input
		move := view.get_last_char
		if move = view.fold then
			model.fold
		end
		if move = view.raise then
			view.get_amount;
			model.raise (view.get_last_int)
		end
		if move = view.call then
			model.call
		end
	end

	get_move(seed:INTEGER)																			--get a random move for the computer
	local
		rnd:RANDOM
		move:INTEGER
		work:INTEGER
	do
		create rnd.make																				--random number generation
		rnd.set_seed(seed)
		rnd.start
		move := rnd.item \\ 10																		--get a number
		work := model.get_current_player.what_to_do(move)
		--work := 2
		if work = 1  then																			--depending on number do an action
			model.fold
			model.set_num_remaining_players (model.get_num_remaining_players - 1)
			model.set_action("F")
			view.print_computer_move (model.get_current_player.get_name, model.get_action,0)
		elseif work = 2 then
			model.call
			model.set_action ("C")
			view.print_computer_move (model.get_current_player.get_name, model.get_action,0)
		else
			rnd.forth
			model.raise(rnd.item \\ 50)
			model.set_action ("R")
			view.print_computer_move (model.get_current_player.get_name, model.get_action,rnd.item \\ 50)
		end
	end

	deal_river																	--draw the river
	do
		model.deal_river;
	end

	game																		--main game application
	local
		stage:INTEGER
		player_index:INTEGER
		winner:PLAYER
		i:INTEGER
		count:INTEGER
	do
		count := 0																--counter to see if human won
		view.introduction														--print out the introduction
		model.get_human.set_name (view.get_last_string)							--get the human players name

		from i := 1																--set the computers names
		until i > 5
		loop
			model.get_players[i+1].set_name ("COMP")
			model.get_players[i+1].get_name.append_integer (i)
			i := i + 1
		end

		view.game_start															--print the starting messages

		from
			finished := false													--main loop for playing run untill somebody human player loses or wins
		until
			finished = true
		loop
			model.set_pot (0)													--reseting everything to make sure its fresh for the game.
			model.set_round (0)
			model.reset_current_bet
			model.set_num_remaining_players(model.get_remaining_players.count)
			model.deck.shuffle(get_seed)
			model.deal
			model.get_human.set_in_round (true)

			from i := 1															--set all players to be out of the round
			until i > model.number_of_players - 1
			loop

				model.get_players[i+1].set_in_round (false)
				i := i + 1
			end

			from i := 1
			until i > model.number_of_players - 1
			loop
				if model.get_players[i+1].get_money > 0 then					--if the players have enough money allow the to continue playing
					model.get_players[i+1].set_in_round (true)
					model.get_players[i+1].set_bet (0)							--initialize the players bets to 0
				end
				i := i + 1
			end

			from stage := model.get_round										--based on the current round deal cards to the river
			until
				stage > 3
			loop
				if stage = 1 then												--When round equals 1, deal 3 cards
					deal_river
					deal_river
					deal_river
				elseif stage > 1 then											--When round equals 2 or three deal 1 card
					deal_river
				end

				print_round_information											--Print round information
				view.deal_river (model.river);									--Print the river

				if model.get_human.in = true then								--Check to see if it is the users turn to move
					model.set_current_player(model.get_players.first)
					get_user_move;												--get the move from the first player
				end

				view.print_space

				from model.get_players.start									--loop through the rest of the players
				until model.get_players.after
				loop
					if model.get_players.item /= model.get_human then			--make sure not to get another move from the user

						if  model.get_players.item.in then						--check to see if Computer player is in the round
							model.set_current_player(model.get_players.item)
							get_move(get_seed)									--get the next move from the computer

						end

					end
					model.get_players.forth
				end
				match_bets														--at the end of betting make sure everyone contributes the same amount
				if stage = 3 then
					view.print_river_pot(model.river,model.get_pot)				--print the pot
					winner := model.showdown (model.get_players);				--determine the winner of the showdown
					view.reveal_hand(model.get_players)							--reveal every players hand
					winner.set_money (model.get_pot)							--give the player the pot
					view.print_win(winner.name);
					model.return												--return all cards to the deck
				elseif model.get_num_remaining_players <= 1 then
					winner := model.get_remaining_players[1]					--determine winner
					winner.set_money (model.pot)								--give winner the pot
					view.print_win (winner.name)
					model.return												--return all cards to the deck
					model.set_round (4)
				end
				model.set_round (model.get_round + 1)
				stage := model.get_round

			end

			from i := 1															--Check to see how many players are still in the game
			until i > model.number_of_players - 1
			loop

				 if model.get_players[i+1].get_money <= 0 then
				 	count := count + 1;											--if player still has no money left increase count by 1
				 end
				i := i + 1
			end

			if count = 5 then													--if all the computer players are out of money you win
				finished := true
				view.user_win
			elseif model.get_human.get_money <= 0 then							--if the user runs out of money it is game over
				view.print_lost
				finished := true;
			end
			count := 0

		end

	end

	get_seed:INTEGER															--psuedo randomly generate a random seed
	local
	    l_time: TIME
	    l_seed: INTEGER
	do
	   -- This computes milliseconds since midnight.
	   -- Milliseconds since 1970 would be even better.
	   create l_time.make_now
	   l_seed := l_time.hour
	   l_seed := l_seed * 60 + l_time.minute
	   l_seed := l_seed * 60 + l_time.second
	   l_seed := l_seed * 1000 + l_time.milli_second
		Result:= l_seed
	end
end
