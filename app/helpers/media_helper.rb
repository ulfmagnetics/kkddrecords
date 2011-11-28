module MediaHelper
  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods
    def valid_audio_formats
      valid_audio_mappings.keys
    end

    def valid_audio_mime_types
      valid_audio_mappings.values.flatten
    end

    private

    def valid_audio_mappings
      { 'mp3'       => ['audio/mp3', 'audio/mpeg3', 'audio/x-mpeg-3'],
        'aiff'      => ['audio/aiff', 'audio/x-aiff'],
        'wav'       => ['audio/wav', 'audio/x-wav'],
        'flac'      => ['audio/flac']
      }
    end
  end
end