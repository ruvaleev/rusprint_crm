class CompaniesController < ApplicationController
  before_action :authenticate_user!
  before_action :resource_company, only: [ :update, :get_printers ]

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
    resource_company.update(company_params)
  end

   def get_printers
    @printers   = resource_company.printers
    @vendors    = Printer::VENDORS.map.with_index.to_a
  end
  
  private

  def resource_company
    Company.find(params[:id])
  end

  def company_params
    params.require(:company).permit(:name, :adress, :telephone)
  end
end