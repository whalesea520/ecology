<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@page import="java.util.Date "%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <meta charset="UTF-8">
  <title>ContractMobile</title>
  <script>
   (function (baseFontSize, fontscale) {
      var _baseFontSize = baseFontSize || 80;
      var _fontscale = fontscale || 1;
      var win = window;
      var doc = win.document;
      var ua = navigator.userAgent;
      var matches = ua.match(/Android[\S\s]+AppleWebkit\/(\d{3})/i);
      var UCversion = ua.match(/U3\/((\d+|\.){5,})/i);
      var isUCHd = UCversion && parseInt(UCversion[1].split('.').join(''), 10) >= 80;
      var isIos = navigator.appVersion.match(/(iphone|ipad|ipod)/gi);
      var dpr = win.devicePixelRatio || 1;
      if (!isIos && !(matches && matches[1] > 534) && !isUCHd) {
        // 如果非iOS, 非Android4.3以上, 非UC内核, 就不执行高清, dpr设为1;
        dpr = 1;
      }
      var scale = 1 / dpr;

      var metaEl = doc.querySelector('meta[name="viewport"]');
      if (!metaEl) {
        metaEl = doc.createElement('meta');
        metaEl.setAttribute('name', 'viewport');
        doc.head.appendChild(metaEl);
      }
      metaEl.setAttribute('content', 'width=device-width,user-scalable=no,initial-scale=' + scale + ',maximum-scale=' + scale + ',minimum-scale=' + scale);
      doc.documentElement.style.fontSize = _baseFontSize / 2 * dpr * _fontscale + 'px';
      window.viewportScale = dpr;
     
    })();
    
  </script>
  <link rel="stylesheet" href="/mobile/plugin/contract/html/index.css"/>
    <style>
.chart-conscount{padding:0 .3rem;}  
  </style> 
</head>
<body style="background-color: #efeff4;">

<div id="container" style="height:100%"></div>
<script type="text/javascript" src="/mobile/plugin/contract/html/index.js?v1.322.1<%=new Date().getTime() %>"></script>

</body>
</html>