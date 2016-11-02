class FilesController < ApplicationController

	def show
	end

	def normalize
		file = params[:audio_file]
		filename = file.original_filename
		tempfile = file.tempfile
		tempfile_path = tempfile.path
		normalized_wav = nil

		RubyAudio::Sound.open(tempfile, 'r') do |snd|
		  sample_rate = snd.info.samplerate
		  length = snd.info.length
		  sample_count = (sample_rate * length).to_i
		  points = snd.read(:float, sample_count)
		  normalized_wav = create_normalized_wav(snd, points, filename)
		  File.delete(tempfile)
		  # File.delete(normalized_wav)
		end

		send_file(normalized_wav)
	end

	def append_normalized_to_filename(filename)
		array = filename.split('.')
		extension = array.pop
		"#{array.join('.')}_NRMLZD.#{extension}"
	end

	def create_normalized_wav(snd, points, tmpfilename)
		normalized_filename = append_normalized_to_filename(tmpfilename)
		normalized_path = tmp_file_path(normalized_filename)
	  new_file = RubyAudio::Sound.open(normalized_path, 'w', snd.info.clone)
	  points = normalize_array_buffer(points)
	  new_file.write(points)
	  new_file.close
	  normalized_path
	end

	def normalize_array_buffer(points)
	  absmax = find_absmax(points)
	  points.each_with_index do |point, index|
	    if point.is_a?(Array)
	    	new_point = [point.first/absmax, point.last/absmax]
	      points[index] = [point.first/absmax, point.last/absmax]
	    else
	      points[index] = point/absmax
	    end
	  end
	  points
	end

	def find_absmax(array_buffer)
		min = 0
		max = 0
		array_buffer.each do |sample|
			if sample.is_a?(Array)
				sample.each do |point|
					min = point if point < min
					min = point if point < min
				end
			else
				min = sample if sample < min
				max = sample if sample > min
			end
		end
	  max.abs > min.abs ? max.abs : min.abs
	end

	def tmp_file_path(filename)
	  Rails.root.join('tmp', filename).to_s
	end


end
