require 'rails_helper'

describe Search do
  %w(Everywhere Questions Answers Comments Users).each do |location|
    it "search location includes #{location}" do
      expect(Search::LOCATION).to include(location)
    end
  end

  describe '#find' do
    let(:location) { 'Questions' }
    let(:everywhere) { 'Everywhere' }
    let(:invalid_location) { 'Subscriptions' }
    let(:query) { 'query' }

    it 'escapes query' do
      expect(ThinkingSphinx::Query).to receive(:escape).with(query)
      Search.find(query, location)
    end

    context 'location' do
      context 'with invalid location' do
        it "doesn't make search" do
          expect(invalid_location.classify.constantize).to_not receive(:search).with(query)
          Search.find(query, invalid_location)
        end
      end

      context 'with Everywhere' do
        it 'calls ThinkingSphinx global search' do
          expect(ThinkingSphinx).to receive(:search).with(query)
          Search.find(query, everywhere)
        end
      end

      context 'with valid location' do
        it 'calls search on loaction' do
          Search::LOCATION.each do |location|
            next if location == 'Everywhere'
            expect(location.classify.constantize).to receive(:search).with(query)
            Search.find(query, location)
          end
        end
      end
    end
  end
end
