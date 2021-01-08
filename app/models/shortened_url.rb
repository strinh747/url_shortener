class ShortenedUrl < ApplicationRecord
    validates :long_url, :short_url, :user_id, presence: true
    validates :short_url, uniqueness: true
    validate :no_spamming, :nonpremium_max

    def self.random_code
        loop do
            random_code = SecureRandom.urlsafe_base64(16)
            return random_code unless ShortenedUrl.exists?(short_url: random_code)
        end
    end

    def self.create_for_user_and_long_url(user,long_url)
        ShortenedUrl.create!(
            user_id: user.id,
            long_url: long_url,
            short_url: ShortenedUrl.random_code
        )

    end

    belongs_to :submitter,
        class_name: 'User',
        foreign_key: :user_id,
        primary_key: :id

    has_many :visits,
        class_name: 'Visit',
        foreign_key: :shortened_url_id,
        primary_key: :id,
        dependent: :destroy

    has_many :visitors, Proc.new {distinct}, through: :visits, source: :visitor

    has_many :taggings,
        class_name: 'Tagging',
        foreign_key: :shortened_url_id,
        primary_key: :id,
        dependent: :destroy

    has_many :tag_topics, through: :taggings, source: :tag_topic

    def num_clicks
        self.visits.count
    end

    def num_uniques
        self.visitors.count
    end

    def num_recent_uniques
        visitors
            .where('visits.created_at < ?', 10.minutes.ago)
            .distinct
            .count
    end

    def self.prune(n)
        ShortenedUrl
            .joins(:submitter)
            .joins('LEFT JOIN visits ON visits.shortened_url_id = shortened_urls.id')
            .where("(shortened_urls.id IN (
            SELECT shortened_urls.id
            FROM shortened_urls
            JOIN visits
            ON visits.shortened_url_id = shortened_urls.id
            GROUP BY shortened_urls.id
            HAVING MAX(visits.created_at) < \'#{n.minute.ago}\'
            ) OR (
            visits.id IS NULL and shortened_urls.created_at < \'#{n.minutes.ago}\'
            )) AND users.premium = \'f\'")
            .destroy_all
    end

    private

    def no_spamming
        last_minute = ShortenedUrl
            .where('created_at < ?', 1.minute.ago)
            .where(user_id: user_id)
            .length

        errors[:maximum] << 'of five short urls per minute' if last_minute >= 5
    end

    def nonpremium_max
        return if User.find(self.user_id).premium

        number_of_urls =
          ShortenedUrl
            .where(user_id: user_id)
            .length
    
        if number_of_urls >= 5
          errors[:Only] << 'premium members can create more than 5 short urls'
        end
    end
end

