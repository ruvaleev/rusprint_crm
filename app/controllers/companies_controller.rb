class CompaniesController < ApplicationController
  before_action :authenticate_user!
  before_action :resource_company, only: %i[update get_printers]

  load_and_authorize_resource

  def index; end

  def create
    @company = Company.create(company_params)
    @message = if @company.errors.any?
                 @company.errors.messages
               else
                 "Компания #{@company.name} успешно создана"
               end
  end

  def show; end

  def update
    message = ''
    if resource_company.update(company_params)
      company_params.each { |key| message << "Успешно обновили #{key.humanize} \n" }
      status = 200
    else
      resource_company.errors.messages.each { |key, value| message << "#{key.to_s.humanize} - #{value} \n" }
      status = 400
    end
    respond_to do |format|
      format.json { render json: { message: message }, status: status }
      format.html
    end
  end

  def get_printers
    @printers = resource_company.printers
    @vendors = Printer::VENDORS.map.with_index.to_a
  end

  private

  def resource_company
    Company.find(params[:id])
  end

  def company_params
    params.require(:company).permit(:name, :adress, :telephone)
  end
end
