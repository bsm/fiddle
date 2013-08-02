class Fiddle::Universe < ActiveRecord::Base
  ConnectionError = Class.new(StandardError)

  cattr_accessor :schemes
  self.schemes = ['sqlite', 'postgres', 'mysql2', 'do:sqlite', 'do:postgres', 'do:mysql']

  class_attribute :stored_connections
  self.stored_connections = {}

  # ---> ASSOCIATIONS
  has_many :cubes, :dependent => :destroy
  has_many :lookups, :dependent => :destroy

  # ---> VALIDATIONS
  validates :name, :presence => true, :length => { :maximum => 40 }, :uniqueness => { :case_sensitive => false, :allow_blank => true }
  validates :uri, :presence => true, :length => { :maximum => 255 }, :format => { :with => URI.regexp(schemes), :allow_blank => true }
  validate  :ensure_connectable

  # ---> CALLBACKS
  before_save    :remove_stored_connection
  before_destroy :remove_stored_connection

  def conn(reconnect = false)
    remove_stored_connection if reconnect
    stored_connections[id] ||= establish_connection
  end

  def establish_connection
    return unless valid_uri?
    Sequel.connect(uri).tap(&:tables)
  rescue Sequel::AdapterNotFound
    raise ConnectionError.new("No such adapter '#{adapter}'")
  rescue Sequel::DatabaseConnectionError => e
    raise ConnectionError.new(e.message)
  end

  def adapter
    uri.to_s.match(/\A#{Regexp.union(*schemes)}/).try(:[], 0)
  end

  def valid_uri?
    uri.to_s =~ URI.regexp(schemes)
  end

  private

    def remove_stored_connection
      return unless persisted?

      stored_connections[id].try(:disconnect)
      stored_connections.delete(id)
    end

    def ensure_connectable
      return if uri.blank?
      begin
        establish_connection
      rescue ConnectionError => e
        errors.add :uri, :not_connected, :reason => e.message
      end
    end

end
