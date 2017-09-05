namespace :btc do

	desc "Checa o preço"
	task :check => [ :environment ] do
		require 'net/http'
		require 'json'
		 
		url = 'https://www.mercadobitcoin.net/api/BTC/ticker/'
		uri = URI(url)
		response = Net::HTTP.get(uri)
		JSON.parse(response)
		puts response
	end

	desc "Configuração inicial"
	task :setup => [ :environment ] do
		#config = YAML.load_file("#{Rails.root.to_s}/config/btc.yml")[Rails.env]
		wallet = Wallet.first
		wallet = Wallet.new unless wallet
		wallet.number = 1
		wallet.money = 100
		wallet.balance = 0
		wallet.save
	end

	desc "Salva o preço da moeda neste momento"
	task :save => [:environment] do
		require 'net/http'
		require 'json'
		require 'date'
		 
		url = 'https://www.mercadobitcoin.net/api/BTC/ticker/'
		uri = URI(url)
		response = Net::HTTP.get(uri)
		ticker = JSON.parse(response)["ticker"]
		history = CoinHistory.new
		date = DateTime.strptime(ticker["date"].to_s, '%s')
		history.coin = 'BTC'
		history.value = ticker["last"]
		history.date = date
		history.save
	end

	desc "Toma a decisão de compra e venda"
	task :decision do

	end

	desc "Compra"
	task :buy => [ :environment ] do
		require "uri"
		require "net/http"

		params = { form: 'data', tapi_method: 'list_orders', 'coin_pair' => 'BRLBTC', tapi_nonce: Time.now.to_i}
		data = params.to_query

		uri = URI.parse("https://www.mercadobitcoin.net/tapi/v3/")
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true

		key = 'SECRET'
		data_uri = uri.request_uri + "?" + data
		digest = OpenSSL::Digest.new('sha512')
		instance = OpenSSL::HMAC.new(key, digest)
		instance.update(data_uri)

		headers = {
		  'TAPI-ID' => 'ID',
		  'TAPI-MAC' => instance.hexdigest,
		  'Content-Type' => 'application/x-www-form-urlencoded'
		}

		response = http.post(uri.request_uri, data, headers)
		output = response.body
		puts output
	end

end
