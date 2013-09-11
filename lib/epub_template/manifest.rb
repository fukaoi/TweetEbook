require 'epub_template'
require 'entities'
require 'ostruct'
require 'shared-mime-info'
require 'date'
require 'uuidtools'
require 'contracts'
include Contracts

module EpubTemplate
  class Manifest < EpubTemplate::Base
    CREATE_FILE = 'package.opf'

    def initialize
      super
      @mani = load 'package.opf.slim'
    end

    Contract String => String
    def render(name)
      ma = Entities::Manifest.new
      ma.page_names = pages_file_name
      ma.created_date = DateTime.now.to_s.split('+09:00')[0] + 'Z'
      ma.images = saves_image_name
      ma.name = name
      ma.uuid = create_uuid
      @manifest = Slim::Template.new { @mani }.render(ma)
    end

    Contract NIL => Bool
    def create
      raise EpubError, 'Not found @manifest' unless @manifest
      super(@manifest, CREATE_FILE)
      raise EpubError, 'Failed makeing of the manifest file' unless exist?(CREATE_FILE)
      true
    end

    private
    Contract NIL => Array
    def saves_image_name
      images_and_file_exts = []
      Dir.glob("#{@output_dir}images/twitter/*").each { |im|
        image = replace_un_name(im)
        file_ext = MIME.check_magics im
        raise EpubError, 'Failed check mime type. maybe not found mime-data' unless file_ext
        images_and_file_exts << OpenStruct.new(image: image, file_ext: file_ext)
      }
      images_and_file_exts
    end

    Contract NIL => String
    def create_uuid
      UUIDTools::UUID::timestamp_create.to_s
    end
  end
end