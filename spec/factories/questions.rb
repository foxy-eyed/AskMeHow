FactoryGirl.define do
  factory :question do
    title 'To be or not to be?'
    body 'That is the question'
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
