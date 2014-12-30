module Socialization
  module RedisStores
    class DownVote < Socialization::RedisStores::Base
      extend Socialization::Stores::Mixins::Base
      extend Socialization::Stores::Mixins::DownVote
      extend Socialization::RedisStores::Mixins::Base

      class << self
        alias_method :downvote!, :relation!;                          public :downvote!
        alias_method :undownvote!, :unrelation!;                      public :undownvote!
        alias_method :downvotes?, :relation?;                         public :downvotes?
        alias_method :downvoters_relation, :actors_relation;          public :downvoters_relation
        alias_method :downvoters, :actors;                            public :downvoters
        alias_method :downvoteables_relation, :victims_relation;      public :downvoteables_relation
        alias_method :downvoteables, :victims;                        public :downvoteables
        alias_method :remove_downvoters, :remove_actor_relations;     public :remove_downvoters
        alias_method :remove_downvoteables, :remove_victim_relations; public :remove_downvoteables
      end

    end
  end
end

