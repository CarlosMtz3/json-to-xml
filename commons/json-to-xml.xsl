<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0"
    xmlns:f="http://functions" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns:saxon="http://saxon.sf.net/"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="f fn math xd xs saxon">
    
    <xsl:output indent="yes" method="xml" encoding="UTF-8" name="archive"/>
    <xsl:output indent="yes" method="xml" encoding="UTF-8" name="original"/> <!--saxon:next-in-chain="fix_characters.xsl"/>-->

    <xsl:include href="../commons/functions.xsl"/>
    <xsl:include href="../commons/params.xsl"/>

    <xsl:strip-space elements="*"/>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template match="/data">
              <xsl:result-document omit-xml-declaration="yes" indent="yes" encoding="UTF-8" 
                href="{$workingDir}A-{$archiveFile}_{position()}.json"
                format="archive">
             <xsl:copy-of select="unparsed-text(resolve-uri($originalFilename))"/>
            </xsl:result-document>
        <xsl:result-document omit-xml-declaration="yes" indent="yes" encoding="UTF-8" 
            href="{$workingDir}N-{$archiveFile}_{position()}.xml"
            format="original">
        <mods version="3.7">
            <xsl:apply-templates select="json-to-xml(.)"/>
        </mods>
        </xsl:result-document>
    </xsl:template>


    <xd:doc>
        <xd:desc> template for the first tag </xd:desc>
    </xd:doc>
    <xsl:template match="map" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
                <!-- select a sub-node structure  -->
        <xsl:apply-templates select="./string[@key = 'title']"/>
        <xsl:apply-templates
            select="./array[@key = 'pub_authors'] | ./array[@key = 'primary_station']"/>


        <!--default values-->
        <typeOfResource>text</typeOfResource>
        <genre>article</genre>
    </xsl:template>


    <xd:doc>
        <xd:desc> template to output a string value </xd:desc>
    </xd:doc>
    <xsl:template match="map/string[@key = 'title']"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <title>
        <titleInfo>
             <xsl:value-of select="."/>    
        </titleInfo>
        </title>
    </xsl:template>

    <xd:doc scope="component" id="contrib">
        <xd:desc>If the contributor is a collaborator rather than an individual, format output
            accordingly. If processing the first author in the group, assign an attribute of
                <xd:b>usage</xd:b> with a value of "primary."</xd:desc>
    </xd:doc>
    <xsl:template
        match="fn:map/fn:array[@key = 'pub_authors'] | fn:map/fn:array[@key = 'primary_station']"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:choose>
            <xsl:when test="map/string[@key = 'primary_station']">
                <name type="corporate">
                    <namePart>
                        <xsl:value-of select="map/string[@key = 'primary_station']"/>
                    </namePart>
                </name>
            </xsl:when>
            <xsl:otherwise>
                <name type="personal">
                    <xsl:if
                        test="position() = 1 and count(map/preceding-sibling::string[@key = 'name']) = 0">
                        <xsl:attribute name="usage">primary</xsl:attribute>
                    </xsl:if>
                    <xsl:call-template name="name-info"/>
                </name>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xd:doc>
        <xd:desc/>

    </xd:doc>
    <xsl:template name="name-info" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:for-each select="map[position()]">
            <xsl:if test="./string[@key = 'name']">
                <namePart type="given">
                    <xsl:value-of
                        select="substring-after(normalize-space(./string[@key = 'name']), ', ')"/>
                </namePart>
                <namePart type="family">
                    <xsl:value-of
                        select="substring-before(normalize-space(./string[@key = 'name']), ', ')"/>
                </namePart>
                <displayName>
                    <xsl:value-of select="./string[@key = 'name']"/>
                </displayName>
            </xsl:if>
            <xsl:if test="./string[@key = 'station_id'] != ''">
                <affiliation>
                    <xsl:value-of select="f:acronymToName(string[@key = 'station_id'])"/>
                    <!--<xsl:if test="./string[@key='unit_id']!=''">
                    <xsl:value-of select="./string[@key='unit_id']"/>
                </xsl:if>-->
                </affiliation>
            </xsl:if>
            <role>
                <roleTerm type="text">author</roleTerm>
            </role>
        </xsl:for-each>
    </xsl:template>
    <!-- Get author's ORCID -->

    <!-- <xsl:template name="acronym" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:for-each select="fn:array[@key='pub_authors']/map/string[2]">
            <xsl:value-of select="f:acronymToName(.)"/>
        </xsl:for-each>
    </xsl:template>-->

    <xd:doc>
        <xd:desc/>

    </xd:doc>
    <xsl:template match="map/string[@key = 'primary_station']">
        <name type="corporate">
            <namePart>United States</namePart>
            <namePart>Forest Service</namePart>
            <namePart>
                <xsl:value-of select="f:acronymToName(.)"/>
            </namePart>
        </name>
    </xsl:template>
    <!--<!-\-Xpath uses the id aattribute and the current() function to the appropriate author (xref/@rid) -\->
       <xsl:for-each select="/article/front/article-meta/contrib-group/aff[@id = current()/xref/@rid]">
           <xsl:variable name="this">
               <xsl:apply-templates mode="affiliation"/>
           </xsl:variable>
           <affiliation>
               <xsl:value-of select="normalize-space($this)"/>
           </affiliation>
       </xsl:for-each>-->


</xsl:stylesheet>
