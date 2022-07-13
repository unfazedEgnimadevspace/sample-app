class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  default_scope -> { order(created_at: :desc)}
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140}
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png], message: "Must be a valid image type"},
                    
                      size: { less_than: 5.megabyte, message: "Should be less than 5MB"}


    def display_image
      image.variant(resize_to_limit: [500, 500])
    end
end
