<%
FULL_NAME_CAPS = "_"..string.upper(this.namespace).."_"..string.upper(this.name).."BASE".."_";
CAP_NAME = capitalizedString(this.name);
FULL_NAME_CAMEL = capitalizedString(this.namespace).."_"..capitalizedString(this.name).."Base";
SUPERCLASS_OVERRIDE = ""; if (hasSuperclass(this)) then SUPERCLASS_OVERRIDE="override "; end
%>//
// Autogenerated by gaxb at <%= os.date("%I:%M:%S %p on %x") %>
//


class <%= CAP_NAME %><% if (hasSuperclass(this)) then %> : <%= superclassForItem(this) %><% end %> {
<% if (hasSuperclass(this) == false) then %>
    var xmlns: String = "<%= this.namespaceURL %>"
    var parent: <%= CAP_NAME %>?
    var originalValues = Dictionary<String, String> ()

    func gaxbValueWillChange(name:String) { }
    func gaxbValueDidChange(name:String) { }

<% end

for k,v in pairs(this.sequences) do
	if(isPlural(v)) then %>
    var <%= pluralName(v.name) %>: Array<<%= simpleTypeForItem(v) %>> = []
<%
  else %>
    var <%= v.name %>: <%= simpleTypeForItem(v) %>?
<%
	end
end

for k,v in pairs(this.attributes) do %>
	var <%= v.name %>: <%= typeForItem(v) %><%
-- setting default values needs a lot of work...
	if (v.default == nil) then %>?<% else %> = <%= v.default %><%
	end %>
    var <%= v.name %>Exists: Bool {
        return <%= v.name %> != nil
    }
    func <%= v.name %>AsString() -> String {<%
 if (v.type=="string") then %>
        return <%= v.name %><% if (v.default == nil) then %>!<% end %>
<% else %>
        return <%= v.name %>.description // <%= typeNameForItem(v) %> / <%= v.type %>
<% end
%>    }
<%
	end
	if (this.mixedContent) then %>
@synthesize MixedContent;
@synthesize MixedContentExists;
-(void) setMixedContent:(NSString *)v
{
    MixedContentExists=YES;
    if([v isKindOfClass:[NSString class]] == NO)
    {
        v = [v description];
    }
    [self gaxb_valueWillChange:@"MixedContent"];
    [self willChangeValueForKey:@"MixedContentAsString"];
    MixedContent = v;
    [self didChangeValueForKey:@"MixedContentAsString"];
    [self gaxb_valueDidChange:@"MixedContent"];
};
- (NSString *) MixedContentAsString { return [MixedContent description]; }
- (void) setMixedContentWithString:(NSString *)string
{
	MixedContentExists=YES;
	[self setMixedContent:[[NSClassFromString(@"NSString") alloc] initWithString:string]];
}
<%
	end
%>

    <%= SUPERCLASS_OVERRIDE %>func attributesXML(useOriginalValues:Bool? = false) -> String {
        var xml = ""
        if useOriginalValues! {
            for (key, value) in originalValues {
                xml += " \\(key)='\\(value)'"
            }
        } else {
<% for k,v in pairs(this.attributes) do
%>            if <%= v.name %>Exists {
                xml += " <%= v.name %>='\\(<%= v.name %>AsString())'"
            }
<% end
%>        }
<% if (hasSuperclass(this)) then %>
        xml += super.attributesXML(useOriginalValues:useOriginalValues)
<% end %>
        return xml
    }

    <%= SUPERCLASS_OVERRIDE %>func sequencesXML(useOriginalValues:Bool? = false) -> String {
        var xml = ""
<%    for k,v in pairs(this.sequences) do
      if (isPlural(v)) then %>
        for <%= v.name %> in <%= pluralName(v.name) %> {
            xml += <%= v.name %>.toXML()
        }
<% else %>    xml += <%= v.name %>.toXML()<% end
    end
 if (hasSuperclass(this)) then %>
        xml += super.sequencesXML(useOriginalValues:useOriginalValues)
<% end %>
        return xml
    }

    <%= SUPERCLASS_OVERRIDE %>func toXML(useOriginalValues:Bool? = false) -> String {

        var xml = "<<%= CAP_NAME %>"
        if parent {
            if parent!.xmlns != xmlns {
                xml += " xmlns='\\(xmlns)'"
            }
        }

        xml += attributesXML(useOriginalValues: useOriginalValues)

        var sXML = sequencesXML(useOriginalValues: useOriginalValues)
        xml += sXML == "" ? "/>" : ">\\n\\(sXML)</AstronomicalObject>"
<% if (hasSuperclass(this)) then %>
        xml += super.toXML(useOriginalValues:useOriginalValues)
<% end %>
        return xml
    }

    <%= SUPERCLASS_OVERRIDE %>func description() -> String {
        return toXML(useOriginalValues: false)
    }

}
