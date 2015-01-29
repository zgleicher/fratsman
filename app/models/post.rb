class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments, dependent: :destroy #if you delete a post, comments are deleted
  validates :title, presence: true, length: {minimum: 5}
  validates :body, presence: true
end
