class Question < ApplicationRecord
  include Attachable
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  belongs_to :user

  validates :title, presence: true, length: { minimum: 10, maximum: 255 }
  validates :body, presence: true, length: { minimum: 10 }

  after_create_commit { QuestionsBroadcastJob.perform_later self }
  after_create_commit :subscribe_author

  private

  def subscribe_author
    subscriptions.create(user_id: self.user_id)
  end
end
