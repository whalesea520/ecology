<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="initial-scale=1.0, maximum-scale=2.0">
    <meta name="description" content="">
    <meta name="author" content="">
    <title>督查督办</title>
    <script type="text/javascript">
        window.REQ_PAGE_LOAD_START = new Date().getTime();
        if (typeof String.prototype.startsWith != 'function') {
			String.prototype.startsWith = function (prefix) {
				return this.slice(0, prefix.length) === prefix;
			};
		}
    </script>
     <link rel="stylesheet" type="text/css" href="/govern/spa/index.css?v=20170710">
</head>
<body>
<div id="container"></div>
<!-- Polyfills -->
<!--[if lt IE 10]>
<script type="text/javascript" src="/cloudstore/resource/pc/shim/shim.min.js"></script>
<![endif]-->
<script type="text/javascript">
window.JS_LOAD_START = new Date().getTime();
</script>
<!-- 全局依赖 -->
<script type="text/javascript" src="/cloudstore/resource/pc/jquery/jquery-1.8.3.min.js"></script>
<script type="text/javascript" src="/cloudstore/resource/pc/react/react-with-addons.min.js"></script>
<script type="text/javascript" src="/cloudstore/resource/pc/react/react-dom.min.js"></script>
<script type="text/javascript" src="/cloudstore/resource/pc/promise/promise.min.js"></script>
<script type="text/javascript" src="/cloudstore/resource/pc/fetch/fetch.min.js"></script>
<script type="text/javascript" src="/govern/spa/index.js?v=20170710" charset="utf-8"></script>
<script type="text/javascript">
window.JS_LOAD_DURATION = new Date().getTime() - window.JS_LOAD_START;
</script>
</body>
</html>