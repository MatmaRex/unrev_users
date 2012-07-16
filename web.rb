# coding: utf-8

require_relative 'topusers.rb'

require 'camping'
Camping.goes :UnrevUsers

module UnrevUsers
	module Controllers
		class Index
			def get
				if @input['wiki']
					@list = get_top_users "#{@input['wiki']}.wikipedia.org"
					render :list
				else
					render :index
				end
			end
		end
	end
	
	module Views
		def layout
			html{head{}; body{yield}}
		end
		def index
			form do
				p do
					text 'Wikipedia (pl, de, etc): '
					input.wiki!
				end
				p do
					input value:'See users with most unreviewed edits', type:'submit'
				end
			end
			p do
				a 'See me on GitHub', href: 'https://github.com/MatmaRex/unrev_users'
			end
		end
		def list
			p "Users with most unreviewed edits on #{@input['wiki']}.wiki:"
			ol do
				@list.each do |edits, username|
					li do
						a username, href: "http://#{@input['wiki']}.wikipedia.org/wiki/Special:Contributions/#{username}?limit=500"
						text " (#{edits} edits)"
					end
				end
			end
			p{a 'Back', href:'/'}
		end
	end
end
