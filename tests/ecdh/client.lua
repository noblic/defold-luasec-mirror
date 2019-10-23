ecdhClient = {}

ecdhClient.name = "ecdh.client"

ecdhClient.test = function()
	local socket = require("builtins.scripts.socket")
	local ssl = require("luasec.ssl")
	local config = require("tests.config")
	
	local params = {
	   mode = "client",
	   protocol = "tlsv1_2",
	   key = sys.load_resource(config.certs .. "clientAkey.pem"),
	   certificate = sys.load_resource(config.certs .. "clientA.pem"),
	   cafile = sys.load_resource(config.certs .. "rootA.pem"),
	   verify = {"peer", "fail_if_no_peer_cert"},
	   options = "all",
	   --
	   curve = "secp384r1",
	}
	
	--------------------------------------------------------------------------------
	local peer = socket.tcp()
	peer:connect(config.serverIP, config.serverPort)
	
	peer = assert( ssl.wrap(peer, params) )
	assert(peer:dohandshake())
	
	print("--- INFO  ---")
	local info = peer:info()
	for k, v in pairs(info) do
	  print(k, v)
	end
	print("---")
	
	peer:close()

	return true
end

return ecdhClient