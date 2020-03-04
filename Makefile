default: sys.start www.build

help:
	@echo 'All:'
	@echo '  install			prep verts and build'
	@echo '  shell				ensure startup and load shell'
	@echo '  all.start			ensure everything is up'
	@echo '  all.stop			ensure everything is down'
	@echo '  all.build			build everything relevant'
	@echo ''
	@echo 'Nucleus stack:'
	@echo '  www.start			ensure all started'
	@echo '  www.stop			ensure all stopped'
	@echo '  www.restart		stop then restart'
	@echo '  www.build			setup and build the stack'
	@echo '  www.rebuild		setup and rebuild the stack'
	@echo ''
	@echo 'System stack:'
	@echo '  sys.start			start system stack'
	@echo '  sys.stop			stop system stack'
	@echo '  sys.restart		restart system stack'
	@echo ''
	@echo 'Code server stack:'
	@echo '  code.start			start code stack'
	@echo '  code.stop			stop code stack'
	@echo '  code.restart		restart code stack'


install: _setup
	@bash scripts/create-certificates \
	&& bash scripts/create-ssh

shell: www.start
	@docker-compose -f stacks/www/docker-compose.yml exec --user=nucleus php bash -l


all.start: sys.start www.start code.start

all.stop: code.stop www.stop sys.stop

all.build: www.build

_setup:
	@bash scripts/setup


www.start:
	@bash scripts/ensure-up www

www.stop:
	@bash scripts/ensure-down www

www.restart: www.stop www.start

www.up:
	@docker-compose -f stacks/www/docker-compose.yml up

www.build: www.stop _setup www._build www.start

www.rebuild: www.stop _setup www._rebuild www.start

www._build:
	@docker-compose -f stacks/www/docker-compose.yml build

www._rebuild:
	@docker-compose -f stacks/www/docker-compose.yml build --no-cache



sys.start: _setup
	@bash scripts/ensure-up system

sys.stop:
	@bash scripts/ensure-down system

sys.restart: sys.stop sys.start



code.start: _setup
	@bash scripts/ensure-up code

code.stop:
	@bash scripts/ensure-down code

code.restart: code.stop code.start
