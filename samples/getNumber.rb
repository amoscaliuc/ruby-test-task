# Get My Number Game
# Written by: you!
puts "Welcome to 'Get My Number!'"
print "What's your name? "
name = gets.chomp #removes \n from string
puts "Welcome, #{name}!"

# Сохранение случайного числа.
puts "I've got a random number between 1 and 100."
puts "Can you guess it?"
target = rand(100) + 1

num_guesses = 0
limit = 10
# Признак продолжения игры.
guessed_it = false

until num_guesses == limit || guessed_it

	puts "You've got #{limit - num_guesses} guesses left."
	print "Make a guess: "
	guess = gets.to_i # input is converted into integer

	num_guesses += 1

	# Сравнение введенного числа с загаданным
	# и вывод соответствующего сообщения.
	if guess < target
		puts "Oops. Your guess was LOW."
	elsif guess > target
		puts "Oops. Your guess was HIGH."
	elsif guess == target
		puts "Good job, #{name}!"
		puts "You guessed my number in #{num_guesses} guesses!"
		guessed_it = true
	end
end

# Если попыток не осталось, сообщить загаданное число.
unless guessed_it
	puts "Sorry. You didn't get my number. (It was #{target}.)"
end