
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	String companyid = Util.null2String(request.getParameter("companyid"));
	String searchaffix = Util.null2String(request.getParameter("searchaffix"));
	
		//--得到该公司下的所有的附件
		String sql =" select companyid ,shareaffix,type from ( "+
			// --查询出所有的附件,并且指定附件的类型(模块类型)
		   "  select t1.companyid, t1.shareaffix,'lmshare'type from CPSHAREHOLDER t1 "+
		   "   UNION  select t2.companyid,t2.drectorsaffix,'lmdirectors' type from CPBOARDDIRECTORS t2 "+
		   "   UNION  select t3.companyid,t3.constituaffix,'lmconstitution' type from CPCONSTITUTION t3 "+
		   "   UNION  select t4.companyid,t4.affixdoc,'lmlicense' type from CPBUSINESSLICENSE t4 where t4.isdel='T' "+
		   "   )  sb where companyid = '"+companyid+"' and  ( shareaffix is not null or shareaffix !='' ) ";
		   	//System.out.println("得到该公司下的所有的附件"+sql);
		rs.execute(sql);
		//用于记录每个附件id，所属的附件类型(模块类型)
		HashMap m=new HashMap();
		String affixdoc = "";
		while(rs.next()){
			affixdoc+=Util.null2String(rs.getString("shareaffix"));
			String temp_[]=Util.null2String(rs.getString("shareaffix")).split(",");
			String kewvalue=Util.null2String(rs.getString("type"));
			for(int jk=0;jk<temp_.length;jk++){
					if(null!=temp_[jk]&&!"".equals(temp_[jk])){
							m.put(temp_[jk], kewvalue);//记录每一个附件id所对应的模块类型
					}
			}
		}
		if(!affixdoc.equals("")){
			if (',' == affixdoc.charAt(affixdoc.length() - 1)){
				affixdoc = affixdoc.substring(0,affixdoc.lastIndexOf(","));
			}
		}
 %>

<!--表头浮动层 start-->


<jsp:include page="/systeminfo/commonTabHead.jsp">
<jsp:param name="mouldID" value="cpcompany"/>
<jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(128158,user.getLanguage())%>"/>
</jsp:include>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">
			
		</td>
	</tr>
</table>

	<div class="OContRightScroll FL OHeaderLayerW8 ML33" style="height:272px">
		<wea:layout>
			<wea:group context='<%=SystemEnv.getHtmlLabelName(30956,user.getLanguage())%>'>
				<wea:item attributes="{'isTableList':'true'}">
			
				<table id="webTable2gd" width="458" border="0" cellpadding="0" cellspacing="1" class="ListStyle">
					<colgroup>
							<col width="20%">
							<col width="*">
					</colgroup>
					
					<tr class="header">
						<th ><%=SystemEnv.getHtmlLabelName(30957,user.getLanguage())%></th>
						<th><%=SystemEnv.getHtmlLabelName(23752,user.getLanguage())%></th>
					</tr>
			<%
				searchaffix=searchaffix.replace("_","\\_");
				String sqldoc="  select imagefileid,imagefilename from imagefile ta where imagefileid in("+affixdoc+") and imagefilename like '%"+searchaffix+"%' ESCAPE '\\'";
				rs.execute(sqldoc);
				while(rs.next()){
			 %>	
			 	<tr>
					<td >
						<%
						  String _type=m.get(rs.getString("imagefileid"))+"";
						   if(_type.equals("lmlicense")){
								out.print(""+SystemEnv.getHtmlLabelName(30958,user.getLanguage()));
							}else if(_type.equals("lmconstitution")){
								out.print(""+SystemEnv.getHtmlLabelName(30941,user.getLanguage()));
							}else if(_type.equals("lmshare")){
								out.print(""+SystemEnv.getHtmlLabelName(28421,user.getLanguage()));
							}else if(_type.equals("lmdirectors")){
								out.print(""+SystemEnv.getHtmlLabelName(30936,user.getLanguage()));
							}else{
								out.print("");
							} 
						%>
					</td>
					<td >
						<A href="/weaver/weaver.file.FileDownload?fileid=<%=rs.getString("imagefileid") %>&download=1" class='aContent0 FL'><%=rs.getString("imagefilename") %></A>
					</td>
				</tr>
			<%
				}
			  %>
			</table>
				</wea:item>
			</wea:group>
		</wea:layout>
</div>


<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="doCancel(this)">
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>
<script type="text/javascript">
function doCancel(){
	parentDialog.close();
	//window.close();
}
</script>
<!--表头浮动层 end-->

<script type="text/javascript">
	/* 关闭 已打开的面板 */
	function closeMaint4Win()
	{
		jQuery("#searchImg").qtip('hide');
		jQuery("#searchImg").qtip('destroy');
	}
	
	//全部选择操作，复选框
	function selectall_chk(Tcheck){
	   if(Tcheck.checked==true){
	      $("input[type=checkbox][inWhichPage='gd']").each(function(){
				 $(this).attr("checked",true);
		  });
	   }else{
		  $("input[type=checkbox][inWhichPage='gd']").each(function(){
				 $(this).attr("checked",false);
		  });
	   }
	}
	 
	//选中其中的一个
	function selectone_chk(){
	    jQuery("#fileid").attr("checked",false); 
	}
	
	
</script>
