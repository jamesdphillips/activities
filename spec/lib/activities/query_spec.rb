require 'spec_helper'
require 'activities/query'

describe 'Query' do
  let(:receiver) { double('new_receiver') }
  let(:activity_1) { double('activity_1') }
  let(:activity_2) { double('activity_2') }
  let!(:expected_activities) { [activity_2, activity_1] }
  let(:time) { Time.now }
  subject(:query) { Activities::Query.new(receiver) }

  before do
    allow(receiver).to receive(:id)

    allow(query).to receive(:prev_cursor)
    allow(query).to receive(:next_cursor)

    allow(query).to receive(:activities_query).and_return(expected_activities)
  end

  describe 'initial query' do

    context 'with no cursor' do
      before do
        allow(query).to receive(:first_activities).and_return(expected_activities)
      end

      it 'retrieves the next activities' do
        expect(query).to receive(:first_activities).with(expected_activities, Activities::Query::DEFAULT_COUNT).once
        expect(query).to receive(:next_cursored_activities).exactly(0).times
        expect(query).to receive(:prev_cursored_activities).exactly(0).times

        query.query
      end
    end

    context 'with cursor -1' do
      before do
      allow(query).to receive(:first_activities).and_return(expected_activities)
    end

    it 'retrieves the next activities' do
      expect(query).to receive(:first_activities).with(expected_activities, Activities::Query::DEFAULT_COUNT).once
      expect(query).to receive(:next_cursored_activities).exactly(0).times
      expect(query).to receive(:prev_cursored_activities).exactly(0).times

      query.query(-1)
    end
    end
  end

  describe 'query with next cursor' do
    let(:cursor) { query.time_to_timestamp(time) }

    before do
      allow(query).to receive(:next_cursored_activities).and_return(expected_activities)
    end

    it 'retrieves the next activities' do
      expect(query).to receive(:next_cursored_activities).with(expected_activities, cursor, Activities::Query::DEFAULT_COUNT).once
      expect(query).to receive(:first_activities).exactly(0).times
      expect(query).to receive(:prev_cursored_activities).exactly(0).times

      query.query(cursor)
    end
  end

  describe 'query with previous cursor' do
    let(:cursor) { query.time_to_timestamp(time) }

    before do
      allow(query).to receive(:prev_cursored_activities).and_return(expected_activities)
    end

    it 'retrieves the previous activities' do
      expect(query).to receive(:prev_cursored_activities).with(expected_activities, cursor, Activities::Query::DEFAULT_COUNT).once
      expect(query).to receive(:first_activities).exactly(0).times
      expect(query).to receive(:next_cursored_activities).exactly(0).times

      query.query(-cursor)
    end
  end

end
