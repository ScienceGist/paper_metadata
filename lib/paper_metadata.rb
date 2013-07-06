require 'paper_metadata/version'
require 'nokogiri'
require 'net/http'
require 'open-uri'
require 'cgi'
require 'uri'

module PaperMetadata
  class << self
    attr_accessor :doi_username

    def doi_username
      raise "PaperMetadata needs the DOI username to work with CrossRef API" unless @doi_username
      @doi_username
    end

    def metadata_for(identifier)
      if identifier =~ /^arxiv\:(.*)/i
        metadata_for_arxiv($1.strip)
      elsif identifier =~ /^doi\:(.*)/i
        metadata_for_doi($1.strip)
      end
    end

    def metadata_for_doi(doi)
      doc = Nokogiri::XML(open("http://www.crossref.org/guestquery?queryType=doi&restype=unixref&doi=#{URI.escape(doi)}&doi_search=Search"))
      paper = Hash.new

      doc = doc.css('table[name=doiresult]').first

      if doc.xpath("//titles/title").first
        paper[:volume] = doc.xpath("//journal_issue/journal_volume/volume").inner_html.to_s
        paper[:isssue] = doc.xpath("//journal_issue/issue").inner_html.to_s
        paper[:first_page] = doc.xpath("//pages/first_page").inner_html.to_s
        paper[:last_page] = doc.xpath("//pages/last_page").inner_html.to_s
        paper[:title] = doc.xpath("//titles/title").inner_html.to_s
        paper[:authors] = doc.xpath("//contributors/person_name").
          map{ |author| author.content.strip}

        paper[:authors] = paper[:authors].map do |author|
          author.gsub(/\s+/, ' ')
        end.join(', ')

        paper[:journal] = doc.xpath("//abbrev_title").inner_html + " " +
          doc.xpath("//journal_issue/publication_date/year").first.inner_html
        paper[:resource] = doc.xpath("//journal_article/doi_data/resource").inner_html
      else
        paper[:status] = :NODOI
      end
      paper
    end

    def metadata_for_arxiv(identifier)
      identifier.gsub!(/^arXiv\:/i, '')
      url = URI.parse("http://export.arxiv.org/api/query?search_query=#{CGI.escape(identifier)}&start=0&max_results=1")
      res = Net::HTTP.get_response(url)
      doc = Nokogiri::XML(res.body)
      doc.remove_namespaces!
      paper = Hash.new
      if entry = doc.xpath("//entry").first
        paper[:title] = entry.xpath('title').text
        paper[:author] = entry.xpath('author').text.strip
        paper[:id] = entry.xpath('id').text
        paper[:updated] = entry.xpath('updated').text
        paper[:summary] = entry.xpath('summary').text
        paper[:published] = entry.xpath('published').text
      end
      paper
    end
  end
end
