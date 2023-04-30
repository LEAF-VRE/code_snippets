# How to create a personography in TEI for XTriples conversion

These instructions are designed to help in the creation of a basic 'personography' (description of the lives of one or more people represented in a body of research) using a TEI template. Follow these instructions in order to produce valid TEI that can then be input into the XTriples tool. XTriples will then RDF in either XML or TTL format. 

You will need basic information about each person that you can provide in structured format:
* At the very least you will need the name by which the person was known (forename, surname, etc.)
* A source from which you have gathered this information (this could be you or your research project)
* If available an existing authority name accessible via VIAF, Wikidata, etc.
* If available the person's birth and/or death date.

----------

## Person (listPerson\person)
Each person's information will be captured within the `<listPerson> \ <person>` element structure.

`<person xml:id="PID_entity_record">`
If you have a Persistent Identitifier (PID) for a person, you will add it to the `xml:id` attribute. Otherwise remove the attribute. 

----------


## Identifier (idno)

If the person has one or more existing authority names on VIAF, Wikidata, or similar online authorities, include one or all of them:

                <idno type="URI">https://www.wikidata.org/wiki/Q40909</idno>

----------

## Person name (persName)
There are at least two ways in which you can provide a person's name:
* "standard" format - *Last Name, Forename(s)*, and
* "preferred" format - nested like this:

               <persName type="preferred" xml:lang="ENG">
                  <name type="forename">Forename</name>
                  <name type="middlename">Middle Name</name>
                  <name type="surname">Surname</name>
                  <genName>(suffix: e.g. the IIIrd, senior, junior, etc.)</genName>
                  <roleName>offical title or rank</roleName>
               </persName>
 
A middle name could be a birth name; if there is no middle name, suffix, or role, remove those elements from your code.


----------

## Birth, Death 
If you know the birth and/or death dates of a person, add information in this format (the same for both birth and death dates):

               <birth>
                  <date when="2000-10-30">D.O.B </date>
               </birth>

Provide  an international date format value (2000-10-30) in the @when attribute and a huamn-readable date (e.g., the 30th of October, 2000) in the body of the text.

----------
## Sex
If you wish to express the person's gender identity or sexual orientation, we encourage you to look for a term in the [LINCS Project's gender vocabulary](https://vocab.lincsproject.ca/Skosmos/cwrc/en/page/Gender)): 
Include the @source and @value attributes:

              <sex source="http://sparql.cwrc.ca/ontology/cwrc.html#Gender" value="GenderQueer"/>


----------
## Occupation
If you know one or more occupations in which the person engaged, consult the 
[https://vocab.lincsproject.ca/Skosmos/occupation/en/](https://vocab.lincsproject.ca/Skosmos/occupation/en/)https://vocab.lincsproject.ca/Skosmos/occupation/en/ and include the URI as a @type value within the element, and a human-readable term.

        <occupation type="http://id.lincsproject.ca/occupation/academic">Researcher</occupation>

(you can include as many occupations as desired)

----------
## Bibliographical source (listBibl)
Provide information about the source from which you gathered this information, 

               <listBibl>
                  <head>Sources:</head>
                  <bibl><ref>Orlando</ref></bibl>
                  <bibl><ref source="https://www.wikidata.org/wiki/Q40909">Wikidata item, Virginia Woolf</ref></bibl>
               </listBibl>


----------

Please follow these instructions, using this structure for each additional person. When you have completed the file and confirmed that it is valid TEI, upload your file to the [XTriples tool](https://app.xtriples.stage.lincsproject.ca/exist/apps/xtriples/index.html). Choose the Personography option, and Download file as XML or Turtle (TTL) format.