<?xml version="1.0" encoding="gb2312"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" encoding="GBK"/>
	<xsl:param name="currpath">/portal/plugin/homepage/web1/left</xsl:param>	
	
	<xsl:template match="/">	
		<div id="divJingjiang">			
			
			 <ul id="ulMenu"> 
     		        <xsl:call-template name="TreeNode">   
			     <xsl:with-param name="Nodes" select="tree/*" />   
	                </xsl:call-template>   
			</ul>
		</div>
	</xsl:template>
	<xsl:template name="TreeNode">   
	 <!--将树集合的节点通过param传过来-->   
	 <xsl:param name="Nodes" />   
	 <!--循环所有子节点，即Item-->   
	 <xsl:for-each select="$Nodes">   
	  <!--计算子节点的数量-->   
	  	 
	  <xsl:variable name="Count" select="count(tree)" />   	  	
	  <xsl:variable name="linkAddress" select="@linkAddress" /> 
	  <xsl:variable name="icon" select="@icon" /> 
	  <xsl:variable name="openmode" select="@baseTarget" /> 
	  <xsl:variable name="id" select="@id" />  
	  <xsl:variable name="display" select="@display" /> 
	  <xsl:variable name="mainMenuId" select="@mainMenuId" /> 
	  <li> 
	     <div>
		
			<span class="spanLeft">
				<a  style="cursor:hand" onclick="javascript:onLeftMenuClick(this,'{$id}','{$linkAddress}','{$openmode}','{$mainMenuId}')">
					<!--<img src="{@icon}" border="0"/>-->
					<xsl:choose>
						<xsl:when test="../@id='0'">
							<img src="images/entity.jpg" border="0"/>
						</xsl:when>
						  <xsl:otherwise>
							<img src="images/entitysub.jpg" border="0"/>
						</xsl:otherwise>
					 </xsl:choose>
					<xsl:value-of select="@text"/>					
				</a>  
			</span>


			 <xsl:choose>
			 
			      <xsl:when test="$Count>0  or $mainMenuId!=''">
					<xsl:choose>
						<xsl:when test="$display=1">
							<span class="spanRight" style="font-family:webdings!important" onclick="showorhidden(this,'{$mainMenuId}')">5</span>
						</xsl:when>
						  <xsl:otherwise>
							<span class="spanRight" style="font-family:webdings!important" onclick="showorhidden(this,'{$mainMenuId}')">6</span>
						</xsl:otherwise>
					 </xsl:choose>

			      </xsl:when>
			     
			      <xsl:otherwise>
				 <span class="spanRightNone" style="font-family:webdings!important">6</span>
			      </xsl:otherwise>
			   </xsl:choose>

			

		
	     </div>
	  </li>   

	  <!--如果有下级级点，则递归获取节点-->   
	  <xsl:if test="$Count>0">   
	  <xsl:choose>
		<xsl:when test="$display=1">
			  <ul id="ul_leftMenu_{$id}" style="display:block">
			   <xsl:call-template name="TreeNode">   
			     <xsl:with-param name="Nodes" select="*" />   
			    </xsl:call-template>
			   </ul>
		</xsl:when>
		  <xsl:otherwise>
			  <ul id="ul_leftMenu_{$id}" style="display:none">
			   <xsl:call-template name="TreeNode">   
			     <xsl:with-param name="Nodes" select="*" />   
			    </xsl:call-template>
			   </ul>
		</xsl:otherwise>
	 </xsl:choose>

	  
	   
	   

	  </xsl:if>   
	 </xsl:for-each>   
	</xsl:template>   
</xsl:stylesheet>
