ecdhServer = {}

ecdhServer.name = "ecdh.server"

ecdhServer.test = function()
	local socket = require("builtins.scripts.socket")
	local ssl = require("luasec.ssl")
	local config = require("tests.config")
	
	local params = {
	   mode = "server",
	   protocol = "any",
	   key = sys.load_resource(config.certs .. "serverAkey.pem"),
	   certificate = sys.load_resource(config.certs .. "serverA.pem"),
	   cafile = sys.load_resource(config.certs .. "rootA.pem"),
	   verify = {"peer", "fail_if_no_peer_cert"},
	   options = "all",
	   --
	   curve = "secp384r1",
	}
	
	------------------------------------------------------------------------------
	local ctx = assert(ssl.newcontext(params))
	
	local server = socket.tcp()
	server:setoption('reuseaddr', true)
	assert( server:bind("*", config.serverPort) )
	server:listen()
	
	local peer = server:accept()
	
	peer = assert( ssl.wrap(peer, ctx) )
	assert( peer:dohandshake() )
	
	print("--- INFO ---")
	local info = peer:info()
	for k, v in pairs(info) do
	  print(k, v)
	end
	print("---")
	
	peer:close()
	server:close()

	return true
end

return ecdhServer