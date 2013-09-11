require 'slim'
require 'yaml'
require 'configuration'
require 'epub_error'

module EpubTemplate
  class Base
    protected
    def initialize
      sett = Configuration.for 'settings'
      @template_dir = sett.epub.template_dir
      @output_dir = "#{sett.epub.output_dir}OEBPS/"
    end

    def load(file_name)
      File.open(@template_dir + file_name, 'rb').read
    end

    def render(render_part, argc = '')
      layout = File.open(@template_dir + 'layout.slim', 'rb').read
      raise EpubError, 'Not found render_part' unless render_part
      layout_tpl = Slim::Template.new { layout }
      if argc
        part_tpl = Slim::Template.new { render_part }.render(argc)
      else
        part_tpl = Slim::Template.new { render_part }
      end
      layout_tpl.render { part_tpl }
    end

    def create(contents, file_name)
      File.open(@output_dir + "#{file_name}", 'w') {
        |f| f.write(contents)
      }
    end

    def exist?(html_file_name)
      File.exist?(@output_dir + html_file_name)
    end

    def pages_file_name
      htmls = []
      sort_file(Dir.glob("#{@output_dir}pages*.html")).each { |page|
        htmls << replace_un_name(page)
      }
      htmls
    end

    private
    def sort_file(arr)
      arr.sort_by! {|k| k[/[+\d]/].to_i}
      arr
    end

    def replace_un_name(name)
      name.sub(/#{@output_dir}/, '')
    end
  end
end
