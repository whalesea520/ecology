<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.file.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="FormComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />
<jsp:useBean id="FormFieldMainManager" class="weaver.workflow.form.FormFieldMainManager" scope="page" />
<jsp:useBean id="FormFieldlabelMainManager" class="weaver.workflow.form.FormFieldlabelMainManager" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
	FileUpload fu = new FileUpload(request);
	
	String sql = "";
	String props[]=new String[10];
	String formfields = "";
	String formdetailfields = "";
	
	String allobjs = Util.null2String(fu.getParameter("allobjs")) ;
	
	int formid = Util.getIntValue(fu.getParameter("formid"),0) ;	
	String type = Util.null2String(fu.getParameter("src")) ;
	String submittypetmp = Util.null2String(fu.getParameter("submittypetmp")) ;
	String isview = Util.null2String(fu.getParameter("isview")) ;
	
	
	String formname = Util.null2String(fu.getParameter("prop_0_1")) ;
	String formdes = Util.null2String(fu.getParameter("prop_0_2")) ;
	
	if(type.equals("addform")){
	
		//添加Form的基本信息
		sql = "insert into workflow_formbase(formname,formdesc) values('"+formname+"','"+formdes+"')";
		rs.executeSql(sql);
		sql = "select max(id) from workflow_formbase";
		rs.executeSql(sql);
		if(rs.next())
			formid = rs.getInt(1);
	}else{
		sql = "update workflow_formbase set formname='"+formname+"',formdesc='"+formdes+"' where id = "+formid;
		rs.executeSql(sql);		
	}
	
	//获取Form对象的属性
	String allobjslist[] = Util.TokenizerString2(allobjs,",");	
		
	FormFieldMainManager.resetParameter();
	FormFieldMainManager.setFormid(formid);
	
	//检查是否有冲突
	if(type.equals("editform")){
		String _formfields = "";
		String _formdetailfields = "";
		for(int i=0;i<allobjslist.length;i++)
		{
			String theobj = allobjslist[i];
			if(theobj.equals(""))
				continue;
			String theobjtype = "0";
			
			int tmppos = theobj.indexOf("_");
			if(tmppos!=-1){
				theobjtype = theobj.substring(0,tmppos);
			}
			
			String _field =  Util.null2String(fu.getParameter("prop_"+theobj+"_2")) ;		//field
			String _isdetail =  Util.null2String(fu.getParameter("prop_"+theobj+"_10")) ;	//isdetail
			
			
			String _strCheck = ",3,4,5,6,9,";
			if(_strCheck.indexOf(","+theobjtype+",") != -1){
				if(_isdetail.equals("0"))	_formfields += _field+",";
				else	_formdetailfields += _field+",";
			}
		}
		
	
		if(FormFieldMainManager.checkByRef(_formfields,_formdetailfields)){
		%>
<script language=javascript>
	window.parent.location = "FormDesignMain.jsp?src=editform&formid=<%=formid%>&errorcode=1";
</script>
<%
		        return;
		}	
		FormFieldMainManager.deleteFormfield();
		FormFieldMainManager.deleteDetailFormfield();
		
		
		FormFieldlabelMainManager.resetParameter();
		FormFieldlabelMainManager.setFormid(formid);
		FormFieldlabelMainManager.deleteFormfield();
		
		sql = "delete from workflow_formprop where formid = "+formid;
		rs.executeSql(sql);
		
	}
	
		
		
	for(int i=0;i<allobjslist.length;i++)
	{
		String theobj = allobjslist[i];
		if(theobj.equals(""))
			continue;
		String theobjtype = "0";
		String theobjid = "0";
		
		int tmppos = theobj.indexOf("_");
		if(tmppos!=-1){
			theobjtype = theobj.substring(0,tmppos);
			theobjid = theobj.substring(tmppos+1);
		}
		
		props[0] = theobjid;
		props[1] = theobjtype;
		props[2] =  Util.null2String(fu.getParameter("prop_"+theobj+"_1")) ; 	//name
		props[3] =  Util.null2String(fu.getParameter("prop_"+theobj+"_2")) ;		//field
		props[4] =  Util.null2String(fu.getParameter("prop_"+theobj+"_3")) ;		//defvalue
		props[5] =  Util.null2String(fu.getParameter("prop_"+theobj+"_ptx")) ;	//ptx
		props[6] =  Util.null2String(fu.getParameter("prop_"+theobj+"_pty")) ;	//pty
		props[7] =  Util.null2String(fu.getParameter("prop_"+theobj+"_width")) ;	//width
		props[8] =  Util.null2String(fu.getParameter("prop_"+theobj+"_height")) ;	//height
		props[9] =  Util.null2String(fu.getParameter("prop_"+theobj+"_10")) ;	//isdetail
		String color = Util.null2String(fu.getParameter("prop_"+theobj+"_11")) ;	//color
		
		if(theobjtype.equals("2") && props[2].indexOf("/weaver/weaver.file.FileDownload?fileid=")==-1){
			String fileids = fu.uploadFiles("prop_"+theobj+"_1");
			if(!fileids.equals(""))
				props[2] = "/weaver/weaver.file.FileDownload?fileid="+fileids;
			
		}
		if(theobjtype.equals("1")){
			String isbold =  Util.null2String(fu.getParameter("prop_"+theobj+"_4")) ;
			props[4] +=":"+isbold;
		}
		
		String _strCheck = ",3,4,5,6,9,";
		if(_strCheck.indexOf(","+props[1]+",") != -1){
			if(props[9].equals("0"))	formfields += props[3]+",";
			else	formdetailfields += props[3]+",";
			
			FormFieldlabelMainManager.resetParameter();
			FormFieldlabelMainManager.setFormid(formid);
			FormFieldlabelMainManager.setFieldid(Util.getIntValue(props[3],0));
			FormFieldlabelMainManager.setLanguageid(7);
			String label = props[2];		
			FormFieldlabelMainManager.setFieldlabel(label);
			FormFieldlabelMainManager.setIsdefault("1");
			FormFieldlabelMainManager.saveFormfieldlabel();
		}
				
		
		if(_strCheck.indexOf(","+props[1]+",") != -1)
			sql = "insert into workflow_formprop(formid,objid,objtype,fieldid,isdetail,ptx,pty,width,height,defvalue,attribute2) values("+formid+","+props[0]+","+props[1]+","+props[3]+","+props[9]+","+props[5]+","+props[6]+","+props[7]+","+props[8]+",'"+props[4]+"','"+color+"')";
		else
			sql = "insert into workflow_formprop(formid,objid,objtype,ptx,pty,width,height,defvalue,attribute1,attribute2) values("+formid+","+props[0]+","+props[1]+","+props[5]+","+props[6]+","+props[7]+","+props[8]+",'"+props[2]+"','"+props[3]+"','"+props[4]+"')";
		if(!props[1].equals("0"))
			rs.executeSql(sql);
	}

	


	FormFieldMainManager.saveFormfield(Util.TokenizerString2(formfields,","));
	
	
	
	FormFieldMainManager.saveDetailFormfield(Util.TokenizerString2(formdetailfields,","));
	
	
  	  FormComInfo.removeFormCache();
  
	if(submittypetmp!=null&&submittypetmp.equals("1")){
  
%>
<script language=javascript>
	window.parent.location = "manageform.jsp";
</script>

<%}else{
%>
<script language=javascript>
	window.parent.location = "FormDesignMain.jsp?src=editform&formid=<%=formid%>&isview=<%=isview%>";
</script>
<%}%>

 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236, user.getLanguage())%>" onClick="javascript:history.go(-1)">