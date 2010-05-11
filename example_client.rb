require 'rubygems'
require 'savon'
require 'savon_ext'
require 'ap'
require 'nokogiri'
require 'spreadsheet'

username = ENV['AFFILIATE_WINDOW_ID']
password = ENV['AFFILIATE_WINDOW_PASSWORD']
type = "affiliate"

client = Savon::Client.new "http://api.affiliatewindow.com/v3/AffiliateService?wsdl" do |soap|
  soap.header = {
    "ns1:UserAuthentication" => {
      "env:mustUnderstand" => "1",
      "env:actor" => "http://api.affiliatewindow.com",
      "ns1:iId" => username,
      "ns1:sPassword" => password,
      "ns1:sType" => type
    }
  }
  soap.namespaces = {
    "xmlns:env" => "http://schemas.xmlsoap.org/soap/envelope/",
    "xmlns:xsd" => "http://www.w3.org/2001/XMLSchema",
    "xmlns:ns1" => "http://api.affiliatewindow.com/"
  }
end

xml = client.get_merchant_list.to_xml
doc = Nokogiri::XML(xml);
doc.xpath
merchants = doc.xpath('//ns1:Merchant')
merchant_info = merchants.map{|m|[m.xpath('ns1:sName/text()').to_s, m.xpath('ns1:sDisplayUrl/text()').to_s]}

book = Spreadsheet::Workbook.new
sheet1 = book.create_worksheet

sheet1.name = "Merchants"
merchant_info.sort{|a,b|a[0].downcase <=> b[0].downcase}.each_with_index do |m, row|
  sheet1.update_row row, m[0], m[1]
end

book.write 'af.xls'



