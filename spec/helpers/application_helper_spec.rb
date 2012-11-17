require 'spec_helper'

describe ApplicationHelper do

  describe :client do
    subject { client }
    it { should be_is_a Instagram::Client }
  end

  describe :authenticated? do
    context 'session have access token' do
      before do
        session[:access_token] = '*** access_token ***'
      end

      it 'should be true' do
        authenticated?.should be_true
      end
    end

    context 'session not have access token' do
      before do
        session[:access_token] = nil
      end

      it 'should be false' do
        authenticated?.should be_false
      end
    end
  end

  describe :mine? do
    context 'is mine id' do
      before do
        session[:user] = {id: 1}
    end

      it 'should be true' do
        mine?(1).should be_true
      end
    end

    context 'is not mine id' do
      before do
        session[:user] = {id: 1}
      end

      it 'should be false' do
        mine?(2).should be_false
      end
    end
  end

  before do
    @photo = Hashie::Mash.new({
      images: {
        low_resolution: {
          url: 'http://example.com/low_resolution.jpg',
          width: 306,
          height: 306
        },
        thumbnail: {
          url: 'http://example.com/thumbnail.jpg',
          width: 150,
          height: 150
        },
        standard_resolution: {
          url: 'http://example.com/standard_resolution.jpg',
          width: 612,
          height: 612
        }
      },
      caption: {
        text: 'caption text'
      },
      created_time: '1298678400',
    })
  end

  describe :link_to_external do
    subject { link_to_external 'Example', 'http://example.com/' }
    it { should == '<a href="http://example.com/" rel="external nofollow" target="_blank">Example</a>' }
  end

  describe :nav_link_tag do
    before do
      @request = ActionController::TestRequest.new
      @request.stub!(:url).and_return('http://example.com/')
      @request.stub!(:fullpath).and_return('')
      self.stub!(:request).and_return(@request)
    end

    context 'current page' do
      subject { nav_link_tag 'Example', 'http://example.com/' }
      it { should == '<li class="active"><a href="http://example.com/">Example</a></li>' }
    end

    context 'not current page' do
      subject { nav_link_tag 'Example', 'http://example.com/other' }
      it { should == '<li><a href="http://example.com/other">Example</a></li>' }
    end
  end

  describe :caption_text do
    subject { caption_text @photo }
    it { should == 'caption text' }
  end

  describe :photo_tag do
    context :low_resolution do
      subject { photo_tag @photo, :low_resolution }
      it { should == '<img alt="caption text" height="306" src="http://example.com/low_resolution.jpg" width="306" />' }
    end
    context :thumbnail do
      subject { photo_tag @photo, :thumbnail }
      it { should == '<img alt="caption text" height="150" src="http://example.com/thumbnail.jpg" width="150" />' }
    end
    context :standard_resolution do
      subject { photo_tag @photo, :standard_resolution }
      it { should == '<img alt="caption text" height="612" src="http://example.com/standard_resolution.jpg" width="612" />' }
    end
  end

  describe :tags_tag do
    context 'have tag' do
      subject { tags_tag 'text #tag1 #tag2' }
      it { should == 'text <a class="tag" href="http://test.host/tags/tag1">#tag1</a> <a class="tag" href="http://test.host/tags/tag2">#tag2</a>' }
      it { should be_html_safe }
    end

    context 'not have tag' do
      subject { tags_tag 'text text text' }
      it { should == 'text text text' }
      it { should be_html_safe }
    end

    context 'sanitize script tag' do
      subject { tags_tag('"\'><script src="//example.com/xss.js">') }
      it { should == '&quot;\'&gt;&lt;script src=&quot;//example.com/xss.js&quot;&gt;' }
    end
  end

  describe :emoji_tag do
    subject { emoji_tag "\uE001" }
    it { should == '<span class="emoji emoji_e001">&nbsp;</span>' }
    it { should be_html_safe }

    context 'sanitize script tag' do
      subject { emoji_tag('"\'><script src="//example.com/xss.js">') }
      it { should == '&quot;\'&gt;&lt;script src=&quot;//example.com/xss.js&quot;&gt;' }
    end
  end

  describe 'nest tag helper' do
    context 'emoji_tag(tags_tag(text))' do
      subject { emoji_tag(tags_tag("\uE001 \uE002 #tag1 #tag2")) }
      it { should == '<span class="emoji emoji_e001">&nbsp;</span> <span class="emoji emoji_e002">&nbsp;</span> <a class="tag" href="http://test.host/tags/tag1">#tag1</a> <a class="tag" href="http://test.host/tags/tag2">#tag2</a>' }
      it { should be_html_safe }
    end

    context 'tags_tag(emoji_tag(text))' do
      subject { tags_tag(emoji_tag("\uE001 \uE002 #tag1 #tag2")) }
      it { should == '<span class="emoji emoji_e001">&nbsp;</span> <span class="emoji emoji_e002">&nbsp;</span> <a class="tag" href="http://test.host/tags/tag1">#tag1</a> <a class="tag" href="http://test.host/tags/tag2">#tag2</a>' }
      it { should be_html_safe }
    end

    context 'sanitize script tag' do
      subject { tags_tag(emoji_tag('"\'><script src="//example.com/xss.js">')) }
      it { should == '&quot;\'&gt;&lt;script src=&quot;//example.com/xss.js&quot;&gt;' }
    end
  end
end
