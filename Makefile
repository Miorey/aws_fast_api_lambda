TF_EXEC?=terraform


run:
	cd app && uvicorn main:app --reload

init:
	cd infrastructure && $(TF_EXEC) init

clean_init:
	cd infrastructure && rm -rf .terraform*
	cd infrastructure && rm -rf terraform.tfstate*


create-archive:
	rm -rf tmp dist
	mkdir -p tmp dist
	cp -rf ./app/*  ./tmp/
	pip3.8 install -r ./requirements.txt --target ./tmp
	cd tmp && zip -r ../dist/my-fast-api.zip .
	rm -rf tmp

deploy: create-archive
	cd infrastructure && $(TF_EXEC) apply

destroy:
	cd infrastructure && $(TF_EXEC) apply -destroy
