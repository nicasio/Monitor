def check_redis()

  begin
    
    service = Cservice.new("redis")

    redishosts = ["x.x.x.x"]
    rams = Array.new
    
    redishosts.each do |host|
        puts "Viendo en redis a #{host}"
        redis = Redis.new(:host => "#{host}")
        info = redis.info
        hram = info['used_memory_human']
        ram = info['used_memory'].to_i/1024/1024
        
        rams.push(hram)
        
        if ram > 50
          service.adderror("#{host}_ram","La ram del redis es #{hram}!")
        else
          service.addok("#{host}_ram")
        end

        service.addevidence("#{host}_info",info)
    end

    error = true

    service.setmessage("Los equipos estan usando #{rams.join("-")} de ram!")
    
    return service

  rescue Exception => ex
      pp ex
      service = Cservice.new("redis")
      service.adderror("Exception","An error of type #{ex.class} happened, message is #{ex.message}")
      return service
  end

end
