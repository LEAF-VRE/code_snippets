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
    
    <!-- Adding TEI and teiHeader before the text -->
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
    
    <!-- Deletes "cp:coreProperties" -->
    <xsl:template match="cp:coreProperties"/>
    
    <!-- Deletes "pkg:part[@pkg:name='/docProps/app.xml']/pkg:xmlData/office:Properties" -->
    <xsl:template match="pkg:part[@pkg:name='/docProps/app.xml']/pkg:xmlData/office:Properties">
        <!-- Do nothing, effectively excluding the "Properties" element and its contents -->
    </xsl:template>
    
    <!-- When w:body exist substitute it with "text" that capsulates "body" -->
    <xsl:template match="w:body">
        <xsl:element name="text" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:element name="body" namespace="http://www.tei-c.org/ns/1.0">
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <!-- This text do number of things first it looks for "w:r" and  once it is found it does one out of four actions. 
        If "w:r" is followed by "w:rPr/w:b" it substitue "w:r/w:rPr/w:b" and capsulate what is between with <p> and <hi rend="bold">. 
        If "w:r" is followed by "w:rPr/w:i" it substitute "w:r/w:rPr/w:i" capsulate what is between with <p> and <hi rend="italic">.
        If "w:r" is followed by "w:rPr/w:color" it ignores the w:r.
        Else it substitute "w:r" with <p>. -->
    <xsl:template match= "w:r">
        <xsl:choose>
            <xsl:when test = "w:rPr/w:b">
                <p xmlns="http://www.tei-c.org/ns/1.0">
                    <hi rend="bold">
                        <xsl:apply-templates/>
                    </hi>
                </p>
            </xsl:when>
            <xsl:when test = "w:rPr/w:i">
                <p xmlns="http://www.tei-c.org/ns/1.0">
                    <hi rend="italic">
                        <xsl:apply-templates/>
                    </hi>
                </p>
            </xsl:when>
            <xsl:when test = "w:rPr/w:color">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <p xmlns="http://www.tei-c.org/ns/1.0">
                    <xsl:apply-templates/>
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>