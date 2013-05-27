require 'cuba'
require 'json'

require './eagle_tags_parse'

Cuba.use Rack::Static, :urls => ["/jquery2.js"], :root => 'static'

Cuba.define do

  on post do
    on 'freeling/analyze' do
      forms = FreelingWeb.parseText req.params['text']
      res['Content-Type'] = 'application/json; charset=utf-8'
      res.write forms.to_json
    end
  end

  on get do
    on root do
      res.write File.open('static/index.html') { |f| f.read }
    end
  end


end

run Cuba
