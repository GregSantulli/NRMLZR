require 'sox'
class FilesController < ApplicationController

	before_action :ensure_file_existence, :ensure_wav_or_mp3, :create_sox_audo, only: [:normalize]
	after_action :delete_tempfiles, only: [:normalize]

	def show
	end

	def normalize
		begin 
			@audio.normalize
			safe_send_data(@audio)
		rescue => e
			flash[:error] = "Normalization Error: " + e.message
			redirect_to root_path
		end
	end

	def safe_send_data(audio)
		File.open(audio.normalized_file_path, 'r') do |f|
		  send_data(f.read, type: audio.content_type, filename: audio.normalized_filename)
		end
	end

	def ensure_file_existence
		if params[:audio_file]
			@file = params[:audio_file]
		else
			flash[:error] = "Please select a file"
			redirect_to root_path and return
		end
	end

	def ensure_wav_or_mp3
		if !["audio/mp3", "audio/wav"].include? @file.content_type
			flash[:error] = "File type not supported"
			redirect_to root_path
		end
	end

	def create_sox_audo
		begin 
			@audio = Sox::Audio.new(@file)
		rescue => e
			flash[:error] = "Sox Audio Error: " + e.message
			redirect_to root_path
		end
	end

	def delete_tempfiles
		@audio.delete_tempfiles
	end

end
