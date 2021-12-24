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
end
