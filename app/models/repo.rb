class Repo
  attr_reader :name,
              :html_url
  def initialize(attributes)
    @name = attributes['name']
    @html_url = attributes['html_url']
  end
end
