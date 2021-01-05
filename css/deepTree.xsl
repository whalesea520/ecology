<?xml version="1.0"?>


<xsl:stylesheet xmlns:xsl="http://www.w3.org/TR/WD-xsl">
	<xsl:template match="/">
	<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="/Tree">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="TreeNode">
		<div class="clsItem" type="leaf">
		        <xsl:choose>
				<xsl:when test="@NodeImgSrc">
					<img type="img">
						<xsl:attribute name="src"><xsl:value-of select="@NodeImgSrc"/></xsl:attribute>
					</img>
				</xsl:when>
				<xsl:otherwise>
				
					<span class="clsNone" type="img">
						<!--span class="clsLeaf">.</span-->
					   <img type="img">
						<xsl:attribute name="src">/images/treeimages/blank.gif</xsl:attribute>
					   </img>	
						
					        
					</span>
				        
					
										
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="@Icon">
                <span  class="clsLabel">
                        <img  type="icon">
							<xsl:attribute name="src"><xsl:value-of select="@Icon"/></xsl:attribute>
						</img>
                </span>
            </xsl:if>
			<span  class="clsLabel" type="label">





				<xsl:attribute name="id"><xsl:value-of select="@NodeId"/></xsl:attribute>
				<xsl:attribute name="nodeType"><xsl:value-of select="@nodeType"/></xsl:attribute>
				<xsl:attribute name="title"><xsl:value-of select="@Title"/></xsl:attribute>
				<xsl:choose>
					<xsl:when test="@Href">
						<a>
							<xsl:choose>
								<xsl:when test="@Target">
									<xsl:attribute name="target"><xsl:value-of select="@Target"/></xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="target">fraContent</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:attribute name="tabindex">-1</xsl:attribute>
							<xsl:attribute name="href"><xsl:value-of select="@Href"/></xsl:attribute>
							<xsl:value-of select="@Title"/>
						</a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="@Title"/>
					</xsl:otherwise>
				</xsl:choose>
			</span>
			<xsl:if test="@checkbox">
						<input type="checkbox" name="selObj">
							<xsl:attribute name="value"><xsl:value-of select="@value"/></xsl:attribute>
							<xsl:attribute name="onclick"><xsl:value-of select="@oncheck"/></xsl:attribute>
							<xsl:if test="@checked">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</input>
			</xsl:if>
			<xsl:if test="@radio">
						<input type="radio" name="selObj">
							<xsl:attribute name="value"><xsl:value-of select="@value"/></xsl:attribute>
							<xsl:attribute name="onclick"><xsl:value-of select="@oncheck"/></xsl:attribute>
							<xsl:if test="@checked">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</input>
			</xsl:if>
		</div>
	</xsl:template>
	<xsl:template match="TreeNode[* or @NodeXmlSrc]">
		<div class="clsItem" type="parent">
		     <xsl:choose>
		        <xsl:when test="@NodeXmlSrc">
			   <xsl:attribute name="state">hidden</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
			   <xsl:attribute name="state">shown</xsl:attribute>
			</xsl:otherwise>
		   </xsl:choose>

			<span class="clsCollapse" type="img">
				<!--span class="clsCollapse">+</span-->
				<img type="img">
				  <xsl:choose>
				          <xsl:when test="@NodeXmlSrc">
						<xsl:attribute name="src">/images/treeimages/expand_xp.gif</xsl:attribute>
					  </xsl:when>
					  <xsl:otherwise>
						<xsl:attribute name="src">/images/treeimages/collapse_xp.gif</xsl:attribute>
					  </xsl:otherwise>
				 </xsl:choose>
		                </img>
			</span>




			<xsl:if test="@Icon">
                <span  class="clsLabel" >
                <img  type="icon">
					<xsl:attribute name="src"><xsl:value-of select="@Icon"/></xsl:attribute>
				</img>
                </span>
            </xsl:if>
			<span class="clsLabel" type="label">
			
			
				<xsl:attribute name="xmlsrc"><xsl:value-of select="@NodeXmlSrc"/></xsl:attribute>
				<xsl:attribute name="id"><xsl:value-of select="@NodeId"/></xsl:attribute>
				<xsl:attribute name="nodeType"><xsl:value-of select="@nodeType"/></xsl:attribute>
				<xsl:attribute name="title"><xsl:value-of select="@Title"/></xsl:attribute>
				<xsl:choose>
					<xsl:when test="@Href">
						<a>
							<xsl:choose>
								<xsl:when test="@Target">
									<xsl:attribute name="target"><xsl:value-of select="@Target"/></xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="target">fraContent</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:attribute name="tabindex">-1</xsl:attribute>
							<xsl:attribute name="href"><xsl:value-of select="@Href"/></xsl:attribute>
							<xsl:value-of select="@Title"/>
						</a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="@Title"/>
					</xsl:otherwise>
				</xsl:choose>
			</span>
			
			<xsl:if test="@checkbox">
				<input type="checkbox" name="selObj">
					<xsl:attribute name="value"><xsl:value-of select="@value"/></xsl:attribute>
					<xsl:attribute name="onclick"><xsl:value-of select="@oncheck"/></xsl:attribute>
					<xsl:if test="@checked">
						<xsl:attribute name="checked">checked</xsl:attribute>
					</xsl:if>
				</input>
			</xsl:if>
			<xsl:if test="@radio">
				<input type="radio" name="selObj">
					<xsl:attribute name="value"><xsl:value-of select="@value"/></xsl:attribute>
					<xsl:attribute name="onclick"><xsl:value-of select="@oncheck"/></xsl:attribute>
					<xsl:if test="@checked">
						<xsl:attribute name="checked">checked</xsl:attribute>
					</xsl:if>
				</input>
			</xsl:if>
			
			<div class="shown" type="container" >
				<xsl:apply-templates/>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="@Target">
		<xsl:copy>
			<xsl:value-of/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="/TreeNode">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="TreeNode/Tree">
		<xsl:apply-templates/>
	</xsl:template>
</xsl:stylesheet>
