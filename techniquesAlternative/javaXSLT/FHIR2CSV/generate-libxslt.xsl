<x:stylesheet xmlns:x="http://www.w3.org/1999/XSL/Transform" xmlns:xsl="output.xsl" version="1.0">
	<x:namespace-alias stylesheet-prefix="xsl" result-prefix="x"/>

	<x:param name="eol" select="'&#13;&#10;'" />
	<x:param name="sep" select="';'" />
	<x:variable name="apos">'</x:variable>

	<x:template match="/">
		<xsl:stylesheet version="1.0">
			<xsl:param name="eol" select="'&#13;&#10;'" />
			<xsl:param name="sep" select="';'" />

			<xsl:output method="text"/>
			<x:apply-templates/>
		</xsl:stylesheet>
	</x:template>

	<x:template match="/table">
		<xsl:template match="/Bundle">
			<x:for-each select="column">					
				<xsl:value-of>
					<x:attribute name="select"><x:value-of select="concat($apos,@label,$apos)"/></x:attribute>
				</xsl:value-of>
				<x:if test="not(position() = last())">
					<xsl:value-of select="$sep"/>
				</x:if>					
			</x:for-each>
			<xsl:value-of select="$eol"/>
			<xsl:apply-templates>
				<x:attribute name="select"><x:value-of select="concat('entry/resource/',@of)"/></x:attribute>
			</xsl:apply-templates>
		</xsl:template>
		<xsl:template>	
			<x:attribute name="match"><x:value-of select="@of"/></x:attribute>
			<xsl:variable name="patientId" select="substring-after(subject/reference/@value,'Patient/')"/>
			<xsl:variable name="patient" select="//Patient[id/@value=$patientId]"/>
			<x:for-each select="column">					
				<xsl:value-of>
					<x:attribute name="select"><x:value-of select="@search"/></x:attribute>
				</xsl:value-of>					
				<x:if test="not(position() = last())">
					<xsl:value-of select="$sep"/>
				</x:if>					
			</x:for-each>
			<xsl:value-of select="$eol"/>			
		</xsl:template>
	</x:template>
</x:stylesheet>