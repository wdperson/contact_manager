#!/usr/bin/env ruby

require 'csv'

class ContactManager
  def initialize
    @people = []
  end

  def start
    @people = Importer.new("person.csv").import_data
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
    matched_index = Searcher.new(email, @people).search
    Output.new(matched_index: matched_index, people: @people).search_results
  end

  def sort_by_last_name
    puts "Enter a letter to sort by last name: "
    letter = gets
    filtered_people = Filter.new(letter, @people).filter_people
    sorted_people = Sorter.new(filtered_people).sort
    Output.new(people: sorted_people).output
  end
end

class Importer
  attr_accessor :file, :people

  def initialize(file)
    @file = file
    @people = []
  end

  def import_data
    CSV.foreach(file,  {headers: true}) do |row|
      person = Person.new(last_name: row['last_name'], first_name: row['first_name'], email: row['email'], phone: row['phone'])
      people << person
    end
    people
  end
end

class Sorter
  attr_accessor :filtered_people

  def initialize(filtered_people)
    @filtered_people = filtered_people
  end

  def sort
    filtered_people.sort! { |a,b| a.last_name.downcase <=> b.last_name.downcase } unless filtered_people.nil?
  end
end

class Searcher
  attr_reader :email, :people

  def initialize(email, people)
    @email = email
    @people = people
  end

  def search
    people.find_index {|person| person.email == email.strip}
  end
end

class Filter
  attr_reader :letter, :people

  def initialize(letter, people)
    @letter = letter
    @people = people
  end

  def filter_people
    people.reject! {|person| person.last_name.downcase[0] != letter.downcase.strip }
  end
end

class Output
  attr_accessor :people, :matched_index

  def initialize(attrs={})
    @people = attrs[:people]
    @matched_index = attrs[:matched_index]
  end

  def search_results
    @match = people[matched_index] unless matched_index.nil?
    @match.nil? ? (puts "no matches") : (puts "Last: #{@match.last_name}, First: #{@match.first_name}, Phone: #{@match.phone}, E-Mail: #{@match.email}")
  end

  def output
    people.empty? ? (puts "no matches") : filtered_output
  end

  def filtered_output
    people.each do |person|
      puts "Last: #{person.last_name}, First: #{person.first_name}, Phone: #{person.phone}, E-Mail: #{person.email}"
    end
  end
end

class Person
  attr_reader :last_name, :first_name, :email, :phone

  def initialize(attrs={})
    @last_name = attrs[:last_name]
    @first_name = attrs[:first_name]
    @email = attrs[:email]
    @phone = attrs[:phone]
  end
end

ContactManager.new().start
