module ApplicationHelper
  def vote_url(resource, value)
    polymorphic_path( resource, 
                      action: 'create_vote', 
                      id: resource, 
                      value: value, 
                      format: :json )
  end
end
