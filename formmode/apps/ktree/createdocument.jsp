<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="com.weaver.formmodel.apps.ktree.KtreePermissionService"%>
<%@page import="weaver.general.Util"%>

<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
int versionid = Util.getIntValue(request.getParameter("versionid"));
int functionid = Util.getIntValue(request.getParameter("functionid"));
int tabid = Util.getIntValue(request.getParameter("tabid"));
KtreePermissionService ktreePermissionService = new KtreePermissionService();
User user = HrmUserVarify.getUser (request , response) ;
int userType = ktreePermissionService.getUserType(user);
String action = "";
if(userType==3){
	action="admin_create";
}else if(userType==2){
	action="customer_create";
}
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>查看文档</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
    <script type="text/javascript">
	 window.UEDITOR_HOME_URL = "/mobilemode/js/ueditor/";
	</script>
	<script type="text/javascript" src="/formmode/js/jquery/jquery-1.8.3.min_wev8.js"></script>
	<script type="text/javascript" src="/mobilemode/js/ueditor/ueditor.config_wev8.js"></script>
	<script type="text/javascript" src="/mobilemode/js/ueditor/ueditor.all_wev8.js"></script>
	<script type="text/javascript" src="/mobilemode/js/ueditor/lang/zh-cn/zh-cn_wev8.js"></script>
  </head>
  <body>
  	<form action="operationKtreeDcoument.jsp" name="fm" method="post">
  		<input name="content" type="hidden" id="content" value=""/>
  		<input name="versionid" type="hidden" id="versionid" value="<%=versionid%>"/>
  		<input name="functionid" type="hidden" id="functionid" value="<%=functionid%>"/>
  		<input name="tabid" type="hidden" id="tabid" value="<%=tabid%>"/>
  		<input name="action" type="hidden" id="action" value="<%=action%>"/>
		<table>
			<tr>
				<td>标题<input name="subject" id="subject" value=""/> <a href="javascript:onSubmitFrom()" name="btn">提交</a></td>
			</tr>
			<tr>
				<td>
					<script id="editor" type="text/plain" style="width:1024px;height:500px;"></script>
				</td>
			</tr>
		</table>
     </form>
  </body>
<script type="text/javascript">
	function onSubmitFrom(){
		$("#content").val(ue.getContent());
		if($("#subject").val()==''){
			alert('请填写标题!');
			$("#subject").focus();
			return;
		}else if($("#content").val()==""){
			alert('请填写内容!');
			UE.getEditor('editor').focus();
			return;
		}else{
			fm.submit();
		}
		
	}
	var lang = UE.I18N['zh-cn'].contextMenu;
	var ue = UE.getEditor('editor',{
            	toolbars:[[
            	//'fullscreen', 'source', '|', 
            	'undo', 'redo', '|',
                'bold', 'italic', 'underline', 'fontborder', 'strikethrough', 'superscript', 'subscript', 'removeformat', 'formatmatch', 'autotypeset', 'blockquote', 'pasteplain', '|', 'forecolor', 'backcolor', 'insertorderedlist', 'insertunorderedlist',// 'selectall', 'cleardoc', '|',
                'rowspacingtop', 'rowspacingbottom', 'lineheight', '|',
                'customstyle', 'paragraph', 
                'fontfamily', 'fontsize', '|',
                'directionalityltr', 'directionalityrtl', 'indent',// '|'
                //'justifyleft', 'justifycenter', 'justifyright', 'justifyjustify', '|', 'touppercase', 'tolowercase', '|',
                //'link', 'unlink', 'anchor', '|', 'imagenone', 'imageleft', 'imageright', 'imagecenter', '|',
                'insertimage'//, 'emotion', 'scrawl', 'insertvideo', 'music', 'attachment', 'map', 'gmap', 'insertframe','insertcode', 'webapp', 'pagebreak', 'template', 'background', '|',
                //'horizontal', 'date', 'time', 'spechars'
                , 'snapscreen'
                //, 'wordimage', '|',
                //'inserttable', 'deletetable', 'insertparagraphbeforetable', 'insertrow', 'deleterow', 'insertcol', 'deletecol', 'mergecells', 'mergeright', 
                //'mergedown', 'splittocells', 'splittorows', 'splittocols', '|',
                //'print', 'preview', 'searchreplace', 'help'
              ]],
              imageUrl:'/weaver/com.weaver.formmodel.apps.ktree.servlet.KtreeUploadAction?action=image',
              imagePath:"",
              snapscreenServerUrl: '/weaver/com.weaver.formmodel.apps.ktree.servlet.KtreeUploadAction?action=image',
              snapscreenPath: "",
              savePath: [''],
              /*allowDivTransToP: false,*/
              contextMenu:[
                {
                    group:lang.table,
                    icon:'table',
                    subMenu:[
                        {
                            label:lang.inserttable,
                            cmdName:'inserttable'
                        },
                        {
                            label:lang.deletetable,
                            cmdName:'deletetable'
                        },
                        '-',
                        {
                            label:lang.deleterow,
                            cmdName:'deleterow'
                        },
                        {
                            label:lang.deletecol,
                            cmdName:'deletecol'
                        },
                        {
                            label:lang.insertcol,
                            cmdName:'insertcol'
                        },
                        {
                            label:lang.insertcolnext,
                            cmdName:'insertcolnext'
                        },
                        {
                            label:lang.insertrow,
                            cmdName:'insertrow'
                        },
                        {
                            label:lang.insertrownext,
                            cmdName:'insertrownext'
                        },
                        '-',
                        {
                            label:lang.insertcaption,
                            cmdName:'insertcaption'
                        },
                        {
                            label:lang.deletecaption,
                            cmdName:'deletecaption'
                        },
                        {
                            label:lang.inserttitle,
                            cmdName:'inserttitle'
                        },
                        {
                            label:lang.deletetitle,
                            cmdName:'deletetitle'
                        },
                        {
                            label:lang.inserttitlecol,
                            cmdName:'inserttitlecol'
                        },
                        {
                            label:lang.deletetitlecol,
                            cmdName:'deletetitlecol'
                        },
                        '-',
                        {
                            label:lang.mergecells,
                            cmdName:'mergecells'
                        },
                        {
                            label:lang.mergeright,
                            cmdName:'mergeright'
                        },
                        {
                            label:lang.mergedown,
                            cmdName:'mergedown'
                        },
                        '-',
                        {
                            label:lang.splittorows,
                            cmdName:'splittorows'
                        },
                        {
                            label:lang.splittocols,
                            cmdName:'splittocols'
                        },
                        {
                            label:lang.splittocells,
                            cmdName:'splittocells'
                        },
                        '-',
                        {
                            label:lang.averageDiseRow,
                            cmdName:'averagedistributerow'
                        },
                        {
                            label:lang.averageDisCol,
                            cmdName:'averagedistributecol'
                        },
                        '-',
                        {
                            label:lang.edittd,
                            cmdName:'edittd',
                            exec:function () {
                                if ( UE.ui['edittd'] ) {
                                    new UE.ui['edittd']( this );
                                }
                                this.getDialog('edittd').open();
                            }
                        },
                        {
                            label:lang.edittable,
                            cmdName:'edittable',
                            exec:function () {
                                if ( UE.ui['edittable'] ) {
                                    new UE.ui['edittable']( this );
                                }
                                this.getDialog('edittable').open();
                            }
                        },
                        {
                            label:lang.setbordervisible,
                            cmdName:'setbordervisible'
                        }
                    ]
                },
                '-',
                {
                	group:'字段属性',
                    subMenu:[
                        {
			                label:'可编辑',       //显示的名称
			                cmdName:'selectall',//执行的command命令，当点击这个右键菜单时
			                exec:function () {
			            		setFieldAttr(2);
			                }
			            },
			            {
			                label:'只读',       //显示的名称
			                cmdName:'selectall',//执行的command命令，当点击这个右键菜单时
			                exec:function () {
			            		setFieldAttr(1);
			                }
			            },
			            {
			                label:'隐藏',       //显示的名称
			                cmdName:'selectall',//执行的command命令，当点击这个右键菜单时
			                exec:function () {
			            		setFieldAttr(0);
			                }
			            },
			            {
			                label:'必填',       //显示的名称
			                cmdName:'selectall',//执行的command命令，当点击这个右键菜单时
			                exec:function () {
			            		setFieldAttr(3);
			                }
			            }]
                   	}
		        ]
            });
    function isControlSelected(tag){
		if (tag){
			if (ue.document.selection.type == "Control") {
				var oControlRange = ue.document.selection.createRange();
				if (oControlRange(0).tagName.toUpperCase() == tag) {
					return true;
				}	
			} else {
				
			}
		}
		return false;
	}
</script>
</html>
