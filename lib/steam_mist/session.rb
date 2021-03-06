# We're placing these here so that if someone wants to only use this part of
# the library, they don't have to require the entire thing.
require 'oj'
require 'uri'
require 'forwardable'
require 'steam_mist/version'
require 'steam_mist/connector'
require 'steam_mist/connectors'
require 'steam_mist/request_uri'
require 'steam_mist/pseudo_interface'
require 'steam_mist/schema'

module SteamMist

  # The session is used as a starting point for connecting to the Steam API.
  class Session

    # The connector that the session is going to use.
    #
    # @return [Class] the connector.
    attr_accessor :connector

    # The default arguments that the session will use.
    #
    # @return [Hash]
    attr_accessor :default_arguments

    # Initialize.
    #
    # @param connector [Class] the connector (should be subclass of {Connector}).
    def initialize(connector = Connectors::LazyConnector)
      @connector   = connector
      @_interfaces = {}
      @default_arguments = {}
    end

    # Grabs an interface for use.  These are cached, so every call with the
    # same argument returns the same object.
    #
    # @param interface [Symbol] the interface name.
    # @return [PseudoInterface]
    def get_interface(interface)
      @_interfaces[interface] ||= PseudoInterface.new(self, interface)
    end

    # Some {#method_missing} magic.  Sorry @charliesome!
    #
    # @see {#get_interface}
    def method_missing(method, *args)
      super if args.length > 0 or block_given?
      get_interface method
    end

    # pretty inspection
    def inspect
      "#<SteamMist::Session #{connector.inspect}>"
    end

  end
end
