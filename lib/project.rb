require 'pry'

class Project
  attr_accessor :title, :id;

  def initialize(attributes)
    @title = attributes.fetch(:title)
    @id = attributes.fetch(:id)
  end
  
  def save
    result = DB.exec("INSERT INTO projects (title) VALUES ('#{@title}') RETURNING id;")
    @id = result.first.fetch("id").to_i
  end

  def ==(project_to_compare)
    (self.title==project_to_compare.title)
  end

  def self.all
    all_projects = []
    results = DB.exec("SELECT * FROM projects;")
    results.each do |entry|
      all_projects.push(Project.new({ :title => entry.fetch("title"), :id => entry.fetch("id").to_i }))
    end
    all_projects
  end

  def self.find(id)
    result = DB.exec("SELECT * FROM projects WHERE id=#{id};").first
    Project.new({ :id => result.fetch("id").to_i, :title => result.fetch("title")})
  end
  
  def update(attributes)
    @title = attributes.fetch(:title)
    DB.exec("UPDATE projects SET title='#{@title}' WHERE id=#{@id};")
  end

  def delete
    DB.exec("DELETE FROM projects WHERE id=#{@id};")
    #because this project is gone, all volunteers associated with project must have project_id updated to 0, which represents no project
    self.volunteers.each do |volunteer|
      volunteer.update({:name => volunteer.name, :project_id => 0})
    end
  end

  def volunteers
    volunteers = []
    results = DB.exec("SELECT * FROM volunteers WHERE project_id=#{@id}")
    results.each do |result|
      volunteers.push(Volunteer.new({:name => result.fetch("name"), :project_id => result.fetch("project_id").to_i, :id => result.fetch("id").to_i }))
    end 
    volunteers
  end
end