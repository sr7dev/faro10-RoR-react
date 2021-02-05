module Facebook
  class HarvestPosts
    def self.run_all
      @users = User.all.each do |user|
        harvest(user)
      end
    end

    def self.harvest(user)
      if !user.oauth_token.nil?
        begin
          graph = Koala::Facebook::API.new(user.oauth_token)
          if user.facebook_posts.count > 0
            insert_posts  graph.get_connections("me", 'posts', { since: user.facebook_posts.order(created_time: :desc).first.created_time}), user
          else
            insert_posts  graph.get_connections("me", 'posts', { since: 5.years.ago}), user
          end
          return true
        rescue Koala::Facebook::AuthenticationError => exception
          Rails.logger.error("Facebook error: " + exception.message)
          return false
        end
      end
    end

    def self.insert_posts(posts, user)
      return if posts.empty?
      posts.each do |post|
        unless FacebookPost.exists?(:facebook_id => post["id"])
          FacebookPost.create(user: user, message: post["message"], created_time: post["created_time"], facebook_id: post["id"])
        end
      end
      insert_posts posts.next_page, user
    end
  end
end
