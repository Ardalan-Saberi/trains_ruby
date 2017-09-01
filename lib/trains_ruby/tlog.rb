require 'logger'

class TLog

  def self.log
    if @logger.nil?
      @logger = Logger.new('log.txt', File::CREAT)
      @logger.level = Logger::DEBUG
      @logger.datetime_format = "%Y-%m-%d %H:%M:%S"
    end
    @logger
  end
end
