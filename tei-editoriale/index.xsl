<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs xsl" version="3.0">

    <xsl:output method="html" indent="yes"/>
    
    
    <xsl:template match="description">
        <xsl:apply-templates select="section"/>
    </xsl:template>
    
    <xsl:template match="section">
        <div class="col-md-9">
            <xsl:apply-templates select="head|p"/>
        </div>
    </xsl:template>
    
    <xsl:template match="head">
        <h2>
            <xsl:value-of select="."/>
        </h2>
    </xsl:template>
    
    <xsl:template match="p">
        <p>
            <xsl:apply-templates select="link|text()"/>
        </p>
    </xsl:template>
    
    <xsl:template match="link">
        <a>
            <xsl:attribute name="href">
                <xsl:value-of select="./@url"/>
            </xsl:attribute>
            <xsl:value-of select="./text()"/>
    </a>
    </xsl:template>
    
    <xsl:template match="text()">
        <xsl:copy select="."/>
    </xsl:template>
    
   
</xsl:stylesheet>