pipeline {
 
    agent any
     
    environment {
        JAVA_TOOL_OPTIONS = "-Duser.home=/home/jenkins"
        ArtifactId = readMavenPom().getArtifactId()
        Version = readMavenPom().getVersion()
        Name = readMavenPom().getName()
        GroupId = readMavenPom().getGroupId()
        registry = "gnishanth444/petclinic"
        registryCredential = 'dockerhub-creds'

    }
    options {
        buildDiscarder(logRotator(numToKeepStr: '10', artifactNumToKeepStr: '10'))
  
    }
   
    stages {
        // Stage 1 build the project using maven 
        stage("Build Project") {
            agent {
              docker {
                   image "maven:3.6.0-jdk-8"
                   args "-v /tmp:/home/jenkins/.m2 -e MAVEN_CONFIG=/home/jenkins/.m2 -u root"
                   reuseNode true
            }
        } 
            steps {               
                sh "mvn -version"
                sh "mvn clean install package"
            }
        }
        // Stage 2 Test the project
        stage("Unit Test"){
       
            steps{
               echo "Testing"
            }
        }
        // Stage 3 Run Sonar Analasys
        stage("Code Quality Test") { 
             agent { 
                  docker {
                    image "maven:3.6.0-jdk-8"
                    args "-v /tmp:/home/jenkins/.m2 -e MAVEN_CONFIG=/home/jenkins/.m2 -u root"
                    reuseNode true  
                   }
             }
             
            steps {
             echo ' Source code published to Sonarqube for SCA......'
                withSonarQubeEnv('sonarqube'){ // You can override the credential to be used
                     sh 'mvn sonar:sonar'
                }   
            }
        }
        // Stage 4 : Print some information
        stage ("Print Env variables of Maven"){
                   steps {
                        echo "Artifact ID is '${ArtifactId}'"
                        echo "Version is '${Version}'"
                        echo "GroupID is '${GroupId}'"
                        echo "Name is '${Name}'"
                    }
                }
        // Stage 5 Push the Artifact to Nexus Repo
        stage("Publish Artifact"){
            steps{
                script {

                def NexusRepo = Version.endsWith("SNAPSHOT") ? "petclinic-SNAPSHOT" : "petclinic-RELEASE"
                nexusArtifactUploader artifacts: 
                [[artifactId: "${ArtifactId}", 
                classifier: '', 
             // file: "target/${ArtifactId}-${Version}.war",
                file: "target/petclinic.war" ,  
                type: 'war']], 
                credentialsId: 'Nexus_Artifact', 
                groupId: "${GroupId}", 
                nexusUrl: '172.31.27.33:8081', 
                nexusVersion: 'nexus3', 
                protocol: 'http', 
                repository: "${NexusRepo}", 
                version: "${Version}"
             }
            
            }         
        }
        // Stage 6 Build the Docker Image with tomcat
            stage("Build Image"){
                steps{
                    script {
                        dockerImage = docker.build registry + ":${Version}"
                     }
                }
            }
        //Stage 7 Push Image to Repository
         stage("Push Image") { 
            steps{
              script {
                  withDockerRegistry([ credentialsId: registryCredential,url: ""] ) {
                      sh 'docker push gnishanth444/petclinic":${Version}"'                    
                   }
                }
              }
            }       
        }
      post {
        always {
            echo 'This will always run'
        }
        success {
            echo 'This will run only if successful'
        }
        failure {
            echo 'This will run only if failed'
        }
        unstable {
            echo 'This will run only if the run was marked as unstable'
        }
        changed {
            echo 'This will run only if the state of the Pipeline has changed'
            echo 'For example, if the Pipeline was previously failing but is now successful'
        }
    }
}
