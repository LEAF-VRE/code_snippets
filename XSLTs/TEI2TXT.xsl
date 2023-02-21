<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs tei" 
    version="2.0">
    
    <xsl:output omit-xml-declaration="yes" method="text" encoding="UTF-8"/>
    <xsl:strip-space elements="*"/>
   
    <!-- This XSLT has been adapted from work done over time by members of the TEI-C council and community.
    Most recently it was developed specifically to transform the XML output from the Transkribus platform
    to TEI-All by members of the Leaf Editorial Academic Framework (LEAF) team for use with the LEAF-Writer text-encoding enfironment.
    The LEAF-Writer project is licensed under the GNU Affero General Public License v3.0 (https://choosealicense.com/licenses/agpl-3.0/)
    For more information about LEAF-Writer, the larger LEAF platform, go to: https://gitlab.com/calincs/cwrc/leaf-writer/leaf-writer-->       
    
    <!-- to recurse through the XML directory and grab all the files, use this code. The xslt and dirList must both
        be located in the xslt folder for this to work, unless you change some of the information below -->
    
        <xsl:template match="list">
        <xsl:for-each select="item">
            <xsl:for-each select="collection(iri-to-uri(concat(@dir, '?select=*.xml')))">
                <xsl:variable name="outpath"
                    select="concat('../text/', substring-before(tokenize(document-uri(.), '/')[last()], '.xml'))"/>
                <xsl:result-document href="{concat($outpath, '.txt')}">
                    <xsl:apply-templates select="tei:TEI"/>
                </xsl:result-document>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>

    
    <xsl:template match="tei:teiHeader"/>
    
    <xsl:template match="*">
        <xsl:apply-templates/>
        <xsl:text> </xsl:text>
    </xsl:template>

<!-- 'tokenize' removes punctuation; remove the tokenize function if you want punctuation in text -->
    <xsl:template match="text()">
        <xsl:value-of select="tokenize(., '\W')"/>
    </xsl:template>
   
</xsl:stylesheet>