<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
                
                exclude-result-prefixes="xs tei" version="2.0">
    
    <!-- This exports the .xml type -->
    <xsl:output method="xml" encoding="utf-8" indent="yes"/>
    <!--     <xsl:strip-space elements="*"/>-->
    
    
    <!-- This adds the TEI All schema -->
    <xsl:template match="/">
        <xsl:processing-instruction name="xml-model"> 
            href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0" 
            href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml"
	        schematypens="http://purl.oclc.org/dsdl/schematron"? 

            href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml"
	        schematypens="http://purl.oclc.org/dsdl/schematron"
        </xsl:processing-instruction>
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="w:body">
        <text>
            <body>
                <xsl:apply-templates/>
            </body>
        </text>
    </xsl:template>
    
    <xsl:template match="w:r">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    
</xsl:stylesheet>