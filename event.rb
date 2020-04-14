class Event
  
  attr_reader :name, :description, :start, :end, :id

  def initialize(info) 
    @name = info[:name]
    @description = info[:description] 
    @start = info[:start].date_time.to_s
    @end = info[:end].date_time.to_s
    @id = info[:id]
  end 

  def info
    data = Hash.new
		data[:name] = @name 
		data[:description] = @description
		data[:start] = @start
		data[:end] = @end
    data[:id] = @id
    data
  end
  
end
