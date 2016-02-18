#!/usr/bin/env ruby

require 'csv'

class ContactManager

  def initialize
    @people = []
  end

  def start
    import_data("person.csv")
    puts "Select an option:"
    puts "1) Sort by Letter of Last Name"
    puts "2) Search by email"
    number = gets
    case number.strip
    when "1"
      sort_by_last_name
    when "2"
      search_email
    end
  end

  def search_email
    puts "Enter an email to search for: "
    email = gets
    search(email)
    search_results
  end

  def sort_by_last_name
    puts "Enter a letter to sort by last name: "
    letter = gets
    filter_people(letter)
    sort
    output
  end

  def sort
    @filtered_people.sort! { |a,b| a.last_name.downcase <=> b.last_name.downcase } unless @filtered_people.nil?
  end

  def output
    @filtered_people.empty? ? (puts "no matches") : filtered_output
  end

  def filtered_output
    @filtered_people.each do |person|
      puts "Last: #{person.last_name}, First: #{person.first_name}, Phone: #{person.phone}, E-Mail: #{person.email}"
    end
  end

  def filter_people(letter)
    @filtered_people = @people.reject! {|person| person.last_name.downcase[0] != letter.downcase.strip }
  end

  def search(email)
    @matched_index = @people.find_index {|person| person.email == email.strip}
  end

  def search_results
    @match = @people[@matched_index] unless @matched_index.nil?
    @match.nil? ? (puts "no matches") : (puts "Last: #{@match.last_name}, First: #{@match.first_name}, Phone: #{@match.phone}, E-Mail: #{@match.email}")
  end

  def import_data(file)
    CSV.foreach(file,  {headers: true}) do |row|
      person = Person.new(last_name: row['last_name'], first_name: row['first_name'], email: row['email'], phone: row['phone'])
      @people << person
    end
  end
end

class Person
  attr_accessor :last_name, :first_name, :email, :phone

  def initialize(attrs={})
    @last_name = attrs[:last_name]
    @first_name = attrs[:first_name]
    @email = attrs[:email]
    @phone = attrs[:phone]
  end
end

ContactManager.new().start
