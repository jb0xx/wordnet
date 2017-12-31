class WordNet
  def initialize(syns,hype)
		f1 = File.open(syns, "r")
		f2 = File.open(hype, "r")

		@num_nouns = 0 									#number of nouns
		@num_edges = 0 									#number of edges
		@nouns = Array.new								#list of nouns in all synsets
		@num_syns = 0  									#number of synsets
		@synsets = Array.new					  		#Array of synsets and their nouns
		@graph = Array.new								#Array representing hypernym graph
		invalid_s = Array.new							#keeps track of invalid lines in synsets input
		invalid_h = Array.new							#keeps track of invalid lines in hypernyms input


		#read in synsets
		f1.each_line do |line|
			line.chomp!
			if line =~ /^id: (\d)+ synset: [^,\s]+(,[^,\s]+)*$/ then
				@num_syns += 1
				s_line = line.split(/\s/)				#an array of the line delimited by spaces
				id = s_line[1]							#the id number of the synset
				sset = s_line[3].split(",")				#an array of all the words in the synset
				
				@synsets[id.to_i] = Array.new
				sset.each do |noun|
					@num_nouns += 1
					@nouns.push(noun)
					@synsets[id.to_i].push(noun)
				end
			else	
				invalid_s.push(line)	
			end	
		end
		
		#Check if the file has strictly valid inputs
		unless invalid_s.size == 0 then
			puts "invalid synsets"
			invalid_s.each do |err_line|
				puts err_line
			end
			exit
		end

		#read in hypernym relations
		f2.each_line do |line|
			line.chomp!
			if line =~ /^from: (\d)+ to: \d+(,\d+)*$/ then
				h_line = line.split(/\s/)				#an array of the line delimited by spaces
				hyponym = h_line[1].to_i				#the id number of the hyponym synset
				hypernyms = h_line[3].split(",")		#an array of all the hypernyms
				
				if @graph[hyponym] == nil then
					@graph[hyponym] = Array.new
				end
				hypernyms.each do |hype|
					@num_edges += 1
					@graph[hyponym].push(hype)
				end
			else
				invalid_h.push(line)
			end
		end

		#Check if the file has strictly valid inputs
		unless invalid_h.size == 0 then
			puts "invalid hypernyms"
			invalid_h.each do |err_line|
				puts err_line
			end
			exit
		end

		f1.close
		f2.close
	end


	#takes a input file containing a list of words return true only if all nouns
	#in the given list exist within our synsets
	def isnoun(noun_list)
		all_true = true
		noun_list.each do |line|
			unless @nouns.include?(line) then
				all_true = false
			end
		end
		all_true
	end


	#Returns the number of nouns
	def nouns
		@num_nouns
	end


	#Returns the number of edges
	def edges
		@num_edges
	end


	#takes noun as input and returns an array of its respective ids
	def find(noun)
		indices = []
		@synsets.each_with_index do |set, i|
			set.each do |n|
				if noun == n then
					indices.push(i)
				end
			end
		end
		indices
	end


	#returns the synset array associated with the given index (returns nil if not there)
	def syns(id)
		@synsets[id.to_i]
	end


	#returns a hash of all ancestors of the given ID with the keys being the distance between
	def ancestors(id)
		id = id.to_i
		unless syns(id) == nil then
			dist = 0 									#current distance away from the original synset
			next_layer = Array.new						#queue of the next synsets to be stored
			curr_layer = Array.new						#queue of the being synsets being
			anc =	Hash.new							#array of ancestors to be stored
			anc["#{id}"] = 0 							#store self first
			#push the first layer of neighbors into the queue
			if @graph[id] != nil then
				@graph[id].each do |elem|
					curr_layer.push(elem)
				end
			end
			#test each in queue while adding all children to new queue
			while curr_layer.size > 0 do
				dist += 1
				curr_layer.each do |s|
					if anc[s] == nil then
						anc[s] = dist
						if @graph[s.to_i] != nil then
							next_layer += @graph[s.to_i]
						end
					end
				end
				curr_layer = next_layer
				next_layer = Array.new
			end
		else
			anc = -1
		end
		anc
	end


	#returns the length between two individual synsets
	def length_helper(x,y)
		anc_x = ancestors(x)							#hash of the ancestors of x
		anc_y = ancestors(y)							#hash of the ancestors of y
		unless anc_x == -1 || anc_y == -1 then 
			len = @num_syns								#theoretical longest possible length
			common = anc_x.keys & anc_y.keys
			if common.size != 0 then
				common.each do |id|
					curr_len = anc_x[id] + anc_y[id]
					len = [len, curr_len].min
				end
			else
				len = -1
			end
		else
			len = -1
		end
		len
	end

	
	#returns the shortest length between all IDs in v vs all IDs in w
	def length(v,w)
		len = @num_syns
		v.each do |x|
			w.each do |y|
				curr_len = length_helper(x,y)
				if curr_len != -1 then
					len = [len, curr_len].min
				end
			end
		end
		if len == @num_syns then
			len = -1
		end
		len
	end


	#returns the lowest common root ancestor of the SAP between each IDs of v and w 
	def ancestor(v,w)
		min_len = length(v,w)								#length of the SAP
		ans = Array.new
		unless min_len == -1 then
			v.each do |x|
				w.each do |y|
					anc_x = ancestors(x)					#hash of the ancestors of x
					anc_y = ancestors(y)					#hash of the ancestors of y
					unless anc_x == -1 || anc_y == -1 then 
						common = anc_x.keys & anc_y.keys 	#array of the common ancestors of x and y
						if common.size != 0 then
							common.each do |id|
								len = anc_x[id] + anc_y[id]
								if len == min_len then
									ans.push(id)
								end
							end
						end
					end
				end
			end
			ans.uniq.sort.join(" ")
		else
			-1
		end
	end


	#find the nouns associated with the LCA of the SAPs of the input nouns
	def root(v,w)
		ids_v = find(v)
		ids_w = find(w)
		ans = []
		if ancestor(ids_v,ids_w) != -1 then
			anc = ancestor(ids_v,ids_w).split(" ")
			anc.each do |x|
				ans.concat syns(x)
			end
			ans.sort.join(" ")
		else
			-1
		end
	end


	#takes in a list of nouns and returns the outcast(s) within the group
	def outcast(n_list)
		max_dist = 0 									#max distance between 
		id_arr = Array.new								#an array of the ids of the n_list
		outcasts = Array.new							#array of outcasts to be returned
		index = 0 										#keeps track of the index of the current elements being examined
		n_list.each do |n|								#push ids to array
			id_arr.push(find(n))	
		end
		id_arr.each do |ids1|
			dist = 0
			id_arr.each do |ids2|
				if ids1 != ids2 then
					len = length(ids1,ids2)
					dist += len*len
				end
			end
			if dist > max_dist then 
				max_dist = dist							#find the maximum distance
				outcasts = [n_list[index]]
			elsif dist == max_dist then
				outcasts.push(n_list[index])
			end
			index += 1
		end
		outcasts.sort.join(" ")
	end
end


if ARGV.length < 3 || ARGV.length > 5
  fail "usage: wordnet.rb <synsets file> <hypersets file> <command> <filename>"
end

synsets_file = ARGV[0]
hypernyms_file = ARGV[1]
command = ARGV[2]
fileName = ARGV[3]

#Refers to number of input lines in file
commands_with_0_input = %w(edges nouns)
commands_with_1_input = %w(outcast isnoun)
commands_with_2_input = %w(length ancestor)

case command
when "root"
	file = File.open(fileName)
	v = file.gets.strip
	w = file.gets.strip
	file.close
    wordnet = WordNet.new(synsets_file, hypernyms_file)   
    puts wordnet.send(command,v,w)
when *commands_with_2_input 
	file = File.open(fileName)
	v = file.gets.split(/\s/).map(&:to_i)
	w = file.gets.split(/\s/).map(&:to_i)
	file.close
    wordnet = WordNet.new(synsets_file, hypernyms_file)
    puts wordnet.send(command,v,w)  
when *commands_with_1_input 
	file = File.open(fileName)
	nouns = file.gets.split(/\s/)
	file.close
    wordnet = WordNet.new(synsets_file, hypernyms_file)
    puts wordnet.send(command,nouns)
when *commands_with_0_input
	wordnet = WordNet.new(synsets_file, hypernyms_file)
	puts wordnet.send(command)
else
  fail "Invalid command"
end

