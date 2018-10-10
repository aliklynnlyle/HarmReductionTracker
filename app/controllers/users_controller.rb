class UsersController < ApplicationController
  helper_method :sort_column, :sort_direction

  #skip_before_action :authenticate_user! , only: [:create]
  before_action :set_user, only: [:show, :update]

  def index
      if search_params[:search_term_county].present?
        @users = User.search_by_county(search_params[:search_term_county]).order("created_at DESC").page(params[:page]).per(20)
      elsif search_params[:search_term_city].present?
        @users = User.search_by_city(search_params[:search_term_city]).order("created_at DESC").page(params[:page]).per(20)        
      elsif search_params[:search_term_date].present?
        @users = User.search_by_last_name(search_params[:search_term_last_name]).order("created_at DESC").page(params[:page]).per(20)
      else
        @users = User.order("#{sort_column} #{sort_direction}").page(params[:page]).per(20)
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render users_path, notice: "Your account was created successfully."
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      redirect_to users_path, notice: "Your account was updated successfully."
    else
      render 'edit', notice: "Error in update."
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |user_params|
      user_params.permit({ roles: [] }, :email, :password, :password_confirmation)
    end
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :password, :email, :phone, :county, :address1, :address2, :city, :state, :zip, :admin, :contact_type, :date_auth, :admin_auth)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def sort_column
    sortable_columns.include?(params[:column]) ? params[:column] : "last_name"
  end
  
  def sortable_columns
    ["first_name", "last_name", "email", "city", "county"]
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def search_params
    params.permit(:search_term_county, :search_term_city, :search_term_last_name)
  end
end
