class Hash
  def stringify_keys!
    keys.each do |key|
      self[key.to_s] = delete(key)
    end
    self
  end

  def stringify_keys
    dup.stringify_keys!
  end

  def symbolize_keys!
    keys.each do |key|
      self[(key.to_sym rescue key) || key] = delete(key)
    end
    self
  end

  def symbolize_keys
    dup.symbolize_keys!
  end
end

class ParamsHash < Hash
  def to_query
    map do |key, value|
      case value
      when Array
        value.map do |v|
          "#{key}=#{CGI.escape(v.to_s)}"
        end.join('&')
      else
        "#{key}=#{CGI.escape(value.to_s)}"
      end
    end.sort * '&'
  end
end
