module LastN
  def last(n)
    self[-n,n]
  end
end

class String
  include LastN
end

class Array
  def sum
    inject(0.0) { |result, el| result + el }
  end

  def mean
    sum / size
  end
end

module JSONable
  def to_json
    hash = {}
    self.instance_variables.each do |var|
      hash[var.to_s.delete "@"] = self.instance_variable_get var
    end
    hash.to_json
  end
  def from_json! string
    JSON.load(string).each do |var, val|
      self.instance_variable_set var, val
    end
  end
end