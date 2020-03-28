class ApplicationController < ActionController::API

    def response_success(class_name, action_name)
        render status: 200, json: { status: 200, message: "Success #{class_name.capitalize} #{action_name.capitalize}" }
    end

end
