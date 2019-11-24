@include "config.awk"

function randint(n) {
	return int(n * rand())
}

function parse_upstreams(_upstreams) {
	_idx = 0
	for (_oidx in cfg_upstreams) {
		split(cfg_upstreams[_oidx], _record, ":")
		_upstreams[_idx]["host"] = _record[1]
		_upstreams[_idx]["port"] = _record[2]
		_idx += 1
	}
}

function random_upstream(_upstreams) {
	_idx = randint(length(_upstreams))
	_upstream = ("/inet/tcp/0/" _upstreams[_idx]["host"] "/" _upstreams[_idx]["port"])
	printf "[upstream " _upstreams[_idx]["host"] ":" _upstreams[_idx]["port"] "] "
	return _upstream
}

BEGIN {
	srand(systime())

	# set record separators
	RS = ORS = "\r\n"

	parse_upstreams(upstreams)
	print "loaded " length(upstreams) " upstreams"

	print "listening on port " server_port
	service = ("/inet/tcp/" server_port "/0/0")

	while ("run" == "run") {
		b = (service |& getline line)
		if (b <= 0) {
			# errored, just terminate
			close(service)
			continue
		}

		upstream = random_upstream(upstreams)
		print line
		print line |& upstream

		# set low read timeout + retry to allow multiplexing each direction
		PROCINFO[service, "READ_TIMEOUT"] = 10
		PROCINFO[upstream, "READ_TIMEOUT"] = 10
		PROCINFO[service, "RETRY"] = 1
		PROCINFO[upstream, "RETRY"] = 1

		timeout = 10
		while (timeout > 0) {
			active = 0

			rc = (service |& getline line)
			if (rc > 0) {
				print line |& upstream
				active += 1
			}

			rc = (upstream |& getline line)
			if (rc > 0) {
				print line |& service
				active += 1
			}

			if (active == 0) {
				timeout -= 1
			}
		}

		close(upstream)
		close(service)

		PROCINFO[service, "READ_TIMEOUT"] = 1000
	}
}
