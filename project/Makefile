GCLOUD_PROJECT:=$(shell gcloud config list project --format="value(core.project)")

.PHONY: all
all: deploy

.PHONY: create-cluster
create-cluster:
	gcloud container clusters create PROJECT_LABEL \
		--scope "cloud-platform" \
		--num-nodes 2
	gcloud container clusters get-credentials PROJECT_LABEL

.PHONY: create-bucket
create-bucket:
	gsutil mb gs://$(GCLOUD_PROJECT)
	gsutil defacl set public-read gs://$(GCLOUD_PROJECT)

.PHONY: build
build:
	docker build -t gcr.io/$(GCLOUD_PROJECT)/PROJECT_LABEL .

.PHONY: push
push: build
	gcloud docker push gcr.io/$(GCLOUD_PROJECT)/PROJECT_LABEL

.PHONY: template
template:
	sed -i ".tmpl" "s/\[GCLOUD_PROJECT\]/$(GCLOUD_PROJECT)/g" gce-frontend.yaml
	sed -i ".tmpl" "s/\[GCLOUD_PROJECT\]/$(GCLOUD_PROJECT)/g" gce-worker.yaml

.PHONY: create-service
create-service:
	kubectl create -f gce-service.yaml

.PHONY: deploy-frontend
deploy-frontend: push template
	kubectl create -f gce-frontend.yaml

.PHONY: deploy-worker
deploy-worker: push template
	kubectl create -f gce-worker.yaml

.PHONY: deploy
deploy: deploy-frontend deploy-worker create-service

.PHONY: delete
delete:
	-kubectl delete -f gce-frontend.yaml
	-kubectl delete -f gce-worker.yaml
	-kubectl delete -f gce-frontend.yaml
