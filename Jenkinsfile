pipeline {
 
    agent any
     
    environment {
        JAVA_TOOL_OPTIONS = "-Duser.home=/home/jenkins"
        ArtifactId = readMavenPom().getArtifactId()
        Version = readMavenPom().getVersion()
        Name = readMavenPom().getfinalName()
        GroupId = readMavenPom().getGroupId()
        registry = "gnishanth444/petclinic"
        registryCredential = 'dockerhub-creds'

    }
    options {
        buildDiscarder(logRotator(numToKeepStr: '10', artifactNumToKeepStr: '10'))
  
    }
   
    stages {
        
        // Stage 4 : Print some information
        stage ("Print Env variables of Maven"){
                   steps {
                        echo "Artifact ID is '${ArtifactId}'"
                        echo "Version is '${Version}'"
                        echo "GroupID is '${GroupId}'"
                        echo "Name is '${Name}'"
                    }
                }
       
    }
}
