digestClient = {}

digestClient.name = "digest.client"

digestClient.test = function()
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
	}
	
	local peer = socket.tcp()
	peer:connect(config.serverIP, config.serverPort)
	
	-- [[ SSL wrapper
	peer = assert( ssl.wrap(peer, params) )
	assert(peer:dohandshake())
	--]]
	
	print(peer:receive("*l"))
	peer:close()

	return true
end

return digestClient