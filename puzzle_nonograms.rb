require 'watir-webdriver'
require 'pry'

@browser = Watir::Browser.new :chrome
@browser.goto 'http://www.puzzle-nonograms.com/'

no = 'http://www.puzzle-nonograms.com/n.gif'
yes = 'http://www.puzzle-nonograms.com/y.gif'
x = 'http://www.puzzle-nonograms.com/x.gif'

# Row headers
r1 = @browser.td(id: 'th_1_0')
r2 = @browser.td(id: 'th_2_0')
r3 = @browser.td(id: 'th_3_0')
r4 = @browser.td(id: 'th_4_0')
r5 = @browser.td(id: 'th_5_0')

# Column headers
c1 = @browser.td(id: 'th_0_1')
c2 = @browser.td(id: 'th_0_2')
c3 = @browser.td(id: 'th_0_3')
c4 = @browser.td(id: 'th_0_4')
c5 = @browser.td(id: 'th_0_5')

# Individual boxes
r1c1 = @browser.image(name: 'i_0_0')
r1c2 = @browser.image(name: 'i_0_1')
r1c3 = @browser.image(name: 'i_0_2')
r1c4 = @browser.image(name: 'i_0_3')
r1c5 = @browser.image(name: 'i_0_4')

r2c1 = @browser.image(name: 'i_1_0')
r2c2 = @browser.image(name: 'i_1_1')
r2c3 = @browser.image(name: 'i_1_2')
r2c4 = @browser.image(name: 'i_1_3')
r2c5 = @browser.image(name: 'i_1_4')

r3c1 = @browser.image(name: 'i_2_0')
r3c2 = @browser.image(name: 'i_2_1')
r3c3 = @browser.image(name: 'i_2_2')
r3c4 = @browser.image(name: 'i_2_3')
r3c5 = @browser.image(name: 'i_2_4')

r4c1 = @browser.image(name: 'i_3_0')
r4c2 = @browser.image(name: 'i_3_1')
r4c3 = @browser.image(name: 'i_3_2')
r4c4 = @browser.image(name: 'i_3_3')
r4c5 = @browser.image(name: 'i_3_4')

r5c1 = @browser.image(name: 'i_4_0')
r5c2 = @browser.image(name: 'i_4_1')
r5c3 = @browser.image(name: 'i_4_2')
r5c4 = @browser.image(name: 'i_4_3')
r5c5 = @browser.image(name: 'i_4_4')

# All boxes in a row
row1 = [r1c1, r1c2, r1c3, r1c4, r1c5]
row2 = [r2c1, r2c2, r2c3, r2c4, r2c5]
row3 = [r3c1, r3c2, r3c3, r3c4, r3c5]
row4 = [r4c1, r4c2, r4c3, r4c4, r4c5]
row5 = [r5c1, r5c2, r5c3, r5c4, r5c5]

# All boxes in a column
col1 = [r1c1, r2c1, r3c1, r4c1, r5c1]
col2 = [r1c2, r2c2, r3c2, r4c2, r5c2]
col3 = [r1c3, r2c3, r3c3, r4c3, r5c3]
col4 = [r1c4, r2c4, r3c4, r4c4, r5c4]
col5 = [r1c5, r2c5, r3c5, r4c5, r5c5]

# Array of row/column numbers
board_numbers = [r1, r2, r3, r4, r5, c1, c2, c3, c4, c5]

# Array of all row/column possibilies
# board = [row1,row2,row3,row4,row5,col1,col2,col3,col4,col5]
board = [[r1, row1],
         [r2, row2],
         [r3, row3],
         [r4, row4],
         [r5, row5],
         [c1, col1],
         [c2, col2],
         [c3, col3],
         [c4, col4],
         [c5, col5]]

board_size = 5

#############
# Functions #
#############

# Get numbers for row/column
def numbers_for(set)
  set.text.split(' ').map(&:to_i)
end

# Check if a box is filled
def there_a_check_on?(checkbox)
  checkbox.src.scan(/\w.gif/)[0].split('').first == 'y'
end

# Get full row/column of checked unchecked boxes
def box_set_results_for(set_of_boxes)
  set_of_boxes.map { |box| is_there_a_check_on(box) }
end

####################
# Solve the Puzzle #
####################

board.each do |set|
  array = numbers_for(set[0])

  # Differentiate logic depending on how many numbers there are
  case array.length
  when 0
    puts('There are zero numbers in the set')

  when 1
    from_start = []
    from_end = []

    # Check for full length/size fills
    numbers_for(set[0]) == board_size ? set[1].each(&:click) : false

    # Set arrays to compare values
    num = numbers_for(set[0]).first
    num.times do
      from_start.push(1)
      from_end.unshift(1)
    end
    (board_size - num).times do
      from_start.push(0)
      from_end.unshift(0)
    end

    # Compare array values for each set and select at overlay
    value = 0
    board_size.times do |box_number|
      if  from_start[value] == from_end[value] &&
          from_start[value].nonzero?
        set[1][box_number].src == (no || x) ? set[1][box_number].click : false
      end
      value += 1
    end

  when 2
    from_start = []
    from_end = []

    # Fill in gaps between numbers with a 0
    array.insert(1, 0)
      array.each do |number|
        # Add a 1 n times
        if number > 0
          number.times do
            # Add a 1 to the beginning
            from_start.push(1)
            # Add a 1 to the end
            from_end.unshift(1)
          end
        else
          # Add a 0 to the beginning
          from_start.push(0)
          # Add a 0 to the end
          from_end.unshift(0)
        end
      end
    while from_start.length < board_size
      from_start.push(0)
      from_end.unshift(0)
    end
    binding.pry

  when 3
    array.insert(1, 0)
    array.insert(3, 0)

  end
end

@browser.close if @browser

# Ruby Array Permutations

# (1..5).to_a

# # Do this if there are multiple numbers
# if numbers_for(set[0]).length > 1
#   array = numbers_for(set[0])
#
#   case array.length
#     when 0
#
#     when 1
#
#     when 2
#       array.insert(1, 0)
#     when 3
#       array.insert(1, 0)
#       array.insert(3, 0)
#   end
#
#   # binding.pry
# end
