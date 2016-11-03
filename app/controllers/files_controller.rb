class FilesController < ApplicationController

	before_action :ensure_wav_or_mp3, only: [:normalize]
	after_action :delete_tempfiles, only: [:normalize]

	def show
	end

	def normalize
		file = params[:audio_file]
		filename = file.original_filename
		tempfile = file.tempfile
		tempfile_path = tempfile.path
		normalized_filename = append_normalized_to_filename(filename)
		normalized_file_path = tmp_file_path(normalized_filename)

		unless system "sox --norm #{tempfile_path} #{normalized_file_path.shellescape}"
			flash[:error] = "SoX error"
			redirect_to root_path and return
		end

		begin
			File.open(normalized_file_path, 'r') do |f|
			  send_data f.read, type: file.content_type, filename: normalized_filename
			end
			delete_tempfiles
		rescue => e
			flash[:error] = e.message
			redirect_to root_path
		end

	end

	def ensure_wav_or_mp3
		if !["audio/mp3", "audio/wav"].include? params[:audio_file].content_type
			flash[:error] = "Filetype not supported"
			redirect_to root_path
		end
	end

	def delete_tempfiles
		Dir.foreach(tmp_file_path()) do |file| 
			if ["mp3", "wav"].include? file[-3..-1]
				File.delete(tmp_file_path(file))
			end
		end
	end

	def append_normalized_to_filename(filename)
		array = filename.split('.')
		extension = array.pop
		"#{array.join('.')}_NRMLZD.#{extension}"
	end

	def tmp_file_path(filename = "")
	  Rails.root.join('tmp', filename).to_s
	end


end
