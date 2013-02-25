require "writer/file_writer"
require "id"
require "coderay"

class PasteController < ApplicationController
  before_filter :set_paste, :only => [:swf, :image, :code]
  before_filter :set_file, :only => [:swf, :image, :code, :direct]
  
  def index
  end

  def swf
  end

  def image
  end

  def code
  end
  
  def direct
    send_file @path, :type => @type, :disposition => "inline"
  end
  
  def upload
    writer = FileWriter.new
    file = params[:file] || params[:code].to_s
    duration = params[:retention].to_i
    expires = Time.now + duration.hours
    filetype = params[:filetype].downcase
    
    begin
      if filetype == "swf" || filetype == "image"
        filename = file.original_filename
        filesize = file.size
        begin
          writer.dimensions(file.tempfile.path) # throws exception if invalid filetype
        rescue
          raise "Invalid filetype"
        end
      elsif filetype == "code"
        filename = "none"
        filesize = file.length
      else
        raise ArgumentError.new("Invalid file type: #{filetype}")
      end
      
      raise ArgumentError.new("File is too large (#{filesize} > #{get_max_filesize(filetype)})") if filesize > get_max_filesize(filetype)
      raise ArgumentError.new("Invalid rentention time") if duration > 1000
      
      paste = Paste.new({
        :filetype => filetype,
        :key => "whatever",
        :name => params[:name],
        :ip => request.remote_ip,
        :filename => filename,
        :filesize => file.size,
        :expires_at => expires
      })
      paste.save!
      
      key = ID.encrypt(paste.id)
      paste.key = key
      paste.save!
      
      writer.write(writer.get_path(key), file)
      
      redirect_to :action => filetype, :id => key
    rescue Exception => e
      raise
      #puts e.inspect
      #redirect_to :index, :error => "Could not save" and return
    end
  end
  
  def all
    render :text => Paste.all.map { |p| p.inspect }.join("<br>").gsub!("#<", "#&lt;")
  end
  
  protected
  
  def validate_filename!(filename)
    
  end
  
  def set_file
    @key = params[:id]
    @writer = FileWriter.new
    @path = @writer.get_path(@key)
    @size = @writer.size(@path)
    
    begin
      @width, @height, @type = @writer.dimensions(@path)
    rescue
      raise "Invalid filetype" unless (!@paste.nil? && @paste.filetype == "code")
    end
  end
  
  def set_paste
    @paste = Paste.find_by_key(params[:id])
    raise "This paste does not exist!" unless @paste
    raise "This paste has expired!" if @paste.expires_at <= Time.now
    @paste.views += 1
    @paste.save!
  end
  
  def get_max_filesize(type)
    return case type
      when "swf" then 10 * 1024 * 1024
      when "image" then 2 * 1024 * 1024
      when "code" then 2 * 1024 * 1024
      else 0
    end
  end
end
