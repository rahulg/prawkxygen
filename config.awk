BEGIN {
	server_port = 7000

	cfg_upstreams[0] = "127.0.0.1:8000"
	cfg_upstreams[1] = "127.0.0.1:8001"
	cfg_upstreams[2] = "127.0.0.1:8002"
	cfg_upstreams[3] = "127.0.0.1:8003"
}
