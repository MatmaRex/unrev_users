# coding: utf-8

require 'sunflower'

def get_top_users wiki
	s = Sunflower.new wiki

	pageids = []
	orstart = '2000-01-01T00:00:00Z'
	while true
		res = s.API("action=query&list=oldreviewedpages&ornamespace=0&orlimit=500&orstart="+orstart)
		
		pageids += res['query']['oldreviewedpages'].map{|h| h['pageid']}
		
		if res['query-continue']
			orstart = res['query-continue']['oldreviewedpages']['orstart']
		else
			break
		end
	end

	users = []
	pageids.each_slice(500) do |pageids|
		unrev_pages = s.API("action=query&prop=revisions&rvprop=user&pageids="+pageids.join('|'))['query']['pages']
		users += unrev_pages.map{|k,v| v['revisions'][0]['user']}
	end

	by_edit_count = users.group_by{|a| a}.map{|k,v| [v.length, k]}.select{|n,u| n>1}.sort.reverse
	return by_edit_count
end
