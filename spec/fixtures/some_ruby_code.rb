# Example ruby code
class User
  attr_accessor :name, :email

  def intialize(name, email)
    @name = name
    @email = email
  end

  def say_hello
    puts "Hello #{name}"
  end
end
