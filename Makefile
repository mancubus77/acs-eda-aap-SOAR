.PHONY: run exploit



run-playbook:
	@. ./.venv/bin/activate
	ansible-playbook -i ansible-automation/hosts ansible-automation/pb.remediate.yaml -e "@ansible-automation/extravars.yaml" -v

run-eda:
	@. ./.venv/bin/activate
	ansible-rulebook -i ansible-automation/hosts \
	--rulebook ansible-automation/rb.main.yaml

trigger-eda:
	curl -H 'Content-Type: application/json' \
	-d '@test/trigger.json' 127.0.0.1:5000

buile-ee:
	ansible-builder build -c ./execution_environment -f ./execution_environment/execution-environment.yml -t quay.io/mancubus77/ansible-ee/ee:24

undo-jails:
	oc patch deployment cve-2017-5638 -n rhacs-operator --type='json' -p='[{"op": "remove", "path": "/spec/template/spec/runtimeClassName"}]'

exploit:
	python exploit/exploit.py http://cve-2017-5638-rhacs-operator.apps.sno-3-25.lab.apac-telco.net/ 'whoami'