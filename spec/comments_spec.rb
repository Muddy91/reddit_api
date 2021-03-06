require "spec_helper"

describe RedditApi::Comments, :vcr do

  describe "#most_recent_subreddits" do
    it "returns the names of n subreddits given user has commented on" do
      comments_api = RedditApi::Comments.new
      user = RedditApi::User.new({ "username" => "spez" })
      count = 5

      subreddits = comments_api.most_recent_subreddits(user, count)

      expect(subreddits.length).to eq(count)
    end

    it "resets misses to 0 after collecting subreddits" do
      max_misses = RedditApi::Comments::DEFAULT_MAX_MISSES
      comments_api = RedditApi::Comments.new(misses: max_misses)
      user = RedditApi::User.new({ "username" => "spez" })

      comments_api.most_recent_subreddits(user, 100)

      expect(comments_api.misses).to eq(0)
    end
  end

  context "when count within single api request limit of 100" do
    describe "#most_recent_comments" do
      it "returns n most recent comments for the given user" do
        comments_api = RedditApi::Comments.new
        user = RedditApi::User.new({ "username" => "spez" })
        count = 5

        comments = comments_api.most_recent_comments(user, count)

        expect(comments.length).to eq(count)
      end

      it "comments are unique" do
        comments_api = RedditApi::Comments.new
        user = RedditApi::User.new({ "username" => "spez" })
        count = 5

        comments = comments_api.most_recent_comments(user, count)
        unique_comments = comments.uniq { |c| c.reddit_id }

        expect(unique_comments.length == comments.length).to be true
      end

      it "returns only comments for the given user" do
        comments_api = RedditApi::Comments.new
        user = RedditApi::User.new({ "username" => "spez" })

        comments = comments_api.most_recent_comments(user, 10)
        authored_by_user = comments.all? do |comment|
          comment.author_name == user.username
        end

        expect(authored_by_user).to be true
      end

      it "returns comment objects" do
        comments_api = RedditApi::Comments.new
        user = RedditApi::User.new({ "username" => "spez" })

        comments = comments_api.most_recent_comments(user, 5)
        all_comments_objects = comments.all? { |c| c.is_a?(RedditApi::Comment) }

        expect(all_comments_objects).to be true
      end
    end
  end

  context "when count greater than single api request limit of 100" do
    describe "#most_recent_subreddits" do
      it "returns the names of n subreddits given user has commented on" do
        comments_api = RedditApi::Comments.new
        user = RedditApi::User.new({ "username" => "spez" })
        count = 10

        subreddits = comments_api.most_recent_subreddits(user, count)

        expect(subreddits.length).to eq(count)
      end
    end

    describe "#most_recent_comments" do
      it "returns n most recent comments for the given user" do
        comments_api = RedditApi::Comments.new
        user = RedditApi::User.new({ "username" => "spez" })
        count = 125

        comments = comments_api.most_recent_comments(user, count)

        expect(comments.length).to eq(count)
      end

      it "comments are unique" do
        comments_api = RedditApi::Comments.new
        user = RedditApi::User.new({ "username" => "spez" })
        count = 125

        comments = comments_api.most_recent_comments(user, count)
        unique_comments = comments.uniq { |c| c.reddit_id }

        expect(unique_comments.length).to eq(count)
      end

      it "returns only comments for the given user" do
        comments_api = RedditApi::Comments.new
        user = RedditApi::User.new({ "username" => "spez" })
        count = 125

        comments = comments_api.most_recent_comments(user, count)
        authored_by_user = comments.all? do |comment|
          comment.author_name == user.username
        end

        expect(authored_by_user).to be true
      end
    end
  end

end

