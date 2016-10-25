class Mastermind

	def initialize
		@number_of_wins = 0
		@won, @answer, @turns = 0, [], 12
		@robo_feedback = [0,0]
		@robo_possibilities = [1,2,3,4,5,6].repeated_permutation(4).to_a
		@colors = ['red', 'orange', 'yellow', 'green', 'blue', 'indigo']
		@number_colors_in_answer = {'red' => 0, 'orange' => 0, 'yellow' => 0,'green' => 0,'blue' => 0,'indigo' => 0, 'guessed' => 0}
		self.play
	end

	def reset_game
		@won, @answer, @turns = 0, [], 12
		@robo_possibilities = [1,2,3,4,5,6].repeated_permutation(4).to_a
		@colors = ['red', 'orange', 'yellow', 'green', 'blue', 'indigo']
		@number_colors_in_answer = {'red' => 0, 'orange' => 0, 'yellow' => 0,'green' => 0,'blue' => 0,'indigo' => 0, 'guessed' => 0}
	end

	def play
		self.reset_game
		puts "Would you like to guess or attemp to fool Mr. Roboto? (1 to guess, 2 to pick the answer) (1/2)"
		playerchoice = gets.chomp.to_i
		if playerchoice == 1
			self.robo_answer
		elsif playerchoice == 2
			self.create_answer
		else
			puts "Incorrect input, try again"
			self.play
		end
	end

	def robo_answer
		4.times do |i|
			@answer[i] = @colors.sample
		end
		self.reset_colorcount
		self.take_turn
	end

	def create_answer
		print "\nWhat is the winning combination? Please input numbers corresponding to the colors with no spaces: ####\n\n |"
		6.times do |x|
			print " #{x+1}:#{@colors[x]} |"
		end
		puts ""
		player_combo = gets.chomp
		if self.verify_guess(player_combo)
			answer_array, @answer = player_combo.split(""), []
			4.times do |x|
				@answer[x] = @colors[answer_array[x].to_i - 1]
			end
		else
			puts "Incorrect input, try again"
			self.create_answer
		end
		self.reset_colorcount
		self.robo_turn
	end

	def reset_colorcount
		@number_colors_in_answer = {'red' => 0, 'orange' => 0, 'yellow' => 0,'green' => 0,'blue' => 0,'indigo' => 0, 'guessed' => 0}
		@answer.each do |x|
			@colors.each do |y|
				@number_colors_in_answer[y] += 1 if y==x
			end
		end
	end

	def check_guess(guess)
		print "\nYou guessed: #{guess}\n"
		correct_color, correct_position, temp_number_colors = 0, 0, @number_colors_in_answer
		for i in 0...guess.length do
			(correct_position += 1; temp_number_colors[guess[i]] -= 1; guess[i] = "guessed") if guess[i] == @answer[i]
		end
		for i in 0...guess.length do
			(correct_color += 1; temp_number_colors[guess[i]] -= 1) if temp_number_colors[guess[i]] > 0
		end
		@turns -= 1
		correct_position == 4 ? (@won = 1; @number_of_wins+=1; self.check_win; return @won) : (puts "# of correct colors in wrong position: #{correct_color}\n# of colors in correct position: #{correct_position}"; self.reset_colorcount)
		@turns == 0? (@won = 2; self.check_win) : (puts "\nTurns left: #{@turns}"; self.take_turn)
	end

	def robo_check_guess(guess_in)
		guess = []
		4.times do |x|
				guess[x] = @colors[guess_in[x].to_i - 1]
			end
		print "\nMr. Roboto guessed: #{guess}\n"
		correct_color, correct_position, temp_number_colors = 0, 0, @number_colors_in_answer
		for i in 0...guess.length do
			(correct_position += 1; temp_number_colors[guess[i]] -= 1; guess[i] = "guessed") if guess[i] == @answer[i]
		end
		for i in 0...guess.length do
			(correct_color += 1; temp_number_colors[guess[i]] -= 1) if temp_number_colors[guess[i]] > 0
		end
		@robo_feedback = [correct_color, correct_position]
		@turns -= 1
		correct_position == 4 ? (@won = 1; @number_of_wins+=1; self.check_win; return @won) : (puts "# of correct colors in wrong position: #{correct_color}\n# of colors in correct position: #{correct_position}"; self.reset_colorcount)
		@turns == 0? (@won = 2; self.check_win) : (puts "\nTurns left: #{@turns}"; self.robo_turn(guess_in))
	end


	def robo_turn(robo_guess=[1,1,2,2])
		if @turns != 12
			puts "There are #{@robo_possibilities.length} possibilities left"
			puts "feedback: #{@robo_feedback}"
			puts "running elimination"
			self.robo_eliminate(robo_guess)
			puts "There are #{@robo_possibilities.length} possibilities left"
			robo_guess = @robo_possibilities.sample
		else
			puts @robo_possibilities.length
		end
		self.robo_check_guess(robo_guess)
	end

	def robo_eliminate(robo_guess)
		puts "Eliminating based on: #{robo_guess}\n"
		#if nothing is correct, delete all possibilities with the guess's values in them
		(@robo_possibilities.delete_if { |possibility| possibility.any? { |x| robo_guess.include? x}}) if @robo_feedback[0] + @robo_feedback[1] == 0	
		puts "#{@robo_possibilities.length} possibilities left after step 1"
		#if something is correct, but in the wrong place, delete all possibilities without a color in the guess in them
		if @robo_feedback[0] >= 1
			@robo_possibilities.keep_if do |p|
				keep_it, counter = false, 0
				4.times do |i|
					counter += 1 if robo_guess.include? p[i]
				end
				keep_it = true if counter >= @robo_feedback[0]
				keep_it
			end
			puts "#{@robo_possibilities.length} possibilities left after step 2"
		end
		if @robo_feedback[1] >= 1
			@robo_possibilities.keep_if do |p| 
				keep_it, counter = false, 0
				4.times do |i|
					counter += 1 if p[i] == robo_guess[i]
				end
				keep_it = true if counter >= @robo_feedback[0]
			end
			puts "#{@robo_possibilities.length} possibilities left after step 3"
		end
	end


	def take_turn
		print "\nWhat is your guess? Please input numbers corresponding to the colors with no spaces: ####\n\n |"
		6.times do |x|
			print " #{x+1}:#{@colors[x]} |"
		end
		puts ""
		the_guess = gets.chomp
		if self.verify_guess(the_guess)
			guess_array, guess_input = the_guess.split(""), []
			4.times do |x|
				guess_input[x] = @colors[guess_array[x].to_i - 1]
			end
			self.check_guess(guess_input)
		else
			puts "That is an invalid guess, try again"
			self.take_turn
		end
	end

	def verify_guess(guess)
		guess_array, good_guess, no_go = guess.split(""), 0, 0
		if guess_array.length == 4
			guess_array.each do |x|
				x.to_i >= 1 && x.to_i <=6 ? (good_guess = 1) : (no_go = 1)
			end
		end
		good_guess == 1 && no_go == 0 ? (return true) : (return false)
	end

	def check_win
		return @won if @won == 0
		puts "You're a total winner with #{@turns} turn(s) left \nYou have won #{@number_of_wins} game(s)" if @won == 1	
		puts "YOU LOST TOO BAD GO CRY \n The answer was #{@answer}" if @won == 2
		self.play_again
	end

	def play_again
		puts "Would you like to...twist again? (y/n)"
		playagain = gets.chomp.downcase
		if playagain == 'y'
			self.play
		elsif playagain == 'n'
			puts "goodbye for now, mister mind mmmmmm"
		else
			puts "Incorrect input, try again"
			self.play_again
		end
	end
end

		
test123 = Mastermind.new