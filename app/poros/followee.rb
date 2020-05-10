class Followee
  attr_reader :username,
              :html_url
  def initialize(attributes)
    @username = attributes[:login]
    @html_url = attributes[:html_url]
  end
end
