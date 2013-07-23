require 'test/unit'
require 'paper_metadata'
require 'test_helper'

class PaperMetadataTest < Test::Unit::TestCase
  def test_doi_parsing

    doi_response = File.read(File.join(File.dirname(__FILE__), 'doi_guestquery.html'))
    stub_request(:any, /www.crossref.org\/.*/).
      to_return(:body => doi_response, :status => 200,  :headers => { 'Content-Length' => doi_response.length } )

    PaperMetadata.doi_username = 'test@example.com'

    assert_equal "Basic Modeling Approach To Optimize Elemental Imaging by Laser Ablation ICPMS",
      PaperMetadata.metadata_for('doi:10.1021/ac1014832')[:title]
  end

  def test_doi_parsing_live
    WebMock.allow_net_connect!
    doi_response = File.read(File.join(File.dirname(__FILE__), 'doi.xml'))
    PaperMetadata.doi_username = 'test@crossref.org'
    assert_equal "Basic Modeling Approach To Optimize Elemental Imaging by Laser Ablation ICPMS",
      PaperMetadata.metadata_for('doi:10.1021/ac1014832')[:title]
    WebMock.disable_net_connect!
  end

  def test_arxiv_parsing
    arxiv_response = File.read(File.join(File.dirname(__FILE__), 'arxiv.xml'))
    stub_request(:any, /.*arxiv.org\/.*/).
      to_return(:body => arxiv_response, :status => 200,  :headers => { 'Content-Length' => arxiv_response.length } )
    assert_equal "Thomas Vojta",
      PaperMetadata.metadata_for('arXiv:1301.7746')[:authors]
  end

  def test_arxiv_parsing_live
    WebMock.allow_net_connect!
    assert_equal "Thomas Vojta",
      PaperMetadata.metadata_for('arXiv:1301.7746')[:authors]
    WebMock.disable_net_connect!
  end
end
