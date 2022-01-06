package models
import (
	"../../common"
	"fmt"
	"strconv"
)

type Company struct {
	id                 int       `json:id`
    name               string    `json:name`
    street             string    `json:street`
    city               string    `json:city`
    state              string    `json:state`
    country            string    `json:country`
    description        string    `json:description`
    industry           string    `json:industry`
    employees          int       `json:employees`
    rating             int       `json:rating`
    isPublic           bool      `json:isPublic`
    lastUpdatedDate    string    `json:lastUpdatedDate`
    applicantEndpoint  string    `json:applicationEndpoint`
}

func (x *Company) ReloadFromJson(json string) {
    var dict = common.StrToDictionary([]byte(json));
    x.id, _ = strconv.Atoi(dict["id"].(string));
    x.name = dict["name"].(string);
	x.street = dict["street"].(string);
	x.city = dict["city"].(string);
	x.state = dict["state"].(string);
	x.country = dict["country"].(string);
	x.description = dict["description"].(string);
	x.industry = dict["industry"].(string);
	x.employees, _ = strconv.Atoi(dict["employees"].(string));
    x.rating, _ = strconv.Atoi(dict["rating"].(string));
	var val, _ = strconv.Atoi(dict["isPublic"].(string));
	x.isPublic = val > 0;
	x.lastUpdatedDate = dict["lastUpdatedDate"].(string);
	x.applicantEndpoint = dict["applicantEndpoint"].(string);
}

func (x *Company) ToJsonString() string {
    var result = "{";
    result += fmt.Sprintf("\"id\":\"%d\"", x.id);
    result += fmt.Sprintf(",\"name\":\"%s\"", x.name);
    result += fmt.Sprintf(",\"rating\":\"%v\"", x.rating);
    result += fmt.Sprintf(",\"employees\":\"%v\"", x.employees);
    result += fmt.Sprintf(",\"city\":\"%s\"", x.city);
	result += fmt.Sprintf(",\"state\":\"%s\"", x.state);
	result += fmt.Sprintf(",\"country\":\"%s\"", x.country);
	result += fmt.Sprintf(",\"description\":\"%s\"", x.description);
	result += fmt.Sprintf(",\"industry\":\"%s\"", x.industry);
	result += fmt.Sprintf(",\"street\":\"%s\"", x.street);
	result += fmt.Sprintf(",\"isPublic\":\"%d\"", x.isPublic);
	result += fmt.Sprintf(",\"lastUpdatedDate\":\"%s\"", x.lastUpdatedDate);
	result += fmt.Sprintf(",\"applicantEndpoint\":\"%s\"", x.applicantEndpoint);
    result += "}";
    return result;
}
func (x *Company) SetID (a int) { x.id = a; }
func (x *Company) SetName (a string) { x.name = a; }
func (x *Company) SetStreet (a string) { x.street = a; }
func (x *Company) SetCity (a string) { x.city = a; }
func (x *Company) SetState (a string) { x.state = a; }
func (x *Company) SetCountry (a string) { x.country = a; }
func (x *Company) SetDescription (a string) { x.description = a; }
func (x *Company) SetIndustry (a string) { x.industry = a; }
func (x *Company) SetEmployees (a int) { x.employees = a; }
func (x *Company) SetRating (a int) { x.rating = a; }
func (x *Company) SetIsPublic (a bool) { x.isPublic = a; }
func (x *Company) SetLastUpdatedDate (a string) { x.lastUpdatedDate = a; }
func (x *Company) SetApplicantEndpoint (a string) { x.applicantEndpoint = a; }
func (x Company) ID() (int) { return x.id; }
func (x Company) Name() (string) { return x.name; }
func (x Company) Street() (string) { return x.street; }
func (x Company) City() (string) { return x.city; }
func (x Company) State() (string) { return x.state; }
func (x Company) Country() (string) { return x.country; }
func (x Company) Description() (string) { return x.description; }
func (x Company) Industry() (string) { return x.industry; }
func (x Company) Employees() (int) { return x.employees; }
func (x Company) Rating() (int) { return x.rating; }
func (x Company) IsPublic() (bool) { return x.isPublic; }
func (x Company) LastUpdatedDate() (string) { return x.lastUpdatedDate; }
func (x Company) ApplicantEndpoint() (string) { return x.applicantEndpoint; }

