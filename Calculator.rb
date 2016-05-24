
class Calculator #Turns a string input into a numerical response
  
  class << self 
  
    def evaluateInput(input) #Returns the numerical evaluation of the string
      if parenCheck(input)
        stripped_input = strip(input)
        return add_sweep(stripped_input)
      else
        return nil
      end
    end
  
    private
  
    def strip(input) #Removes spaces from input
      returnString = ''
      input.each_char do |input_char|
        if input_char != " "
          returnString<<input_char
        end
      end
      return returnString
    end
  
    def add_sweep(input) #Performs the first addition possible given a string input,
                        #or returns the evaluation of the string input if no 
                        #addition is possible
      if input.length == 0 || input == nil
        return 0
      end
      puts input
      parenDepth = 0
      foundPlus = false
      foundOperator = false
      index = 0
      leftHand = ''
      toNegate = false
      while (index < input.length && (not foundPlus)) do
        if parenDepth == 0 #Only additions outside of parentheses can be
                          #performed
          if (input[index] == '+' || input[index] == '-')
            if (index > 0 && not(input[index-1] == "*" ||\
                input[index-1] == "/"))
              foundPlus = true
            elsif input[index] == '-' &&\
                index == 0
              toNegate = true
              index = 1
            else
              leftHand<<input[index]
              index += 1
            end
          elsif input[index] == '('
            parenDepth = 1
            index+=1
            leftHand<<'('
            foundOperator = true
          elsif isOperator(input[index]) &&
              index > 0
            foundOperator = true
            leftHand<<input[index]
            index+=1
          else
            leftHand<<input[index]
            index+=1
          end
        else
          if input[index] == '('
            parenDepth += 1
          elsif input[index] == ')'
            parenDepth -= 1
          end
          leftHand << input[index]
          index+=1
        end
        
      end
      if toNegate
        if foundOperator
          if foundPlus
            if input[index] == "+"
              return (-1) * add_sweep(leftHand[0..index - 1])\
                + add_sweep(input[index+1..-1])
            elsif input[index] == "-"
              return (-1) * add_sweep(leftHand[0..index - 1])\
                - add_sweep(input[index+1..-1])
            end
          else
            return (-1) * multiply_sweep(leftHand[0..index - 1])
          end
        else
          if foundPlus
            if input[index] == "+"
              return (-1) * leftHand[0..index - 1].to_i\
                + add_sweep(input[index+1..-1])
            elsif input[index] == "-"
              return (-1) * leftHand[0..index - 1].to_i\
                - add_sweep(input[index+1..-1])
            end
          else
            return (-1) * leftHand.to_i
          end
        end
      else
        if foundOperator
          if foundPlus
            if input[index] == "+"
              return multiply_sweep(leftHand) + add_sweep(input[index+1..-1])
            elsif input[index] == "-"
              return multiply_sweep(leftHand) - add_sweep(input[index+1..-1])
            end
          else
            return multiply_sweep(leftHand)
          end
        else
          if foundPlus
            if input[index] == "+"
              return leftHand.to_i + add_sweep(input[index+1..-1])
            elsif input[index] == "-"
              return leftHand.to_i - add_sweep(input[index+1..-1])
            end
          else
            return leftHand.to_i
          end
        end
      end
    end
    
    def multiply_sweep(input) #Performs the first multiplication possible given a
                              #string input, or returns the evaluation of the input
                              #if that isn't possible
      if input.length == 0 || input == nil
        return 1
      end
      parenDepth = 0
      foundTimes = false
      foundOperator = false
      index = 0
      leftHand = ''
      inParenResult = ''
      while index < input.length && (not foundTimes) do
        if parenDepth == 0 #Only multiplications outside of parentheses can be
                          #performed
          if input[index] == '*' || input[index] == '/'
            foundTimes = true
          else
            if input[index] == '('
              parenDepth = 1
              index+=1
            else
              if isOperator(input[index])
                foundOperator = true
              end
              leftHand<<input[index]
              index+=1
            end
          end
        else
          if input[index] == '('
            parenDepth += 1
          end
          if input[index] == ')'
            parenDepth -= 1
            if parenDepth > 0
              inParenResult<<input[index]
            else
              leftHand<<add_sweep(inParenResult).to_s
            end
          else
            inParenResult<<input[index]
          end
          index+=1
        end
      end
      if foundOperator
        if foundTimes
          if input[index] == "*"
            return multiply_sweep(leftHand) * add_sweep(input[index+1..-1])
          elsif input[index] == "/"
            return multiply_sweep(leftHand) / add_sweep(input[index+1..-1])
          end
        else
          puts "Invalid expression"
        end
      else
        if foundTimes
          if input[index] == "*"
            return leftHand.to_i * add_sweep(input[index+1..-1])
          elsif input[index] == "/"
            return leftHand.to_i / add_sweep(input[index+1..-1])
          end
        else
          return leftHand.to_i
        end
      end
    end
    
    def isOperator(char) #Determines if a character is in the set of
                        #operators recognized by Calculator
      ['+','-','*','/','(',')'].each do |sign|
        if char == sign
          return true
        end
      end
      return false
    end
    
    
    
    def parenCheck(input) #Checks if there is an equal number of open
                  #and closed parentheses
      parenDepth = 0
      input.each_char do |input_char|
        if input_char == '('
          parenDepth+=1
        elsif input_char == ')'
          parenDepth-=1
        end
      end
      if parenDepth == 0
        return true
      else
        puts "Parenthesese mismatch"
        return false
      end
    end
  end
end
    
