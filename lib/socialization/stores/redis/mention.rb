module Socialization
  module RedisStores
    class Mention < Socialization::RedisStores::Base
      extend Socialization::Stores::Mixins::Base
      extend Socialization::Stores::Mixins::Mention
      extend Socialization::RedisStores::Mixins::Base

      class << self
        alias_method :mention!, :relation!;                          public :mention!
        alias_method :unmention!, :unrelation!;                      public :unmention!
        alias_method :mentions?, :relation?;                         public :mentions?
        alias_method :mentioners_relation, :actors_relation;         public :mentioners_relation
        alias_method :mentioners, :actors;                           public :mentioners
        alias_method :mentionables_relation, :victims_relation;      public :mentionables_relation
        alias_method :mentionables, :victims;                        public :mentionables
        alias_method :remove_mentioners, :remove_actor_relations;    public :remove_mentioners
        alias_method :remove_mentionables, :remove_victim_relations; public :remove_mentionables
        alias_method :mention_time, :score;                          public :mention_time
      end

    end
  end
end
