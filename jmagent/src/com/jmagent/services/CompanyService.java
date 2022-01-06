package com.jmagent.services;
import com.jmagent.models.Company;

public class CompanyService {
    private DataService data;
    private static CompanyService instance;
    private ConfigurationService cs;

    private CompanyService() {
        this.data = DataService.getInstance();
        this.cs = ConfigurationService.getInstance(null);
    }

    public static CompanyService getInstance() {
        if (instance == null) {
            instance = new CompanyService();
        }
        return instance;
    }

    public boolean contains(Company company) {
        return this.data.serviceQuery(String.format("SELECT 1 FROM COMPANY WHERE COMPANY_NAME = '%s'", company.getName())).getRows().size() > 0;
    }

    public Integer add(Company company) {
		if (!this.contains(company) && !this.cs.getProperty("safeMode").equals("1")) {
			if (this.data.runServiceQuery("INSERT INTO COMPANY (COMPANY_NAME, COMPANY_STREET, COMPANY_CITY, COMPANY_STATE, COMPANY_COUNTRY, COMPANY_DESCRIPTION, COMPANY_INDUSTRY, COMPANY_EMPLOYEES, COMPANY_RATING, COMPANY_ISPUBLIC) VALUES ("
				+ "'" + company.getName() + "'"
				+ ",'" + company.getStreet() + "'"
				+ ",'" + company.getCity() + "'"
				+ ",'" + company.getState() + "'"
				+ ",'" + company.getCountry() + "'"
				+ ",'" + company.getDescription() + "'"
				+ ",'" + company.getIndustry() + "'"
				+ ",'" + company.getEmployees().toString() + "'"
				+ ",'" + company.getRating().toString() + "'"
				+ ",'" + (company.getIsPublic() ? "1" : "0") + "'"
				+ ")")) {
				return Integer.parseInt(this.data.serviceQuery(String.format("SELECT COMPANY_ID FROM COMPANY WHERE COMPANY_NAME = '%s'", 
					company.getName())).getRows().get(0).getColumn("COMPANY_ID").getColumnValue());
			}
		}
		else if (this.contains(company)) {
			return Integer.parseInt(this.data.serviceQuery(String.format("SELECT COMPANY_ID FROM COMPANY WHERE COMPANY_NAME = '%s'",
                    company.getName())).getRows().get(0).getColumn("COMPANY_ID").getColumnValue());
		}
        return -1;
    }
}