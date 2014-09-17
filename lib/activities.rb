require "activities/version"
require "activities/creator"
require "activities/query"

module Activities

  class Engine < Rails::Engine
  end

  @@verbs = {}
  mattr_accessor :verbs

  class << self
    def configure(&block)
      instance_eval(&block) if block_given?
    end

    # Define a 'verb' with a message and validations
    #
    # @param [String] name
    # @param [Hash] options
    # @param [Block] Block Anything within the block with be executed in the scope of the Creator class
    #
    # @example
    #   verb :add_document do
    #     message :i18n, -> {{ name: actor.full_name, type: object.class.humanize }}
    #     validates :actor,  is_a: User
    #     validates :object, is_a: Document::Base
    #     validates :target, is_a: Matter
    #   end
    #
    # @return [Void]
    def verb(name, options = {}, &block)
      method = "#{ name }!"

      # Create a subclass as we're going to customize it with validations for each verb that we define.
      creator = Class.new(Creator, &block)
      self.verbs[name] = creator

      self.class.send(:define_method, method) do |hash|
        creator.new(hash.merge(verb: name)).create
      end
    end
  end
end
