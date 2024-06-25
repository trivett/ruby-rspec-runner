require 'rspec'
require 'pry'
require_relative '../lib/greet'

describe 'Greeter' do
  describe '#greet' do
    context 'when name is defined' do
      let(:name) { 'Vincent' }

      it 'greets' do
        puts 'hi'
        expect(Greet.new(name).greet).to eq('Hello Vincent')
      end
    end
  end
end
