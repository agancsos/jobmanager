package services
import (
	"../models"
	"fmt"
	"strconv"
	"net/http"
	"io/ioutil"
	"../../common"
)

// Local service
type CompanyService struct {
	dbs           *DataService
}

var ccsi *CompanyService;
func GetCompanyServiceInstance() IService {
	if ccsi == nil {
		ccsi = &CompanyService{};
		ccsi.dbs = GetDataServiceInstance().(*DataService);
	}
	return ccsi;
}

func (x *CompanyService) GetCompany(a int) *models.Company {
	var result *models.Company;
	var rows = x.dbs.ServiceQuery(fmt.Sprintf("SELECT * FROM COMPANY WHERE COMPANY_ID = '%d'", a)).Rows();
	if len(rows) > 0 {
		result = &models.Company{};
		var row = rows[0];
		result.SetID(a);
		result.SetName(row.Column("COMPANY_NAME").Value());
		result.SetStreet(row.Column("COMPANY_STREET").Value());
		result.SetCity(row.Column("COMPANY_CITY").Value());
		result.SetState(row.Column("COMPANY_STATE").Value());
		result.SetCountry(row.Column("COMPANY_COUNTRY").Value());
		result.SetDescription(row.Column("COMPANY_DESCRIPTION").Value());
		result.SetIndustry(row.Column("COMPANY_INDUSTRY").Value());
		var val, _ = strconv.Atoi(row.Column("COMPANY_EMPLOYEES").Value())
		result.SetEmployees(val);
		val, _ = strconv.Atoi(row.Column("COMPANY_RATING").Value());
		result.SetRating(val);
		val, _ = strconv.Atoi(row.Column("COMPANY_ISPUBLIC").Value());
		result.SetIsPublic(val > 0);
		result.SetLastUpdatedDate(row.Column("LAST_UPDATED_DATE").Value());
		result.SetApplicantEndpoint(row.Column("COMPANY_APPLICATION_ENDPOINT").Value());
	}
	return result;
}

func (x *CompanyService) GetCompanies() []*models.Company {
	var result = []*models.Company {};
	var rows = x.dbs.ServiceQuery(fmt.Sprintf("SELECT COMPANY_ID FROM COMPANY ORDER BY LOWER(COMPANY_NAME) ASC")).Rows();
	for _, row := range rows {
		var id, _ = strconv.Atoi(row.Column("COMPANY_ID").Value());
		result = append(result, x.GetCompany(id));
	}
	return result;
}

func (x *CompanyService) AddCompany(a *models.Company) bool {
	return x.dbs.RunServiceQuery(fmt.Sprintf(`INSERT INTO COMPANY (COMPANY_NAME, COMPANY_STREET, COMPANY_CITY, COMPANY_STATE, COMPANY_COUNTRY, COMPANY_DESCRIPTION, COMPANY_INDUSTRY, 
		COMPANY_EMPLOYEES, COMPANY_RATING, COMPANY_ISPUBLIC, COMPANY_APPLICANT_ENDPOINT) VALUES ('%s','%s','%s','%s','%s','%s','%s','%d','%d','%d', '%s')`,
		a.Name(), a.Street(), a.City(), a.State(), a.Country(), a.Description(), a.Industry(), a.Employees(), a.Rating(), a.IsPublic(), a.ApplicantEndpoint()));
}

func (x *CompanyService) HasCompany(a string) bool {
	return len(x.dbs.ServiceQuery(fmt.Sprintf("SELECT 1 FROM COMPANY WHERE COMPANY_NAME = '%s'", a)).Rows()) > 0;
}

func (x *CompanyService) UpdateCompany(a *models.Company) bool {
	return x.dbs.RunServiceQuery(fmt.Sprintf(`UPDATE COMPANY SET COMPANY_NAME = '%s', COMPANY_STREET = '%s', COMPANY_CITY = '%s', COMPANY_STATE = '%s',
		COMPANY_COUNTRY = '%s', COMPANY_DESCRIPTION = '%s', COMPANY_INDUSTRY = '%s', COMPANY_EMPLOYEES = '%d', COMPANY_RATING = '%d', 
		COMPANY_ISPUBLIC = '%d', COMPANY_APPLICANT_ENDPOINT = '%s', LAST_UPDATED_DATE = CURRENT_TIMESTAMP WHERE COMPANY_ID = '%d'`,
		a.Name(), a.Street(), a.City(), a.State(), a.Country(), a.Description(), a.Industry(), a.Employees(), a.Rating(), a.IsPublic(), a.ApplicantEndpoint(), a.ID()));
}

func (x *CompanyService) GetEndpoints() []*models.Company {
	var result = []*models.Company{};
	for _, row := range x.dbs.ServiceQuery("SELECT COMPANY_ID FROM COMPANY WHERE COMPANY_APPLICANT_ENDPOINT <> '' ORDER BY COMPANY_NAME ASC").Rows() {
		var id, _ = strconv.Atoi(row.Column("COMPANY_ID").Value());
		result = append(result, x.GetCompany(id));
	}
	return result;
}

func (x *CompanyService) Initialize() { }
/*****************************************************************************/

// Rest service
type RestCompanyService struct {
	lcs       *CompanyService
}
var rcs *RestCompanyService;
func GetRestCompanyServiceInstance() *RestCompanyService {
	if rcs == nil {
		rcs = &RestCompanyService{};
		rcs.lcs = GetCompanyServiceInstance().(*CompanyService);
	}
	return rcs;
}

func (x *RestCompanyService) GetCompanies(w http.ResponseWriter, r *http.Request) {
	if !common.EnsureRestMethod(r, "GET") { return; }
	var companies = x.lcs.GetCompanies();
	var result = "{\"companies\":[";
	for i, company := range companies {
		if i > 0 {
			result += ",";
		}
		result += company.ToJsonString();
	}
	result += "]}";
	w.Write([]byte(result));
}

func (x *RestCompanyService) AddCompany(w http.ResponseWriter, r *http.Request) {
	if !common.EnsureRestMethod(r, "POST") { return; }
	var company = &models.Company{};
	var data, _ = ioutil.ReadAll(r.Body);
	company.ReloadFromJson(string(data));
	w.Write([]byte(fmt.Sprintf("{\"result\":\"%d\"}", common.BoolToInt(x.lcs.AddCompany(company)))));
}

func (x *RestCompanyService) UpdateCompany(w http.ResponseWriter, r *http.Request) {
	if !common.EnsureRestMethod(r, "POST") { return; }
	var company = &models.Company{};
    var data, _ = ioutil.ReadAll(r.Body);
    company.ReloadFromJson(string(data));
    w.Write([]byte(fmt.Sprintf("{\"result\":\"%d\"}", common.BoolToInt(x.lcs.UpdateCompany(company)))));
}

func (x *RestCompanyService) HasCompany(w http.ResponseWriter, r *http.Request) {
	if !common.EnsureRestMethod(r, "POST") { return; }
    var data, _ = ioutil.ReadAll(r.Body);
    w.Write([]byte(fmt.Sprintf("{\"result\":\"%d\"}", common.BoolToInt(x.lcs.HasCompany(string(data))))));
}

func (x *RestCompanyService) RemoveCompany(w http.ResponseWriter, r *http.Request) {
	if !common.EnsureRestMethod(r, "POST") { return; }
	var company = &models.Company{};
    var data, _ = ioutil.ReadAll(r.Body);
    company.ReloadFromJson(string(data));
	var ds = GetDataServiceInstance().(*DataService);
	ds.RunServiceQuery(fmt.Sprintf("DELETE FROM RESULT WHERE COMPANY_ID = '%d'", company.ID()));
    w.Write([]byte(fmt.Sprintf("{\"result\":\"%d\"}", common.BoolToInt(ds.RunServiceQuery(fmt.Sprintf("DELETE FROM COMPANY WHERE COMPANY_ID = '%d'", company.ID()))))));
}

func (x *RestCompanyService) Initialize() {
	http.HandleFunc("/api/companies/get/", x.GetCompanies);
	http.HandleFunc("/api/companies/add/", x.AddCompany);
	http.HandleFunc("/api/companies/has/", x.HasCompany);
	http.HandleFunc("/api/companies/update/", x.UpdateCompany);
	http.HandleFunc("/api/companies/remove/", x.RemoveCompany);
}
/*****************************************************************************/

