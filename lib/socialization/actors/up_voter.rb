module ActiveRecord
  class Base
    def is_upvoter?
      false
    end
    alias upvoter? is_upvoter?
  end
end

module Socialization
  module UpVoter
    extend ActiveSupport::Concern

    included do
      after_destroy { Socialization.upvote_model.remove_upvoteables(self) }

      # Specifies if self can upvote {upvoteable} objects.
      #
      # @return [Boolean]
      def is_upvoter?
        true
      end
      alias upvoter? is_upvoter?

      # Create a new {upvote upvote} relationship.
      #
      # @param [upvoteable] upvoteable the object to be upvoted.
      # @return [Boolean]
      def upvote!(upvoteable)
        raise Socialization::ArgumentError, "#{upvoteable} is not upvoteable!"  unless upvoteable.respond_to?(:is_upvoteable?) && upvoteable.is_upvoteable?
        Socialization.upvote_model.upvote!(self, upvoteable)
      end

      # Delete a {upvote upvote} relationship.
      #
      # @param [upvoteable] upvoteable the object to unupvote.
      # @return [Boolean]
      def unupvote!(upvoteable)
        raise Socialization::ArgumentError, "#{upvoteable} is not upvoteable!" unless upvoteable.respond_to?(:is_upvoteable?) && upvoteable.is_upvoteable?
        Socialization.upvote_model.unupvote!(self, upvoteable)
      end

      def upvote_time!(upvoteable)
        raise Socialization::ArgumentError, "#{upvoteable} is not upvoteable!" unless upvoteable.respond_to?(:is_upvoteable?) && upvoteable.is_upvoteable?
        Socialization.upvote_model.upvote_time!(self, upvoteable)
      end
      # Toggles a {upvote upvote} relationship.
      #
      # @param [upvoteable] upvoteable the object to upvote/unupvote.
      # @return [Boolean]
      def toggle_upvote!(upvoteable)
        raise Socialization::ArgumentError, "#{upvoteable} is not upvoteable!" unless upvoteable.respond_to?(:is_upvoteable?) && upvoteable.is_upvoteable?
        if upvotes?(upvoteable)
          unupvote!(upvoteable)
          false
        else
          upvote!(upvoteable)
          true
        end
      end

      # Specifies if self upvotes a {upvoteable} object.
      #
      # @param [upvoteable] upvoteable the {upvoteable} object to test against.
      # @return [Boolean]
      def upvotes?(upvoteable)
        raise Socialization::ArgumentError, "#{upvoteable} is not upvoteable!" unless upvoteable.respond_to?(:is_upvoteable?) && upvoteable.is_upvoteable?
        Socialization.upvote_model.upvotes?(self, upvoteable)
      end

      # Returns all the upvoteables of a certain type that are upvoted by self
      #
      # @params [upvoteable] klass the type of {upvoteable} you want
      # @params [Hash] opts a hash of options
      # @return [Array<upvoteable, Numeric>] An array of upvoteable objects or IDs
      def upvoteables(klass, opts = {})
        Socialization.upvote_model.upvoteables(self, klass, opts)
      end
      alias :upvotees :upvoteables

      # Returns a relation for all the upvoteables of a certain type that are upvoted by self
      #
      # @params [upvoteable] klass the type of {upvoteable} you want
      # @params [Hash] opts a hash of options
      # @return ActiveRecord::Relation
      def upvoteables_relation(klass, opts = {})
        Socialization.upvote_model.upvoteables_relation(self, klass, opts)
      end
      alias :upvotees_relation :upvoteables_relation
    end
  end
end

