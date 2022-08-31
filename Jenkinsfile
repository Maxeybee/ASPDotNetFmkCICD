pipeline {
    agent any
    
    environment {
        SiteName = "MyWindDashboard"
        PackageName = "MWD.zip"
        // DeployPath = ""
        // WindowsServer = ""
        // AgentLabel = ""
    }

    stages{
        stage("Check Stage Information") {
            when {
                branch 'stage'             
            }
            steps {
                script {
                    env.WindowsServer = "QA"
                    env.AgentLabel = "qa-windows-agent"
                    env.DeployPath = "C:/jenkins-agent/workspace/My_Portal_Pipeline_stage/MyWindDashboard/${env.PackageName}"
                } 
            }
        }
        stage("Check Prod Information"){
            when {
                branch 'master'             
            }
                steps {
                script {
                    env.WindowsServer = "PROD"
                    env.AgentLabel = "prod-windows-agent"
                    env.DeployPath = "C:/jenkins-agent/workspace/My_Portal_Pipeline_stage/MyWindDashboard/${env.PackageName}"
                } 
            }
        }
        stage("Start"){
            agent { node { label env.AgentLabel } }  
            stages(){
                stage('Clean, Build & Package ') {    
                    steps {
                        script{
                            bat "nuget.exe restore"
                            bat "msbuild ./${env.SiteName}.sln -t:Restore /p:TargetFrameworkVersion=v4.8"
                            bat "msbuild ./${env.SiteName}.sln -t:Clean /p:TargetFrameworkVersion=v4.8"
                            bat "msbuild ./${env.SiteName}.sln -t:Build /m /p:Platform=\"Any CPU\" /detailedsummary /p:TargetFrameworkVersion=v4.8 /p:DeployOnBuild=True /p:ToolsDllPath='C:/jenkins-agent/workspace/My_Portal_Pipeline_stage/GESSOUtility/extReferences/RestSharp.dll' /p:WebPublishMethod=Package /p:PackageAsSingleFile=True /p:PackageLocation=${env.PackageName} /p:configuration=release /p:DeployIISAppPath=\"Default Web Site/${env.SiteName}\""										               
                        }
                    }
                }
                stage('My Portal FULL BACKUP') {
                    steps {
                        script{
                            try{
                                powershell "./PS_Scripts/${env.WindowsServer}/BackupMyPortalWebApp.ps1"
                            } catch (err){
                                echo err.getMessage()
                            }
                        }
                    }
                }
                stage('Stop Existing App'){
                    steps{
                        script{
                            try{
                                powershell "./PS_Scripts/${env.WindowsServer}/StopApp.ps1"
                            } catch (err){
                                echo err.getMessage()
                            }
                        }
                    }
                }
                stage('Publish IIS & Update Config Files') {
                    steps {
                        // bat "dotnet publish ./${env.SiteName}/${env.SiteName}.csproj --output D:/inetpub/wwwroot/${env.SiteName}"
                        powershell "msdeploy -verb:sync -source:package=${env.DeployPath} -dest:auto"
                        powershell "Copy-Item ./PS_Scripts/${env.WindowsServer}/SSOConfig.xml -Destination D:/inetpub/wwwroot/${env.SiteName}"
                        powershell "Copy-Item ./PS_Scripts/${env.WindowsServer}/web.config -Destination D:/inetpub/wwwroot/${env.SiteName}"
                    }
                }
                stage('Convert To Web App & Manage User Rights') {
                    steps {
                        powershell "./PS_Scripts/${env.WindowsServer}/ConvertApp.ps1"
                        powershell "New-Item D:/inetpub/wwwroot/${env.SiteName}/Logs -itemType Directory"
                        bat "cmd /c icacls D:/inetpub/wwwroot/${env.SiteName} /grant Everyone:(OI)(CI)F"
                    }
                }
            }
        }
        // Add Cleaning steps to keep only 2 or 3 backup folders for the application
    }
}