require 'rubygems'
require 'mechanize'
require 'csv'

# Parse the urls from the csv to search
url_list = CSV.read('urls.csv')

new_urls = Queue.new # urls to visit
old_urls = Set.new # urls we've already visited

emails = Set.new # emails we've found

# load the urls into the queue
url_list.shift
url_list.each do |url|
  new_urls << url[0].strip
end

agent = Mechanize.new

while !new_urls.empty?
  # grab a new url
  url = new_urls.pop()
  old_urls.add(url)

  # navigate to the new page and retrieve it
  page  = agent.get(url)

  # emails = /([\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+)/.match page.text.to_s
  # if there is a link with a mailto: href, grab it
  page.links_with(:href => %r'mailto:').each do |email|
    emails << email
    old_urls << email.href
  end

  # now we need to find any relative links that we haven't already searched and add
  # them to the queue
  page.links_with(:href => %r'^(?!www\.|(?:http|ftp)s?://|[A-Za-z]:\\|//).*').each do |rel_url|
    puts page.uri.merge rel_url.uri

    # urls << rel_urls
  end
end