package models
import (
	"../../common"
	"encoding/json"
)

type Profile struct {
    id                   int      `json:id`
    name                 string   `json:name`
    lastUpdatedDate      string   `json:lastUpdatedDate`
    filter               *Filter  `json:filter`
}

func (x *Profile) ReloadFromJson(json string) {
    var dict = common.StrToDictionary([]byte(json));
    x.id = dict["id"].(int);
    x.name = dict["name"].(string);
    x.filter = &Filter{};
	x.filter.ReloadFromJson(common.DictionaryToJsonString(dict["filter"].(map[string]interface{})));
    x.lastUpdatedDate = dict["lastUpdatedDate"].(string);
}

func (x *Profile) ToJsonString() string {
    rawJson, _ := json.Marshal(x);
    return common.DictionaryToJsonString(common.StrToDictionary(rawJson));
}
func (x Profile)  ID()int { return x.id; }
func (x *Profile) SetID(a int) {x.id = a; }
func (x Profile)  Name() string { return x.name; }
func (x *Profile) SetName(a string) { x.name = a; }
func (x *Profile) SetLastUpdatedDate(a string) { x.lastUpdatedDate = a; }
func (x Profile)  LastUpdatedDate()string { return x.lastUpdatedDate; }
func (x *Profile) SetFilter(a *Filter) { x.filter = a; }
func (x Profile)  Filter() (*Filter) { return x.filter; }

