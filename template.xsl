<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cq="http://www.day.com/jcr/cq/1.0" xmlns:jcr="http://www.jcp.org/jcr/1.0" xmlns:nt="http://www.jcp.org/jcr/nt/1.0" xmlns:sling="http://sling.apache.org/jcr/sling/1.0">
	<xsl:output method="xml" indent="yes" />
	<xsl:template match="/">
		<jcr:root
			jcr:primaryType="cq:Page">
			<jcr:content
				jcr:primaryType="nt:unstructured"
				sling:resourceType="cedars-sinai/pages/page">
				<xsl:attribute name="jcr:title">
					<xsl:value-of select="root/pageContent/field[@name='rx:www_navbartitle']" />
				</xsl:attribute>
				<xsl:attribute name="jcr:description">
					<xsl:value-of select="root/pageContent/field[@name='rx:www_metatags']" />
				</xsl:attribute>
				<par
					jcr:primaryType="nt:unstructured"
					sling:resourceType="wcm/foundation/components/parsys">
					<title
						jcr:primaryType="nt:unstructured"
						type="h1"
						sling:resourceType="cedars-sinai/global/title">
						<xsl:attribute name="jcr:title">
							<xsl:value-of select="root/pageContent/field[@name='rx:www_headertitle']" />
						</xsl:attribute>
					</title>
					<text
						jcr:primaryType="nt:unstructured"
						sling:resourceType="cedars-sinai/global/text">
						<xsl:attribute name="text">
							<xsl:value-of select="root/pageContent/field[@name='rx:body']" />
						</xsl:attribute>
					</text>
					<slots 
						jcr:primaryType="nt:unstructured"
					   sling:resourceType="wcm/foundation/components/parsys">
						<xsl:for-each select="root/slots/slot">
							<xsl:variable name="posi" select="position()"/>
					 		<xsl:element name="{concat('image-', $posi)}"
	                			jcr:primaryType="nt:unstructured"
	                			sling:resourceType="foundation/components/image">
	                			<xsl:attribute name="fileReference">
									<xsl:value-of select="slotContent/link" />
								</xsl:attribute>
	                		</xsl:element>
                		</xsl:for-each>
                		</slots>		
				</par>
				
                </jcr:content>
		</jcr:root>
	</xsl:template>
</xsl:stylesheet>