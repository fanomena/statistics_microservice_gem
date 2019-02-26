class Entity

  def initialize
    self.class::MEMBER_VARIABLES.each do |a|
      send("#{a.to_s}=", nil)
    end
  end

  # Create a destination class object from a hash (e.g. a hash resulting from a json request)
   def self.from_hash(hash)
     entity = self.new
     self::MEMBER_VARIABLES.each do |an|
       entity.send("#{an.to_s}=", hash[an.to_s])
     end
     entity
   end

   def to_h
    hash = {}
    instance_variables.each do |var|
      hash[var.to_s.delete("@").to_sym] = instance_variable_get(var)
    end
    hash
  end
end