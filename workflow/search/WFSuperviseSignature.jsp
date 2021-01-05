
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<% 
	String reqids = Util.null2String(request.getParameter("reqids"));
	String isclose = Util.null2String(request.getParameter("isclose"));
	
	int fromtype = Util.getIntValue(Util.null2String(request.getParameter("fromtype")), 0);
	int isSPA = Util.getIntValue(Util.null2String(request.getParameter("isSPA")), 0);
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>


<style type="text/css">

._signinputphraseblockClass .cg_block ul {
	width: 100%;
	list-style-position: outside;
	list-style: none;
	padding: 0;
	margin: 0;
}

._signinputphraseblockClass .cg_block ul li {
	padding:2px 5px 2px 5px;
	cursor:pointer;
}

._signinputphraseblockClass .cg_block ul li.cg_item:hover {
	background:#f4fcfa;
	/*#;*/
}

._signinputphraseblockClass .cg_splitline {
	border-bottom:1px dotted #bfbfc0;
	height:1px!important;
	margin:0 5px;
}

._signinputphraseblockClass .cg_title {
	color:#242424;
}
._signinputphraseblockClass .cg_detail {
	display:inline-block;width:100%;overflow: hidden;white-space: nowrap;text-overflow: ellipsis;
	color:#242424；

}

._signinputphraseblockClass .phrase_btn {
	color:#8d8d8d;
	display:inline-block;
	height:22px;
	line-height:22px;
	cursor:pointer;
}
/*
.cg_btn:hover {
	border:1px solid #d9d9d9;
}
*/
._signinputphraseblockClass .cg_allresli .cg_title {
	display:inline-block;margin-bottom:10px;margin-top:10px;
}

._signinputphraseblockClass .cg_detail {
	margin-top:5px;
}
._signinputphraseblockClass .phrase_arrowsblock {
	height:14px!important;
	width:14px!important;
	position: absolute;
	left:120px;
	bottom:-6px;
}

._signinputphraseblockClass {
	width:160px!important;
	POSITION:absolute;
}

._signinputphraseblockClass .cg_block {
	width:160px;
	border:1px solid #bfbfbf;margin-top:7px;
}

._signinputphraseblockClass .addphraseblockClass{
	display:none;padding:3px;width:243px;background:#e6f6ff;border:1px solid #c3dbea;margin-top:0px;text-align:left;
	margin-bottom:-1px;
	margin-left:-90px;
}

._signinputphraseblockClass .phraseinputClass {
	width:192px;height:30px;border:1px solid #c3dbea;
}
</style>
<!--签字意见-->
<link rel="stylesheet" type="text/css" href="/css/ecology8/workflowsign_wev8.css" />
<script type="text/javascript" language="javascript" src="/wui/common/js/ckeditor/ckeditor_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/wui/common/js/ckeditor/ckeditorext_wev8.js"></script>
<script language=javascript >
var isclose = "<%=isclose%>";

var dialog = parent.getDialog(window); 
var parentWin = parent.getParentWindow(window)
if(isclose === "1"){
	top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(30700,user.getLanguage()) %>');
	dialog.close();
	parentWin.location.reload();
}

function checkSubmit(){
    if(check_form(frmmain,'')){
        if ('<%=fromtype %>' == '1') {
        	var _tempRemark = jQuery("#remark").val();
        	if("<%=isSPA %>" == "1"){
        		dialog.close({remark:_tempRemark});
        	}else{
        	if (_tempRemark === '') {
				parentWin.OnMultiSubmitNew2(null, '');
        	} 
        	dialog.close(_tempRemark);
        	}
        } else {
        	frmmain.submit();
        }
    }
}
/*
var JPlaceHolder = {
    //检测

    _check : function(){
        return 'placeholder' in document.createElement('input');
    },
    //初始化

    init : function(){
        if(!this._check()){
            this.fix();
        }
    },
    //修复
    fix : function(){
        jQuery(':input[placeholder]').each(function(index, element) {
            var self = $(this), txt = self.attr('placeholder');
            self.wrap($('<div></div>').css({position:'relative', zoom:'1', border:'none', background:'none', padding:'none', margin:'none'}));
            var pos = self.position(), h = self.outerHeight(true), paddingleft = self.css('padding-left');
            var holder = $('<span></span>').text(txt).css({position:'absolute', left:pos.left, top:pos.top, height:h, lienHeight:h, paddingLeft:paddingleft, color:'#aaa'}).appendTo(self.parent());
            self.focusin(function(e) {
                holder.hide();
            }).focusout(function(e) {
                if(!self.val()){
                    holder.show();
                }
            });
            holder.click(function(e) {
                holder.hide();
                self.focus();
            });
        });
    }
};
*/
//执行
/*
jQuery(function(){
    JPlaceHolder.init();    
});
*/
var initphrase = function () {
	//点击其他地方，隐藏常用批示语选择框

	jQuery("html").live('mouseup', function (e) {
		if (jQuery("#_signinputphraseblock").is(":visible") && !!!jQuery(e.target).closest("#_signinputphraseblock")[0]) {
			jQuery("#_signinputphraseblock").hide();
			jQuery("#_addPhrasebtn").show()
			jQuery("#cg_splitline").show();
			jQuery("#addphraseblock").hide();
		}
		e.stopPropagation();
	});
	
	//combox html
	var comboxHtml = "" +
					"<div id=\"_signinputphraseblock\" class=\"_signinputphraseblockClass\" style='display:none;z-index:999;'>" +
					"	<div class=\"cg_block\"  style='background:#fff;'>" +
					"		<div id=\"_signinputphrasecontentblock\">" +
					"			<ul>" +
					"				<li style=\"padding:2px;\"></li>" +
					"			</ul>" +
					"	    </div>" +
					"		<div class=\"cg_splitline\" id=\"cg_splitline\" style='display:none;'></div>" +
					"		<ul>" +
					"			<li >" +
					"				<div class=\"cg_optblock\" style=\"text-align:center;margin:2px 0 4px 0px;\">" +
					"					<span class=\"phrase_btn\" style=\"color:#1ca96f;\" id=\"_addPhrasebtn\">" +
					"						<img src=\"/images/ecology8/workflow/phrase/addPhrase_wev8.png\" height=\"22px\" width=\"22px\"  style=\"vertical-align:middle;\"/>" +
					"						<span style=\"display:none;\">	" +
					"							 <%=SystemEnv.getHtmlLabelName(84562,user.getLanguage())%>" +
					"						</span>" +
					"					</span>" +
					"				</div>" +
					"			</li>" +
					"		</ul>" +
					"		<div id=\"addphraseblock\" class=\"addphraseblockClass\">" +
					"			<input type=\"text\" name=\"phraseinput\" id=\"phraseinput\" class=\"phraseinputClass\" style=\"\"><span style=\"margin-left:12px;color:#3c82b0;cursor:pointer;\" id=\"phraseqdbtn\"><%=SystemEnv.getHtmlLabelName(83446,user.getLanguage())%></span>" +
					"		</div>" +
					"	</div>" +
					"	<div class=\"phrase_arrowsblock\"><img src=\"/images/ecology8/workflow/phrase/addPhrasejt_down_wev8.png\" width=\"14px\" height=\"14px\"></div>" +
					"</div>"
	var comboxobj = jQuery(comboxHtml);
	//插入dom对象
	jQuery(document.body).append(comboxobj);
	
	//从隐藏的select中获取常用批示语
	var phraseselect = jQuery("#phraseselect option");
	var _ul = comboxobj.find("#_signinputphrasecontentblock ul");
    for (var i=1; i<phraseselect.length; i++) {
    	var phrasejsondata = jQuery(phraseselect[i]);
		
		var _style = "";			
    	if (_ul.children("li").length > 3)  {
			_style = " style='display:none;' ";
		}
		_ul.append("<li " + _style + " class=\"cg_item\"><span class='cg_detail'>" + phrasejsondata.html() + "</span></li>");
    }
    //删除‘添加常用批示语’ 文字
	if (comboxobj.find("#_signinputphrasecontentblock ul li").length > 1) {
    	jQuery(comboxobj).find("#cg_splitline").show();
    } else {
    	comboxobj.find("#_signinputphrasecontentblock ul").append("<li style=\"text-align:center;\" id='phrasedesc'><span class='cg_detail'><%=SystemEnv.getHtmlLabelName(84562,user.getLanguage())%></span></li>");
    }
	
	//添加按钮 鼠标交互时事件

	jQuery("#_addPhrasebtn").hover(function () {
		jQuery(this).children("img").hide();
		jQuery(this).children("span").show();
	}, function () {
		jQuery(this).children("img").show();
		jQuery(this).children("span").hide();
	});
	
	jQuery("#_addPhrasebtn").bind("click", function () {
		jQuery(this).hide()
		jQuery("#cg_splitline").hide();
		jQuery("#addphraseblock").show();
		jQuery("#phraseinput")[0].focus();
		
	});
	
	jQuery("#_signinputphrasecontentblock ul li").live("click", function () {
		var liarray = jQuery("#_signinputphrasecontentblock ul li");
		var j = 0;
		for (j=0; j<liarray.length; j++) {
			if (liarray[j] == this) {
				break;
			}
		}
		try {
           	_onAddPhrase(jQuery("#phraseselect option")[j].value);
           } catch (e) {
           }
           jQuery("#_signinputphraseblock").hide();
           jQuery("#_addPhrasebtn").show()
		jQuery("#cg_splitline").show();
		jQuery("#addphraseblock").hide();
	});
	
	//加常用短语

	var _onAddPhrase = function (phrase){
		if(phrase!=null && phrase!=""){
			var oldvl = jQuery("#remark").val();
			if (oldvl != '') {
				oldvl += "\r\n"; 
			}
			jQuery("#remark").val(oldvl + phrase);
			
		}
	}
	
	jQuery("#phraseqdbtn").bind("click", function () {
		var phrasetext = jQuery("#phraseinput").val();
		if (phrasetext != '') {
			
			phrasetext = jQuery("<div>" + phrasetext + "</div>").text();
			
			jQuery("#_signinputphrasecontentblock ul").append("<li class=\"loaddingli\"><span class='cg_detail' style='color:#7f7f7f;'><%=SystemEnv.getHtmlLabelName(147338,user.getLanguage()) %></span></li>");
			jQuery("#_signinputphrasecontentblock").scrollTop(jQuery("#_signinputphrasecontentblock ul").height());
			jQuery.ajax({
				type: "get",
				cache: false,
				url: "/workflow/sysPhrase/PhraseOperate.jsp?operation=add&phraseShort=" + encodeURIComponent(phrasetext) + "&phraseDesc=" + encodeURIComponent(phrasetext),
			    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
			    complete: function(){
				},
			    error:function (XMLHttpRequest, textStatus, errorThrown) {
			    } , 
			    success : function (data, textStatus) {
			    	jQuery("#phraseinput").val("");
			    	jQuery("#phrasedesc").remove();
			    	
			    	var lastli = jQuery("#_signinputphrasecontentblock ul .loaddingli");
			    	
					if (jQuery("#_signinputphrasecontentblock ul li").length > 3)  {
						jQuery("#_signinputphrasecontentblock").css("height", jQuery("#_signinputphrasecontentblock").height() + "px");
						jQuery("#_signinputphrasecontentblock").css("overflow", "hidden");
						jQuery("#_signinputphrasecontentblock").perfectScrollbar({horizrailenabled:false,zindex:1000});
					}
					lastli.removeClass("loaddingli");
					lastli.addClass("cg_item");
					lastli.html("<span class='cg_detail'>" + phrasetext + "</span>");
					//jQuery("#_signinputphrasecontentblock ul").append("<li class=\"cg_item\"><span class='cg_detail'>" + phrasetext + "</span></li>");
					var phraseselect = jQuery("#phraseselect").append("<option value=\"" + phrasetext.replace(/"/g,"&quot;") + "\">" + phrasetext + "</option>");
					
					//jQuery("#_signinputphrasecontentblock").scrollTop(999);
					//jQuery("#_signinputphrasecontentblock").scrollTop(jQuery("#_signinputphrasecontentblock ul").height());
			    }
			});
			
		}
		jQuery("#_addPhrasebtn").show()
		jQuery("#cg_splitline").show();

		
		jQuery("#addphraseblock").hide();
	    
	});
};

_firstclc = true;
jQuery(function () {
initphrase();
$("#addphresbtn").bind("click" , function () {
//这里可以不用执行命令,做你自己的操作也可

            var el = jQuery(this);
            var px=el.offset().left - (jQuery("#_signinputphraseblock").width() - jQuery(this).width()) + 19;
		    var py=el.offset().top - jQuery("#_signinputphraseblock").height() - 6;
		    jQuery("#_signinputphraseblock").css({"top":py + "px", "left":px+"px"});
			jQuery("#_signinputphraseblock").show();
			
			if (_firstclc) {
		    	_firstclc = false;
		    	var _outdiv = jQuery("#_signinputphrasecontentblock");
		    	var _li = jQuery("#_signinputphrasecontentblock ul li");
		    	if (_li.length > 3)  {
					jQuery("#_signinputphrasecontentblock").css("height", jQuery("#_signinputphrasecontentblock").height() + "px");
					jQuery("#_signinputphrasecontentblock").css("overflow", "hidden");
					jQuery("#_signinputphrasecontentblock").perfectScrollbar({horizrailenabled:false,zindex:1000});
					_li.show();
				}
		    }
});
});
</script>
</HEAD>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %> 
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage()) %>"/>
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" onclick="checkSubmit()" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(fromtype == 1 ? 17598 : 21223,user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="zDialog_div_content" style="overflow:hidden;">
<FORM id=frmmain name=frmmain action="/workflow/search/WFSuperviseSignatureOperation.jsp" method=post>
	<input type="hidden" name="reqids" value="<%=reqids %>" >
	<textarea class=Inputstyle name=remark id="remark" rows=7 
	style="width:100%;margin-top:-1px;color: gray;overflow-x:hidden;overflow-y:auto;color:#000;" 
	temptitle="<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>" 
	></textarea>
</FORM>


<span id="addphresbtn" style="border:1px solid #3b7ffb;padding:0px 10px;display:inline-block;text-alig:center;line-height:26px;float:right;margin-right:15px;margin-top:15px;cursor:pointer;">
	<img src="/ueditor/custbtn/images/phraselist_wev8.png" width="16px" height="16px" style="margin-top:-4px;" valign="middle">
	<%=SystemEnv.getHtmlLabelName(33861, user.getLanguage()) %> 
</span>

		<div style="display:none;">
		<select class=inputstyle notBeauty=true id="phraseselect" beautySelect="true" name=phraseselect style="width: 150px!important;" onChange='onAddPhrase(this.value)' onmousewheel="return false;">
		      <option value=""> －－<%=SystemEnv.getHtmlLabelName(22409, user.getLanguage())%>－－ </option>
		      <%
		      boolean isSuccess  = RecordSet.executeProc("sysPhrase_selectByHrmId",""+ user.getUID()); 
		   		String workflowPhrases[] = new String[RecordSet.getCounts()];
		   		String workflowPhrasesContent[] = new String[RecordSet.getCounts()];
		   		int x = 0 ;
		   		if (isSuccess) {
		   			while (RecordSet.next()){
		   				workflowPhrases[x] = Util.null2String(RecordSet.getString("phraseShort"));
		   				workflowPhrasesContent[x] = Util.toHtml(Util.null2String(RecordSet.getString("phrasedesc")));
		   				x ++ ;
		   			}
		   		}
		                       if (workflowPhrases.length > 0) {
		                       //常用提示语

		                                  for (int i = 0; i < workflowPhrases.length; i++) {
		                                              String workflowPhrase = workflowPhrases[i];
		                              %>
								      <option value="<%=Util.delHtml(workflowPhrasesContent[i]).replaceAll("%nbsp;", " ").replaceAll("\"", "&quot;")%>"><%=workflowPhrase%></option>
								      <%
								          }
								      
								}
								%>
		  </select>
		</div>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
</BODY>
</HTML>
