
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<jsp:useBean id="BaseBeanOfWebRevision" class="weaver.general.BaseBean" scope="page" />
<%
	String revisionServerName="RevisionServer.jsp";
	//String revisionClientName="iWebRevision.cab#version=6,1,0,112";
	//String revisionClassId="clsid:2294689C-9EDF-40BC-86AE-0438112CA439";
	String revisionClientName=BaseBeanOfWebRevision.getPropValue("weaver_iWebRevision","revisionClientName");
    if(revisionClientName==null||revisionClientName.trim().equals("")){
		revisionClientName="iWebRevision.cab#version=6,1,0,112";
	}

	String revisionClassId=BaseBeanOfWebRevision.getPropValue("weaver_iWebRevision","revisionClassId");
    if(revisionClassId==null||revisionClassId.trim().equals("")){
		revisionClassId="clsid:2294689C-9EDF-40BC-86AE-0438112CA439";
	}

	String CASignType=BaseBeanOfWebRevision.getPropValue("weaver_iWebRevision","CASignType");
    if(CASignType==null||CASignType.trim().equals("")){
		CASignType="0";
	}

	String SignatureType=BaseBeanOfWebRevision.getPropValue("weaver_iWebRevision","SignatureType");
    if(SignatureType==null||SignatureType.trim().equals("")){
		SignatureType="0";
	}

	String DocEmptyJuggle=BaseBeanOfWebRevision.getPropValue("weaver_iWebRevision","DocEmptyJuggle");
    if(DocEmptyJuggle==null||DocEmptyJuggle.trim().equals("")){
		DocEmptyJuggle="true";
	}
%>

