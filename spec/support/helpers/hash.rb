class Hash
  def deep_except!(*excluded_keys)
    current_class = self.class
    self.each do |current_key, current_value|
      if excluded_keys.include?(current_key)
        self.delete(current_key)
        next
      end
      if current_value.is_a?(current_class)
        current_value.deep_except(*excluded_keys)
      elsif current_value.is_a?(Array) && current_value.all? { |el| el.is_a?(current_class) }
        self[current_key] = current_value.map { |el| el.deep_except!(*excluded_keys) }
      end
    end
  end
end
