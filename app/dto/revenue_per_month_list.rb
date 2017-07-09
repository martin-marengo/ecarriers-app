class RevenuePerMonthList
  attr_accessor :amount, :month, :year
  attr_writer :amount
  
  def initialize
    @data = {}
  end
  
  def add_amount(amount, year, month)
    if @data[year].blank?
      @data[year] = {}
    end
    
    if @data[year][month].blank?
      @data[year][month] = 0
    end
    
    @data[year][month] += amount
  end
  
  def to_hash
    hash = {}
    
    @data.each do |year, months_data|
      months_data.each do |month, amount|
        date = Date.new(year, month)
        
        hash["#{year} - #{month}"] = amount
      end
    end
    
    return hash
  end

  def to_json
    to_hash.to_json
  end
end