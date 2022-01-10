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
  erb(:volunteers_list)
end

post('/volunteers') do
  new_volunteer = Volunteer.new({:name => params[:volunteer], :project_id => params[:project].to_i, :id => nil })
  new_volunteer.save
  @volunteers = Volunteer.all
  @projects = Project.all
  @project = Project.find(params[:project].to_i)
  erb(:volunteers_list)
end

get('/projects/:project_id/volunteers/:id') do
  @volunteer = Volunteer.find(params[:id].to_i)
  @projects = Project.all
  @project_title = Project.find(@volunteer.project_id).title
  erb(:volunteer)
end

get('/projects/:project_id/volunteers') do
  @projects = Project.all
  @project = Project.find(params[:project_id].to_i)
  erb(:new_volunteer)
end

post('/projects/:project_id/volunteers') do
    new_volunteer = Volunteer.new({:name => params[:volunteer], :project_id => params[:project].to_i, :id => nil })
  new_volunteer.save
  @volunteers = Volunteer.all
  @projects = Project.all
  @project = Project.find(params[:project_id].to_i)
  @volunteers = Volunteer.all
  erb(:project)
end

patch('/projects/:project_id/volunteers/:id') do
  @volunteer = Volunteer.find(params[:id].to_i)
  @project = Project.find(params[:project_id].to_i)
  @volunteer.update({:name => params[:name], :project_id => params[:project].to_i})
  @volunteers = Volunteer.all
  erb(:project)
end

delete('/projects/:project_id/volunteers/:id') do
  @volunteer = Volunteer.find(params[:id].to_i)
  @project = Project.find(params[:project_id].to_i)
  @volunteer.delete
  @volunteers = Volunteer.all
  erb(:project)
end
get('/projects/:id') do
  @project = Project.find(params[:id].to_i)
  @volunteers = Volunteer.all
  erb(:project)
end

get('/projects/:id/edit') do
  @project = Project.find(params[:id].to_i)
  @volunteers = Volunteer.all
  erb(:edit_project)
end

patch('/projects/:id/edit') do
  @project = Project.find(params[:id].to_i)
  @volunteers = Volunteer.all
  @project.update({:title => params[:title]})
  erb(:project)
end

delete('/projects/:id/edit') do
  @project = Project.find(params[:id].to_i)
  @project.delete
  redirect '/projects'
end

patch('/projects/:id/new-volunteer') do
  volunteer_new = params[:volunteer].to_i
  @project = Project.find(params[:id].to_i)
  @volunteers = Volunteer.all
  if volunteer_new != ""
    volunteer=Volunteer.find(volunteer_new)
    target_project_id = params[:id].to_i
    volunteer.update({:name => volunteer.name, :project_id => target_project_id})
  end
  erb(:project)
end