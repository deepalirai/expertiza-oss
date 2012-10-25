require File.dirname(__FILE__) + '/../test_helper'

class WikiTypeTest < ActiveSupport::TestCase

  def test_check_valid_url
    mwiki = WikiType.find_by_name("MediaWiki")
    resp = mwiki.check_valid_url("http://expertiza.csc.ncsu.edu/wiki/index.php/CSC/ECE_517_Fall_2012/ch1b_1w71_gs")
    assert_not_equal(resp,"","VALID URL!!")
  end

  def test_check_invalid_url
    mwiki = WikiType.find_by_name("MediaWiki")
    resp = mwiki.check_valid_url("http//expertiza.csc.ncsu.ed")
    assert_equal(resp,"","INVALID URL!!")
  end

  def test_set_args
    mwiki = WikiType.find_by_name("MediaWiki")
    assert(mwiki.set_args("http://expertiza.csc.ncsu.edu/wiki/index.php/CSC/ECE_517_Fall_2012/ch1b_1w71_gs"))
  end

  def test_initialize_media
    mwiki = WikiType.find_by_name("MediaWiki")
    mwiki.set_args("http://expertiza.csc.ncsu.edu/wiki/index.php/CSC/ECE_517_Fall_2012/ch1b_1w71_gs")
    assert(mwiki.initialize_media("easton"))
  end

  def test_get_url
    mwiki = WikiType.find_by_name("MediaWiki")
    mwiki.set_args("http://expertiza.csc.ncsu.edu/wiki/index.php/CSC/ECE_517_Fall_2012/ch1b_1w71_gs")
    mwiki.initialize_media("easton")
    assert(mwiki.get_url)
  end

  def test_clean_url
    mwiki = WikiType.find_by_name("MediaWiki")
    mwiki.set_args("http://expertiza.csc.ncsu.edu/wiki/index.php/CSC/ECE_517_Fall_2012/ch1b_1w71_gs")
    mwiki.initialize_media("easton")
    mwiki.get_url()
    assert(mwiki.clean_url)
  end

  def test_extract_line_items
    mwiki = WikiType.find_by_name("MediaWiki")
    mwiki.set_args("http://expertiza.csc.ncsu.edu/wiki/index.php/CSC/ECE_517_Fall_2012/ch1b_1w71_gs")
    mwiki.initialize_media("easton")
    mwiki.get_url()
    mwiki.clean_url()
    assert(mwiki.extract_line_items)
  end

  def test_extract_dates
    mwiki = WikiType.find_by_name("MediaWiki")
    mwiki.set_args("http://expertiza.csc.ncsu.edu/wiki/index.php/CSC/ECE_517_Fall_2012/ch1b_1w71_gs")
    mwiki.initialize_media("easton")
    mwiki.get_url()
    mwiki.clean_url()
    assert(mwiki.extract_dates)
  end

  def test_parse_media
    mwiki = WikiType.find_by_name("MediaWiki")
    mwiki.set_args("http://expertiza.csc.ncsu.edu/wiki/index.php/CSC/ECE_517_Fall_2012/ch1b_1w71_gs")
    mwiki.initialize_media("easton")
    mwiki.get_url()
    mwiki.clean_url()
    assert(mwiki.parse_media)
  end

  def test_get_line_items
    mwiki = WikiType.find_by_name("MediaWiki")
    mwiki.set_args("http://expertiza.csc.ncsu.edu/wiki/index.php/CSC/ECE_517_Fall_2012/ch1b_1w71_gs")
    mwiki.initialize_media("easton")
    mwiki.get_url()
    mwiki.clean_url()
    mwiki.extract_line_items()
    mwiki.extract_dates()
    assert(mwiki.get_line_items("2012/09/14"))
  end

  def test_review_wiki
    mwiki = WikiType.find_by_name("MediaWiki")
    assert(mwiki.review_wiki("http://expertiza.csc.ncsu.edu/wiki/index.php/CSC/ECE_517_Fall_2012/ch1b_1w71_gs","2012/09/14","easton"))
  end

  def test_review_mediawiki_group
    mwiki = WikiType.find_by_name("MediaWiki")
    assert(mwiki.review_mediawiki_group("http://expertiza.csc.ncsu.edu/wiki/index.php/CSC/ECE_517_Fall_2012/ch1b_1w71_gs","2012/09/14","easton"))
  end

  def test_doku_check_valid_url
    dwiki = WikiType.find_by_name("DokuWiki")
    resp = dwiki.check_valid_url("http://pg-server.ece.ncsu.edu/dokuwiki/doku.php/ece633:hw1")
    assert_not_equal(resp,"","VALID URL!!")
  end

  def test_doku_check_invalid_url
    dwiki = WikiType.find_by_name("DokuWiki")
    resp = dwiki.check_valid_url("http//expertiza.csc.ncsu.ed")
    assert_equal(resp,"","INVALID URL!!")
  end

  def test_doku_set_args
    dwiki = WikiType.find_by_name("DokuWiki")
    assert(dwiki.set_args("http://expertiza.csc.ncsu.edu/wiki/index.php/CSC/ECE_517_Fall_2012/ch1b_1w71_gs"))
  end

  def test_doku_get_url
    dwiki = WikiType.find_by_name("DokuWiki")
    dwiki.set_args("http://expertiza.csc.ncsu.edu/wiki/index.php/CSC/ECE_517_Fall_2012/ch1b_1w71_gs")
    assert(dwiki.initialize_dokuwiki())
  end

  def test_doku_get_url
    dwiki = WikiType.find_by_name("DokuWiki")
    dwiki.set_args("http://expertiza.csc.ncsu.edu/wiki/index.php/CSC/ECE_517_Fall_2012/ch1b_1w71_gs")
    dwiki.initialize_dokuwiki()
    assert(dwiki.get_url)
  end

  def test_doku_clean_url
    dwiki = WikiType.find_by_name("DokuWiki")
    dwiki.set_args("http://expertiza.csc.ncsu.edu/wiki/index.php/CSC/ECE_517_Fall_2012/ch1b_1w71_gs")
    dwiki.initialize_dokuwiki()
    dwiki.get_url()
    assert(dwiki.clean_url)
  end

  def test_doku_extract_line_items
    dwiki = WikiType.find_by_name("DokuWiki")
    dwiki.set_args("http://expertiza.csc.ncsu.edu/wiki/index.php/CSC/ECE_517_Fall_2012/ch1b_1w71_gs")
    dwiki.initialize_dokuwiki()
    dwiki.get_url()
    dwiki.clean_url()
    assert(dwiki.extract_line_items)
  end

  def test_doku_extract_dates
    dwiki = WikiType.find_by_name("DokuWiki")
    dwiki.set_args("http://expertiza.csc.ncsu.edu/wiki/index.php/CSC/ECE_517_Fall_2012/ch1b_1w71_gs")
    dwiki.initialize_dokuwiki()
    dwiki.get_url()
    dwiki.clean_url()
    dwiki.extract_line_items()
    assert_nil(dwiki.extract_dates("easton"))
  end

  def test_doku_parse_doku
    dwiki = WikiType.find_by_name("DokuWiki")
    dwiki.set_args("http://expertiza.csc.ncsu.edu/wiki/index.php/CSC/ECE_517_Fall_2012/ch1b_1w71_gs")
    dwiki.initialize_dokuwiki()
    dwiki.get_url()
    dwiki.clean_url()
    assert(dwiki.parse_doku)
  end

  def test_doku_get_line_items
    dwiki = WikiType.find_by_name("DokuWiki")
    dwiki.set_args("http://expertiza.csc.ncsu.edu/wiki/index.php/CSC/ECE_517_Fall_2012/ch1b_1w71_gs")
    dwiki.initialize_dokuwiki()
    dwiki.get_url()
    dwiki.clean_url()
    dwiki.extract_line_items()
    dwiki.extract_dates("easton")
    assert(dwiki.get_line_items("2012/09/14"))
  end

  def test_doku_review_wiki
    dwiki = WikiType.find_by_name("DokuWiki")
    assert(dwiki.review_wiki("http://expertiza.csc.ncsu.edu/wiki/index.php/CSC/ECE_517_Fall_2012/ch1b_1w71_gs","2012/09/14","easton"))
  end
end



