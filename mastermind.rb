class Mastermind

	def initialize(player1, player2 = "mr roboto")
		@player1 = player1
		@player2 = player2
		@won = 0
		@answer = []
		@correctness = ['-', '-', '-', '-']
		@colors = ['red', 'orange', 'yellow', 'green', 'blue', 'indigo']
		@number_colors_in_answer = {'red' => 0, 'orange' => 0, 'yellow' => 0,'green' => 0,'blue' => 0,'indigo' => 0}
	end

	def robo_answer
		4.times do |i|
			@answer[i] = @colors.sample
		end
		@answer = ['red','red','indigo','blue']
		@answer.each do |x|
			@colors.each do |y|
				@number_colors_in_answer[y] += 1 if y==x
			end
		end
	end

	def check_guess(guess)
		# puts "Invalid guess"; return "no" if guess.length != 4
		temp_guess = guess
		temp_number_colors = @number_colors_in_answer
		first_check_correct_color = 0
		correct_location = 0
		#first check for the number of correct colors
		puts temp_number_colors[guess[1]]
		@colors.each do |x|
			for i in 0...temp_guess.length do
				puts "hey"; first_check_correct_color += 1; temp_guess.delete_at(i); temp_number_colors[x] -= 1 if temp_number_colors[guess[i]] > 0
			end
		end
		puts temp_guess
		puts temp_number_colors
		puts first_check_correct_color

	end
end

		
test123 = Mastermind.new("joe")

test123.robo_answer
guess = ['red','red','orange','indigo']
puts guess.length
test123.check_guess(guess)