<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei" version="2.0">

    <!-- This XSLT has been adapted from work done over time by members of the TEI-C council and community.
    Most recently it was developed specifically to transform the XML output from the Transkribus platform
    to TEI-All by members of the Leaf Editorial Academic Framework (LEAF) team for use with the LEAF-Writer text-encoding enfironment.
    The LEAF-Writer project is licensed under the GNU Affero General Public License v3.0 (https://choosealicense.com/licenses/agpl-3.0/)
    For more information about LEAF-Writer, the larger LEAF platform, go to: https://gitlab.com/calincs/cwrc/leaf-writer/leaf-writer-->

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



    <!-- This replaces the default teiHeader with the Heresies Project teiHeader -->
    <xsl:template match="tei:teiHeader">
        <teiHeader xmlns="http://www.tei-c.org/ns/1.0">
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
    </xsl:template>


    <!-- This removes the duplicated fileDesc structure (which is now managed by the above -->
    <xsl:template match="tei:fileDesc"/>

    <!-- This strips out the lb tags that are auto-generated by Transkribus -->
    <!-- Note that the paragraph tags are guided by the text regions identified in Transkribus and does not auto-detect paragraph breaks -->
    <xsl:template match="tei:lb"/>
        
<!-- All else is rendered as exported -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
