<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@page import="weaver.conn.RecordSet"%>
<%@ page import="weaver.general.Util" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/css/ecology8/request/leftNumMenu_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/leftNumMenu_wev8.js"></script>
<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core_wev8.js"></script>
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<style type="text/css">
.blue{
	color:blue ;
}
</style>
</head>
<body>
<div class="zDialog_div_content">
<table cellspacing="0" cellpadding="0" class="flowsTable" style="width:100%;height:100%;"  >
	<tr>
		<td class="leftTypeSearch">
			<div>
				<span class="leftType" onclick="reload()">菜单分类<span id="totalDoc"></span></span>
				<span class="leftSearchSpan">
					&nbsp;<input type="text" class="leftSearchInput" style="width:110px;"/>
				</span>
			</div>
		</td>
		<td rowspan="2"></td>
	</tr>
	<tr>
		<td style="width:23%;" class="flowMenusTd">
			<div class="flowMenuDiv"  >
					<div class="ulDiv">
						<div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml" style="overflow:hidden;">
					</div>
			</div>
		</td>
	</tr>
</table>
</DIV>
<script type="text/javascript">
var demoLeftMenus=[
                   { 
                    name:"一级菜单01",
                    //attr表示自定义属性，里面可以放跟业务相关的数据，例如在待办中可以放typeid表示流程类别的ID
                    attr:{
                     typeid:"abcdefg"
                    },
                    //submenus表示子菜单（子菜单可以嵌套，但是在本例中只写了两级菜单）
                    submenus:[
                     { 
                      name:"二级类型0101",
                      //这里的workflowid和nodeids是根据流程路径的类型确定的
                      //你可以放其他的属性，比如说如果这个菜单用于文档，那么这个地方可以放文档目录的ID
                      attr:{
                       workflowid:"12345678",
                       nodeids:"87654321"
                      },
                      
                      //二级菜单的数字
                      numbers:{
                      
                       //菜单标题后面显示的数字（可以有任意个，但是不要放太多，否则页面样式没法处理）
                       //下面四个属性分别代表流程中的四种状态；可以根据你的实际需求在这里放入任意属性
                        flowNew:"1",
                        flowResponse:"0",
                        flowOut:"0",
                        flowAll:"7"
                      }
                     }
                    ],
                    
                    //一级菜单的数字
                    numbers:{
                      flowNew:"1",
                      flowResponse:"0",
                      flowOut:"0",
                      flowAll:"7"
                    }
                   }
                   ,
                   { 
                    name:"一级菜单02",
                    attr:{
                     typeid:"2"
                    },
                    submenus:[
                     { 
                      name:"二级菜单0201",
                      attr:{
                       workflowid:"207",
                       nodeids:""
                      },
                      numbers:{
                        flowNew:"0",
                        flowResponse:"0",
                        flowOut:"0",
                        flowAll:"3"
                      }
                     },
                     { 
                      name:"二级菜单0202",
                      attr:{
                       workflowid:"767",
                       nodeids:""
                      },
                      numbers:{
                        flowNew:"0",
                        flowResponse:"0",
                        flowOut:"0",
                        flowAll:"2"
                      }
                     }
                    ],
                    numbers:{
                      flowNew:"5",
                      flowResponse:"0",
                      flowOut:"0",
                      flowAll:"17"
                    }
                   }
                  ];

$(".ulDiv").leftNumMenu(demoLeftMenus,{
	 numberTypes:{
	 //下面的四个属性需要跟你在数据中定义的属性名称相同，本例中为flowNew、flowResponse、flowOut、flowAll
	  flowNew:{
		   hoverColor:"#EDCEAF",//鼠标悬停时显示的方块的颜色 
		   color:"#FFA302",//普通文字的颜色 
		   title:"新的流程"//鼠标悬停时显示的方块的title  
	  },
	  flowResponse:{hoverColor:"#C0D8B8",color:"#486C3E",title:"超时的流程"},
	  flowOut:{hoverColor:"#DAC0E3",color:"#C325FF",title:"有反馈的流程"},
	  flowAll:{hoverColor:"#A6A6A6",color:"black",title:"全部流程"}
	 },
	 //是否显示值为0的数字；不写的话默认为false
	 showZero:false,
	 
	 //菜单的点击事件
	 //三个参数的含义：
	 //attr:就是你在菜单中定义的自定义属性，attr.xxx可以取到属性的值；例如attr.workflowid
	 //level：被点击的菜单的层级；注意是从1开始，不是从0开始的；
	 //numberType：如果你是在鼠标悬停的方块上点击的，那么这个numberType的值为方块的类型。比如说flowNew
	 clickFunction:function(attr,level,numberType){
		  var v = '';
		  if(level==1){
		    v = attr.typeid;
		  }else{
		   	v = attr.workflowid;
		  }
		  parent.jQuery("#contentframe").attr("src","/demo/body.jsp?level="+level+"&value="+v);
	 }
  });

function reload(){
	e8InitTreeSearch({ifrms:'',formID:'',conditions:''});
	var optFrame=jQuery("#contentframe",parent.document);
	var src="/demo/body.jsp?1=1";
	optFrame.attr("src",src);
}
</script>
</body>
</HTML>

































