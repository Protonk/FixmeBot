class Datacycle
  def self.keepgrabbing
    Rails.logger.info "Datacycle started: PID #{Process.pid}"

    i = 0
    loop do
      i += 1
      Rails.logger.info "starting cycle #{i}..."
      articles = FindArticles.at_random(count: 1000)
      Rails.logger.info "#{articles.count} mainspace articles found"
      articles = DiscardRedirects.from(articles)
      Rails.logger.info "#{articles.count} are not redirects"
      articles = HighPageviews.from_among(articles, min_views: 300)
      Rails.logger.info "#{articles.count} of those have high page views"
      articles = Ores.discard_high_revision_scores(articles, max_wp10: 30)
      if articles.count > 0
        Rails.logger.info "#{articles.count} tweetable prospect(s) found!"
      else
        Rails.logger.info "no tweetable articles found in that cycle"
      end
      Article.import articles
    end
  end
end