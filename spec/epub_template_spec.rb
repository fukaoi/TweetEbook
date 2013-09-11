require 'helper'
require 'epub_template'
require 'epub_template/pages'
require 'epub_template/cover'
require 'epub_template/nav'
require 'epub_template/manifest'
require 'epub_error'

describe EpubTemplate::Pages do
  before(:all) { helper_create_oebps_dir }
  let(:pages) { EpubTemplate::Pages.new }
  let(:tweet) { build_list(Entities::Tweet, 10) }
  context 'Rendering pages template' do
    describe 'EpubTemplate::Pages#render' do
      context 'Input tweet data' do
        it {
          render_result = pages.render(tweet)
          expect(render_result).to be_kind_of Array
          expect(render_result[0]).to match(xml_regex_format)
        }
      end

      context 'No input' do
        it { expect { pages.render }.to raise_error(ArgumentError) }
      end

      context 'Input other "Tweet" object' do
        it { expect { pages.render('dummy') }.to raise_error(ContractError) }
      end
    end
  end

  context 'Create html file' do
    describe 'EpubTemplate::Pages#create' do
      context '@html seet, create pages.html' do
        it {
          expect(pages.render(tweet)).to be_true
          expect(pages.create).to be_true
        }
      end

      context 'Do not set @html when call create()' do
        it { expect { pages.create }.to raise_error(EpubError) }
      end
    end
  end
end

describe EpubTemplate::Cover do
  before(:all) { helper_create_oebps_dir }
  let(:cover) { EpubTemplate::Cover.new }
  let(:usac) { build(Entities::UserAccount) }
  context 'Rendering cover template' do
    describe 'EpubTemplate::Cover#render' do
      context 'Input tweet data' do
        it { cover.render(usac).should match(xml_regex_format) }
      end

      context 'No input' do
        it { expect { cover.render }.to raise_error(ArgumentError) }
      end
    end
  end

  context 'Create html file' do
    describe 'EpubTemplate::Cover#create' do
      context '@html seet, create cover.html' do
        it {
          expect(cover.render(usac)).to be_true
          expect(cover.create).to be_true
        }
      end

      context 'Do not set @html when call create()' do
        it { expect { cover.create }.to raise_error(EpubError) }
      end
    end
  end
end

describe EpubTemplate::Nav do
  before(:all) { helper_create_oebps_dir }
  let(:pages) { EpubTemplate::Pages.new }
  let(:nav) { EpubTemplate::Nav.new }
  let(:tweet) { build_list(Entities::Tweet, 10) }
  context 'Rendering nav template' do
    describe 'EpubTemplate::Nav#render' do
      context 'Input tweet data' do
        it {
          expect(pages.render(tweet)).to be_true
          expect(pages.create).to be_true
          expect(nav.render(tweet)).to match(xml_regex_format)
        }
      end
      context 'No input' do
        it { expect { nav.render }.to raise_error(ArgumentError) }
      end
    end
  end

  context 'Create html file' do
    describe 'EpubTemplate::Nav#create' do
      context '@html set, create nav.html' do
        it {
          expect(nav.render(tweet)).to match(xml_regex_format)
          expect(nav.create).to be_true
        }
      end

      context 'Do not set @html when call create()' do
        it { expect { nav.create }.to raise_error(EpubError) }
      end
    end
  end
end


describe EpubTemplate::Manifest do
  before(:all) { helper_create_oebps_dir }
  let(:mani) { EpubTemplate::Manifest.new }
  let(:usac) { build(Entities::UserAccount) }
  context 'Rendering manifest template' do
    describe 'EpubTemplate::Manifest#render' do
      context 'Input tweet data' do
        it { expect { mani.render }.to raise_error(ArgumentError) }
      end
    end
  end

  context 'Create manifest file' do
    describe 'EpubTemplate::Manifest#create' do
      context '@manifest set, create package.opf' do
        it {
          mani.render(usac.name)
          expect(mani.create).to be_true
        }
      end

      context 'No type set render argiments' do
        it {
          expect{mani.render(10)}.to raise_error(ContractError)
        }
      end

      context 'Do not set @manifest when call create()' do
        it { expect{mani.create}.to raise_error(EpubError) }
      end
    end
  end
end