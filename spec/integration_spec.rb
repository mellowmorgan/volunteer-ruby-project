require "capybara/rspec"
require "./app"
require "pry"
require('spec_helper')

Capybara.app = Sinatra::Application
set(:show_exceptions, false)

# Your project should be set up so that a volunteer can only be created if a project already exists. (This makes it easier to assign the one to many relationship in Sinatra.) Focus on getting one integration spec passing at a time.

# The user should be able to visit the home page and fill out a form to add a new project. When that project is created, the application should direct them back to the homepage.

describe 'the project creation path', {:type => :feature} do
  it 'takes the user to the homepage where they can create a project' do
    visit '/'
    fill_in('title', :with => 'Teaching Kids to Code')
    click_button('Create Project')
    expect(page).to have_content('Teaching Kids to Code')
  end
end

# A user should be able to click on a project to see its detail. The detail page includes a form where the project can be updated. When the form is submitted, the user can be directed to either the home page or that project's detail page. (The test will work for either.)

describe 'the project update path', {:type => :feature} do
  it 'allows a user to change the name of the project' do
    test_project = Project.new({:title => 'Teaching Kids to Code', :id => nil})
    test_project.save
    visit '/'
    click_link('Teaching Kids to Code')
    click_link('Edit Project')
    fill_in('title', :with => 'Teaching Ruby to Kids')
    click_button('Update Project')
    expect(page).to have_content('Teaching Ruby to Kids')
  end
end

# A user should be able to nagivate to a project's detail page and delete the project. The user will then be directed to the index page. The project should no longer be on the list of projects.

describe 'the project delete path', {:type => :feature} do
  it 'allows a user to delete a project' do
    test_project = Project.new({:title => 'Teaching Kids to Code', :id => nil})
    test_project.save
    id = test_project.id
    visit "/projects/#{id}/edit"
    click_button('Delete Project')
    visit '/'
    expect(page).not_to have_content("Teaching Kids to Code")
  end
end


# The user should be able to click on a project detail page and see a list of all volunteers working on that project. The user should be able to click on a volunteer to see the volunteer's detail page.

describe 'the volunteer update page path', {:type => :feature} do
  it 'shows a volunteer and updates them' do
    test_project = Project.new({:title => 'Teaching Kids to Code', :id => nil})
    test_project.save
    project_id = test_project.id.to_i
    test_volunteer = Volunteer.new({:name => 'Jasmine', :project_id => project_id, :id => nil})
    test_volunteer.save
    visit "/projects/#{project_id}"
    click_link('Jasmine')
    fill_in('name', :with => 'Jane')
    click_button('Update Volunteer')
    expect(page).to have_content('Jane')
  end
end

describe 'add existing volunteer to project', {:type => :feature} do
  it 'shows volunteer on project list of project page' do
    test_project = Project.new({:title => 'Teaching Kids to Code', :id => nil})
    test_project.save
    test_volunteer = Volunteer.new({:name => 'Jasmine', :project_id => test_project.id, :id => nil})
    test_volunteer.save
    test_project_2 = Project.new({:title => 'Teaching Kids to Code 2', :id => nil})
    test_project_2.save
    visit "/projects/#{test_project_2.id}"
    select "Jasmine", :from => "volunteer"
    click_button('Add')
    visit "/projects/#{test_project_2.id}"
    expect(page).to have_content('Jasmine')
  end
end

describe 'delete volunteer from volunteers page', {:type => :feature} do
  it 'volunteer is gone from page' do
    test_project = Project.new({:title => 'Teaching Kids to Code', :id => nil})
    test_project.save
    test_volunteer = Volunteer.new({:name => 'Jasmine', :project_id => test_project.id, :id => nil})
    test_volunteer.save
    visit "/volunteers"
    click_link('Jasmine')
    click_button('Delete')
    expect(page).to have_no_content('Jasmine')
  end
end
describe 'delete volunteer from project nested route', {:type => :feature} do
  it 'volunteer is gone from page' do
    test_project = Project.new({:title => 'Teaching Kids to Code', :id => nil})
    test_project.save
    test_volunteer = Volunteer.new({:name => 'Jasmine', :project_id => test_project.id, :id => nil})
    test_volunteer.save
    visit "/projects/#{test_project.id}"
    click_link('Jasmine')
    click_button('Delete')
    expect(page).to have_no_content('Jasmine')
  end
end


describe 'add volunteer to project page', {:type => :feature} do
  it 'shows volunteer on project list of project page' do
    test_project = Project.new({:title => 'Teaching Kids to Code', :id => nil})
    test_project.save
    project_id = test_project.id.to_i
    test_volunteer = Volunteer.new({:name => 'Jasmine', :project_id => test_project.id, :id => nil})
    test_volunteer.save
    test_project_2 = Project.new({:title => 'Teaching Kids to Code 2', :id => nil})
    test_project_2.save
    visit "projects/#{test_project.id}/volunteers/#{test_volunteer.id}"
    select "Teaching Kids to Code 2", :from => "project"
    click_button('Update Volunteer')
    click_link('Projects')
    click_link('Teaching Kids to Code 2')
    expect(page).to have_content('Jasmine')
  end
end

describe 'add volunteer from volunteers page', {:type => :feature} do
  it 'shows volunteer of volunteers page' do
    test_project = Project.new({:title => 'Teaching Kids to Code', :id => nil})
    test_project.save
    visit "/volunteers"
    fill_in('volunteer', :with => 'Hasan')
    select "Teaching Kids to Code", :from => "project"
    click_button('Add Volunteer')
    expect(page).to have_content('Hasan')
  end
end
describe 'delete project deletes volunteers associated', {:type => :feature} do
  it 'volunteers are gone when project they belong to is deleted' do
    test_project = Project.new({:title => 'Teaching Kids to Code', :id => nil})
    test_project.save
    project_id = test_project.id.to_i
    test_volunteer = Volunteer.new({:name => 'Jasmine', :project_id => test_project.id, :id => nil})
    test_volunteer.save
    id = test_project.id
    visit "/projects/#{id}/edit"
    click_button('Delete Project')
    visit '/'
    expect(page).to have_no_content('Jasmine')
  end
end