require 'pry'

class Volunteer
  attr_accessor :name, :project_id, :id;

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
    @project_id = attributes.fetch(:project_id)
  end
  
  def save
    result = DB.exec("INSERT INTO volunteers (name, project_id) VALUES ('#{@name}', #{@project_id}) RETURNING id;")
    @id = result.first.fetch("id").to_i
  end

  def ==(volunteer_to_compare)
    (self.name == volunteer_to_compare.name) && (self.project_id == volunteer_to_compare.project_id)
  end

  def self.all
    all_volunteers = []
    results = DB.exec("SELECT * FROM volunteers;")
    results.each do |entry|
      all_volunteers.push(Volunteer.new({ :name => entry.fetch("name"), :project_id => entry.fetch("project_id").to_i, :id => entry.fetch("id").to_i }))
    end
    all_volunteers
  end
end