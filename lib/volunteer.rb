require 'pry'

class Volunteer
  attr_accessor :name, :project_id, :id;

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
    @project_id = attributes.fetch(:project_id)
  end
  
  def save
    # I wanted to allow volunteer to be onboarded without project assigned to them yet, on update they can assign them a project_id
    if(@project_id == nil)
      sql_project_id = 'null'
    else
      sql_project_id = @project_id
    end
    result = DB.exec("INSERT INTO volunteers (name, project_id) VALUES ('#{@name}', #{sql_project_id}) RETURNING id;")
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
  def self.find(id)
    result = DB.exec("SELECT * FROM volunteers WHERE id=#{id};").first
    Volunteer.new({ :id => result.fetch("id").to_i, :project_id => result.fetch("project_id").to_i, :name => result.fetch("name")})
  end
  
  def update(attributes)
    @name = attributes.fetch(:name)
    @project_id = attributes.fetch(:project_id)
    DB.exec("UPDATE volunteers SET name='#{@name}', project_id=#{@project_id} WHERE id=#{@id};")
  end

  def delete
    DB.exec("DELETE FROM volunteers WHERE id=#{@id};")
  end
end
