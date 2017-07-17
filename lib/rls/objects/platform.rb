module RLS
  class Platform
    attr_reader :id, :name

    def initialize(data)
      @id = data['id']
      @name = data['name']
    end
  end

  Platform::Steam   = Platform.new({ 'id' => 1, 'name' => 'Steam' })
  Platform::Ps4     = Platform.new({ 'id' => 2, 'name' => 'Ps4' })
  Platform::XboxOne = Platform.new({ 'id' => 3, 'name' => 'XboxOne' })
end
