build:
	~/Library/Python/3.9/bin/ansible-playbook playbooks/build.yml

run: build
	~/Library/Python/3.9/bin/ansible-playbook playbooks/run.yml

cleanup:
	~/Library/Python/3.9/bin/ansible-playbook playbooks/stop.yml

test:
	pytest tests/isRunning.py