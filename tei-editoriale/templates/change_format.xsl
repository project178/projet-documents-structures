<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xpath-default-namespace="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs xsl tei" version="3.0">
    
    
    <xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:quote">
        <q>
            <xsl:apply-templates select="text()|tei:hi|tei:quote"/>
        </q>
    </xsl:template>
    <xsl:template match="tei:hi[@rend='italic']">
        <i>
            <xsl:apply-templates select="text()|tei:hi|tei:quote"/>
        </i>
    </xsl:template>
    <xsl:template match="tei:hi[@rend='bold']">
        <b>
            <xsl:apply-templates select="text()|tei:hi|tei:quote"/>
        </b>
    </xsl:template>
    <xsl:template match="text()">
        <xsl:value-of select="."/>
    </xsl:template>
    
</xsl:stylesheet>