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
  @volunteers = Volunteer.all
  erb(:home)
end

get('/home') do
  erb(:home)
end

get('/projects') do
  @projects = Project.all
  erb(:projects)
end

post('/projects') do
  new_project = Project.new({:title => params[:project], :id => nil })
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



