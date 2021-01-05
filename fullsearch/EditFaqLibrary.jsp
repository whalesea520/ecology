
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<HTML>
<%
	String titlename = ""
			+ SystemEnv.getHtmlLabelName(571, user.getLanguage()) + ":"
			+ SystemEnv.getHtmlLabelName(93, user.getLanguage());
%>
<head>
	<script type="text/javascript" src="/js/weaver_wev8.js"></script>
	<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
	<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css
		rel=STYLESHEET>
	<script language=javascript
		src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
	<!--引入ueditor相关文件-->
    <script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.config_wev8.js"></script>
    <script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.all.min_wev8.js"> </script>
    <script type="text/javascript" charset="UTF-8" src="/ueditor/lang/zh-cn/zh-cn_wev8.js"></script>
    <style>
        .labelDiv{
            margin-top:5px;
            margin-bottom:5px;
        }
    </style>
</head>
<%!
       public String StrFilter(String str){
        
        str = Util.null2String(str);
        if (str.contains("'"))
        {
            str = str.replace("'", "&#39;"); // 
            return str;
        }else if(str.contains("\"")){
            str = str.replace("\"", "\\\"");
            return str;
        }else{
            return str;
        }
    }
    %>
<%
	if (!HrmUserVarify.checkUserRight("eAssistant:faq", user)) {
	    response.sendRedirect("/notice/noright.jsp");
	    return;
	}
	String changeQ = "";
	String faqLabel = "";
	String changeA = "";
	String fromTable= "";
	String id = "";
	String labelOnlyFlg = "false";
	int labelSize = 0;//标签新增删除用
	
	// 需要编辑的ID
	String faqId = Util.null2String(request.getParameter("faqId"));
	// 操作的标识FLG
	String faqOperType = Util.null2String(request
			.getParameter("faqOperType"));
	if ("edit".equals(faqOperType)) {
        rs.execute("SELECT ID, FAQLABEL, FAQDESC,FAQANSWER,FROMTABLE  FROM FULLSEARCH_FAQDETAIL WHERE ID = "+ faqId);
        rs.next();
        changeQ = rs.getString("FAQDESC");
        faqLabel = rs.getString("FAQLABEL");
        changeA = rs.getString("FAQANSWER");
        id = rs.getString("ID");
        fromTable = Util.null2String(rs.getString("FROMTABLE"));
	}
	if(!fromTable.equals("")){
		labelOnlyFlg = "true";
	}
	//通过小e传过来的问题库
	String fromFaqId=Util.null2String(request.getParameter("fromFaqId"));
	if(!"".equals(fromFaqId)){
		rs.execute("select ask,answer from Fullsearch_E_Faq where id="+fromFaqId);
		if(rs.next()){
			changeQ=rs.getString("ask");
			changeA=rs.getString("answer");
			faqOperType="add";
		}
	}
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp"%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp"%>
<%
if(!"true".equals(labelOnlyFlg)){
	RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage())
    + ",javascript:saveInfo(),_self} ";	
}else{
	RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage())
    + ",javascript:saveInfo1(),_self} ";
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp"%>

<body>
	<jsp:include page="/systeminfo/commonTabHead.jsp">
		<jsp:param name="mouldID" value="eAssistant" />
		<jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(24419,user.getLanguage()) %>" />
	</jsp:include>

	<wea:layout attributes="{layoutTableId:topTitle}">
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
				<span title="<%=SystemEnv.getHtmlLabelName(86, user .getLanguage())%>" style="font-size: 12px; cursor: pointer;">
					 <%if(!"true".equals(labelOnlyFlg)){%>
					 <input class="e8_btn_top middle" onclick="saveInfo()" type="button" value="<%=SystemEnv.getHtmlLabelName(86, user .getLanguage())%>" />
					 <%}else{ %>
					 <input class="e8_btn_top middle" onclick="saveInfo1()" type="button" value="<%=SystemEnv.getHtmlLabelName(86, user .getLanguage())%>" />
					 <%} %>
				</span>
				<span
					title="<%=SystemEnv.getHtmlLabelName(82753, user
										.getLanguage())%>"
					class="cornerMenu"></span>
			</wea:item>
		</wea:group>
	</wea:layout>
	<div class="zDialog_div_content" style="height:518px;">
	<form method="post" action="ViewServiceLib.jsp" name="weaver"  onsubmit="javascript:return false;">
	<input type="hidden" name="faqOperType" id="faqOperType" value="<%=faqOperType%>">
	<input type="hidden" name="faqId" id="faqId" value="<%=faqId%>">
	<input type="hidden" name="labelOnlyFlg" id="labelOnlyFlg" value="<%=labelOnlyFlg%>">
	<input type="hidden" id="changeLabel" name="changeLabel" value="">
	<input type="hidden" id="fromFaqId" name="fromFaqId" value="<%=fromFaqId %>">
		<wea:layout
			attributes="{'expandAllGroup':'true'}">
			<wea:group
				context='<%=SystemEnv.getHtmlLabelName(1361, user
									.getLanguage())%>'>
				<wea:item><%=SystemEnv.getHtmlLabelNames("24419", user
										.getLanguage())%></wea:item>
                <wea:item>
					<%if(!"true".equals(labelOnlyFlg) || "add".equals(faqOperType)){ %>
					<input type="text" name="changeQ" class="inputstyle" id="changeQ"
                        onchange="checkinput('changeQ','nameImage1')" value='<%=StrFilter(changeQ)%>' >
                    <% }else{%>
                    <%=StrFilter(changeQ)%>
                    <%} %>
                    <SPAN id=nameImage1><%if("".equals(StrFilter(changeQ))) {%><img align="absmiddle" src="/images/BacoError_wev8.gif"><%} %></SPAN>
				</wea:item>

				<wea:item><%=SystemEnv.getHtmlLabelName(129059, user
										.getLanguage())%></wea:item>
				<wea:item>
                    <div id="totalLabel">
                    <%
                       String labelArr[] = faqLabel.split(" ");
                       labelSize = labelArr.length;
                       for(int i = 0; i<labelArr.length; i++){
                    	   if(i == 0){
                    		 %>
                    		 <div class="labelDiv" id="label<%=i %>" name="label"><input type="text" name="changeLabel<%=i %>" id="changeLabel<%=i %>" class="inputstyle"
                                value='<%=StrFilter(labelArr[i])%>' ><button style="vertical-align:middle" type="button" class="addbtn" id="addbtn" onclick="addLabel()" title="<%=SystemEnv.getHtmlLabelName(456,user.getLanguage())%>" ></button></div>
                    		 <%  
                    	   }else{%>
                    	   <div class="labelDiv" id="label<%=i %>" name="label"><input type="text" name="changeLabel<%=i %>" id="changeLabel<%=i %>" class="inputstyle"
                                value='<%=StrFilter(labelArr[i])%>' ><button style="vertical-align:middle" type='button' class=delbtn onclick="removeLabel(this)" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onFocus="this.blur()"></button></div>
                    		   <%
                    	   }
                       }
                    %>
                    </div>
				</wea:item>
			</wea:group>
			<wea:group
                context='<%=SystemEnv.getHtmlLabelName(128709, user
                                    .getLanguage())%>'>
                <wea:item attributes="{'isTableList':'true'}">
                <%if(!"true".equals(labelOnlyFlg) || "add".equals(faqOperType)){ %>
                    <textarea name="changeA" id="changeA" style="width:100%;"><%=changeA %></textarea>
                    <% }else{%>
                    <div style="padding:10px;height:364px;overflow:auto" id="changeA1" name="changeA1">
                        <%=changeA%>
                    </div>
                    <%} %>
                    
                </wea:item>
            </wea:group>
		</wea:layout>
	</form>
</div>
	<div style="" id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
			<wea:group context="" attributes="">
				<wea:item type="toolbar">
					<input type="button"
						value="<%=SystemEnv.getHtmlLabelName(309, user
										.getLanguage())%>"
						id="zd_btn_cancle" class="zd_btn_cancle"
						onclick="javascript:parentWin.closeDialog();">
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
	<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
</body>
</HTML>
<script language="javascript">
var labelSize = <%=labelSize%>;
var parentWin = parent.getParentWindow(window);
var doubleClick = false; 
function saveInfo(){
if(!doubleClick){
	doubleClick = true;
}else{
	return;
}
if(check_form(weaver,"changeQ")){
var changeLabels = "";
var aa=jQuery("#totalLabel").find("input[type='text']");
var label = "";
var labelArr = [];
var subLabel = "";
for(var key=0;key<aa.size();key++){
        label =jQuery(aa[key]).attr("value").replace(/(^\s*)|(\s*$)/g, "");
        labelArr= label.split(" ");  
        if(label==""){
            continue;
        }
        if(labelArr.length>0){
            for(var i =0;i<labelArr.length;i++){
                subLabel = labelArr[i].replace(/(^\s*)|(\s*$)/g, "");
                if(subLabel == ""){
                    continue;
                }else{
                    changeLabels+=subLabel + " ";
                }
            }
            
        }else{
            changeLabels +=label + " ";
        }
    }
jQuery("#changeLabel").val(changeLabels);
var editor_data = ue.getContent();
jQuery("#changeA").val(editor_data);
     jQuery.post("ViewFaqLib.jsp",{
     faqOperType:jQuery("#faqOperType").val(),
     faqId:jQuery("#faqId").val(),
     changeQ:jQuery("#changeQ").val(),
     changeA:jQuery("#changeA").val(),
     changeLabel:jQuery("#changeLabel").val(),
     fromFaqId:jQuery("#fromFaqId").val(),
     },function(){
        parentWin.closeDialog();
     });
  }
     
}

function saveInfo1(){
if(!doubleClick){
	doubleClick = true;
}else{
	return;
}
var changeLabels = "";
var aa=jQuery("#totalLabel").find("input[type='text']");
var label = "";
var labelArr = [];
var subLabel = "";
for(var key=0;key<aa.size();key++){
        label =jQuery(aa[key]).attr("value").replace(/(^\s*)|(\s*$)/g, "");
        labelArr= label.split(" ");  
        if(label==""){
            continue;
        }
        if(labelArr.length>0){
            for(var i =0;i<labelArr.length;i++){
                subLabel = labelArr[i].replace(/(^\s*)|(\s*$)/g, "");
                if(subLabel == ""){
                    continue;
                }else{
                    changeLabels+=subLabel + " ";
                }
            }
            
        }else{
            changeLabels +=label + " ";
        }
    }
jQuery("#changeLabel").val(changeLabels);
jQuery.post("ViewFaqLib.jsp",{
     faqOperType:jQuery("#faqOperType").val(),
     faqId:jQuery("#faqId").val(),
     labelOnlyFlg:jQuery("#labelOnlyFlg").val(),
     changeLabel:jQuery("#changeLabel").val(),
     },function(){
        parentWin.closeDialog();
     });
}
function onCancel(){
        var dialog = parent.getParentWindow(parent);
        dialog.closeDialog();
}


var ue ;

$(document).ready(function(){
    $("#changeA1").find("img").css("max-width","990px");
    $("#changeA1").find("a").css("color","red");
    $("#changeA1").find("a").css("text-decoration","underline!important");
    initFckEdit();
})

function initFckEdit(){
    ue = UE.getEditor('changeA',{
      toolbars: [[
            'fullscreen', 'source', '|',
            'bold', 'italic', 'underline', 'fontborder', 'strikethrough', '|', 'fontfamily', 'fontsize', 'forecolor', 'backcolor','|', 'insertorderedlist', 'insertunorderedlist',
            'lineheight',
            'indent','paragraph', '|',
            ,'justifyleft', 'justifycenter', 'justifyright', '|',
            'link', 'unlink', 'anchor', '|', 'imagenone', 'imageleft', 'imageright', 'imagecenter', '|',
            'insertimage', 'insertvideo', 'map', 'insertframe', 'background',
            'horizontal',  'spechars', '|',
            'inserttable' ,'|','cleardoc','removeformat', 'formatmatch','pasteplain', '|',
            'print', 'searchreplace', 'undo', 'redo'
        ]],
      initialFrameHeight:297,
      initialFrameWidth:1000,
      wordCount:false,
      elementPathEnabled : false,
      pasteplain:true
    });
    
}

function addLabel(){
labelSize++;
var innerhtml = '<div class="labelDiv" id="label' + labelSize + '" name="label" onmouseover="showDelBtn(' + labelSize +')" onmouseout="unShowDelBtn(' + labelSize +')"><input type="text" name="changeLabel' + labelSize +'" id="changeLabel' + labelSize +'" class="inputstyle" value="" ><button style="vertical-align:middle" type="button" class=delbtn onclick="removeLabel(this)" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onFocus="this.blur()"></button></div>';
$("#totalLabel").append(innerhtml);
}

function  removeLabel(index){
$(index).parent().remove();

}

</script>