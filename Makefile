build:
	ansible-playbook playbooks/build.yml

run: build
	ansible-playbook playbooks/run.yml

cleanup:
	ansible-playbook playbooks/stop.yml

test:
	pytest tests/isRunning.py