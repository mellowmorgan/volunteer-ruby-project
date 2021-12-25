require('sinatra')
require('sinatra/reloader')
require('./lib/project')
require('./lib/volunteer')
require('pry')
also_reload('lib/**/*.rb')
require 'pg'

DB = PG.connect({:dbname => "volunteer_tracker"})

get('/') do
  @projects = Project.all
  erb(:projects)
end

get('/projects') do
  @projects = Project.all
  erb(:projects)
end

post('/projects') do
  new_project = Project.new({:title => params[:title], :id => nil })
  new_project.save
  @projects = Project.all
  erb(:projects)
end

get('/volunteers') do
  @volunteers = Volunteer.all
  @projects = Project.all
  erb(:volunteers)
end

post('/volunteers') do
  new_volunteer = Volunteer.new({:name => params[:volunteer], :project_id => params[:project].to_i, :id => nil })
  new_volunteer.save
  @volunteers = Volunteer.all
  @projects = Project.all
  erb(:volunteers)
end

get('/volunteers/:id') do
  @volunteer = Volunteer.find(params[:id].to_i)
  @projects = Project.all
  if @volunteer.project_id == 0
    @project_title = "none yet"
  else
    @project_title = Project.find(@volunteer.project_id).title
  end
  erb(:volunteer)
end

patch('/volunteers/:id') do
  @volunteer = Volunteer.find(params[:id].to_i)
  # @projects = Project.all
  @volunteer.update({:name => params[:volunteer], :project_id => params[:project].to_i})
  redirect '/volunteers'
end

delete('/volunteers/:id') do
  @volunteer = Volunteer.find(params[:id].to_i)
  @volunteer.delete
  redirect '/volunteers'
end

get('/projects/:id') do
  @project = Project.find(params[:id].to_i)
  @volunteers = Volunteer.all
  erb(:project)
end

get('/projects/:id/update') do
  @project = Project.find(params[:id].to_i)
  @volunteers = Volunteer.all
  erb(:edit_project)
end

patch('/projects/:id/update') do
  @project = Project.find(params[:id].to_i)
  @project.update({:title => params[:title]})
  redirect '/projects'
end

delete('/projects/:id') do
  @project = Project.find(params[:id].to_i)
  @project.delete
  redirect '/projects'
end

patch('/projects/:id/new-volunteer') do
  volunteer_new = params[:volunteer].to_i
  if volunteer_new != ""
    volunteer=Volunteer.find(volunteer_new)
    target_project_id = params[:id].to_i
    volunteer.update({:name => volunteer.name, :project_id => target_project_id})
  end
  redirect '/projects'
end