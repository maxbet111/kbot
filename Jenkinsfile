pipeline {
    agent any

    parameters {
        choice(name: 'OS', choices: ['linux', 'windows', 'darwin'], description: 'Target OS for build')
        choice(name: 'ARCH', choices: ['amd64', 'arm64'], description: 'Target architecture')
    }

    environment {
        APP_NAME = "kbot"
        RELEASES_DIR = "build/releases"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                script {
                    // Використовуємо інструмент Go, який ми налаштували раніше
                    def goTool = tool 'go-1.22'
                    withEnv(["PATH+GO=${goTool}/bin"]) {
                        def outputName = "${env.APP_NAME}-${params.OS}-${params.ARCH}"
                        if (params.OS == 'windows') { outputName += ".exe" }
                        
                        echo "Building for ${params.OS}/${params.ARCH}..."
                        sh "GOOS=${params.OS} GOARCH=${params.ARCH} go build -v -o ${outputName}"
                    }
                }
            }
        }

        stage('Artifacts') {
            steps {
                archiveArtifacts artifacts: 'kbot-*', fingerprint: true
            }
        }
    }
}
