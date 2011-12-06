class HomeController < ApplicationController

  def index
    string = Rails.application.routes.routes.map do |route|
      [route.name.ljust(40), route.path].join(" ")
    end.join("\n")
    render :text => "<pre>#{string}</pre>"
  end

end
