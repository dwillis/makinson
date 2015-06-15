require 'csv'
require 'open-uri'
require 'nokogiri'
require "makinson/version"

module Makinson

  SUBSECTORS = ["A01","A02","A04","A05","A06","A07","A09","A10","A11","B00","B01","B02","B08","B09","B12","B13","C01","C02","C03",
    "C04","C05","D01","D02","D03","E01","E04","E07","E08","E09","E10","E11","F03","F04","F05","F06","F07","F09","F10","F11","F13",
    "H01","H02","H03","H04","H05","K01","K02","M01","M02","M03","M04","M05","M06","N00","N01","N02","N03","N04","N05","N06","N07",
    "N08","N09","N12","N13","N14","N15","N16","P01","P02","P03","P04","P05","Q01","Q02","Q03","Q04","Q05","Q08","Q09","Q10","Q11",
    "Q12","Q13","Q14","Q15","Q16","W02","W03","W04","W05","W06","W07","Y00","Y01","Y02","Y03","Y04","Z02","Z04","Z07","Z08","Z09"]

  def self.subsector_csv
    SUBSECTORS.each do |subsector|
      subsector_totals(subsector)
    end
  end

  def self.subsector_totals(subsector)
    headers = [:cycle, :rank, :total_contributions, :individual_contributions, :pac_contributions, :soft_money, :democrats, :republicans, :dem_pct, :rep_pct, :subsector]
    url = "http://www.opensecrets.org/industries/totals.php?cycle=2016&ind=#{subsector}"
    doc = Nokogiri::HTML(open(url).read)
    rows = (doc/:table/:tr)[1..-1]
    if rows
      results = rows.map{|r| r.children.map{|c| c.text.gsub(",","").gsub("$","")}}
      results = results.map{|r| r.push(subsector)}
      CSV.open("#{subsector}.csv", "w", :write_headers=> true, :headers => headers) do |csv|
        results.each do |result|
          csv << result
        end
      end
    end
  end


end
