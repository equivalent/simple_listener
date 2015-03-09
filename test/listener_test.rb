require "minitest/autorun"
require 'simple_listener'

class Book
  include SimpleListener

  attr_accessor :author,:persisted

  def save
    call_listeners(:before_create)
    call_listeners(:before_update) # just to demonstrate Rails save
    self.persisted = true
    call_listeners(:after_create)  # just to demonstrate Rails save
    call_listeners(:after_update)  # just to demonstrate Rails save
  end
end

class AssignAuthorListener
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def before_create(book)
    book.author = user
  end
end

describe Book do
  before do
    @book = Book.new
  end

  describe "when called without listeners" do
    it "must not set any values" do
      @book.save
      @book.author.must_be_nil
    end
  end

  describe "when called with listener" do
    before do
      @current_user = Object.new
      @book.add_listener(AssignAuthorListener.new(@current_user))
    end

    it 'must set attributes related to that listener' do
      @book.save
      @book.author.must_equal @current_user
    end
  end
end
