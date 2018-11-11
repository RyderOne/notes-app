# ================================================================================
# If the first argument is one of the supported commands...
# ================================================================================
SUPPORTED_COMMANDS := npm-install serverless-invoke-local serverless-deploy-function react-install
SUPPORTS_MAKE_ARGS := $(findstring $(firstword $(MAKECMDGOALS)), $(SUPPORTED_COMMANDS))
ifneq "$(SUPPORTS_MAKE_ARGS)" ""
  # use the rest as arguments for the command
  COMMAND_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))

  # Escape ":" to allow easier symfony commands, e.g.: make console debug:autowiring
  COMMAND_ARGS := $(subst :,\:,$(COMMAND_ARGS))
  # ...and turn them into do-nothing targets
  $(eval $(COMMAND_ARGS):;@:)
endif


NPM_IMAGE_NAME = mkenney/npm:node-8-alpine

SERVERLESS_APP_NAME = notes-app-api
REACT_APP_NAME = notes-app-client

BASE_OPTIONS = --rm -e PUID=$(UID) -e PGID=$(GID) --volume $(shell pwd)/.cache:/home/dev/.npm --volume $(shell pwd)/.aws:/home/dev/.aws:ro

NPM_BASE_OPTIONS = $(BASE_OPTIONS) --volume $(shell pwd):/src
NPM_SERVERLESS_OPTIONS = $(BASE_OPTIONS) --volume $(shell pwd)/$(SERVERLESS_APP_NAME):/src
NPM_REACT_OPTIONS = $(BASE_OPTIONS) --volume $(shell pwd)/$(REACT_APP_NAME):/src

NPM_BASE_DOCKER_RUN = docker run -it $(NPM_BASE_OPTIONS) $(NPM_IMAGE_NAME)
NPM_SERVERLESS_DOCKER_RUN = docker run -it $(NPM_SERVERLESS_OPTIONS) $(NPM_IMAGE_NAME)
NPM_REACT_DOCKER_RUN = docker run -it $(NPM_REACT_OPTIONS) $(NPM_IMAGE_NAME)

bash:
	@$(NPM_BASE_DOCKER_RUN) sh

npm-version:
	@$(NPM_BASE_DOCKER_RUN) 'npm -v'
	@$(NPM_BASE_DOCKER_RUN) 'node -v'

serverless-init:
	@$(NPM_BASE_DOCKER_RUN) 'npx serverless install --url https://github.com/AnomalyInnovations/serverless-nodejs-starter --name $(SERVERLESS_APP_NAME)'

serverless-install:
	@$(NPM_SERVERLESS_DOCKER_RUN) 'npm install $(COMMAND_ARGS)'

serverless-invoke-local:
	@$(NPM_SERVERLESS_DOCKER_RUN) 'npx serverless invoke local $(COMMAND_ARGS)'

serverless-deploy:
	@$(NPM_SERVERLESS_DOCKER_RUN) 'npx serverless deploy'

serverless-deploy-function:
	@$(NPM_SERVERLESS_DOCKER_RUN) 'npx serverless deploy function -f $(COMMAND_ARGS)'

react-init:
	@$(NPM_BASE_DOCKER_RUN) 'npx create-react-app $(REACT_APP_NAME)'

react-start:
	@docker run -d -p 3000:3000 --name $(REACT_APP_NAME) $(NPM_REACT_OPTIONS) $(NPM_IMAGE_NAME) 'npm run-script start-js'

react-stop:
	@docker stop $(REACT_APP_NAME) || true
	@docker rm $(REACT_APP_NAME) || true

react-restart: react-stop react-start

react-install:
	@$(NPM_REACT_DOCKER_RUN) 'npm install $(COMMAND_ARGS)'

react-build:
	@$(NPM_REACT_DOCKER_RUN) 'npm run-script build-js'

react-deploy:
