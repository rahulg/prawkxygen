# prAWKxygen: a really bad load balancer

Why would you use this? I don't know. Why would you?


## Instructions

- Make sure you have GNU `awk` installed.
- Edit `config.awk` to set your local port and upstreams.
- Run `gawk -f main.awk` and marvel at the insanity.

## FAQ

- **What is this?**
	- It's a load balancer written in `awk` (the GNU flavour, so I guess `gawk`). It was supposed to be a HTTP load balancer, but for now it's a TCP load balancer.
- **What sort of functionality does it have?**
	- Very little. It can handle a grand total of one connection in parallel. Deal with it. It also has no support for rules. Yet. Maybe this will be fixed.
- **What is performance like?**
	- Poor.
- **Is this a joke?**
	- You tell me.
- **Why would you do this?**
	- Why do you still write code in Java?
