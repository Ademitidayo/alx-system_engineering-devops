module Warning
  def self.warn(msg)
    # Suppress warnings about URI.escape being obsolete
    if msg =~ /URI.escape is obsolete/
      return
    end

    # Suppress warnings about $SAFE
    if msg =~ /\$SAFE will become a normal global variable in Ruby 3.0/
      return
    end
    if msg =~ /\$URI.escape is obsolete/
      return
    end


    super
  end
end
