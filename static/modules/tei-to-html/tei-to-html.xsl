<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="tei" version="3.0">
    <xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes" indent="yes"/>   
    <xsl:variable name="entry" select="/*"/>
    <xsl:variable name="uuid" select="$entry/@xml:id"/>
    

    <xsl:template match="/">
        <xsl:result-document href="{concat($uuid, '.html')}">
            <article xmlns="http://www.w3.org/1999/xhtml">
                <article id="headword"><xsl:value-of select="normalize-space(string-join($entry/(tei:orth, tei:gramGrp), ' '))" /></article>
                <article id="quote"><xsl:value-of select="$entry/tei:quote" /></article>
                <article id="bibl">
                  <xsl:for-each select="$entry/tei:bibl">
                    <xsl:value-of select="string-join((tei:ptr/@target, tei:citedRange, tei:date), ', ')" /><br/>
                  </xsl:for-each>                
                </article>
                <article id="note">
                  <xsl:for-each select="$entry/tei:note">
                    <xsl:value-of select="node()" /><br/>
                  </xsl:for-each>
                </article>
            </article>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>
