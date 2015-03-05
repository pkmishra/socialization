module ActiveRecord
  class Base
    def is_downvoter?
      false
    end
    alias downvoter? is_downvoter?
  end
end

module Socialization
  module DownVoter
    extend ActiveSupport::Concern

    included do
      after_destroy { Socialization.downvote_model.remove_downvoteables(self) }

      # Specifies if self can downvote {downvoteable} objects.
      #
      # @return [Boolean]
      def is_downvoter?
        true
      end
      alias downvoter? is_downvoter?

      # Create a new {downvote downvote} relationship.
      #
      # @param [downvoteable] downvoteable the object to be downvoted.
      # @return [Boolean]
      def downvote!(downvoteable)
        raise Socialization::ArgumentError, "#{downvoteable} is not downvoteable!"  unless downvoteable.respond_to?(:is_downvoteable?) && downvoteable.is_downvoteable?
        Socialization.downvote_model.downvote!(self, downvoteable)
      end

      # Delete a {downvote downvote} relationship.
      #
      # @param [downvoteable] downvoteable the object to undownvote.
      # @return [Boolean]
      def undownvote!(downvoteable)
        raise Socialization::ArgumentError, "#{downvoteable} is not downvoteable!" unless downvoteable.respond_to?(:is_downvoteable?) && downvoteable.is_downvoteable?
        Socialization.downvote_model.undownvote!(self, downvoteable)
      end

      # Toggles a {downvote downvote} relationship.
      #
      # @param [downvoteable] downvoteable the object to downvote/undownvote.
      # @return [Boolean]
      def toggle_downvote!(downvoteable)
        raise Socialization::ArgumentError, "#{downvoteable} is not downvoteable!" unless downvoteable.respond_to?(:is_downvoteable?) && downvoteable.is_downvoteable?
        if downvotes?(downvoteable)
          undownvote!(downvoteable)
          false
        else
          downvote!(downvoteable)
          true
        end
      end

      # Specifies if self downvotes a {downvoteable} object.
      #
      # @param [downvoteable] downvoteable the {downvoteable} object to test against.
      # @return [Boolean]
      def downvotes?(downvoteable)
        raise Socialization::ArgumentError, "#{downvoteable} is not downvoteable!" unless downvoteable.respond_to?(:is_downvoteable?) && downvoteable.is_downvoteable?
        Socialization.downvote_model.downvotes?(self, downvoteable)
      end
    
      def score!(downvoteable)
        raise Socialization::ArgumentError, "#{downvoteable} is not downvoteable!" unless downvoteable.respond_to?(:is_downvoteable?) && downvoteable.is_downvoteable?
        Socialization.downvote_model.score!(self, downvoteable)
      end
      # Returns all the downvoteables of a certain type that are downvoted by self
      #
      # @params [downvoteable] klass the type of {downvoteable} you want
      # @params [Hash] opts a hash of options
      # @return [Array<downvoteable, Numeric>] An array of downvoteable objects or IDs
      def downvoteables(klass, opts = {})
        Socialization.downvote_model.downvoteables(self, klass, opts)
      end
      alias :downvotees :downvoteables

      # Returns a relation for all the downvoteables of a certain type that are downvoted by self
      #
      # @params [downvoteable] klass the type of {downvoteable} you want
      # @params [Hash] opts a hash of options
      # @return ActiveRecord::Relation
      def downvoteables_relation(klass, opts = {})
        Socialization.downvote_model.downvoteables_relation(self, klass, opts)
      end
      alias :downvotees_relation :downvoteables_relation
    end
  end
end

