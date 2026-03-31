% Copyright 2025 The MathWorks, Inc.
% setenv('WORKSPACE',pwd); setenv('MW_SUPPORT_PACKAGE_ROOT', matlabroot);
% setenv('MW_REMOTE_BUILD_CACHE_NAME','prj'); setenv('MW_PIPELINE_GEN_DIRECTORY','_gen_');
function generate_jenkins_pipeline()
    workspace = string(getenv('WORKSPACE'));      % Reading Jenkins workspace environment variable
    supportPackageRoot = string(getenv('MW_SUPPORT_PACKAGE_ROOT'));
    relativeProjectPath = string(getenv('MW_RELATIVE_PROJECT_PATH'));
    remoteBuildCacheName = string(getenv('MW_REMOTE_BUILD_CACHE_NAME'));
    pipelineGenDirectory = string(getenv('MW_PIPELINE_GEN_DIRECTORY'));

    cp = openProject(strcat(workspace,filesep,string(relativeProjectPath)));
    op = padv.pipeline.JenkinsOptions;
    op.AgentLabel = "padv_win_agents";
    op.PipelineArchitecture = "IndependentModelPipelines";
    op.GeneratorVersion = 2;
    op.SupportPackageRoot = supportPackageRoot;
    op.GeneratedPipelineDirectory = pipelineGenDirectory;
    op.StopOnStageFailure = true;
    op.RunprocessCommandOptions.GenerateJUnitForProcess = true;
    op.ReportPath = "$PROJECTROOT$/PA_Results/Report/ProcessAdvisorReport";
    op.RelativeProjectPath = relativeProjectPath;
    op.RemoteBuildCacheName = remoteBuildCacheName;

    op.ArtifactServiceMode = 'azure_blob';         % network/jfrog/s3/azure_blob
    % op.NetworkStoragePath = '<Network storage path>';
    % op.ArtifactoryUrl = '<JFrog Artifactory url>';
    % op.ArtifactoryRepoName = '<JFrog Artifactory repo name>';
    % op.S3BucketName = '<AWS S3 bucket name>';
    % op.S3AwsAccessKeyID = '<AWS S3 access key id>';
    op.AzContainerName = 'padvblobcontainer';
    % op.RunnerType = "container";          % default/container
    % op.ImageTag = '<Docker Image full name>';
    % op.ImageArgs = "<Docker container arguments>";
    
    % Docker image settings
    op.UseMatlabPlugin = false;
    % op.MatlabLaunchCmd = "xvfb-run -a matlab -batch"; 
    % op.MatlabStartupOptions = "";
    % op.AddBatchStartupOption = false;
    padv.pipeline.generatePipeline(op, "CIPipeline");
end