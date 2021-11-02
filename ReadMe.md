# JSON-to-MODS XSLT Transformation

**Task:** Transform [Treesearch](https://www.fs.usda.gov/treesearch/) JSON files to MODS XML records for ingest into Unified Repository.

**Materials**: Treesearch metadata in JSON format from the [United States Forest Service (USFS)](https://www.fs.usda.gov/).

## Transformation process

The _[json_to_mods.xsl](https://github.com/CarlosMtz3/json-to-xml/blob/master/json-to-mods.xsl)_ utilizes the following formats and schema to transform the JSON format into MODS.
-   [JSON](https://www.json.org/json-en.html): (JavaScript Object Notation)
-   [XPath 3.1](https://www.w3.org/TR/xpath-31/): (XML Path Language)
-   [XSLT 3.0](https://www.w3.org/TR/xslt-30/): (Extensible Stylesheet Language Transformations)
-   [MODS 3.7](https://www.loc.gov/standards/mods/v3/mods-3-7.xsd) : (Metadata Object Description Schema)
######* Each JSON file is first transformed to XML, upon which the XML produced is mapped its respective MODS element.


flowchart  i(Stat)--(Sto) style  filstroke:#333,stroke-widtheh le i fistroe,troeidtpclorftohar
# JSON-to-MODS XSLT Transformation

**Task:** Transform [Treesearch](https://www.fs.usda.gov/treesearch/) JSON files to MODS XML records for ingest into Unified Repository.

**Materials**: Treesearch metadata in JSON format from the [United States Forest Service (USFS)](https://www.fs.usda.gov/).

## Transformation process

The _[json_to_mods.xsl](https://github.com/CarlosMtz3/json-to-xml/blob/master/json-to-mods.xsl)_ utilizes the following formats and schema to transform the JSON format into MODS.

-   [JSON](https://www.json.org/json-en.html): (JavaScript Object Notation)
-   [XPath 3.1](https://www.w3.org/TR/xpath-31/): (XML Path Language)
-   [XSLT 3.0](https://www.w3.org/TR/xslt-30/): (Extensible Stylesheet Language Transformations)
-   [MODS 3.7](https://www.loc.gov/standards/mods/v3/mods-3-7.xsd) : (Metadata Object Description Schema)

*Each JSON file is first transformed to XML, upon which the XML produced is mapped its respective MODS element.

## JSON to MODS Transformation Flowchart
```mermad
flowchart LR
A[JSON] --> B((XSLT3.0))
B-->B.1((XPath 3.1))-->C
B --transforms_to--> C{XML}
C --maps to--> D[MODS 3.7]
style A fill:#f9f,stro33stro:4px 
style B fill:#bbf,stroke:#f66,stroke-width:2px,color:#fff,stroke-dasharray: 5 5
style B.1 fill:#bbf,stroke:#f66,stroke-width:2px,color:#fff,stroke-dasharray: 5 5
style C fill:#9fc5e8, stroke:#f66, stroke-dasharray: 5 5
style D fill:#9fc5e8,stroke:#333,stroke-width:4px ``` ###### *If the UML does not render, the image below is how the code above would render using Mermaid.<ahref="



 https://ibb.co/bbkKx8n"><img src="https://i.ibb.co/QD4KZ1G/json-to-mods-transformation-flowchart.png" alt="json-to-mods-transformation-flowchart" border="0" /></a> ## Preparing JSON Files for XSLT Transformation1.  Open the source_files folder2.  Locate the following shell scripts	 (a) merge_json.sh 	 (b) data_amp_add.sh3.  Run the merge_json.sh4.  Run the data_amp_add.sh5.  Open a JSON file in Oxygen










6. Verify it containset>  ataat the beinnig o the ie and  the en of the`<data>  </data>`at the beginning of the file and at the end of the file. ## Create a Transformation Scenario or Select the Debugging Layout1) Choose the json-to-mods.xsl as the transformation stylesheet. 2) If you're creating a scenario, set the output page as desired. 3) DO NOT set any parameters. This is taken care of by the new testing parameters added to the params-cm.xsl file. 4) Run the scenario or choose the debugging button to transform JSON to MODS## Issues1) Page numbers are not consistently correct.	(a) When JSON key values are present:		-  **










pub_start_page**, and 		-  **pub_end_page**		-  or the **pub_page**	(b) No issues are present with page numbers	c(c ) When they are not, they must be derived from the **pub_publicaton** or **citation** key values.		- These are strings of text with inconsistent formatting. 		- It is difficult to get the correct data from them each time.(2) Random station_id appearing at the end of the author names section. 






	

<!--stackedit_data:
eyJoaXN0b3J5IjpbNjk2NDI3Njc4LDE5MTE5NzU2NDVdfQ==
-->