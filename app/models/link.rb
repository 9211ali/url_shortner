class Link < ApplicationRecord

  has_many :views, dependent: :destroy
  belongs_to :user, optional: true

  scope :recent_first, -> { order(created_at: :desc) }

  validates :url, presence: true

  after_save_commit if: :url_previously_changed? do
    MetadataJob.perform_later(to_param)
  end

  def to_param
    ShortCode.encode(id)
  end

  def self.find(id)
    super ShortCode.decode(id)
  end

  def domain
    URI(url).host rescue nil
  end

  def editable_by?(user)
    user_id && (user_id == user&.id)
  end
end
