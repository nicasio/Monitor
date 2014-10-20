#!/usr/bin/ruby


def begin_check(name)
	Thread.current[:stdout] = open("slogs/#{name}.log", "a")
	Thread.current[:stdout].sync = true
	while(1)
			puts "Comienza #{name}"
			service = send("check_#{name}")
			puts "Duermo #{service.sleep} para #{name}"
			service.finish()
			sleep service.sleep
	end
end

begin

puts "Comienza Silk"

puts "Cargo librerias.."

Dir['lib/*.rb'].each do |filename|   
        puts "Cargando a #{filename}"
        require filename 
end

services = Array.new
	
puts "Inicializo excepciones"

Thread.new {
	update_exceptions()
}

sleep 5

puts "Cargo modulos"

Dir['modules/*.rb'].each do |filename| 
    service = (File.basename filename).split(".")[0]
    	if ARGV[0] != "DEBUG" or ARGV[1] == service
	        require filename 
	        Thread.new {
	        begin_check(service)
	        }
	end
end

rescue Exception => ex
	if ARGV[0] != "TEST" and ex.class != "Interrupt"
		puts "An error of type #{ex.class} happened, message is #{ex.message} #{ex.backtrace[0]}"
		Pony.mail(:via => :smtp, :via_options => { :address => @smtp }, :from => @destiny, :to => @destiny, :subject => "Skitter: ERROR EN SKITTER" , :body => "An error of type #{ex.class} happened, message is #{ex.message} #{ex.backtrace[0]}")
	end
end
