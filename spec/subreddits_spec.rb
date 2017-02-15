require "spec_helper"

describe RedditApi::Subreddits do

  describe "#top" do
    it "returns an array of the top n subreddits" do
      subreddit_api = RedditApi::Subreddits.new
      count = 5

      result = subreddit_api.top(count)

      expect(result.length).to eq(5)
    end
  end

end