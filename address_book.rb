require 'rubygems'
require 'yaml'

# We're using an Array as our data store. This the ONE AND ONLY TIME we'll use
# a global variable!
$address_book = []

# A Person represents an individual that we want to store contact information
# for, the superclass of Trainee and Instructor
#
class Person
  attr_accessor :shoes
  attr_accessor :first_name
  attr_accessor :last_name
  # TODO 1. Add more!

  attr_accessor :email
  attr_accessor :github
  attr_accessor :twitter
  attr_accessor :fun_fact


  def initialize(shoes)
    self.shoes = shoes
  end


  def self.make_person(type,gui)
      case type
        when "Trainee"

          Trainee.new(gui)

        when "Instructor"

          Instructor.new(gui)
      end 
  end


  def self.find_person(name) 
    debug $address_book
    $address_book.select do |person|

          if person.last_name[0] == name
              yield person
          end

     end
  
  end


  # Displays the input form to the user
  #
  def draw
    shoes.clear
    shoes.append do
      # Show the questions on the screen
      draw_questions

      shoes.button "Save" do
        # Set the values from the boxes into the Object
        save_values

        # Append ourselves to our address_book Array
        $address_book << self

        # TODO: 6. Open a address_book.yml YAML file and write it out to disc
        # shoes.debug self.to_yaml
        filename = "address_book.yaml"

        File.open(filename, "a") { |file| 

              file.write self.to_yaml


        }


        # Create a new person object
        new_person = Person.make_person(self.class.to_s, shoes)
        new_person.draw

        shoes.alert 'Saved'
      end
    end
  end

  # Renders some labels and textboxes to prompt the user for input
  #
  def draw_questions
    shoes.flow do
      shoes.caption "First name"
      @first_name_field = shoes.edit_line
    end

    shoes.flow do
      shoes.caption "Last name"
      @last_name_field = shoes.edit_line
    end

    shoes.flow do
     shoes.caption "Email"
     @email_field = shoes.edit_line
    end

    shoes.flow do
      shoes.caption "Github"
      @github_field = shoes.edit_line
    end

    shoes.flow do
      shoes.caption "Twitter"
      @twitter_field =shoes.edit_line
    end

    shoes.flow do
      shoes.caption "Fun fact"
      @fun_fact_field = shoes.edit_line
    end

    # TODO 4. Add fields for the user to fill in, but only if they are
    # relevant to the given user type.

  end

  # Set the persons's name to the contents of the text box
  #
  def save_values
    self.first_name = @first_name_field.text.strip.chomp
    self.last_name = @last_name_field.text.strip.chomp
   
  # TODO: 2. Finish the implementation to set the other fields.
    self.email = @email_field.text.strip.chomp
    self.github = @github_field.text.strip.chomp
    self.twitter = @twitter_field.text.strip.chomp
    self.fun_fact = @fun_fact_field.text.strip.chomp
  end
end

class Trainee < Person
  attr_accessor :preferred_text_editor

  def draw_questions
    super
    shoes.flow do
        shoes.caption "Preferred text editor"
        @preferred_text_editor_field = shoes.edit_line
    end
  end
  def save_values
    super
    self.preferred_text_editor = @preferred_text_editor_field.text.strip.chomp
  end
end



class Instructor < Person
  attr_accessor :teaching_experience

  def draw_questions
    super
    shoes.flow do 
        shoes.caption "Teaching Experience"
        @teaching_experience_field = shoes.edit_line
    end
  end

  def save_values
    super
    self.teaching_experience = @teaching_experience_field.text.strip.chomp
  end
end

Shoes.app title: "Ruby Address Book", width: 520 do
  background rgb(240, 250, 208)
  # The row of buttons to lookup Person objects in the address_book
  ('A'..'Z').each do |letter|
    flow width: 40 do
      button letter do
        # TODO 5. Show each of the Person objects in the address_book where the
        # last name matches.

    
            Person.find_person(letter) do |contact| 
              debug contact

                    para  ("#{contact.first_name} #{contact.last_name}")                    
                      
                      
            end

          # }        
       # }   

      end
    end
  end


  stack margin: 20 do
    flow do
      caption "Type"
      list_box :items => %w(Trainee Instructor) do |selected|
        debug selected.text

        # TODO 3. Create a Trainee or an Instructor using a Person factory method
        # and store the result in @person. Show the fields for the user to fill in
          @person = Person.make_person(selected.text,@form)
          @person.draw
          # address_book.push(@person)

          debug @person.inspect
      end
    end

    # This reserves space for the form elements to be appended later by the
    # draw method
    @form = stack

    # Actually draw the form using Trainee as a default
    @person = Trainee.new(@form)
    @person.draw
  end


end