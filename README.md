# PaperMetadata

PaperMetadata is a gem that gets a publication's metadata by accessing the CrossRef OpenURL API.

## Installation

Add this line to your application's Gemfile:

    gem 'paper_metadata'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install paper_metadata

## Usage

You must first configure PaperMetadata with your CrossRef API username (which you can obtain here [http://www.crossref.org/requestaccount/](http://www.crossref.org/requestaccount/)):

    PaperMetadata.doi_username = 'email@example.com'

You can then access API:

    result = PaperMetadata.metadata_for('doi:10.1021/ac1014832')

The result will be a hash similar to this one:

    { :volume=>"82",
      :isssue=>"19",
      :first_page=>"8153",
      :last_page=>"8160",
      :title=>
      "Basic Modeling Approach To Optimize Elemental Imaging by Laser Ablation ICPMS",
      :authors=>"Jure Triglav, Johannes T. van Elteren, Vid S. Šelih",
      :journal=>"Anal. Chem. 2010",
      :resource=>"http://pubs.acs.org/doi/abs/10.1021/ac1014832" }

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Be sure to run the specs too.
