class WikiType < ActiveRecord::Base
  has_many :assignments
  require 'open-uri'
  require 'time'

  self.inheritance_column = 'name'


#Argument list
  @url
  @wiki_url
  @namespace
  @namespace_url
  @review
  @index
  @response
  @line_items
  @scan_result

   def check_valid_url(_assignment_url)
    #Check to make sure we were passed a valid URL

    response = '' #the response from the URL

    matches = /http:/.match( _assignment_url )
    if not matches
      return response
    end
  end
  def set_args(_assignment_url)
    #Args
    @url = _assignment_url.chomp("/")
    @wiki_url = _assignment_url.scan(/(.*?)index.php/)
    @namespace = _assignment_url.split(/\//)
    @namespace_url = @namespace.last
  end
  def open_url
    #return url
    open(@url,
         "User-Agent" => "Ruby/#{RUBY_VERSION}",
         "From" => "email@addr.com", #Put pg admin email address here
         "Referer" => "http://") { |f| #Put pg URL here

                                       # Save the response body
      @response = f.read

    }

  end
  def get_line_items(_start_date)
    #if start date provided we only want date line items since start date

        if _start_date


      #NOTE: The date_lines index = dates index

      #Convert _start_date
      start_date = Time.parse(_start_date)

      #Remove dates before deadline
      @dates.each_with_index do |date, index|

        #The date is before start of review
        if Time.parse(date) < start_date
          @line_items.delete_at(index)

        end

      end

    end
  end

end


class MediaWiki < WikiType


  def review_wiki(_assignment_url, _start_date = nil , _wiki_user = nil)
    check_valid_url(_assignment_url)
    set_args(_assignment_url)
    initialize_media(_wiki_user)
    get_url()
    clean_url()
    parse_media()
    extract_line_items()
    extract_dates()
    get_line_items(_start_date)

    #Remove line items that not in this namespace
    @line_items.each_with_index do |item, index|

      @scan_result = item.scan(@namespace_url)

      if not @namespace_url === @scan_result[0]
        @line_items[index] = nil
      end

    end

    @line_items.compact!

    formatted_line_items =Array.new
    formatted_line_items << "<ul>"
    formatted_line_items << @line_items
    formatted_line_items << "</ul>"
    return formatted_line_items
  end
  def initialize_media(_wiki_user)
    @review = "index.php?title=Special:Contributions&target=" + _wiki_user
  end
  def get_url()
    #Grab this user's contributions

    @url = @wiki_url[0].to_s + @review

    open(@url,
         "User-Agent" => "Ruby/#{RUBY_VERSION}",
         "From" => "email@addr.com", #Put pg admin email address here
         "Referer" => "http://") { |f| #Put pg URL here

                                       # Save the response body
      @response = f.read

    }
  end
  def clean_url()
    @response = @response.gsub(/href=\"(.*?)index.php/,'href="' + @wiki_url[0].to_s + 'index.php')
  end
  def extract_line_items()
    #Extract each line item
    @line_items = @response.scan(/<li>.*<\/li>/)
  end
  def extract_dates()
    #Extract the dates only
    @dates = @response.scan(/\d\d:\d\d, \d+ \w+ \d\d\d\d/)
  end
  def parse_media()
    #Mediawiki uses a structure like:
    # <!-- start content -->
    # Content
    # <!-- end content -->
    #
    #Get everything between the words "wikipage"
    changes = @response.split(/<!-- start content -->/)
    changes2 = changes[0].split(/<!-- end content -->/)
    @response = changes2[0]
  end


  def review_mediawiki_group(_assignment_url, _start_date = nil, _wiki_user = nil)
    @line_items = review_wiki(_assignment_url, _start_date , _wiki_user)
    return @line_items.first(3)
  end
end


class DokuWiki < WikiType



  def review_wiki(_assignment_url, _start_date = nil, _wiki_user = nil)           #find_submission
    check_valid_url(_assignment_url)
    set_args(_assignment_url)
    initialize_dokuwiki()
    get_url()
    clean_url()

    #Get all URLs
    @index_urls = @response.scan(/href=\"(.*?)\"/)

    @namespace_urls = Array.new #Create array to store all URLs in this namespace
    @namespace_urls << _assignment_url

    #Narrow down to all URLs in our namespace
    @index_urls.each_with_index do |@index_url, @index|

      @scan_result = @index_url[0].scan(_assignment_url + ":") #scan current item

      if _assignment_url + ":" === @scan_result[0]
        @namespace_urls << @index_urls[@index].to_s
      end
    end

    #Create a array for all of our review_items
    @review_items = Array.new

    #Process Each page in our namespace
    @namespace_urls.each_with_index do |cur_url, index|    #The do that starts here, ends in the last just before the method closes.

                                                           #return cur_url + review
      @url = @namespace_urls[index].to_s
      @url += @review

      open_url()
      parse_doku()
      extract_line_items()
      extract_dates(_wiki_user)
      get_line_items(_start_date)
      @review_items = @review_items + @line_items
    end
    return @review_items


  end

  def initialize_dokuwiki()
    #Doku Wiki Specific
    @index = "?idx=" + @namespace_url
    @review = "?do=revisions" #"?do=recent"
  end
  def get_url()
    #Grab all relevant urls from index page ####################
    @url += @index

    open(@url,
         "User-Agent" => "Ruby/#{RUBY_VERSION}",
         "From" => "email@addr.com", #Put pg admin email address here
         "Referer" => "http://") { |f| #Put pg URL here

                                       # Save the response body
      @response = f.read

    }
  end
  def clean_url()
    @response = @response.gsub(/href=\"(.*?)doku.php/, 'href="' + @wiki_url[0].to_s + 'doku.php')
  end
  def parse_doku
    clean_url()

    # Luckily, dokuwiki uses a structure like:
    # <!-- wikipage start -->
    # Content
    # <!-- wikipage stop -->
    #
    #Get everything between the words "wikipage"
    changes = @response.split(/wikipage/)
    #Trim the "start -->" from "<!-- wikipage start -->"
    changes = changes[0].sub(/start -->/,"")
    #Trim the "<!--" from "<!-- wikipage stop -->"
    @response = changes.sub(/<!--/,"")

  end
  def extract_line_items
    #Extract each line item
    @line_items = @response.scan(/<li>(.*?)<\/li>/)
  end

  def extract_dates(_wiki_user)
    #Extract the dates only
    @dates = @response.scan(/\d\d\d\d\/\d\d\/\d\d \d\d\:\d\d/)

    #if wiki username provided we only want their line items
    if _wiki_user

      #Remove line items that do not contain this user
      @line_items.each_with_index do |item, index|

        @scan_result = item[0].scan(_wiki_user) #scan current item

        if not _wiki_user === @scan_result[0] #no match for wiki user --> eliminate
          @line_items[index] = nil
          @dates[index] = nil
        end

      end

      @line_items.compact!
      @dates.compact!
    end
  end

end


class No < WikiType

end
