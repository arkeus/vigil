require "writer/file_writer"
require "id"
require "coderay"

class PasteController < ApplicationController
  before_filter :set_paste, :only => [:swf, :image, :code]
  
  def index
  end

  def swf
  end

  def image
  end

  def code
  end
  
  def upload
    writer = FileWriter.new
    filetype = params[:filetype].downcase
    file = filetype != "code" ? params[:file] : params[:code].to_s
    retention = Retention.from_i(params[:retention].to_i)
    expires = Time.now + retention.time
    width = height = type = nil
    
    begin
      if filetype == "swf" || filetype == "image"
        filename = file.original_filename
        filesize = file.size
        begin
          width, height, type = writer.dimensions(file.tempfile.path) # throws exception if invalid filetype
        rescue
          raise "Invalid filetype"
        end
      elsif filetype == "code"
        filename = "none"
        filesize = file.length
        type = "text/plain"
      else
        raise ArgumentError.new("Invalid file type: #{filetype}")
      end
      
      raise ArgumentError.new("Filename must begin with a letter, number, or underscore") unless filename =~ /^[a-zA-z0-9_]/
      raise ArgumentError.new("File is too large (#{filesize} > #{get_max_filesize(filetype)})") if filesize > get_max_filesize(filetype)
      
      paste = Paste.new({
        :filetype => filetype,
        :bucket => writer.bucket,
        :key => "whatever",
        :name => params[:name],
        :ip => request.remote_ip,
        :filename => filename,
        :filesize => file.size,
        :expires_at => expires,
        :width => width,
        :height => height,
        :content_type => type
      })
      paste.save!
      
      key = retention.code + ID.encrypt(paste.id)
      paste.key = key
      paste.save!
      
      writer.write(writer.get_path(key), file)
      
      redirect_to :action => filetype, :id => key
    rescue Exception => e
      raise
    end
  rescue Exception => e
    Rails.logger.error("Could not upload: #{e.message}\n#{e.backtrace.join("\n")}")
    flash[:error] = e.message
    redirect_to :index
  end
  
  def all
    render :text => Paste.all.map { |p| p.inspect }.join("<br>").gsub!("#<", "#&lt;")
  end
  
  protected
  
  def set_paste
    @key = params[:id]
    @path = S3Writer.get_path(@key)
    @paste = Paste.find_by_key(params[:id])
    raise "This paste does not exist!" unless @paste
    raise "This paste has expired!" if @paste.expires_at <= Time.now
    @paste.views += 1
    @paste.save!
  end
  
  def get_max_filesize(type)
    return case type
      when "swf" then 20 * 1024 * 1024
      when "image" then 2 * 1024 * 1024
      when "code" then 2 * 1024 * 1024
      else 0
    end
  end
end
