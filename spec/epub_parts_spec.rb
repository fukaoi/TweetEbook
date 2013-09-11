require 'helper'
require 'epub_parts'

describe EpubParts do
  let(:parts) { EpubParts.new }

  context 'create meta_dir' do
    subject { parts.create_meta_dir? }
    it { should be_true }
  end

  context 'Failure create meta_dir, Not found @template_dir' do
    it {
      parts.instance_eval "@template_dir = 'not_found_dir/'"
      expect { parts.create_meta_dir? }.to raise_error
    }
  end

  context 'Failure create meta_dir, Not found @output_dir' do
    it {
      parts.instance_eval "@output_dir = 'not_found_dir/'"
      expect { parts.create_meta_dir? }.to raise_error
    }
  end

  context 'create oebps_dir' do
    subject { parts.create_oebps_dir? }
    it { should be_true }
  end

  context 'Failure create oebps_dir, Not found @template_dir' do
    it {
      parts.instance_eval "@template_dir = 'not_found_dir/'"
      expect { parts.create_oebps_dir? }.to raise_error
    }
  end

  context 'Failure create oebps_dir, Not found @output_dir' do
    it {
      parts.instance_eval "@output_dir = 'not_found_dir/'"
      expect { parts.create_oebps_dir? }.to raise_error
    }
  end

  before(:all) { helper_create_oebps_dir }
  let(:tweet) { build(Entities::Tweet) }
  context 'Get profile image file' do
    subject { parts.save_images?(tweet.images) }
    it { should be_true }
  end

  context 'Failure get profile image files' do
    it { expect { parts.save_images?('') }.to raise_error }
  end

  before(:all) { helper_create_oebps_dir }
  context 'create no image files' do
    subject { parts.save_images?(%w(http://fukaoi.org/static/dummy.jpg)) }
    it { should be_true }
  end

  before(:all) { helper_create_oebps_dir }
  context 'Create mimetype a file' do
    subject { parts.create_mimefile? }
    it { should be_true }
  end

  before(:all) { helper_create_all }
  let(:tweet) { build(Entities::Tweet) }
  context 'Create an epub file' do
    subject {
      parts.save_images?(tweet.images)
      parts.create_epub?
    }
    it { should be_true }
  end
end
