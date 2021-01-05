
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
	<script type="text/javascript">
		var dialog;
		var parentWin;
		jQuery(document).ready(function(){
			dialog = window.top.getDialog(window);
			parentWin = window.top.getParentWindow(window);
			if(parentWin.getCodeHtml()){
				jQuery.ajax({
					type:"POST",
					url:"/formmode/exceldesign/excelSecurity.jsp",
					dataType:"text",
					data:{str1:parentWin.getCodeHtml(),securitype:"decode"},
					success:function(res){
						try{
							if(jQuery.trim(res) == ""){
								setInitCodeDesc();
							}else{
								$("#codedesc").val(res);
							}
						}catch(e){	//报错后关闭不了的问题
						}
					}
				});
			}else{
				setInitCodeDesc();
			}
			
			$("body").resize(function(){
				$("#codedesc").css("height",($(".tab_box").height()-50)+"px");
			});
			window.setTimeout(function(){
				$("#codedesc").css("height",($(".tab_box").height()-50)+"px");
			},200);
		});
		
		
		
		function setInitCodeDesc(){
			var initCode = '<!-- script代码，如果需要引用js文件，请使用与HTML中相同的方式。 -->\n'
				+ '<script type="text\/javascript">\n'
				+ '    \/*\n'
				+ '    *  TODO\n'
				+ '     *  请在此处编写javascript代码\n'
				+ '     *\/\n'
				+ '<\/script>\n';
			$("#codedesc").val(initCode);
		}
		
		function setCodeDesc(){
			jQuery.ajax({
				type:"POST",
				url:"/formmode/exceldesign/excelSecurity.jsp",
				dataType:"text",
				data:{str1:$("#codedesc").val(),securitype:"encode"},
				
				success:function(res){
					try{
						parentWin.setCodeHtml(res);
						dialog.close();
					}catch(e)	//报错后关闭不了的问题
					{
						dialog.close();
					}
				}
			});
				
		}
		
	</script>
</HEAD>
 	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<BODY>
	<jsp:include page="/systeminfo/commonTabHead.jsp">
	   <jsp:param name="mouldID" value="workflow"/>
	   <jsp:param name="navName" value="插入代码块"/>
	</jsp:include>     	
	
	<wea:layout type="twoCol">
			    <wea:group context="代码块">
			    	<wea:item>
			    		<textarea style="margin-top:2px;margin-bottom:2px;margin-top: 2px;margin-bottom: 2px;resize: none;width: 90%;" rows="10" cols="20" name="codedesc" id="codedesc"></textarea>
			    	</wea:item>
			    </wea:group>
			</wea:layout>
		<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>			    		
      </div>
      <div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{groupDisplay:none}">
				<wea:item type="toolbar">
					<input type="button" value="确定" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="setCodeDesc()">
			    	<input type="button" value="取消" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()">
				</wea:item>
			</wea:group>
		</wea:layout>      
	  </div>
  </body>
   <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</BODY>
</HTML>
