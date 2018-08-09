class CompaniesController < ApplicationController
  before_action :authenticate_user!

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

  private

  def company_params
    params.require(:company).permit(:name, :adress, :telephone)
  end
end