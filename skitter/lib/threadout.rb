module ThreadOut

  ##
  # Writes to Thread.current[:stdout] instead of STDOUT if the thread local is
  # set.

  def self.write(stuff)
    if Thread.current[:stdout] then
      Thread.current[:stdout] << stuff 
      STDOUT.write stuff
    else
      STDOUT.write stuff
    end
  end
  
end

$stdout = ThreadOut
