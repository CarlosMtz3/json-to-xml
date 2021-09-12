<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:saxon="http://saxon.sf.net/" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="xd xlink xs">

    <xd:doc scope="stylesheet" id="global_parameters">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b>July 24, 2021</xd:p>
            <xd:p><xd:b>Authored by:</xd:b>Carlos Martinez</xd:p>
            <xd:p><xd:b>Edited on:</xd:b>Sept 16, 2021</xd:p>
            <xd:p><xd:b>Edited by:</xd:b>Carlos Martinez</xd:p>
        </xd:desc>
    </xd:doc>
    <xd:doc>
        <xd:desc scope="component">
            <xd:p>
                <xd:b>Global parameters defined</xd:b>
            </xd:p>
            <xd:p><xd:i>Justification:</xd:i> Currently only one parameter is assigned a select
                attribute. Making use of XSLT functions the params.xsl and the root template of the
                primary stylesheet will dynamically create result-documents with original filenames.
                This is achieved using the "href" attribute to dynamically generate filenames on the
                fly.</xd:p>
            <xd:p>
                <xd:i>(e.g., href="{$workingDir}A-{$archiveFile}_{position()}.xml").</xd:i>
            </xd:p>
            <xd:ul>
                <xd:li>
                    <xd:param>
                        <xd:i>vendorName</xd:i>
                    </xd:param>
                </xd:li>
                <xd:li>
                    <xd:param><xd:i>archiveFile</xd:i> tokenizes the base-uri (i.e., the full file
                        path) to be segmented by each forward slash. The last function chooses the
                        filename at the end of the filepath. Using the replace function, the rest of
                        the URI is removed by using a three part regular expression delimit the file
                        directories, from the file name. Group two is selected as group three
                        contains the file extension and must be removed, before using the position
                        function to differentiate the filename. Then finally the file extension is
                        appened to the resulting file name.</xd:param>
                    <xd:return>
                        <xd:p>"fileName"</xd:p>
                    </xd:return>
                </xd:li>
                <xd:li>
                    <xd:param>
                        <xd:p><xd:i>originalFilename</xd:i>base-uri(), document-uri(.) or
                            saxon:system-id(), can all be used here to get the full filepath of the
                            document being processed.</xd:p>
                    </xd:param>
                    <xd:return> "file:\drive:\fileDiretories\fileName.xml"</xd:return>
                </xd:li>
                <xd:li>
                    <xd:param>
                        <xd:i>workingDir</xd:i> assigns value to the filename and working directory,
                        creating the ability to construct a fully qualified filepath for
                        transformation </xd:param>
                    <xd:return>
                        <xd:p>Returns: "file:\drive:\fileDiretories\"</xd:p>
                    </xd:return>
                </xd:li>
            </xd:ul>
        </xd:desc>
    </xd:doc>
    <xsl:param name="vendorCode"/>
    <xsl:param name="archiveFile" select="replace(tokenize(base-uri(),'/')[last()],'(.*)(\.\w{3,4})', '$1')"/>
    <xsl:param name="originalFilename" select="saxon:system-id()"/>
    <xsl:param name="workingDir" select="substring-before(base-uri(), $archiveFile)"/>
</xsl:stylesheet>
