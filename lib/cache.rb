class LRUCache
  attr_accessor :capacity, :cache, :ordered_keys, :length

  def initialize(capacity)
    @capacity = capacity
    @length = 0
    @cache = {}
    @ordered_keys = DoubleLinkedList.new
  end

  def get(key)
    if @cache[key]
      @ordered_keys.move_to_head(@cache[key])
      return @cache[key].value
    end

    -1
  end

  def put(key, value)
    pop_tail if @length == @capacity

    new_node = @ordered_keys.prepend(key, value)
    @cache[key] = new_node

    @length += 1
  end

  private

  def pop_tail
    key_to_rm = @ordered_keys.pop_tail
    @cache.delete(key_to_rm)
    @length -= 1
  end
end

class DoubleLinkedList
  attr_accessor :head, :tail

  def initialize
    @head = nil
    @tail = nil
  end

  def pop_tail
    curr_tail = @tail

    @tail = curr_tail.prev
    @tail.nxt = nil

    curr_tail&.key
  end

  def move_to_head(node)
    return node if node == @head

    if @tail == node
      @tail = node.prev
      @tail.nxt = nil
    end

    node.prev.nxt = node.nxt
    node.nxt.prev = node.prev
    curr_head = @head
    curr_head.prev = node
    node.prev = nil
    @head = node
    @tail.nxt = nil
  end

  def create_first_node(new_node)
    @head = new_node
    @tail = new_node

    @tail.prev = @head
    @head.nxt = @tail
  end

  def prepend(key, value)
    new_node = Node.new(key, value)

    if !@head && !@tail
      create_first_node(new_node)
      new_node
    end

    current_head_node = @head
    current_head_node.prev = new_node
    new_node.nxt = current_head_node
    @head = new_node

    new_node
  end

  def print_order(node = @head)
    puts node.key
    return unless node.nxt

    print_order(node.nxt)
  end
end

class Node
  attr_accessor :key, :value, :prev, :nxt

  def initialize(key, value, prev = nil, nxt = nil)
    @key = key
    @value = value
    @prev = prev
    @nxt = nxt
  end
end
