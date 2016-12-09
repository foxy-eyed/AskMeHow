shared_examples_for 'add attachments ability' do
  background do
    sign_in(user)
    visit path
  end

  scenario 'Authenticated user creates record with attachments', js: true do
    fill_form

    click_on '+ Add file'
    all('input[type="file"]').first.set "#{Rails.root}/spec/files/file_01.txt"
    click_on '+ Add file'
    all('input[type="file"]').last.set "#{Rails.root}/spec/files/file_02.txt"

    click_on btn

    within container do
      expect(page).to have_link 'file_01.txt', href: /uploads\/attachment\/file\/\d\/file_01\.txt/
      expect(page).to have_link 'file_02.txt', href: /uploads\/attachment\/file\/\d\/file_02\.txt/
    end
  end
end

shared_examples_for 'edit attachments ability' do
  let!(:attachment) { create(:attachment, attachable: attachable) }
  let!(:attachable_name) { attachable.class.to_s.underscore }

  background do
    sign_in(user)
    visit path
    within trigger_container do
      click_on 'Edit'
    end
  end

  scenario 'Author removes attachment', js: true do
    within ".#{attachable_name}" do
      expect(page).to have_link 'fox.jpg', href: /uploads\/attachment\/file\/\d\/fox\.jpg/

      within '.nested-fields' do
        first('.attachment-remove').click
      end
      click_on "Update #{attachable_name}"
      wait_for_ajax

      expect(page).to_not have_link 'fox.jpg', href: /uploads\/attachment\/file\/\d\/fox\.jpg/
    end
  end

  scenario 'Author attach additional file', js: true do
    within ".#{attachable_name}" do
      click_on '+ Add file'
      first('input[type="file"]').set "#{Rails.root}/spec/files/coon.jpg"
      click_on "Update #{attachable_name}"
      wait_for_ajax

      expect(page).to have_link 'fox.jpg', href: /uploads\/attachment\/file\/\d\/fox\.jpg/
      expect(page).to have_link 'coon.jpg', href: /uploads\/attachment\/file\/\d\/coon\.jpg/
    end
  end
end
