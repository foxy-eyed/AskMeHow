FactoryGirl.define do
  factory :answer do
    body 'To be!'
    question
    user
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
    question nil
    user nil
  end
end
