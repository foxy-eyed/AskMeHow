include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :attachment do
    file { fixture_file_upload "#{Rails.root}/spec/files/fox.jpg", 'image/jpg' }
    attachable nil
  end
end
