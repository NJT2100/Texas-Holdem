note
	description: "Summary description for {GAME_VIEW}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_VIEW

create
	make

feature -- Representation


	banner:PLAIN_TEXT_FILE								--text file containing banner

	last_string:STRING									--the last string entered by user

	last_char:CHARACTER									--the last character entered by user

	last_int:INTEGER									--the last integer entered by the user

	call:CHARACTER = 'C'								--character representing calling

	fold:CHARACTER = 'F'								--character representing folding

	raise:CHARACTER = 'R'								--character representing raising

feature

	make
	do
		create banner.make_open_read ("TEXAS.txt")
		last_string := ""
		last_char := 'f'
		last_int := 0
	end

	introduction					--Print the title and get the username
	do
		Io.put_new_line
		print("Welcome to...%N%N")
		from banner.start			-- read the input file and print out the banner line by line
		until banner.off
		loop
			banner.readline
			print(banner.last_string)
			Io.put_new_line
		end
		print("%NPlease enter your name:")		--ask the user for their name
		get_string
	end

	game_start									--print the intro
	local
		TEST:INTEGER
	do
		print("%NWelcome!")

		print("%NDo you know how to play texas holdem? Y/N ")
		io.read_character
		if io.last_character = 'N'  then						--ask if they know how to play if not print out a quick summery
			print("%NThis game is a variant on poker. Instead of getting 5 cards you only get 2. 5 cards are dealt into what is called the river.")
			print("%NPlayers use the cards in the river and their own 2 to make the highest poker hand they can.")
			print("%NThere are 4 rounds of betting. Each player is dealt two cards then there is a round of better")
			print("%NAfter that 3 cards are dealt to the river. Then another round of betting")
			print("%NThen another card is dealt to the river and the third round of betting happen")
			print("%NThe final card is dealt and a final round of betting happens. If there is more than one player left players reveal their hands and the highest poker hand wins!")
			print("%NQuick legend")
			print("%NS = spades H = hearts D = diamonds C = clubs J = jack Q = Queen K = king")
		end
		print("%NLet the game begin%N")
	end



	get_string			--get a string from the user and make it available in fuction "get_last_string"	
	do
		io.read_line
		last_string := io.last_string
		io.put_new_line
	end

	print_computer_move(name:STRING; action:STRING; ammount:INTEGER)		--print out the last action of the computer player
	do
		io.put_new_line
		print(name)
		if action.is_equal (fold.out)  then
			print(" folds%N")
		elseif action.is_equal (call.out) then
			print(" calls%N")
		else
			print(" raises ")
			print(ammount)
			print("%N")

		end
	end

	get_move													--get a move from the user and make it available in function 'get_last_char'
	local
		valid:BOOLEAN
	do
		print("%NChoose your move:%N")
		print("Call - 'C', Raise - 'R', Fold - 'F':")
		from
		until valid												--loops until user inputs a valid character
		loop

			io.read_character
			if io.last_character = call or io.last_character = fold or io.last_character = raise then
				last_char := io.last_character
				valid := true
			end
		end
	end

	get_move_re(diff:INTEGER)			--if a computer bets ask if player wants to continue or not
	local
		valid:BOOLEAN
	do
		print("%NFollow? to follow need to bet $")
		print(diff)
		print(" more%N")
		print("Follow - 'C', Fold - 'F':")
		from
		until valid
		loop

			io.read_character
			if io.last_character = call or io.last_character = fold then
				last_char := io.last_character
				valid := true
			end
		end
	end

	reveal_hand(players:ARRAYED_LIST[PLAYER])		--Show every players hand
	local
		hand:STRING
	do
		io.put_new_line
		from players.start
		until players.after
		loop
			create hand.make_empty
			if players.item.in then					--if player is still in game print their name and the cards in their hand
				 hand.append (players.item.get_name)
				 hand.append (" had the cards: ")
				 hand.append (players.item.get_hand.first.to_string)
				 hand.append (",")
				 hand.append (players.item.get_hand.last.to_string)
				 hand.append (" There hand is: ")
				 if players.item.get_hand_rank = 9 then				--check which hand in poker they have
					hand.append ("straight flush")
				 elseif players.item.get_hand_rank = 8  then
					hand.append ("four of a kind")
				 elseif players.item.get_hand_rank = 7  then
					hand.append ("full house")
				 elseif players.item.get_hand_rank = 6  then
					hand.append ("flush")
				 elseif players.item.get_hand_rank = 5  then
					hand.append ("straight")
				 elseif players.item.get_hand_rank = 4  then
					hand.append ("three of a kind")
				 elseif players.item.get_hand_rank = 3  then
					hand.append ("two pair")
				 elseif players.item.get_hand_rank = 2  then
					hand.append ("one pair")
				 elseif players.item.get_hand_rank = 1  then
					hand.append ("high card")
				 else
				 	hand.append ("high card")
				 end
				 print(hand)
				 io.put_new_line

			end
			players.forth
		end
	end

	state(players_left:INTEGER;round:INTEGER; current_pot:INTEGER;players:ARRAYED_LIST[PLAYER] ) --print information about thr current round
	do
		print("%Ncurrent state:%N")
		print("players left:")
		print(players_left)
		print(" round:")
		print(round)
		print(" Pot:$")
		print(current_pot)
		io.put_new_line
		from
			players.start					--print information about each plays money if they still have any
		until
			players.exhausted
		loop
			if players.item.in then
				print(players.item.get_name)
				print(" Money: ")
				print(players.item.get_money)
				io.put_new_line
			end



			players.forth
		end
		io.put_new_line
	end

	deal(cards:LINKED_LIST[CARD])						--print out the hand dealt to the user
	do
		print("Current hand:")
		print(cards.i_th(1).to_string)
		print(",")
		print(cards.i_th(2).to_string)
	end

	deal_river(cards:LINKED_LIST[CARD])					--print out cards dealt to the river
	do
		print("River currently:")
		from
			cards.start
		until
			cards.exhausted
		loop
			print(cards.item.to_string)
			print(" ")
			cards.forth
		end
		io.put_new_line
	end
	print_win(winner:STRING)							--print the winner of the round
	do
		print("winner this round:")
		print(winner);
		io.put_new_line

	end

	print_space											--print out sapces so that it doesnt get too cluttered
	local
		count:INTEGER
	do
		from
			count := 1
		until
			count > 50
		loop
			io.put_new_line
			count := count + 1
		end
	end


	print_lost
	do
		print("%Nlooks like you lose")
		print("%NBetter luck next time")
		print("%Nenter any key to end")
		io.read_character
	end

	user_win
	do
		print("%NCongratulations!")
		print("%Nyou have betten all the computers and shown your power")
		print("%Nenter any key to end")
		io.read_character
	end

	print_river_pot(river:LINKED_LIST[CARD];pot:INTEGER)		--print out the river and the pot for when it gets to showdown		
	do
		io.put_new_line
		print("River currently:")
		from
			river.start
		until
			river.exhausted
		loop
			print(river.item.to_string)
			print(" ")
			river.forth
		end
		io.put_new_line
		print("pot : ")
		print(pot)
		io.put_new_line
	end

	get_amount											--get the raise amount from the user
	do
		print("Raise amount:")
		io.read_integer
		last_int := io.last_integer
	end

	get_last_string:STRING								--return the last string entered by user
	do
		Result := last_string
	end

	get_last_char:CHARACTER								--return the last string entered by user
	do
		Result := last_char
	end

	get_last_int:INTEGER								--return last integer entered by the user
	do
		Result := last_int
	end
end
