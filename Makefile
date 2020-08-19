default: www.build

help:
	@echo 'All:'
	@echo '  install			prep environment and build'
	@echo '  update				pull updates and rebuild'
	@echo ''
	@echo 'Nucleus stack:'
	@echo '  www.start			start www stack'
	@echo '  www.stop			stop www stack'
	@echo '  www.restart		restart www stack'
	@echo '  www.up				load www stack in current tty'
	@echo '  www.build			setup and build the stack'
	@echo '  www.rebuild		setup and rebuild the stack'
	@echo '  www.shell			load user www shell'
	@echo '  www.root.shell		load root www shell'
	@echo ''
	@echo 'Code server stack:'
	@echo '  code.start			start code stack'
	@echo '  code.stop			stop code stack'
	@echo '  code.restart		restart code stack'
	@echo '  code.up			load code stack in current tty'
	@echo '  code.build			setup and build the stack'
	@echo '  code.rebuild		setup and rebuild the stack'
	@echo '  code.shell			load standard coder shell'

vm.init:
	@bash scripts/vm/init-ubuntu

install: _setup
	@bash scripts/stack.init/create-certificates \
	&& bash scripts/stack.init/create-ssh

_setup:
	@bash scripts/stack.init/setup-directories


update: code.stop www.stop _pull www.rebuild code.rebuild

_pull:
	@git pull



www.start:
	@bash scripts/stack.control/ensure-up www

www.stop:
	@bash scripts/stack.control/ensure-down www

www.restart: www.stop www.start

www.up:
	@docker-compose -f stacks/www/docker-compose.yml up

www.build: www.stop _setup www._build www.start

www.rebuild: www.stop _setup www._rebuild www.start

www._build:
	@docker-compose -f stacks/www/docker-compose.yml build

www._rebuild:
	@docker-compose -f stacks/www/docker-compose.yml build --no-cache

www.shell: www.start
	@docker-compose -f stacks/www/docker-compose.yml exec --user=1000 php bash -l

www.root.shell: www.start
	@docker-compose -f stacks/www/docker-compose.yml exec php bash -l



code.start: _setup
	@bash scripts/stack.control/ensure-up code

code.stop:
	@bash scripts/stack.control/ensure-down code

code.restart: code.stop code.start

code.up:
	@docker-compose -f stacks/code/docker-compose.yml up

code.build: code.stop _setup code._build code.start

code.rebuild: code.stop _setup code._rebuild code.start

code._build:
	@docker-compose -f stacks/code/docker-compose.yml build

code._rebuild:
	@docker-compose -f stacks/code/docker-compose.yml build --no-cache

code.shell: code.start
	@docker-compose -f stacks/code/docker-compose.yml exec --user=coder code-server bash -l
