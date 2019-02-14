class CompaniesController < ApplicationController
  before_action :authenticate_user!

  load_and_authorize_resource
  
  def index
  end

  def create
    @company = Company.create(company_params)
    if @company.errors.any?
      @message = @company.errors.messages
    else
      @message = "Компания #{@company.name} успешно создана"
    end
  end

  def show
  end

  def update
    @company = Company.find(params[:id])
    @company.update(company_params)
  end

  private

  def company_params
    params.require(:company).permit(:name, :adress, :telephone)
  end
end