# app/controllers/recipes_controller.rb
class RecipesController < ApplicationController
    before_action :authorize_user, except: :index
  
    def index
      if logged_in?
        recipes = Recipe.all.includes(:user)
        render json: recipes, include: :user, status: :ok
      else
        render json: { errors: ['Unauthorized'] }, status: :unauthorized
      end
    end
  
    def create
      if logged_in?
        user = User.find(session[:user_id])
        recipe = user.recipes.build(recipe_params)
  
        if recipe.save
          render json: recipe, include: :user, status: :created
        else
          render json: { errors: recipe.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { errors: ['Unauthorized'] }, status: :unauthorized
      end
    end
  
    private
  
    def recipe_params
      params.require(:recipe).permit(:title, :instructions, :minutes_to_complete)
    end
  
    def authorize_user
      unless session[:user_id]
        render json: { errors: ['Unauthorized'] }, status: :unauthorized
      end
    end
  end
  