require 'rails_helper'

describe 'Usuário(ADM) tenta ver dúvidas não respondidas', selenium: true do
  it 'e vê uma com sucesso' do
    video_card_category = ItemCategory.create!(name: 'Placas de Vídeo')

    image_file = File.open("#{Rails.root}/spec/system/items/imgs/download.jpg")
    item = Item.new(name: 'AMD Radeon HD7970 3GB Saphire', description: 'Placa de vídeo para computador',
                    weight: 3500, width: 25, height: 6, depth: 11, item_category_id: video_card_category.id)
    item.image.attach(io: image_file, filename: 'download.jpg')
    item.save!

    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    user2 = User.create!(email: 'joao@leilaodogalpao.com.br', name: 'João Almeida', password: 'password', cpf: '93053597012')
    batch = Batch.create!(start_date: Date.today, end_date: 7.day.from_now, minimum_bid_difference: 30, created_by_id: user.id, minimum_bid: 30)
    BatchItem.create!(batch_id: batch.id, item_id: item.id)
    batch.approved_by = user2
    batch.save!
    user3 = User.create!(email: 'leticia@gmail.com ', name: 'Letícia Alcantara', password: 'password', cpf: '61492939048')
    doubt = Doubt.create!(user_id: user3.id, batch_id: batch.id, content: 'Olá onde é feita a retirada do lote ?')
    answer = Answer.create!(doubt_id: doubt.id, user_id: user3.id, content: 'Alguém me responde por favor')
    login_as(user)

    visit root_path
    click_on 'Dúvidas em aberto'
    
    within "div#doubt_#{doubt.id}" do
      click_on 'Respostas'
    end

    expect(page).to have_content(answer.content)
    within "div#doubt_#{doubt.id}" do
      click_on 'Respostas'
    end

    expect(page).not_to have_content(answer.content)
    within "div#doubt_#{doubt.id}" do
      click_on 'Respostas'
    end

    expect(page).to have_content(answer.content)

  end

  it 'e vê multiplas com sucesso' do
    video_card_category = ItemCategory.create!(name: 'Placas de Vídeo')

    image_file = File.open("#{Rails.root}/spec/system/items/imgs/download.jpg")
    item = Item.new(name: 'AMD Radeon HD7970 3GB Saphire', description: 'Placa de vídeo para computador',
                    weight: 3500, width: 25, height: 6, depth: 11, item_category_id: video_card_category.id)
    item.image.attach(io: image_file, filename: 'download.jpg')
    item.save!

    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    user2 = User.create!(email: 'joao@leilaodogalpao.com.br', name: 'João Almeida', password: 'password', cpf: '93053597012')
    batch = Batch.create!(start_date: Date.today, end_date: 7.day.from_now, minimum_bid_difference: 30, created_by_id: user.id, minimum_bid: 30)
    BatchItem.create!(batch_id: batch.id, item_id: item.id)
    batch.approved_by = user2
    batch.save!
    user3 = User.create!(email: 'leticia@gmail.com ', name: 'Letícia Alcantara', password: 'password', cpf: '61492939048')
    doubt = Doubt.create!(user_id: user3.id, batch_id: batch.id, content: 'Olá onde é feita a retirada do lote ?')
    answer = Answer.create!(doubt_id: doubt.id, user_id: user3.id, content: 'Alguém me responde por favor')
    answer2 = Answer.create!(doubt_id: doubt.id, user_id: user3.id, content: '??????')
    login_as(user)

    visit root_path
    click_on 'Dúvidas em aberto'

    within "div#doubt_#{doubt.id}" do
      click_on 'Respostas'
    end

    expect(page).to have_content(answer.content)
    expect(page).to have_content(answer2.content)
    within "div#doubt_#{doubt.id}" do
      click_on 'Respostas'
    end

    expect(page).not_to have_content(answer.content)
    expect(page).not_to have_content(answer2.content)
    within "div#doubt_#{doubt.id}" do
      click_on 'Respostas'
    end

    expect(page).to have_content(answer.content)
  end

  it 'e vê nenhuma com sucesso' do
    video_card_category = ItemCategory.create!(name: 'Placas de Vídeo')

    image_file = File.open("#{Rails.root}/spec/system/items/imgs/download.jpg")
    item = Item.new(name: 'AMD Radeon HD7970 3GB Saphire', description: 'Placa de vídeo para computador',
                    weight: 3500, width: 25, height: 6, depth: 11, item_category_id: video_card_category.id)
    item.image.attach(io: image_file, filename: 'download.jpg')
    item.save!

    user = User.create!(email: 'gustavo@leilaodogalpao.com.br', name: 'Gustavo Alberto', password: 'password', cpf: '73896923080')
    user2 = User.create!(email: 'joao@leilaodogalpao.com.br', name: 'João Almeida', password: 'password', cpf: '93053597012')
    batch = Batch.create!(start_date: Date.today, end_date: 7.day.from_now, minimum_bid_difference: 30, created_by_id: user.id, minimum_bid: 30)
    BatchItem.create!(batch_id: batch.id, item_id: item.id)
    batch.approved_by = user2
    batch.save!
    user3 = User.create!(email: 'leticia@gmail.com ', name: 'Letícia Alcantara', password: 'password', cpf: '61492939048')
    doubt = Doubt.create!(user_id: user3.id, batch_id: batch.id, content: 'Olá onde é feita a retirada do lote ?')
    login_as(user)

    visit root_path
    click_on 'Dúvidas em aberto'
    
    within "div#doubt_#{doubt.id}" do
      click_on 'Respostas'
    end
    
    expect(page).to have_content('Ainda não existem respostas para essa dúvida')
  end
end