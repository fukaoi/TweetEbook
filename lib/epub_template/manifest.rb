require 'epub_template'
require 'entities'
require 'ostruct'
require 'mime-types'
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
    Contract NIL => ArrayOf[{image: String, file_ext: String}]
    def saves_image_name
      images_and_file_exts = []
      Dir.glob("#{@output_dir}images/twitter/*").each do |im|
        images_and_file_exts << {
          image: replace_un_name(im), file_ext: check_mime(im)
        }
      end
      images_and_file_exts
    end

    Contract NIL => String
    def create_uuid
      UUIDTools::UUID::timestamp_create.to_s
    end

    Contract String => String
    def check_mime(file_path)
      MIME::Types.type_for(file_path).last.to_s
    end
  end
end