require File.expand_path('../../lib/sle2docker',__FILE__)
require 'minitest/autorun'
require 'stringio'
require 'fakefs/safe'

class Object
  def capture(stream)
    begin
      stream = stream.to_s
      eval "$#{stream} = StringIO.new"
      yield
      result = eval("$#{stream}").string
    ensure
      eval("$#{stream} = #{stream.upcase}")
    end
    result
  end
end

class MiniTest::Test

  def read_fixture(name)
    File.read(File.expand_path("../fixtures/#{name}", __FILE__))
  end

end

class FakeStdin

  # @param [Array[String]] fake_input
  def initialize(fake_input)
    @fake_input = fake_input.reverse
  end

  def gets()
    @fake_input.pop
  end

  def noecho()
    yield(self)
  end

end

