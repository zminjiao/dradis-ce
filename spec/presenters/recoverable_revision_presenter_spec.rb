require 'rails_helper'

RSpec.describe RecoverableRevisionPresenter do
  class FakeView
    include ActionView::Helpers::TextHelper
  end

  include ActionView::Helpers::TagHelper

  def revision_title_tag(text)
    content_tag :span, text, class: 'item-content'
  end

  def presenter_for(revision)
    described_class.new(revision, FakeView.new)
  end

  describe 'for a methodology' do
    before do
      methodology_content = File.read(Rails.root.join('spec/fixtures/files/methodologies/webapp.xml'))

      note = Node.methodology_library.notes.create(
        author:  'methodology builder',
        text:     methodology_content,
        category: Category.default,
      )
      note.destroy
      revision = RecoverableRevision.new(note.versions.last)

      @presenter = presenter_for(revision)
    end

    it 'has the correct title' do
      expect(@presenter.send(:title)).to eq revision_title_tag('Webapp')
    end

    it 'has the correct type' do
      expect(@presenter.send(:type)).to eq 'Methodology'
    end
  end

  describe 'for an Issue' do
    before do
      issue = create(:issue, text: "#[Title]#\nMy issue")
      issue.destroy
      revision = RecoverableRevision.new(issue.versions.last)

      @presenter = presenter_for(revision)
    end

    it 'has the correct title' do
      expect(@presenter.send(:title)).to eq revision_title_tag("My issue")
    end

    it 'has the correct type' do
      expect(@presenter.send(:type)).to eq 'Issue'
    end
  end

  describe 'for a note' do
    before do
      note = create(:note, text: "#[Title]#\nMy note")
      note.destroy
      revision = RecoverableRevision.new(note.versions.last)

      @presenter = presenter_for(revision)
    end

    it 'has the correct title' do
      expect(@presenter.send(:title)).to eq revision_title_tag('My note')
    end

    it 'has the correct type' do
      expect(@presenter.send(:type)).to eq 'Note'
    end
  end
end
