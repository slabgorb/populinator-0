class PeopleController < ApplicationController
  def random_name 
    gender = Person.random_gender
    render json: [gender, Person.random_name(gender),  Person.random_age]
  end
end
