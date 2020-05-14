<?xml version="1.0" encoding="UTF-8"?>

<!--
	Generator zum Erzeugen von FHIR2CSV Stylesheets
	Frank Meineke, 11.3.2020, frank.meineke@imise.uni-leipzig.de
	Version für Saxon
-->
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:axsl="http://www.w3.org/1999/XSL/TransformAlias"
	>
	<xsl:output method="xml" indent="yes"/>

	<xsl:namespace-alias stylesheet-prefix="axsl" result-prefix="xsl"/>

	<xsl:param name="eol" select="'&#13;&#10;'" />
	<xsl:param name="sep" select="';'" />
	<xsl:variable name="apos">'</xsl:variable>

	<xsl:output method="xml"/>

	<xsl:template match="/table">
		<axsl:stylesheet version="1.0" 
			xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
			xpath-default-namespace="http://hl7.org/fhir">

			<axsl:param name="eol" select="'&#13;&#10;'" />
			<axsl:param name="sep" select="';'" />

			<axsl:output method="text"/>

			<axsl:template match="/Bundle">
				<xsl:for-each select="column">					
					<axsl:value-of>
						<xsl:attribute name="select" select="concat($apos,@label,$apos)"/>
					</axsl:value-of>
					<xsl:if test="not(position() = last())">
						<axsl:value-of select="$sep"/>
					</xsl:if>					
				</xsl:for-each>
				<axsl:value-of select="$eol"/>
				<axsl:apply-templates>
					<xsl:attribute name="select" select="concat('entry/resource/',@of)"/>
				</axsl:apply-templates>
			</axsl:template>
			<axsl:template>	
				<xsl:attribute name="match" select="@of"/>
				<axsl:variable name="patientId" select="substring-after(subject/reference/@value,'Patient/')"/>
				<axsl:variable name="patient" select="//Patient[id/@value=$patientId]"/>
				<xsl:for-each select="column">					
					<axsl:value-of>
						<xsl:attribute name="select" select="@search"/>
					</axsl:value-of>					
					<xsl:if test="not(position() = last())">
						<axsl:value-of select="$sep"/>
					</xsl:if>					
				</xsl:for-each>
				<axsl:value-of select="$eol"/>			
			</axsl:template>
		</axsl:stylesheet>
	</xsl:template>

</xsl:stylesheet>
