<%
FULL_NAME_CAPS = "_"..string.upper(this.namespace).."_"
FULL_NAME_CAMEL = capitalizedString(this.namespace)
%>
//
// Autogenerated by gaxb at <%= os.date("%I:%M:%S %p on %x") %>
//

class <%= FULL_NAME_CAMEL %> {

		class func classWithName(name : String) -> GaxbElement? {
				switch name {<%
for k,v in pairs(schema.elements) do
	-- if not in the schema namespace, skip
	if (schema.namespace == v.namespace) then
		v.name = cleanedName(v.name);%>
				case "<%= v.name %>":
						return <%= v.name %>()<%
	end
end %>
				default:
						return nil
				}
		}

		class func readFromFile(filepath : String) -> GaxbElement? {
				let rootXML: AnyObject! = RXMLElement.elementFromXMLFile(filepath)
				if rootXML as? RXMLElement {
						return <%= FULL_NAME_CAMEL %>.parseElement(rootXML as RXMLElement)
				}
				return nil
		}

		class func parseElement(element: RXMLElement) -> GaxbElement? {
				println("element = " + element.tag)
				if let entity : GaxbElement = <%= FULL_NAME_CAMEL %>.classWithName(element.tag) {
						let names = element.attributeNames() as [String]
						for name in names {
								let value = element.attribute(name) as String
								entity.setAttribute(value, key: name)
						}

						let block: (element: RXMLElement!) -> Void = { element in
								if let subEntity : GaxbElement? = <%= FULL_NAME_CAMEL %>.parseElement(element) {
										entity.setElement(subEntity!, key: element.tag!)
										println("element.tag = " + element.tag )
								}
						}
						element.iterate("*", usingBlock:block)
						return entity
				}
				return nil
		}

}

<%
	-- simpleType definitions, such as enums
	for k,v in pairs(schema.simpleTypes) do
		-- only include defintions from this schema's namespace
		if (isEnumForItem(v)) then
			if (schema.namespace == v.namespace) then

				gaxb_print("enum "..v.name..": String {\n");

							local appinfo = gaxb_xpath(v.xml, "./XMLSchema:annotation/XMLSchema:appinfo");
				local enums = gaxb_xpath(v.xml, "./XMLSchema:restriction/XMLSchema:enumeration");

				if(appinfo ~= nil) then
					appinfo = appinfo[1].content;
				end

				if(appinfo == "ENUM" or appinfo == "NAMED_ENUM") then
					for k,v in pairs(enums) do
						gaxb_print("\tcase "..v.attributes.value.." = \""..v.attributes.value.."\"\n")
					end
				end
		--		if(appinfo == "ENUM_MASK") then
		--			local i = 1
		--			gaxb_print("enum\n{\n")
		--			for k,v in pairs(enums) do
		--				gaxb_print("\t"..v.attributes.value.." = "..i..",\n")
		--				i = i * 2;
		--			end
		--			gaxb_print("};\n")
		--		end

				gaxb_print("}");
			end
		end
	end
%>





//+ (id) readFromData:(NSData *)data withParent:(id)p AndMemoryLite:(BOOL)memLite
//+ (id) readFromData:(NSData *)data withParent:(id)p
//+ (id) readFromData:(NSData *)data
//+ (id) readFromFile:(NSString *)path
//+ (id) readFromString:(NSString *)xml_string
//+ (id) readFromDataFast:(NSData *)data
//+ (id) readFromFileFast:(NSString *)path
//+ (id) readFromStringFast:(NSString *)xml_string
//+ (NSString *) writeToString:(id)object
//+ (NSString *) writeOriginalXMLToString:(id)object
//+ (void) write:(id)object toFile:(NSString *)path
//+ (NSData *) writeToData:(id)object
//- (id) initWithParent:(id)p AndMemoryLite:(BOOL)m
//static char * DecodeAllAmpersands(char * src)
//static void SetValue(NSObject * object, NSObject * childObject, const char * elementName, const char * className)
//static NSObject * CreateElementWithNamespace(TBXMLElement * element, const char * currentNamespace, NSMutableDictionary * namespaceMap, NSObject * parent)
