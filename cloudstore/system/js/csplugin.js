!function(e,t){"object"==typeof exports&&"object"==typeof module?module.exports=t():"function"==typeof define&&define.amd?define([],t):"object"==typeof exports?exports.weaPlugin=t():e.weaPlugin=t()}(this,function(){return function(e){function t(o){if(n[o])return n[o].exports;var s=n[o]={exports:{},id:o,loaded:!1};return e[o].call(s.exports,s,s.exports,t),s.loaded=!0,s.exports}var n={};return t.m=e,t.c=n,t.p="",t(0)}([function(e,t){"use strict";function n(e){for(var t=!1,n=0;n<d.length&&!t;n++)e==d[n]&&(t=!0);return t}function o(){n("no0000006")&&c("/cloudstore/app/no0000006/js/wfTrigger.js",function(){a.indexCb("0000006")}),n("no0000012")&&c("/cloudstore/app/no0000012/js/wfDetail.js",function(){a.indexCb("0000012")}),n("index")&&a.indexCb("index")}function s(){c("/cloudstore/libs/reactjs/0.14.7/react.min.js",function(){c("/cloudstore/libs/reactjs/0.14.7/react-dom.min.js",function(){c("/cloudstore/libs/antd/antd.min.js",function(){i("/cloudstore/libs/antd/antd.min.css",function(){c("/cloudstore/libs/ComponentsV1/index.js",function(){"undefined"==typeof JSON?c("/cloudstore/libs/json2/json2.js",function(){o()}):o()})})})})})}function c(e,t){var n=document.createElement("script");n.type="text/javascript",n.charset="utf-8",n.readyState?n.onreadystatechange=function(){("loaded"==n.readyState||"complete"==n.readyState)&&(n.onreadystatechange=null,t())}:n.onload=function(){t()},n.src=e,document.getElementsByTagName("head")[0].appendChild(n)}function i(e,t){var n=document.createElement("link");n.setAttribute("rel","stylesheet"),n.setAttribute("type","text/css"),n.setAttribute("href",e),n.readyState?n.onreadystatechange=function(){("loaded"==n.readyState||"complete"==n.readyState)&&(n.onreadystatechange=null,t())}:n.onload=function(){t()},n.src=e,document.getElementsByTagName("head")[0].appendChild(n)}var a={indexCb:function(e){}},r=document.getElementById("csplugin").getAttribute("params"),d=r?r.split(","):[],u=0;try{u=parseInt(document.documentMode)}catch(l){u=0}n("0000006")||n("0000012")||(console.log("isis"),u>0?c("/cloudstore/libs/antd/js/shim.min.js",function(){s()}):s()),e.exports=a}])});