class ApplicationController < ActionController::API

  def response_success_update(bike)
    render status: 200, json: {status: 200, message: "Congratulations! #{bike.brand.name} is sold"}
  end

  def response_success_created(bike)
    render status: 201, json: { status: 201, message: "#{bike.brand.name} (#{bike.serial_number})  Successfully registered!!" }
  end

  def response_not_found(object)
    render status: 404, json: { status: 404, error: "#{object} cannot be found"}
  end

  def response_not_updated(bike)
    render status: 404, json: { status: 404, message: "#{bike.brand.name} (#{bike.serial_number}) already sold out!"}
  end

  def response_not_created(bike)
    render status: 422, json: { status: 422, error: bike.errors.full_messages}
  end

end
