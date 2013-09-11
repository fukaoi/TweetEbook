require 'configuration'
require 'fileutils'
require 'net/https'
require 'uri'
require 'contracts'
include Contracts

class EpubParts
  def initialize
    sett = Configuration.for 'settings'
    @template_dir = sett.epub.template_dir
    @output_dir = sett.epub.output_dir
    @created_name = sett.epub.created_name
    FileUtils.mkdir @output_dir if !File.exist? @output_dir
  end

  def create_meta_dir?
    temp_dir = "#{@template_dir}META-INF"
    out_dir = "#{@output_dir}META-INF"
    FileUtils.copy_entry(temp_dir, out_dir)
    File.exist? out_dir
  end

  def create_oebps_dir?
    temp_dir = "#{@template_dir}OEBPS"
    out_dir = "#{@output_dir}OEBPS"
    FileUtils.copy_entry(temp_dir, out_dir)
    File.exist? out_dir
  end

  Contract ArrayOf[String] => Bool
  def save_images?(urls)
    begin
      raise EpubError, 'Not found param' unless urls
      urls.each { |url| save_image(url) }
    rescue => e
      raise e
    end
    true
  end

  def create_mimefile?
    temp_file = "#{@template_dir}mimetype"
    out_file = "#{@output_dir}mimetype"
    FileUtils.copy_entry(temp_file, out_file)
    File.exists? out_file
  end

  def create_epub?
    first_command = "/usr/bin/zip -X #{@created_name} mimetype"
    seconnd_command = "/usr/bin/zip -Xr #{@created_name} META-INF OEBPS"
    Dir.chdir(@output_dir) {
      system("#{first_command};#{seconnd_command}")
    }
    File.exists? @output_dir + @created_name
  end

  private
  Contract String => Bool
  def save_image(url)
    file_name = File.basename url
    open(file_name, 'wb') do |f|
      parse_url = URI::parse(url)
      net = url.match('http://') ? http_get(parse_url) : https_get(parse_url)
      if Net::HTTPSuccess === net
        f.puts net.body
      else
        no_image(file_name)
      end
    end
    move_image_dir(file_name)
  end

  Contract URI::HTTP => Or[Net::HTTPOK, Net::HTTPError, Net::HTTPNotFound]
  def http_get(parse_url)
    Net::HTTP.get_response(parse_url)
  end

  Contract URI::HTTPS => Or[Net::HTTPOK, Net::HTTPError, Net::HTTPNotFound]
  def https_get(parse_url)
    net = Net::HTTP.new(parse_url.host, parse_url.port)
    net.use_ssl = true
    req = Net::HTTP::Get.new(parse_url.request_uri)
    net.request(req)
  end

  Contract String => Bool
  def move_image_dir(file_name)
    out_dir = "#{@output_dir}OEBPS/images/twitter/"
    FileUtils.mv(file_name, out_dir)
    File.exist? "#{out_dir}#{file_name}"
  end

  Contract String => NIL
  def no_image(file_name)
    temp_file = "#{@template_dir}OEBPS/images/no_image.png"
    FileUtils.copy_entry(temp_file, file_name)
  end
end
