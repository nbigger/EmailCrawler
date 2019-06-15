require 'rubygems'
require 'mechanize'

# urls to visit
new_urls = Queue.new
new_urls << 'https://www.cityoftacoma.org/government/city_departments/community_and_economic_development/economic_development_services/small_business_assistance'

# urls we've already visited
old_urls = Set.new

# emails we've found
emails = Set.new

agent = Mechanize.new

# while !urls.empty?
  # grab a new url
  url = new_urls.pop()
  old_urls.add(url)

  # navigate to the new page and retrieve it
  page  = agent.get(url)

  page.links.each do |link|
    if !old_urls.include?(link)
      new_urls << link
    end
  end
# end