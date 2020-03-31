class ApplicationController < ActionController::API
  def response_success_update(bike)
    data = {
      status: 200, message: "Congratulations! #{bike.brand.name} is sold"
    }
    data = JSON.pretty_generate(data)
    render status: :ok, json: data
  end

  def response_success_created(bike)
    data = {
      status: 201, message: "#{bike.brand.name} (#{bike.serial_number})  Successfully registered!!"
    }
    data = JSON.pretty_generate(data)
    render status: :created, json: data
  end

  def response_not_found(object)
    data = { status: 404, error: "#{object} cannot be found" }
    data = JSON.pretty_generate(data)
    render status: :not_found, json: data
  end

  def response_not_updated(bike)
    data = {
      status: 404, message: "#{bike.brand.name} (#{bike.serial_number}) already sold out!"
    }
    data = JSON.pretty_generate(data)
    render status: :not_found, json: data
  end

  def response_not_created(bike)
    data = { status: 422, error: bike.errors.full_messages }
    data = JSON.pretty_generate(data)
    render status: :unprocessable_entity, json: data
  end

  def datetime_to_strftime(bikes)
    data = []
    bikes.each do |bike| # datetime型を、日本語の日付に変換
      sold_at = if bike.sold_at.present?
                  bike.sold_at.strftime('%Y年%-m月%-d日 %-H時%-M分')
                else
                  bike.sold_at
                end
      data = data.push({ id: bike.id, serial_number: bike.serial_number, sold_at: sold_at })
    end
    data
  end
end
