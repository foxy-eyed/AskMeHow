class Question < ApplicationRecord
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :attachments, dependent: :destroy, as: :attachable
  belongs_to :user

  validates :title, presence: true, length: { minimum: 10, maximum: 255 }
  validates :body, presence: true, length: { minimum: 10 }

  after_create_commit { QuestionsBroadcastJob.perform_later self }

  accepts_nested_attributes_for :attachments, reject_if: proc { |attributes| attributes['file'].blank? },
      allow_destroy: true
end
