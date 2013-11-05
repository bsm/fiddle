# Fiddle

[![Build Status](https://travis-ci.org/bsm/fiddle.png?branch=master)](https://travis-ci.org/bsm/fiddle)

This Rails engine allows you to build simple and effective data/reporting APIs and expose them 
securely to your users. Custom data universes can be queired by clients via SQL-like URL query parameters. 

## Example:
 
    GET https://my.api.host/reports/site_stats.json?select[]=page_views&by[]=date|site&where[site_id.in]=33|44|55&where[date.between]=-30..0

## Installation

Add it to your Gemfile:

    gem 'fiddle'

Mount it in your config/routes.rb:

    MyApp::Application.routes.draw do
      # ...
      mount Fiddle::Engine => "/fiddle", as: :fiddle
    end

## Usage

The engine will add models & controllers to manage which allow you to connect to various RDMS sources, 
setup data cubes with dimensions, measures, contraints & lookups.

Once in place, users can be given access to these cubes in controllers. Example:
  
    # reports_controller.rb
    def show
      @cube  = Fiddle::Cube.find_by_name!(params[:id])
      parser = Fiddle::ParamParser.new(@cube, params)
      render json: Fiddle::SQLBuilder.new(@cube, parser.to_hash).dataset
    end

## Licence

    Copyright (c) 2008-2013 Black Square Media

    Permission is hereby granted, free of charge, to any person obtaining
    a copy of this software and associated documentation files (the
    "Software"), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish,
    distribute, sublicense, and/or sell copies of the Software, and to
    permit persons to whom the Software is furnished to do so, subject to
    the following conditions:

    The above copyright notice and this permission notice shall be
    included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
    NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
    LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
    OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
    WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
