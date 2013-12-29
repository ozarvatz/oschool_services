module Configuration
	extend self

  attr_accessor :env

  def init
    @env = ENV["RACK_ENV"] || "development"
    # binding.pry
    Mongoid.load!("config/mongoid.yml", env)

    setup_logger(env)

  end

  def setup_logger(env)
    log_shift = 1
    log_size  = 10000000
    FileUtils.mkdir("log") unless File.exist?("log")

    $log 			 = Logger.new("log/#{env}.log", log_shift, log_size)
    $log.level = logger_level(env)
  end

  private

  def logger_level(env)
  	case env
  	when 'production'  then Logger::ERROR
  	when 'development' then Logger::DEBUG
  										 else Logger::INFO
  	end 
  end
end