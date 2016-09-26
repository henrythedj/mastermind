class Mastermind

	def initialize(player1, player2 = "mr roboto")
		@player1 = player1
		@player2 = player2
		@won = 0
		@answer = []
		@correctness = ['-', '-', '-', '-']
		@colors = ['red', 'orange', 'yellow', 'green', 'blue', 'indigo']
		@number_colors_in_answer = {'red' => 0, 'orange' => 0, 'yellow' => 0,'green' => 0,'blue' => 0,'indigo' => 0, 'guessed' => 0}
		self.robo_answer
	end

	def robo_answer
		4.times do |i|
			@answer[i] = @colors.sample
		end
		@answer.each do |x|
			@colors.each do |y|
				@number_colors_in_answer[y] += 1 if y==x
			end
		end
		print @answer
		puts " "
	end

	def check_guess(guess)
		print "You guessed: #{guess}\n"
		correct_color, correct_position, temp_number_colors = 0, 0, @number_colors_in_answer
		for i in 0...guess.length do
			(correct_position += 1; temp_number_colors[guess[i]] -= 1; guess[i] = "guessed") if guess[i] == @answer[i]
		end
		for i in 0...guess.length do
			(correct_color += 1; temp_number_colors[guess[i]] -= 1) if temp_number_colors[guess[i]] > 0
		end
		puts "# of correct colors in wrong position: #{correct_color}\n# of colors in correct position: #{correct_position}"
	end
end

		
test123 = Mastermind.new("joe")
bowdown = ['blue','red','green','red']

test123.check_guess(bowdown)