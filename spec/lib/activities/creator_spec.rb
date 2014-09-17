require 'spec_helper'
require 'activities/creator'

describe 'Creator' do

  let(:receiver) { double('new_receiver') }
  let(:attributes) { {receivers: [receiver], verb: 'blah'} }
  let(:title) { 'So and so performed an activity' }
  subject(:creator) { Activities::Creator.new(attributes) }

  before do
    allow(receiver).to receive(:id)
    allow(creator).to receive(:create_activity)
    allow(creator).to receive(:create_activity_receiver)
    allow(creator).to receive(:create_title).and_return(title)
  end

  describe 'create' do
    it 'creates the activity' do
      expect(creator).to receive(:create_activity).with(hash_including(verb: 'blah', title: title))

      creator.create
    end

    it 'created the activity receivers' do
      expect(creator).to receive(:create_activity_receiver).with(hash_including(receiver: receiver))

      creator.create
    end
  end

end
