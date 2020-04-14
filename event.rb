class Event
  
  attr_reader :name, :description, :start, :end, :id

  def initialize(info) 
    @name = info[:name]
    @description = info[:description] 
    @start = info[:start].date_time.to_s
    @end = info[:end].date_time.to_s
    @id = info[:id]
  end 
  
end
