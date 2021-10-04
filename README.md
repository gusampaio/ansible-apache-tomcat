# Sample Apache Tomcat Application 

This project runs a containerized Apache Tomcat Sample application with the `tomcat:9-alpine` docker image, serving on the endpoint `http://locahost:8080/sample`.


## How it works

With Ansible's help, this project intend to [download](#download), [build](#build), [test](#test), 
[run](#run) and [cleanup](#cleanup) a docker Tomcat Sample Application.

## Usage
```
# Download Sample App and Build docker image
$ make build

# Build, Test and Run container containing the sample App 
$ make run

# Test if app is running under the specified port and path
$ make test

# Cleanup downloaded war file and stopping docker container
$ make cleanup
```
### Steps

#### Download

A sample war file is downloaded from `https://tomcat.apache.org/tomcat-9.0-doc/appdev/sample/sample.war` and stored in `src/` folder. That is the first task of the [build.yml](playbooks/build.yml) playbook:

```yaml
- name: Download Tomcat Sample Application
    get_url:
        url: https://tomcat.apache.org/tomcat-9.0-doc/appdev/sample/sample.war
        dest: ../src/sample.war
        mode: '0440'
```

#### Build

Once the war file  is downloaded, a task to build the docker container is executed. In this phase, Ansible is configured to build a Docker image, using the parameters defined in the [build.yml](playbooks/build.yml) playbook. This image is created based on the Dockerfile present in the root folder of the project, as per defined in the `source:build` option:

```yaml
- name: Build container image
    docker_image:
        name: "{{ docker_image }}"
        tag: "{{ tag }}"
        source: build
        build:
            path: ../
        state: present
```

#### Run

After building and creating the container image, the [run.yml](playbooks/run.yml) is invoked when running `$ make run`. At this phase the container image created in the previous step will be started, if not already running, on port `8080`:

```yaml
- name: Staring Sample App container 
    docker_container:
        name: sample-app
        image: "{{ docker_image }}"
        state: started
        published_ports: "{{ host_port }}:{{ container_port }}"
        restart: yes
```

#### Tests 

Steps included in the [run.yml](playbooks/run.yml). After running the container, check if the port 8080 is available:

```yaml
- name: Wait for port 8080 to become open on the host
    wait_for:
        port: "{{ host_port }}"
        timeout: 60
```

If port is available, test with `pytest` if page `http://localhost:8080/sample` return code `200`.

```yaml
- name: Test docker container
    shell: pytest ../tests/isRunning.py
```

[tests/isRunning.py](tests/isRunning.py):
```python
def test_page_response():
    test_url = "http://localhost:8080/sample"
    response = get_page(test_url)
    assert response.status_code == 200

def get_page(search_url):
    page = requests.get(search_url)
    return page

```

#### Cleanup

Playbook [stop.yml](#playbooks/stop.yml) to delete downloaded war file and stop container.

```yaml
- name: Stoppping Sample App container 
    docker_container:
        name: sample-app
        image: "{{ docker_image }}"
        state: absent
    
- name: "Cleaning src folder"
    shell: rm -f ../src/sample.war
```

## Requirements

- Docker
- Python3 
- Pytest
- Ansible (supporting Python 3 only) 
- Port 8080 is available