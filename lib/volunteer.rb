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
end