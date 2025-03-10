<xsl:stylesheet version="3.0"  exclude-result-prefixes="xs xsl text office meta"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
    xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
    xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0">
    <xsl:output method="xml" indent="yes"/>
    
    
    
    <xsl:template match="/office:document-content/office:body/office:text">
        <xsl:variable name="title" select="text:p[@text:style-name='Title']"/>
        <xsl:variable name="meta" select="document(concat(concat('input/', replace($title, ' ', '-')), '/meta.xml'))/office:document-meta/office:meta"/>
        <TEI xmlns="http://www.tei-c.org/ns/1.0">
            <teiHeader><fileDesc>
                <titleStmt>
                    <title><xsl:value-of select="$meta/meta:user-defined[@meta:name='Titre']"/></title>
                    <author><xsl:value-of select="$meta/meta:user-defined[@meta:name='Auteur']"/></author>
                </titleStmt>
                <publicationStmt>
                    <authority/>
                    <availability><licence><xsl:attribute name="target"><xsl:value-of select="$meta/meta:user-defined[@meta:name='Licence']"/></xsl:attribute></licence></availability>
                    <date>
                        <xsl:attribute name="when"><xsl:value-of select="$meta/meta:user-defined[@meta:name='Date de la source']"/></xsl:attribute>
                        <xsl:value-of select="$meta/meta:user-defined[@meta:name='Date de publication' or @meta:name='Date de la publication' ]"/>
                    </date>
                </publicationStmt>
                <sourceDesc>
                    <p><xsl:value-of select="$meta/meta:user-defined[@meta:name='Description']"/></p>
                    <p>Disponible à l'adresse suivante <xsl:value-of select="$meta/meta:user-defined[@meta:name='Source']"/></p>
                </sourceDesc>
            </fileDesc></teiHeader>
            <text><body>
                <head><xsl:value-of select="$title"/></head>
                <xsl:choose>
                    <xsl:when test="text:h[@text:outline-level='1']"><xsl:apply-templates select="text:h[@text:outline-level='1']|/office:document-content/office:body/office:text/text:p[$title=(preceding-sibling::*)[last()]]"/></xsl:when>
                    <xsl:otherwise><div n="1"><xsl:apply-templates select="/office:document-content/office:body/office:text/text:h[@text:outline-level='2']"/></div></xsl:otherwise>
                </xsl:choose>
            </body></text>
        </TEI>
    </xsl:template>
    
    <xsl:template match="text:h[@text:outline-level='1']">
        <xsl:variable name="part" select="."/>
        <div n="1">
            <head><xsl:value-of select="$part"/></head>
            <xsl:apply-templates select="/office:document-content/office:body/office:text/text:h[@text:outline-level='2' and $part=(preceding-sibling::text:h[@text:outline-level='1'])[last()]]|/office:document-content/office:body/office:text/text:p[$part=(preceding-sibling::*)[last()]]"/>
        </div>
    </xsl:template>
    
    <xsl:template match="/office:document-content/office:body/office:text/text:h[@text:outline-level='2']">
        <xsl:variable name="chapter" select="."/>
        <div n="2">
            <head><xsl:value-of select="."/></head>
            <xsl:apply-templates select="/office:document-content/office:body/office:text/text:p[$chapter=(preceding-sibling::text:h)[last()]]"/>
        </div>
    </xsl:template>
    
    <xsl:template match="/office:document-content/office:body/office:text/text:p">
        <p>
            <xsl:choose>
                <xsl:when test="./@text:style-name='citation'"><quote><xsl:apply-templates select="text:span|text()"/></quote></xsl:when>
                <xsl:otherwise><xsl:apply-templates select="text:span|text()"/></xsl:otherwise>
            </xsl:choose>
        </p>
    </xsl:template>
    
    <xsl:template match="text()">
        <xsl:value-of select="."/>
    </xsl:template>
    
    <xsl:template match="text:span[@text:style-name='gras']">
        <hi rend="bold"><xsl:value-of select="."/></hi>
    </xsl:template>
    
    <xsl:template match="text:span[@text:style-name='italique']">
        <hi rend="italic"><xsl:value-of select="."/></hi>
    </xsl:template>



</xsl:stylesheet>