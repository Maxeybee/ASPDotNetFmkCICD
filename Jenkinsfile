pipeline {
    agent any
    environment {
        SiteName = "MyWindDashboard"
        PackageName = "MWD.zip"
        DeployPath = "C:/jenkins-agent/workspace/My_Portal_Pipeline_stage/MyWindDashboard/${env.PackageName}"
    }
    
    // GLOBAL STAGES
    stages{
        // QA STEPS
        stage("QA Steps"){
            when {
                beforeAgent true
                branch "stage"
            }
            agent { node { label 'qa-windows-agent' } }  
            // LIST OF QA Stages
            stages(){
                stage('QA Clean, Build & Package ') {    
                    steps {
                        script{
                            bat "nuget.exe restore"
                            bat "msbuild ./${env.SiteName}.sln -t:Restore /p:TargetFrameworkVersion=v4.8"
                            bat "msbuild ./${env.SiteName}.sln -t:Clean /p:TargetFrameworkVersion=v4.8"
                            bat "msbuild ./${env.SiteName}.sln -t:Build /m /p:Platform=\"Any CPU\" /detailedsummary /p:TargetFrameworkVersion=v4.8 /p:DeployOnBuild=True /p:ToolsDllPath='C:/jenkins-agent/workspace/My_Portal_Pipeline_stage/GESSOUtility/extReferences/RestSharp.dll' /p:WebPublishMethod=Package /p:PackageAsSingleFile=True /p:PackageLocation=${env.PackageName} /p:configuration=release /p:DeployIISAppPath=\"Default Web Site/${env.SiteName}\""										               
                        }
                    }
                }
                stage('QA MYPortal FULL BACKUP') {
                    steps {
                        script{
                            try{
                                powershell "./PS_Scripts/QA/BackupMyPortalWebApp.ps1"
                            } catch (err){
                                echo err.getMessage()
                            }
                        }
                    }
                }
                stage('QA Stop Existing App'){
                    steps{
                        script{
                            try{
                                powershell "./PS_Scripts/QA/StopApp.ps1"
                            } catch (err){
                                echo err.getMessage()
                            }
                        }
                    }
                }
                stage('QA Publish IIS & Config Files') {
                    steps {
                        // bat "dotnet publish ./${env.SiteName}/${env.SiteName}.csproj --output D:/inetpub/wwwroot/${env.SiteName}"
                        powershell "msdeploy -verb:sync -source:package=${env.DeployPath} -dest:auto"
                        powershell "Copy-Item ./PS_Scripts/QA/SSOConfig.xml -Destination D:/inetpub/wwwroot/${env.SiteName}"
                        powershell "Copy-Item ./PS_Scripts/QA/web.config -Destination D:/inetpub/wwwroot/${env.SiteName}"
                    }
                }
                stage('QA Convert Web App & user rights') {
                    steps {
                        powershell "./PS_Scripts/QA/ConvertApp.ps1"
                        powershell "New-Item D:/inetpub/wwwroot/${env.SiteName}/Logs -itemType Directory"
                        bat "cmd /c icacls D:/inetpub/wwwroot/${env.SiteName} /grant Everyone:(OI)(CI)F"
                    }
                }
            }
        }
        stage("PROD Steps"){
            when {
                beforeAgent true
                branch "master_disable"
            }
            agent { node { label 'prod-windows-agent_disable' } }  
            // LIST OF PROD Stages
            stages(){
                stage('PROD Clean, Build & Package ') {    
                    steps {
					bat "msbuild ./${env.SiteName}.sln -t:Restore /p:TargetFrameworkVersion=v4.8"
					bat "msbuild ./${env.SiteName}.sln -t:Clean /p:TargetFrameworkVersion=v4.8"
					bat "msbuild ./${env.SiteName}.sln -t:Build /m /p:Platform=\"Any CPU\" /detailedsummary /p:TargetFrameworkVersion=v4.8 /p:DeployOnBuild=True /p:WebPublishMethod=Package /p:PackageAsSingleFile=True /p:PackageLocation=${env.PackageName} /p:configuration=release /p:DeployIISAppPath=\"Default Web Site/${env.SiteName}\""										
                    }
                }
                stage('PROD MYPortal FULL BACKUP') {
                    steps {
                        script{
                            try{
                                powershell "./PS_Scripts/PROD/BackupMyPortalWebApp.ps1"
                            } catch (err){
                                echo err.getMessage()
                            }
                        }
                    }
                }
                stage('PROD Stop Existing App'){
                    steps{
                        script{
                            try{
                                powershell "./PS_Scripts/PROD/StopApp.ps1"
                            } catch (err){
                                echo err.getMessage()
                            }
                        }
                    }
                }
                stage('PROD Publish IIS & Config Files') {
                    steps {
                        powershell "msdeploy -verb:sync -source:package=${env.DeployPath} -dest:auto"
                        powershell "Copy-Item ./PS_Scripts/PROD/SSOConfig.xml -Destination D:/inetpub/MyWindDashboard/${env.SiteName}"
                        powershell "Copy-Item ./PS_Scripts/PROD/web.config -Destination D:/inetpub/MyWindDashboard/${env.SiteName}"
                    }
                }
                stage('PROD Convert Web App & user rights') {
                    steps {
                        powershell "./PS_Scripts/PROD/ConvertApp.ps1"
                        powershell "New-Item D:/inetpub/wwwroot/${env.SiteName}/Logs -itemType Directory"
                        bat "cmd /c icacls D:/inetpub/wwwroot/${env.SiteName} /grant Everyone:(OI)(CI)F"
                    }
                }
            }
        }
    }
}