require 'rspec'
require 'pry'
require_relative '../lib/cache'

describe 'cache' do
  describe '#get' do
    let(:cache) { LRUCache.new(5) }
    context 'when the cache does not have that key' do
      it 'returns -1' do
        expect(cache.get('a')).to eq(-1)
        expect(cache.cache).to be_empty
      end
    end

    fcontext 'when the cache is at capacity' do
      before do
        cache.put('a', 1)
        cache.put('b', 2)
        cache.put('c', 3)
        cache.put('d', 4)
        cache.put('e', 5)
      end

      it 'moves the accessed key to the head' do
        cache.get('c')

        expect(cache.ordered_keys.head.key).to eq('c')
        expect(cache.ordered_keys.head.value).to eq(3)
        expect(cache.length).to eq(cache.capacity)

        o = cache.ordered_keys
        binding.pry
        expect(o.head.key).to eq('c')
        expect(o.head.nxt.key).to eq('e')
      end
    end
  end

  describe '#put' do
    let(:cache) { LRUCache.new(5) }
    context 'when the cache is empty' do
      it 'adds the key and value to the cache and places the new node at the front/back' do
        cache.put('a', 1)

        expect(cache.get('a')).to eq(1)

        expect(cache.ordered_keys.head.key).to eq('a')
        expect(cache.ordered_keys.tail.key).to eq('a')
        expect(cache.ordered_keys.head.value).to eq(1)
        expect(cache.ordered_keys.tail.value).to eq(1)
      end
    end

    context 'with an existing item in the cache' do
      before do
        cache.put('a', 1)
      end

      it 'adds to cache and puts to the front of the ordered list' do
        cache.put('b', 2)

        expect(cache.get('b')).to eq(2)

        expect(cache.ordered_keys.head.key).to eq('b')
        expect(cache.ordered_keys.tail.key).to eq('a')
        expect(cache.ordered_keys.head.value).to eq(2)
        expect(cache.ordered_keys.tail.value).to eq(1)
      end
    end

    context 'when the cache is at capacity' do
      before do
        cache.put('a', 1)
        cache.put('b', 2)
        cache.put('c', 3)
        cache.put('d', 4)
        cache.put('e', 5)
      end

      it 'removes the earliest one' do
        cache.put('f', 6)
        expect(cache.cache['a']).to be_nil
        expect(cache.get('a')).to eq(-1)
        expect(cache.length).to eq(cache.capacity)
        expect(cache.ordered_keys.head.key).to eq('f')
        expect(cache.ordered_keys.head.value).to eq(6)
        expect(cache.ordered_keys.tail.key).to eq('b')
        expect(cache.ordered_keys.tail.value).to eq(2)
      end
    end
  end
end
