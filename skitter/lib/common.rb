require 'pp'
require 'rubygems'
require 'mysql'
require 'net/smtp'
require 'json'
require 'securerandom'
require 'pony'
require 'mysql'
require 'redis'
require 'net/http'
require 'time'

class Ccheck  < Struct.new(:name,:message,:status,:values, :troubleshooting, :troubleshooting_result, :evidence, :order)
end


class Cservice
  def initialize(name)
    @name = name
    @errors = Array.new
    @errors_names = Array.new
    @working_names = Array.new
    @working = Array.new
    @all = Array.new
    @status = "ok"
    @message = ""
    @evidence = Array.new
    @sleep = 120
    @startdate = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    @finishdate = "NO TERMINO"
    @start = 0
    @end = 24
  end
  
  def startdate()
  	return @startdate
  end
  
  def finish()
  	@finishdate = Time.now.strftime("%Y-%m-%d %H:%M:%S")
  end
  
  def finishdate()
  	return @finishdate
  end
  
  def addevidence(check,evidence)
      @evidence.push("#{check} => #{evidence}")
  end
  
  def sleep()
  	return @sleep
  end
  
  def setsleep(xsleep)
  	@sleep = xsleep
  end
  
  def evidence()
    return @evidence
  end

  def errors()
        return @errors
  end

  def working_names()
        return @working_names
  end
  
  def errors_names()
        return @errors_names
  end  

  def message()
        return @message
  end

  def setmessage(msg)
        @message = msg
  end

  def status()
        return @status
  end

  def working()
        return @working
  end

  def name()
        return @name
  end

  def setstart(start)
  	@start = start
  end
  
  def setend(ending)
  	@end = ending
  end
  
  def start()
  	return @start
  end
  
  def ending()
  	return @end
  end

  def all()
        return @all
  end
  
  def adderror(type,message = "Error!",order = 1,values = nil)
    tcheck = Ccheck.new(type,message,"error",values)
    tcheck.order = order
    self.add(tcheck)
  end
  
  def addok(type,message = "Ok!",order = 1,values = nil)
    tcheck = Ccheck.new(type,message,"ok",values)
    tcheck.order = order
    self.add(tcheck)
  end

  def realstatus()

    errors.each do |error|
      if error.troubleshooting == nil
        return "error"
      else
        if error.troubleshooting_result == "Failure"
          return "error"
        end
      end
    end
    return "ok"
  end


  def show()
     if @status == "ok"
      return "#{@name}: Todo ok! #{@message} (#{@startdate})"
    else
      troublespeach = ""
      fixed = ""

      errors.each do |error|
        if error.troubleshooting != nil
          if troublespeach == ""
            troublespeach = "||| Troubleshooting => "
          end
          troublespeach = troublespeach + "#{error.name}: #{error.troubleshooting_result} (#{@startdate})"
        end
      end

      if self.realstatus == "ok"
        fixed = "REPARADO!"
      end

      return "#{@name}: ERROR! Los siguientes chequeos fallaron => #{@errors_names.uniq.join("-")} #{troublespeach} #{fixed} (#{@startdate})"
    end
  end

  def add(tcheck)
    if tcheck.status == "error"
      @errors.push(tcheck)
      @errors_names.push(tcheck.name)
      @status = "error"
    else
      @working.push(tcheck)
      @working_names.push(tcheck.name)
    end

    @all.push(tcheck)
  end
end

def connect()
  begin
      con = Mysql.new 'localhost', 'root' , @dbpass , 'skitter' 
      rs = con.query 'SELECT VERSION()'

  rescue Mysql::Error => e
      puts e.errno
      puts e.error
      puts "Error al conectarte a la base de datos DB"
      Pony.mail(:via => :smtp, :via_options => { :address => @smtp }, :from => @destiny, :to => @destiny, :subject => "Skitter: ERROR EN SKITTER" , :body => "Error al intentar conectarse a DB")
  end

  return con
end

def utcgetdate()
        utc = Time.now.utc
        return utc.strftime("%Y-%m-%d")
end

def gmtgetdate(minus = 0)
        utc = Time.now.utc - 60*60*3  - 60*minus
        return utc.strftime("%Y-%m-%d")
end

def getgmttime(minus = 0)
        utc = Time.now.utc - (minus*60) - 60*60*3
        return utc.strftime("%H:%M:%S")
end

def get_exceptions()
	
	con = connect()

	date = Time.now.strftime("%Y-%m-%d")
	
	exceptions = Array.new
	
	response = con.query("SELECT source from skitter_exceptions where date = '#{date}' or permanent = 1 ")
	
	response.each_hash do |source|
		begin
			exceptions.push(source['source'].downcase)
			puts "Agrego a #{source['source']} a la cola de exceptuados"
		rescue
			puts "Error.."
		end
	end

	con.close()

	return exceptions

end
