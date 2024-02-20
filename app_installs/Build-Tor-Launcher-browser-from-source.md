





<!DOCTYPE html>
<html class="ui-light-gray with-header with-top-bar " lang="en">
<head prefix="og: http://ogp.me/ns#">
<meta charset="utf-8">
<meta content="IE=edge" http-equiv="X-UA-Compatible">
<meta content="width=device-width, initial-scale=1" name="viewport">
<title>BUILD.md · main · The Tor Project / Applications / torbrowser-launcher · GitLab</title>
<script>
//<![CDATA[
window.gon={};gon.features={"blobBlameInfo":true,"highlightJsWorker":true,"explainCodeChat":false,"encodingLogsTree":false};
//]]>
</script>

<script>
//<![CDATA[
var gl = window.gl || {};
gl.startup_calls = {"/tpo/applications/torbrowser-launcher/-/blob/main/BUILD.md?format=json\u0026viewer=rich":{}};
gl.startup_graphql_calls = [{"query":"query getBlobInfo(\n  $projectPath: ID!\n  $filePath: String!\n  $ref: String!\n  $refType: RefType\n  $shouldFetchRawText: Boolean!\n) {\n  project(fullPath: $projectPath) {\n    __typename\n    id\n    repository {\n      __typename\n      empty\n      blobs(paths: [$filePath], ref: $ref, refType: $refType) {\n        __typename\n        nodes {\n          __typename\n          id\n          webPath\n          name\n          size\n          rawSize\n          rawTextBlob @include(if: $shouldFetchRawText)\n          fileType\n          language\n          path\n          blamePath\n          editBlobPath\n          gitpodBlobUrl\n          ideEditPath\n          forkAndEditPath\n          ideForkAndEditPath\n          codeNavigationPath\n          projectBlobPathRoot\n          forkAndViewPath\n          environmentFormattedExternalUrl\n          environmentExternalUrlForRouteMap\n          canModifyBlob\n          canCurrentUserPushToBranch\n          archived\n          storedExternally\n          externalStorage\n          externalStorageUrl\n          rawPath\n          replacePath\n          pipelineEditorPath\n          simpleViewer {\n            fileType\n            tooLarge\n            type\n            renderError\n          }\n          richViewer {\n            fileType\n            tooLarge\n            type\n            renderError\n          }\n        }\n      }\n    }\n  }\n}\n","variables":{"projectPath":"tpo/applications/torbrowser-launcher","ref":"main","refType":"","filePath":"BUILD.md","shouldFetchRawText":false}}];

if (gl.startup_calls && window.fetch) {
  Object.keys(gl.startup_calls).forEach(apiCall => {
   gl.startup_calls[apiCall] = {
      fetchCall: fetch(apiCall, {
        // Emulate XHR for Rails AJAX request checks
        headers: {
          'X-Requested-With': 'XMLHttpRequest'
        },
        // fetch won’t send cookies in older browsers, unless you set the credentials init option.
        // We set to `same-origin` which is default value in modern browsers.
        // See https://github.com/whatwg/fetch/pull/585 for more information.
        credentials: 'same-origin'
      })
    };
  });
}
if (gl.startup_graphql_calls && window.fetch) {
  const headers = {"X-CSRF-Token":"b_fyqYO9CJufLfmq2dwnBX8uLrzIiROUGVFz5ISNKT-xb3n4HZN31lDW3AMDeSVLVHx7ekD3m1ruT3EZD-pe-Q","x-gitlab-feature-category":"source_code_management"};
  const url = `https://eweiibe6tdjsdprb4px6rqrzzcsi22m4koia44kc5pcjr7nec2rlxyad.onion/api/graphql`

  const opts = {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      ...headers,
    }
  };

  gl.startup_graphql_calls = gl.startup_graphql_calls.map(call => ({
    ...call,
    fetchCall: fetch(url, {
      ...opts,
      credentials: 'same-origin',
      body: JSON.stringify(call)
    })
  }))
}


//]]>
</script>

<link rel="prefetch" href="/assets/webpack/monaco.13f17867.chunk.js">

<link rel="stylesheet" href="/assets/application-9412070de1081bd15748e4c0278a95f4b9b50ad910d97e8004582321e45a8858.css" media="all" />
<link rel="stylesheet" href="/assets/page_bundles/tree-a5089dc5ce426c5f11ae90f6dc4a5b0be7ec204192f87d6438b0500eaf370d7c.css" media="all" /><link rel="stylesheet" href="/assets/page_bundles/projects-5607bd5be3ced38d6a7ed3afc0b32793aca283fbd27c21c26ca01d576fb445fb.css" media="all" />
<link rel="stylesheet" href="/assets/application_utilities-a3a6a0c210fab7b8f8237b16134485da1bf5a98097325a65685ef93b30a97976.css" media="all" />


<link rel="stylesheet" href="/assets/fonts-115c4704cb8c77e2fdf3fd0243eebf164e2e9b54bbab7bf6a4c14868b865ddf8.css" media="all" />
<link rel="stylesheet" href="/assets/highlight/themes/white-1b0806cb2775fab529e835804dfb351a11dd641f48d830a28b4b37882174cc0c.css" media="all" />


<link rel="preload" href="/assets/application_utilities-a3a6a0c210fab7b8f8237b16134485da1bf5a98097325a65685ef93b30a97976.css" as="style" type="text/css">
<link rel="preload" href="/assets/application-9412070de1081bd15748e4c0278a95f4b9b50ad910d97e8004582321e45a8858.css" as="style" type="text/css">
<link rel="preload" href="/assets/highlight/themes/white-1b0806cb2775fab529e835804dfb351a11dd641f48d830a28b4b37882174cc0c.css" as="style" type="text/css">





<script src="/assets/webpack/runtime.088dd419.bundle.js" defer="defer"></script>
<script src="/assets/webpack/main.b4eceecd.chunk.js" defer="defer"></script>
<script src="/assets/webpack/graphql.d06f65d4.chunk.js" defer="defer"></script>
<script src="/assets/webpack/commons-pages.admin.abuse_reports-pages.admin.abuse_reports.show-pages.admin.application_settings-pa-82b9feb8.5080bbd8.chunk.js" defer="defer"></script>
<script src="/assets/webpack/commons-pages.search.show-super_sidebar.ca54de1d.chunk.js" defer="defer"></script>
<script src="/assets/webpack/super_sidebar.2f2b8561.chunk.js" defer="defer"></script>
<script src="/assets/webpack/commons-jira_connect_app-pages.abuse_reports-pages.admin.abuse_reports.show-pages.admin.application_-886e45b9.8aa469b9.chunk.js" defer="defer"></script>
<script src="/assets/webpack/commons-pages.admin.runners.show-pages.clusters.agents.dashboard-pages.explore.catalog-pages.groups.-fa999277.e6aae721.chunk.js" defer="defer"></script>
<script src="/assets/webpack/commons-pages.projects.blob.show-pages.projects.branches.new-pages.projects.commits.show-pages.proje-81161c0b.02c1fd7f.chunk.js" defer="defer"></script>
<script src="/assets/webpack/commons-pages.projects.blob.show-pages.projects.show-pages.projects.snippets.edit-pages.projects.sni-42df7d4c.89335e65.chunk.js" defer="defer"></script>
<script src="/assets/webpack/commons-pages.projects.blob.show-pages.projects.show-pages.projects.snippets.show-pages.projects.tre-c684fcf6.1597a45b.chunk.js" defer="defer"></script>
<script src="/assets/webpack/commons-pages.projects.blame.show-pages.projects.blame.streaming-pages.projects.blob.show-pages.proj-9f3d272f.f13404c4.chunk.js" defer="defer"></script>
<script src="/assets/webpack/commons-pages.groups.show-pages.projects.blob.show-pages.projects.show-pages.projects.tree.show.602e8fd6.chunk.js" defer="defer"></script>
<script src="/assets/webpack/commons-pages.projects.blob.show-pages.projects.forks.new-pages.projects.show-pages.projects.tree.show.6475655f.chunk.js" defer="defer"></script>
<script src="/assets/webpack/commons-pages.projects.blob.show-pages.projects.show-pages.projects.tree.show.c9d6843b.chunk.js" defer="defer"></script>
<script src="/assets/webpack/commons-pages.projects.blob.show-pages.projects.tree.show-treeList.c594064e.chunk.js" defer="defer"></script>
<script src="/assets/webpack/pages.projects.blob.show.dc1ffbe6.chunk.js" defer="defer"></script>
<meta content="object" property="og:type">
<meta content="GitLab" property="og:site_name">
<meta content="BUILD.md · main · The Tor Project / Applications / torbrowser-launcher · GitLab" property="og:title">
<meta content="Welcome to The Tor Project&#39;s Gitlab" property="og:description">
<meta content="https://eweiibe6tdjsdprb4px6rqrzzcsi22m4koia44kc5pcjr7nec2rlxyad.onion/assets/twitter_card-570ddb06edf56a2312253c5872489847a0f385112ddbcd71ccfa1570febab5d2.jpg" property="og:image">
<meta content="64" property="og:image:width">
<meta content="64" property="og:image:height">
<meta content="https://eweiibe6tdjsdprb4px6rqrzzcsi22m4koia44kc5pcjr7nec2rlxyad.onion/tpo/applications/torbrowser-launcher/-/blob/main/BUILD.md" property="og:url">
<meta content="summary" property="twitter:card">
<meta content="BUILD.md · main · The Tor Project / Applications / torbrowser-launcher · GitLab" property="twitter:title">
<meta content="Welcome to The Tor Project&#39;s Gitlab" property="twitter:description">
<meta content="https://eweiibe6tdjsdprb4px6rqrzzcsi22m4koia44kc5pcjr7nec2rlxyad.onion/assets/twitter_card-570ddb06edf56a2312253c5872489847a0f385112ddbcd71ccfa1570febab5d2.jpg" property="twitter:image">

<meta name="csrf-param" content="authenticity_token" />
<meta name="csrf-token" content="4sKtP9Ev6APazf2k1IUlupHIN4Rug46xWLhq6fy3RrM8WiZuTwGXThU22A0OICf0uppiQub9Bn-vpmgUd9AxdQ" />
<meta name="csp-nonce" />
<meta name="action-cable-url" content="/-/cable" />
<link href="/-/manifest.json" rel="manifest">
<link rel="icon" type="image/png" href="/uploads/-/system/appearance/favicon/1/favicon.ico" id="favicon" data-original-href="/uploads/-/system/appearance/favicon/1/favicon.ico" />
<link rel="apple-touch-icon" type="image/x-icon" href="/assets/apple-touch-icon-b049d4bc0dd9626f31db825d61880737befc7835982586d015bded10b4435460.png" />
<link href="/search/opensearch.xml" rel="search" title="Search GitLab" type="application/opensearchdescription+xml">




<meta content="Welcome to The Tor Project&#39;s Gitlab" name="description">
<meta content="#ececef" name="theme-color">
</head>

<body class="tab-width-8 gl-browser-generic gl-platform-other  " data-find-file="/tpo/applications/torbrowser-launcher/-/find_file/main" data-group="applications" data-group-full-path="tpo/applications" data-namespace-id="477" data-page="projects:blob:show" data-page-type-id="main/BUILD.md" data-project="torbrowser-launcher" data-project-id="2250">

<script>
//<![CDATA[
gl = window.gl || {};
gl.client = {"isGeneric":true,"isOther":true};


//]]>
</script>



<header class="header-logged-out" data-testid="navbar">
<a class="gl-sr-only gl-accessibility" href="#content-body">Skip to content</a>
<div class="container-fluid">
<nav aria-label="Explore GitLab" class="header-logged-out-nav gl-display-flex gl-gap-3 gl-justify-content-space-between">
<div class="header-logged-out-logo gl-display-flex gl-align-items-center gl-gap-3">
<span class="gl-sr-only">GitLab</span>
<a title="Homepage" id="logo" class="has-tooltip" aria-label="Homepage" href="/"><img class="brand-header-logo lazy" alt="" data-src="/uploads/-/system/appearance/header_logo/1/purple.svg" src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" />
</a><div class="gl-display-flex gl-align-items-center">
</div>
</div>
<ul class="gl-list-style-none gl-p-0 gl-m-0 gl-display-flex gl-gap-3 gl-align-items-center gl-flex-grow-1">
<li class="header-logged-out-nav-item">
<a class="" href="/explore">Explore</a>
</li>
</ul>
<ul class="gl-list-style-none gl-p-0 gl-m-0 gl-display-flex gl-gap-3 gl-align-items-center gl-justify-content-end">
<li class="header-logged-out-nav-item">
<a href="/users/sign_in?redirect_to_referer=yes">Sign in</a>
</li>
</ul>
</nav>
</div>
</header>

<div class="layout-page page-with-super-sidebar">
<aside class="js-super-sidebar super-sidebar super-sidebar-loading" data-command-palette="{&quot;project_files_url&quot;:&quot;/tpo/applications/torbrowser-launcher/-/files/main?format=json&quot;,&quot;project_blob_url&quot;:&quot;/tpo/applications/torbrowser-launcher/-/blob/main&quot;}" data-force-desktop-expanded-sidebar="" data-root-path="/" data-sidebar="{&quot;is_logged_in&quot;:false,&quot;context_switcher_links&quot;:[{&quot;title&quot;:&quot;Explore&quot;,&quot;link&quot;:&quot;/explore&quot;,&quot;icon&quot;:&quot;compass&quot;}],&quot;current_menu_items&quot;:[{&quot;id&quot;:&quot;project_overview&quot;,&quot;title&quot;:&quot;torbrowser-launcher&quot;,&quot;icon&quot;:null,&quot;avatar&quot;:null,&quot;entity_id&quot;:2250,&quot;link&quot;:&quot;/tpo/applications/torbrowser-launcher&quot;,&quot;pill_count&quot;:null,&quot;link_classes&quot;:&quot;shortcuts-project&quot;,&quot;is_active&quot;:false},{&quot;id&quot;:&quot;manage_menu&quot;,&quot;title&quot;:&quot;Manage&quot;,&quot;icon&quot;:&quot;users&quot;,&quot;avatar&quot;:null,&quot;avatar_shape&quot;:&quot;rect&quot;,&quot;entity_id&quot;:null,&quot;link&quot;:&quot;/tpo/applications/torbrowser-launcher/activity&quot;,&quot;is_active&quot;:false,&quot;pill_count&quot;:null,&quot;items&quot;:[{&quot;id&quot;:&quot;activity&quot;,&quot;title&quot;:&quot;Activity&quot;,&quot;icon&quot;:null,&quot;avatar&quot;:null,&quot;entity_id&quot;:null,&quot;link&quot;:&quot;/tpo/applications/torbrowser-launcher/activity&quot;,&quot;pill_count&quot;:null,&quot;link_classes&quot;:&quot;shortcuts-project-activity&quot;,&quot;is_active&quot;:false},{&quot;id&quot;:&quot;members&quot;,&quot;title&quot;:&quot;Members&quot;,&quot;icon&quot;:null,&quot;avatar&quot;:null,&quot;entity_id&quot;:null,&quot;link&quot;:&quot;/tpo/applications/torbrowser-launcher/-/project_members&quot;,&quot;pill_count&quot;:null,&quot;link_classes&quot;:null,&quot;is_active&quot;:false},{&quot;id&quot;:&quot;labels&quot;,&quot;title&quot;:&quot;Labels&quot;,&quot;icon&quot;:null,&quot;avatar&quot;:null,&quot;entity_id&quot;:null,&quot;link&quot;:&quot;/tpo/applications/torbrowser-launcher/-/labels&quot;,&quot;pill_count&quot;:null,&quot;link_classes&quot;:null,&quot;is_active&quot;:false}],&quot;separated&quot;:false},{&quot;id&quot;:&quot;plan_menu&quot;,&quot;title&quot;:&quot;Plan&quot;,&quot;icon&quot;:&quot;planning&quot;,&quot;avatar&quot;:null,&quot;avatar_shape&quot;:&quot;rect&quot;,&quot;entity_id&quot;:null,&quot;link&quot;:&quot;/tpo/applications/torbrowser-launcher/-/issues&quot;,&quot;is_active&quot;:false,&quot;pill_count&quot;:null,&quot;items&quot;:[{&quot;id&quot;:&quot;project_issue_list&quot;,&quot;title&quot;:&quot;Issues&quot;,&quot;icon&quot;:null,&quot;avatar&quot;:null,&quot;entity_id&quot;:null,&quot;link&quot;:&quot;/tpo/applications/torbrowser-launcher/-/issues&quot;,&quot;pill_count&quot;:&quot;2&quot;,&quot;link_classes&quot;:&quot;shortcuts-issues has-sub-items&quot;,&quot;is_active&quot;:false},{&quot;id&quot;:&quot;boards&quot;,&quot;title&quot;:&quot;Issue boards&quot;,&quot;icon&quot;:null,&quot;avatar&quot;:null,&quot;entity_id&quot;:null,&quot;link&quot;:&quot;/tpo/applications/torbrowser-launcher/-/boards&quot;,&quot;pill_count&quot;:null,&quot;link_classes&quot;:&quot;shortcuts-issue-boards&quot;,&quot;is_active&quot;:false},{&quot;id&quot;:&quot;milestones&quot;,&quot;title&quot;:&quot;Milestones&quot;,&quot;icon&quot;:null,&quot;avatar&quot;:null,&quot;entity_id&quot;:null,&quot;link&quot;:&quot;/tpo/applications/torbrowser-launcher/-/milestones&quot;,&quot;pill_count&quot;:null,&quot;link_classes&quot;:null,&quot;is_active&quot;:false},{&quot;id&quot;:&quot;project_wiki&quot;,&quot;title&quot;:&quot;Wiki&quot;,&quot;icon&quot;:null,&quot;avatar&quot;:null,&quot;entity_id&quot;:null,&quot;link&quot;:&quot;/tpo/applications/torbrowser-launcher/-/wikis/home&quot;,&quot;pill_count&quot;:null,&quot;link_classes&quot;:&quot;shortcuts-wiki&quot;,&quot;is_active&quot;:false}],&quot;separated&quot;:false},{&quot;id&quot;:&quot;code_menu&quot;,&quot;title&quot;:&quot;Code&quot;,&quot;icon&quot;:&quot;code&quot;,&quot;avatar&quot;:null,&quot;avatar_shape&quot;:&quot;rect&quot;,&quot;entity_id&quot;:null,&quot;link&quot;:&quot;/tpo/applications/torbrowser-launcher/-/merge_requests&quot;,&quot;is_active&quot;:true,&quot;pill_count&quot;:null,&quot;items&quot;:[{&quot;id&quot;:&quot;project_merge_request_list&quot;,&quot;title&quot;:&quot;Merge requests&quot;,&quot;icon&quot;:null,&quot;avatar&quot;:null,&quot;entity_id&quot;:null,&quot;link&quot;:&quot;/tpo/applications/torbrowser-launcher/-/merge_requests&quot;,&quot;pill_count&quot;:&quot;0&quot;,&quot;link_classes&quot;:&quot;shortcuts-merge_requests&quot;,&quot;is_active&quot;:false},{&quot;id&quot;:&quot;files&quot;,&quot;title&quot;:&quot;Repository&quot;,&quot;icon&quot;:null,&quot;avatar&quot;:null,&quot;entity_id&quot;:null,&quot;link&quot;:&quot;/tpo/applications/torbrowser-launcher/-/tree/main&quot;,&quot;pill_count&quot;:null,&quot;link_classes&quot;:&quot;shortcuts-tree&quot;,&quot;is_active&quot;:true},{&quot;id&quot;:&quot;branches&quot;,&quot;title&quot;:&quot;Branches&quot;,&quot;icon&quot;:null,&quot;avatar&quot;:null,&quot;entity_id&quot;:null,&quot;link&quot;:&quot;/tpo/applications/torbrowser-launcher/-/branches&quot;,&quot;pill_count&quot;:null,&quot;link_classes&quot;:null,&quot;is_active&quot;:false},{&quot;id&quot;:&quot;commits&quot;,&quot;title&quot;:&quot;Commits&quot;,&quot;icon&quot;:null,&quot;avatar&quot;:null,&quot;entity_id&quot;:null,&quot;link&quot;:&quot;/tpo/applications/torbrowser-launcher/-/commits/main?ref_type=heads&quot;,&quot;pill_count&quot;:null,&quot;link_classes&quot;:&quot;shortcuts-commits&quot;,&quot;is_active&quot;:false},{&quot;id&quot;:&quot;tags&quot;,&quot;title&quot;:&quot;Tags&quot;,&quot;icon&quot;:null,&quot;avatar&quot;:null,&quot;entity_id&quot;:null,&quot;link&quot;:&quot;/tpo/applications/torbrowser-launcher/-/tags&quot;,&quot;pill_count&quot;:null,&quot;link_classes&quot;:null,&quot;is_active&quot;:false},{&quot;id&quot;:&quot;graphs&quot;,&quot;title&quot;:&quot;Repository graph&quot;,&quot;icon&quot;:null,&quot;avatar&quot;:null,&quot;entity_id&quot;:null,&quot;link&quot;:&quot;/tpo/applications/torbrowser-launcher/-/network/main?ref_type=heads&quot;,&quot;pill_count&quot;:null,&quot;link_classes&quot;:&quot;shortcuts-network&quot;,&quot;is_active&quot;:false},{&quot;id&quot;:&quot;compare&quot;,&quot;title&quot;:&quot;Compare revisions&quot;,&quot;icon&quot;:null,&quot;avatar&quot;:null,&quot;entity_id&quot;:null,&quot;link&quot;:&quot;/tpo/applications/torbrowser-launcher/-/compare?from=main\u0026to=main&quot;,&quot;pill_count&quot;:null,&quot;link_classes&quot;:null,&quot;is_active&quot;:false},{&quot;id&quot;:&quot;project_snippets&quot;,&quot;title&quot;:&quot;Snippets&quot;,&quot;icon&quot;:null,&quot;avatar&quot;:null,&quot;entity_id&quot;:null,&quot;link&quot;:&quot;/tpo/applications/torbrowser-launcher/-/snippets&quot;,&quot;pill_count&quot;:null,&quot;link_classes&quot;:&quot;shortcuts-snippets&quot;,&quot;is_active&quot;:false}],&quot;separated&quot;:false},{&quot;id&quot;:&quot;build_menu&quot;,&quot;title&quot;:&quot;Build&quot;,&quot;icon&quot;:&quot;rocket&quot;,&quot;avatar&quot;:null,&quot;avatar_shape&quot;:&quot;rect&quot;,&quot;entity_id&quot;:null,&quot;link&quot;:&quot;/tpo/applications/torbrowser-launcher/-/pipelines&quot;,&quot;is_active&quot;:false,&quot;pill_count&quot;:null,&quot;items&quot;:[{&quot;id&quot;:&quot;pipelines&quot;,&quot;title&quot;:&quot;Pipelines&quot;,&quot;icon&quot;:null,&quot;avatar&quot;:null,&quot;entity_id&quot;:null,&quot;link&quot;:&quot;/tpo/applications/torbrowser-launcher/-/pipelines&quot;,&quot;pill_count&quot;:null,&quot;link_classes&quot;:&quot;shortcuts-pipelines&quot;,&quot;is_active&quot;:false},{&quot;id&quot;:&quot;jobs&quot;,&quot;title&quot;:&quot;Jobs&quot;,&quot;icon&quot;:null,&quot;avatar&quot;:null,&quot;entity_id&quot;:null,&quot;link&quot;:&quot;/tpo/applications/torbrowser-launcher/-/jobs&quot;,&quot;pill_count&quot;:null,&quot;link_classes&quot;:&quot;shortcuts-builds&quot;,&quot;is_active&quot;:false},{&quot;id&quot;:&quot;pipeline_schedules&quot;,&quot;title&quot;:&quot;Pipeline schedules&quot;,&quot;icon&quot;:null,&quot;avatar&quot;:null,&quot;entity_id&quot;:null,&quot;link&quot;:&quot;/tpo/applications/torbrowser-launcher/-/pipeline_schedules&quot;,&quot;pill_count&quot;:null,&quot;link_classes&quot;:&quot;shortcuts-builds&quot;,&quot;is_active&quot;:false},{&quot;id&quot;:&quot;artifacts&quot;,&quot;title&quot;:&quot;Artifacts&quot;,&quot;icon&quot;:null,&quot;avatar&quot;:null,&quot;entity_id&quot;:null,&quot;link&quot;:&quot;/tpo/applications/torbrowser-launcher/-/artifacts&quot;,&quot;pill_count&quot;:null,&quot;link_classes&quot;:&quot;shortcuts-builds&quot;,&quot;is_active&quot;:false}],&quot;separated&quot;:false},{&quot;id&quot;:&quot;deploy_menu&quot;,&quot;title&quot;:&quot;Deploy&quot;,&quot;icon&quot;:&quot;deployments&quot;,&quot;avatar&quot;:null,&quot;avatar_shape&quot;:&quot;rect&quot;,&quot;entity_id&quot;:null,&quot;link&quot;:&quot;/tpo/applications/torbrowser-launcher/-/releases&quot;,&quot;is_active&quot;:false,&quot;pill_count&quot;:null,&quot;items&quot;:[{&quot;id&quot;:&quot;releases&quot;,&quot;title&quot;:&quot;Releases&quot;,&quot;icon&quot;:null,&quot;avatar&quot;:null,&quot;entity_id&quot;:null,&quot;link&quot;:&quot;/tpo/applications/torbrowser-launcher/-/releases&quot;,&quot;pill_count&quot;:null,&quot;link_classes&quot;:&quot;shortcuts-deployments-releases&quot;,&quot;is_active&quot;:false},{&quot;id&quot;:&quot;packages_registry&quot;,&quot;title&quot;:&quot;Package Registry&quot;,&quot;icon&quot;:null,&quot;avatar&quot;:null,&quot;entity_id&quot;:null,&quot;link&quot;:&quot;/tpo/applications/torbrowser-launcher/-/packages&quot;,&quot;pill_count&quot;:null,&quot;link_classes&quot;:&quot;shortcuts-container-registry&quot;,&quot;is_active&quot;:false},{&quot;id&quot;:&quot;container_registry&quot;,&quot;title&quot;:&quot;Container Registry&quot;,&quot;icon&quot;:null,&quot;avatar&quot;:null,&quot;entity_id&quot;:null,&quot;link&quot;:&quot;/tpo/applications/torbrowser-launcher/container_registry&quot;,&quot;pill_count&quot;:null,&quot;link_classes&quot;:null,&quot;is_active&quot;:false}],&quot;separated&quot;:false},{&quot;id&quot;:&quot;operations_menu&quot;,&quot;title&quot;:&quot;Operate&quot;,&quot;icon&quot;:&quot;cloud-pod&quot;,&quot;avatar&quot;:null,&quot;avatar_shape&quot;:&quot;rect&quot;,&quot;entity_id&quot;:null,&quot;link&quot;:&quot;/tpo/applications/torbrowser-launcher/-/environments&quot;,&quot;is_active&quot;:false,&quot;pill_count&quot;:null,&quot;items&quot;:[{&quot;id&quot;:&quot;environments&quot;,&quot;title&quot;:&quot;Environments&quot;,&quot;icon&quot;:null,&quot;avatar&quot;:null,&quot;entity_id&quot;:null,&quot;link&quot;:&quot;/tpo/applications/torbrowser-launcher/-/environments&quot;,&quot;pill_count&quot;:null,&quot;link_classes&quot;:&quot;shortcuts-environments&quot;,&quot;is_active&quot;:false},{&quot;id&quot;:&quot;infrastructure_registry&quot;,&quot;title&quot;:&quot;Terraform modules&quot;,&quot;icon&quot;:null,&quot;avatar&quot;:null,&quot;entity_id&quot;:null,&quot;link&quot;:&quot;/tpo/applications/torbrowser-launcher/-/infrastructure_registry&quot;,&quot;pill_count&quot;:null,&quot;link_classes&quot;:null,&quot;is_active&quot;:false}],&quot;separated&quot;:false},{&quot;id&quot;:&quot;monitor_menu&quot;,&quot;title&quot;:&quot;Monitor&quot;,&quot;icon&quot;:&quot;monitor&quot;,&quot;avatar&quot;:null,&quot;avatar_shape&quot;:&quot;rect&quot;,&quot;entity_id&quot;:null,&quot;link&quot;:&quot;/tpo/applications/torbrowser-launcher/-/incidents&quot;,&quot;is_active&quot;:false,&quot;pill_count&quot;:null,&quot;items&quot;:[{&quot;id&quot;:&quot;incidents&quot;,&quot;title&quot;:&quot;Incidents&quot;,&quot;icon&quot;:null,&quot;avatar&quot;:null,&quot;entity_id&quot;:null,&quot;link&quot;:&quot;/tpo/applications/torbrowser-launcher/-/incidents&quot;,&quot;pill_count&quot;:null,&quot;link_classes&quot;:null,&quot;is_active&quot;:false},{&quot;id&quot;:&quot;service_desk&quot;,&quot;title&quot;:&quot;Service Desk&quot;,&quot;icon&quot;:null,&quot;avatar&quot;:null,&quot;entity_id&quot;:null,&quot;link&quot;:&quot;/tpo/applications/torbrowser-launcher/-/issues/service_desk&quot;,&quot;pill_count&quot;:null,&quot;link_classes&quot;:null,&quot;is_active&quot;:false}],&quot;separated&quot;:false},{&quot;id&quot;:&quot;analyze_menu&quot;,&quot;title&quot;:&quot;Analyze&quot;,&quot;icon&quot;:&quot;chart&quot;,&quot;avatar&quot;:null,&quot;avatar_shape&quot;:&quot;rect&quot;,&quot;entity_id&quot;:null,&quot;link&quot;:&quot;/tpo/applications/torbrowser-launcher/-/value_stream_analytics&quot;,&quot;is_active&quot;:false,&quot;pill_count&quot;:null,&quot;items&quot;:[{&quot;id&quot;:&quot;cycle_analytics&quot;,&quot;title&quot;:&quot;Value stream analytics&quot;,&quot;icon&quot;:null,&quot;avatar&quot;:null,&quot;entity_id&quot;:null,&quot;link&quot;:&quot;/tpo/applications/torbrowser-launcher/-/value_stream_analytics&quot;,&quot;pill_count&quot;:null,&quot;link_classes&quot;:&quot;shortcuts-project-cycle-analytics&quot;,&quot;is_active&quot;:false},{&quot;id&quot;:&quot;contributors&quot;,&quot;title&quot;:&quot;Contributor analytics&quot;,&quot;icon&quot;:null,&quot;avatar&quot;:null,&quot;entity_id&quot;:null,&quot;link&quot;:&quot;/tpo/applications/torbrowser-launcher/-/graphs/main?ref_type=heads&quot;,&quot;pill_count&quot;:null,&quot;link_classes&quot;:null,&quot;is_active&quot;:false},{&quot;id&quot;:&quot;ci_cd_analytics&quot;,&quot;title&quot;:&quot;CI/CD analytics&quot;,&quot;icon&quot;:null,&quot;avatar&quot;:null,&quot;entity_id&quot;:null,&quot;link&quot;:&quot;/tpo/applications/torbrowser-launcher/-/pipelines/charts&quot;,&quot;pill_count&quot;:null,&quot;link_classes&quot;:null,&quot;is_active&quot;:false},{&quot;id&quot;:&quot;repository_analytics&quot;,&quot;title&quot;:&quot;Repository analytics&quot;,&quot;icon&quot;:null,&quot;avatar&quot;:null,&quot;entity_id&quot;:null,&quot;link&quot;:&quot;/tpo/applications/torbrowser-launcher/-/graphs/main/charts&quot;,&quot;pill_count&quot;:null,&quot;link_classes&quot;:&quot;shortcuts-repository-charts&quot;,&quot;is_active&quot;:false},{&quot;id&quot;:&quot;model_experiments&quot;,&quot;title&quot;:&quot;Model experiments&quot;,&quot;icon&quot;:null,&quot;avatar&quot;:null,&quot;entity_id&quot;:null,&quot;link&quot;:&quot;/tpo/applications/torbrowser-launcher/-/ml/experiments&quot;,&quot;pill_count&quot;:null,&quot;link_classes&quot;:null,&quot;is_active&quot;:false}],&quot;separated&quot;:false}],&quot;current_context_header&quot;:&quot;Project&quot;,&quot;support_path&quot;:&quot;https://support.torproject.org/&quot;,&quot;display_whats_new&quot;:false,&quot;whats_new_most_recent_release_items_count&quot;:1,&quot;whats_new_version_digest&quot;:&quot;9a80cbde0c0fd67d411980e9d12a6f2bbec7cc5f5bb2125ad7afad55edf570e3&quot;,&quot;show_version_check&quot;:false,&quot;gitlab_version&quot;:{&quot;major&quot;:16,&quot;minor&quot;:8,&quot;patch&quot;:1,&quot;suffix_s&quot;:&quot;&quot;},&quot;gitlab_version_check&quot;:null,&quot;search&quot;:{&quot;search_path&quot;:&quot;/search&quot;,&quot;issues_path&quot;:&quot;/dashboard/issues&quot;,&quot;mr_path&quot;:&quot;/dashboard/merge_requests&quot;,&quot;autocomplete_path&quot;:&quot;/search/autocomplete&quot;,&quot;search_context&quot;:{&quot;group&quot;:{&quot;id&quot;:477,&quot;name&quot;:&quot;Applications&quot;,&quot;full_name&quot;:&quot;The Tor Project / Applications&quot;},&quot;group_metadata&quot;:{&quot;issues_path&quot;:&quot;/groups/tpo/applications/-/issues&quot;,&quot;mr_path&quot;:&quot;/groups/tpo/applications/-/merge_requests&quot;},&quot;project&quot;:{&quot;id&quot;:2250,&quot;name&quot;:&quot;torbrowser-launcher&quot;},&quot;project_metadata&quot;:{&quot;mr_path&quot;:&quot;/tpo/applications/torbrowser-launcher/-/merge_requests&quot;,&quot;issues_path&quot;:&quot;/tpo/applications/torbrowser-launcher/-/issues&quot;},&quot;code_search&quot;:true,&quot;ref&quot;:&quot;main&quot;,&quot;scope&quot;:null,&quot;for_snippets&quot;:null}},&quot;panel_type&quot;:&quot;project&quot;,&quot;shortcut_links&quot;:[{&quot;title&quot;:&quot;Snippets&quot;,&quot;href&quot;:&quot;/explore/snippets&quot;,&quot;css_class&quot;:&quot;dashboard-shortcuts-snippets&quot;},{&quot;title&quot;:&quot;Groups&quot;,&quot;href&quot;:&quot;/explore/groups&quot;,&quot;css_class&quot;:&quot;dashboard-shortcuts-groups&quot;},{&quot;title&quot;:&quot;Projects&quot;,&quot;href&quot;:&quot;/explore/projects&quot;,&quot;css_class&quot;:&quot;dashboard-shortcuts-projects&quot;}]}"></aside>

<div class="content-wrapper">
<div class="mobile-overlay"></div>

<div class="alert-wrapper gl-force-block-formatting-context">





<div class="gl-broadcast-message broadcast-banner-message banner js-broadcast-notification-7 light" data-testid="banner-broadcast-message" role="alert">
<div class="gl-broadcast-message-content">
<div class="gl-broadcast-message-icon">
<svg class="s16" data-testid="bullhorn-icon"><use href="/assets/icons-1563760c6022424ca5187159258484be0c106b044e5e5a1b4f0be7a10cd6c90f.svg#bullhorn"></use></svg>
</div>
<div class="gl-broadcast-message-text js-broadcast-message-preview">
<h2 class="gl-sr-only">
Admin message
</h2>
<p>On Monday, February 5th, two-factor authentication will become mandatory for accounts with privileges in any group/project in the "tpo" namespace. For details, see <a href="http://eweiibe6tdjsdprb4px6rqrzzcsi22m4koia44kc5pcjr7nec2rlxyad.onion/tpo/tpa/team/-/wikis/policy/tpa-rfc-60-gitlab-2fa-enforcement">TPA-RFC-60: GitLab 2-factor authentication enforcement</a>.</p>
</div>
</div>
<button class="gl-button btn btn-icon btn-sm btn-default btn-default-tertiary gl-close-btn-color-inherit gl-broadcast-message-dismiss js-dismiss-current-broadcast-notification" aria-label="Close" data-id="7" data-expire-date="2024-02-05T17:00:42Z" type="button"><svg class="s16 gl-icon gl-button-icon gl-text-white" data-testid="close-icon"><use href="/assets/icons-1563760c6022424ca5187159258484be0c106b044e5e5a1b4f0be7a10cd6c90f.svg#close"></use></svg>

</button>
</div>



















<div class="top-bar-fixed container-fluid" data-testid="top-bar">
<div class="top-bar-container gl-display-flex gl-align-items-center gl-gap-2">
<button class="gl-button btn btn-icon btn-md btn-default btn-default-tertiary js-super-sidebar-toggle-expand super-sidebar-toggle gl-ml-n3" aria-controls="super-sidebar" aria-expanded="false" aria-label="Primary navigation sidebar" type="button"><svg class="s16 gl-icon gl-button-icon " data-testid="sidebar-icon"><use href="/assets/icons-1563760c6022424ca5187159258484be0c106b044e5e5a1b4f0be7a10cd6c90f.svg#sidebar"></use></svg>

</button>
<nav aria-label="Breadcrumbs" class="breadcrumbs gl-breadcrumbs" data-testid="breadcrumb-links">
<ul class="breadcrumb gl-breadcrumb-list js-breadcrumbs-list">
<li class="gl-breadcrumb-item gl-display-inline-flex"><a class="group-path js-breadcrumb-item-text " href="/tpo">The Tor Project</a></li><li class="gl-breadcrumb-item gl-display-inline-flex"><a class="group-path js-breadcrumb-item-text " href="/tpo/applications">Applications</a></li> <li class="gl-breadcrumb-item gl-display-inline-flex"><a class="gl-display-inline-flex!" href="/tpo/applications/torbrowser-launcher"><span class="js-breadcrumb-item-text">torbrowser-launcher</span></a></li>

<li class="gl-breadcrumb-item" data-testid="breadcrumb-current-link">
<a href="/tpo/applications/torbrowser-launcher/-/blob/main/BUILD.md">Repository</a>
</li>
</ul>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"The Tor Project","item":"https://eweiibe6tdjsdprb4px6rqrzzcsi22m4koia44kc5pcjr7nec2rlxyad.onion/tpo"},{"@type":"ListItem","position":2,"name":"Applications","item":"https://eweiibe6tdjsdprb4px6rqrzzcsi22m4koia44kc5pcjr7nec2rlxyad.onion/tpo/applications"},{"@type":"ListItem","position":3,"name":"torbrowser-launcher","item":"https://eweiibe6tdjsdprb4px6rqrzzcsi22m4koia44kc5pcjr7nec2rlxyad.onion/tpo/applications/torbrowser-launcher"},{"@type":"ListItem","position":4,"name":"Repository","item":"https://eweiibe6tdjsdprb4px6rqrzzcsi22m4koia44kc5pcjr7nec2rlxyad.onion/tpo/applications/torbrowser-launcher/-/blob/main/BUILD.md"}]}

</script>
</nav>



</div>
</div>

</div>
<div class="container-fluid container-limited project-highlight-puc">
<main class="content" id="content-body" itemscope itemtype="http://schema.org/SoftwareSourceCode">
<div class="flash-container flash-container-page sticky" data-testid="flash-container">
<div id="js-global-alerts"></div>
</div>




<div class="js-signature-container" data-signatures-path="/tpo/applications/torbrowser-launcher/-/commits/8f4d4c84b93efa8aeab7a2da81e8f1f0be542631/signatures?limit=1"></div>

<div class="tree-holder gl-pt-4" id="tree-holder">
<div class="nav-block">
<div class="tree-ref-container">
<div class="tree-ref-holder gl-max-w-26">
<div data-project-id="2250" data-project-root-path="/tpo/applications/torbrowser-launcher" data-ref="main" data-ref-type="" id="js-tree-ref-switcher"></div>
</div>
<ul class="breadcrumb repo-breadcrumb">
<li class="breadcrumb-item">
<a href="/tpo/applications/torbrowser-launcher/-/tree/main">torbrowser-launcher
</a></li>
<li class="breadcrumb-item">
<a href="/tpo/applications/torbrowser-launcher/-/blob/main/BUILD.md"><strong>BUILD.md</strong>
</a></li>
</ul>
</div>
<div class="tree-controls gl-display-flex gl-flex-wrap gl-sm-flex-nowrap gl-align-items-baseline gl-gap-3">
<a class="gl-button btn btn-md btn-default shortcuts-find-file" rel="nofollow" href="/tpo/applications/torbrowser-launcher/-/find_file/main"><span class="gl-button-text">
Find file

</span>

</a>
<a class="gl-button btn btn-md btn-default js-blob-blame-link" href="/tpo/applications/torbrowser-launcher/-/blame/main/BUILD.md"><span class="gl-button-text">
Blame
</span>

</a>
<a class="gl-button btn btn-md btn-default " href="/tpo/applications/torbrowser-launcher/-/commits/main/BUILD.md"><span class="gl-button-text">
History
</span>

</a>
<a class="gl-button btn btn-md btn-default js-data-file-blob-permalink-url" href="/tpo/applications/torbrowser-launcher/-/blob/96594666ab8b92e036f6962387177830f8f289f3/BUILD.md"><span class="gl-button-text">
Permalink
</span>

</a>
</div>
</div>

<div class="info-well d-none d-sm-block">
<div class="well-segment">
<ul class="blob-commit-info">
<li class="commit flex-row js-toggle-container" id="commit-8f4d4c84">
<div class="avatar-cell d-none d-sm-block">
<a href="/asciiwolf"><img alt="asciiwolf&#39;s avatar" src="/assets/no_avatar-849f9c04a3a0d0cea2424ae97b27447dc64a7dbfae83c036c45b403392f0e8ba.png" class="avatar s40 gl-display-none gl-sm-display-inline-block" title="asciiwolf"></a>
</div>
<div class="commit-detail flex-list gl-display-flex gl-justify-content-space-between gl-align-items-center gl-flex-grow-1 gl-min-w-0">
<div class="commit-content" data-testid="commit-content">
<a class="commit-row-message item-title js-onboarding-commit-item " href="/tpo/applications/torbrowser-launcher/-/commit/8f4d4c84b93efa8aeab7a2da81e8f1f0be542631">Update Git repo URL in BUILD.md</a>
<span class="commit-row-message d-inline d-sm-none">
&middot;
8f4d4c84
</span>
<div class="committer">
<a class="commit-author-link js-user-link" data-user-id="3134" href="/asciiwolf">asciiwolf</a> authored <time class="js-timeago" title="Oct 13, 2023 12:22pm" datetime="2023-10-13T12:22:19Z" data-toggle="tooltip" data-placement="bottom" data-container="body">Oct 13, 2023</time>
</div>

</div>
<div class="commit-actions flex-row">

<div class="js-commit-pipeline-status" data-endpoint="/tpo/applications/torbrowser-launcher/-/commit/8f4d4c84b93efa8aeab7a2da81e8f1f0be542631/pipelines?ref=main"></div>
<div class="commit-sha-group btn-group d-none d-sm-flex">
<div class="label label-monospace monospace">
8f4d4c84
</div>
<button class="gl-button btn btn-icon btn-md btn-default " title="Copy commit SHA" aria-label="Copy commit SHA" aria-live="polite" data-toggle="tooltip" data-placement="bottom" data-container="body" data-html="true" data-category="primary" data-size="medium" data-clipboard-text="8f4d4c84b93efa8aeab7a2da81e8f1f0be542631" type="button"><svg class="s16 gl-icon gl-button-icon " data-testid="copy-to-clipboard-icon"><use href="/assets/icons-1563760c6022424ca5187159258484be0c106b044e5e5a1b4f0be7a10cd6c90f.svg#copy-to-clipboard"></use></svg>

</button>

</div>
</div>
</div>
</li>

</ul>
</div>

</div>
<div class="blob-content-holder js-per-page" data-blame-per-page="1000" id="blob-content-holder">
<div data-blob-path="BUILD.md" data-original-branch="main" data-project-path="tpo/applications/torbrowser-launcher" data-ref-type="" data-resource-id="gid://gitlab/Project/2250" data-target-branch="main" data-user-id="" id="js-view-blob-app">
<div class="gl-spinner-container" role="status"><span aria-label="Loading" class="gl-spinner gl-spinner-md gl-spinner-dark gl-vertical-align-text-bottom!"></span></div>
</div>
</div>

</div>

<script>
//<![CDATA[
  window.gl = window.gl || {};
  window.gl.webIDEPath = '/-/ide/project/tpo/applications/torbrowser-launcher/edit/main/-/BUILD.md'


//]]>
</script>
<div data-ambiguous="false" data-ref="main" id="js-ambiguous-ref-modal"></div>

</main>
</div>


</div>
</div>


<script>
//<![CDATA[
if ('loading' in HTMLImageElement.prototype) {
  document.querySelectorAll('img.lazy').forEach(img => {
    img.loading = 'lazy';
    let imgUrl = img.dataset.src;
    // Only adding width + height for avatars for now
    if (imgUrl.indexOf('/avatar/') > -1 && imgUrl.indexOf('?') === -1) {
      const targetWidth = img.getAttribute('width') || img.width;
      imgUrl += `?width=${targetWidth}`;
    }
    img.src = imgUrl;
    img.removeAttribute('data-src');
    img.classList.remove('lazy');
    img.classList.add('js-lazy-loaded');
    img.dataset.testid = 'js-lazy-loaded-content';
  });
}

//]]>
</script>
<script>
//<![CDATA[
gl = window.gl || {};
gl.experiments = {};


//]]>
</script>

</body>
</html>

