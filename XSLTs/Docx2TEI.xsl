<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema" 
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
                xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage"
                xmlns:cp="http://schemas.openxmlformats.org/package/2006/metadata/core-properties"
                xmlns:office="http://schemas.openxmlformats.org/officeDocument/2006/extended-properties"
                
                exclude-result-prefixes="xs"
                version="2.0">
    
    <!-- This exports the .xml type -->
    <xsl:output method="xml" encoding="utf-8" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    
    <!-- This adds the TEI All schema -->
    <xsl:template match="/">
        <xsl:processing-instruction name="xml-model"> 
            href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml" 
            schematypens="http://relaxng.org/ns/structure/1.0" 
            href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml"
	        schematypens="http://purl.oclc.org/dsdl/schematron"? 

            href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml"
	        schematypens="http://purl.oclc.org/dsdl/schematron"
        </xsl:processing-instruction>
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="pkg:package">
        <TEI xmlns="http://www.tei-c.org/ns/1.0">
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title>Title</title>
                    </titleStmt>
                    <publicationStmt>
                        <p>Publication Information</p>
                    </publicationStmt>
                    <sourceDesc>
                        <p>Information about the source</p>
                    </sourceDesc>
                </fileDesc>
            </teiHeader>
            <xsl:apply-templates/>
        </TEI>
    </xsl:template>

    <xsl:template match="cp:coreProperties"/>
    
    <xsl:template match="pkg:part[@pkg:name='/docProps/app.xml']/pkg:xmlData/office:Properties">
        <!-- Do nothing, effectively excluding the "Properties" element and its contents -->
    </xsl:template>
    
    <xsl:template match="w:body">
        <text>
            <body>
                <xsl:apply-templates/>
            </body>
        </text>
    </xsl:template>
 
    <xsl:template match= "w:r">
        <xsl:choose>
            
            <xsl:when test = "w:rPr/w:b">
                <p>
                    <hi rend="bold">
                        <xsl:apply-templates/>
                    </hi>
                </p>
            </xsl:when>
            
            <xsl:when test = "w:rPr/w:i">
                <p>
                    <hi rend="italic">
                        <xsl:apply-templates/>
                    </hi>
                </p>
            </xsl:when>
            
            <xsl:when test = "w:rPr/w:color">
                <xsl:apply-templates/>
            </xsl:when>

            <xsl:otherwise>
                <p>
                    <xsl:apply-templates/>
                </p>
                
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>