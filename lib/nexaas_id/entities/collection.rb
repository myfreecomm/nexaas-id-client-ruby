class NexaasID::Entities::Collection < Base
  extend Forwardable

  PAGE_REGEX = /page=(\d+)/

  attr_reader :total
  def_delegators :@collection, :first, :last, :each, :map, :count, :empty?, :any?

  def initialize(response, entity_class)
    @response = response
    @entity_class = entity_class
    @total = parsed_body['count'].to_i
    @collection = []
   end

  def self.build(response, entity_class)
    self.new(response, entity_class).build
  end

  def build
    build_collection
    self
  end

  def next_page
    page_for('next')
  end

  def previous_page
    page_for('previous')
  end

  def to_a
    @collection.clone
  end

  private

  def page_for(page_rel)
    match = parsed_body[page_rel].match(PAGE_REGEX)
    return match[1].to_i if match
  end

  def build_collection
    parsed_body['collection'].each do |attributes|
      @collection.push(@entity_class.new(attributes))
    end
  end

  def parsed_body
    @parsed_body ||= @response.parsed
  end
end
