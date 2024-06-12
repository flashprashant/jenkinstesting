pipeline {
    agent {
        kubernetes {
            yaml '''
                apiVersion: v1
                kind: Pod
                spec:
                    containers:
                      - name: build
                        image: registry.digitalocean.com/mhs/jenkins-build-env:latest
                        command:
                          - cat
                        tty: true
                        volumeMounts:
                          - name: docker-sock
                            mountPath: /var/run/docker.sock
                    volumes:
                      - name: docker-sock
                        hostPath:
                            path: "/var/run/docker.sock"
                '''
        }
    }
    stages {
        stage ('Test') {
            steps {
                container('build') {
                    sh "ls -l"
                    sh "pwd"
                    sh "docker compose build --no-cache build"
                    sh "docker compose run --entrypoint=/usr/local/bin/composer build install"
                    sh "docker compose run --entrypoint=/usr/local/bin/composer build test"
                }
            }
        }
    }
    post {
        always {
            deleteDir()
        }
    }
}
