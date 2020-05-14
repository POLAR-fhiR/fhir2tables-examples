<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0"
                xpath-default-namespace="http://hl7.org/fhir">
   <xsl:param name="eol" select="'&#xD;&#xA;'"/>
   <xsl:param name="sep" select="';'"/>
   <xsl:output method="text"/>
   <xsl:template match="/Bundle">
      <xsl:value-of select="'PID'"/>
      <xsl:value-of select="$sep"/>
      <xsl:value-of select="'DIA'"/>
      <xsl:value-of select="$sep"/>
      <xsl:value-of select="'SYS'"/>
      <xsl:value-of select="$eol"/>
      <xsl:apply-templates select="entry/resource/Observation"/>
   </xsl:template>
   <xsl:template match="Observation">
      <xsl:variable name="patientId"
                    select="substring-after(subject/reference/@value,'Patient/')"/>
      <xsl:variable name="patient" select="//Patient[id/@value=$patientId]"/>
      <xsl:value-of select="$patientId"/>
      <xsl:value-of select="$sep"/>
      <xsl:value-of select="component[.//code/@value='8462-4']/valueQuantity/value/@value"/>
      <xsl:value-of select="$sep"/>
      <xsl:value-of select="component[.//code/@value='8480-6']/valueQuantity/value/@value"/>
      <xsl:value-of select="$eol"/>
   </xsl:template>
</xsl:stylesheet>
