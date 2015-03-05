module Socialization
  module RedisStores
    class UpVote < Socialization::RedisStores::Base
      extend Socialization::Stores::Mixins::Base
      extend Socialization::Stores::Mixins::UpVote
      extend Socialization::RedisStores::Mixins::Base

      class << self
        alias_method :upvote!, :relation!;                          public :upvote!
        alias_method :unupvote!, :unrelation!;                      public :unupvote!
        alias_method :upvotes?, :relation?;                         public :upvotes?
        alias_method :upvoters_relation, :actors_relation;          public :upvoters_relation
        alias_method :upvoters, :actors;                            public :upvoters
        alias_method :upvoteables_relation, :victims_relation;      public :upvoteables_relation
        alias_method :upvoteables, :victims;                        public :upvoteables
        alias_method :remove_upvoters, :remove_actor_relations;     public :remove_upvoters
        alias_method :remove_upvoteables, :remove_victim_relations; public :remove_upvoteables
        alias_method :upvote_time, :score;                          public :upvote_time
      end

    end
  end
end

