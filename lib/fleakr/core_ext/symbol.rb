class Symbol

  def <=>(other)
    to_s <=> other.to_s
  end

end