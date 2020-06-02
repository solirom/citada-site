<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="#all" version="3.0">
    <xsl:output method="json" encoding="UTF-8" />   
    <xsl:variable name="uuid" select="/*/@xml:id"/>
    <xsl:template match="/">
        <xsl:result-document href="{concat($uuid, '.json')}">
            <xsl:variable name="a" select="string(/*/tei:editor/@xml:id)" />
            <xsl:variable name="s" select="string(/*/tei:revisionDesc/@status)" />
            <xsl:variable name="l" select="string(/*/tei:orth)" />
            <xsl:variable name="sigla" select="string-join(/*/tei:bibl/tei:ptr/@target ! replace(., ',', '') ! replace(., ' ', ''), ' ')" />
            <xsl:sequence select="map {'a': $a, 's': $s, 'l': $l, 'sigla': $sigla}" />
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>
