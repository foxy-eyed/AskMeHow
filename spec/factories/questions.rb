FactoryGirl.define do
  factory :question do
    title 'To be or not to be?'
    body 'That is the question'
    user

    factory :question_with_answers do
      transient do
        answers_count 5
      end

      after(:create) do |question, evaluator|
        create_list(:answer, evaluator.answers_count, question: question)
      end
    end
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
    user
  end
end
